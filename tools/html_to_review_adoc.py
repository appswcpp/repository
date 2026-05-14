#!/usr/bin/env python3
"""Create a readable AsciiDoc review draft from generated PP HTML."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

from lxml import html


SKIP_TAGS = {"script", "style", "noscript"}


def clean(text: str) -> str:
    text = text.replace("\xa0", " ")
    text = re.sub(r"[ \t\r\f\v]+", " ", text)
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text.strip()


def adoc_text(text: str) -> str:
    text = clean(text)
    if re.fullmatch(r"\[[^\]]+\]", text):
        return "\\" + text
    return text


def text_content(node) -> str:
    return adoc_text(" ".join(node.itertext()))


def table_to_adoc(table) -> list[str]:
    rows = []
    for tr in table.xpath("./tr|./thead/tr|./tbody/tr"):
        cells = [text_content(cell) for cell in tr.xpath("./th|./td")]
        if cells:
            rows.append(cells)
    if not rows:
        return []

    max_cols = max(len(row) for row in rows)
    lines = ["[cols=\"{}*\",options=\"header\"]".format(max_cols), "|===",]
    for row_index, row in enumerate(rows):
        padded = row + [""] * (max_cols - len(row))
        for cell in padded:
            lines.append("|" + cell.replace("\n", " +\n"))
        if row_index == 0:
            lines.append("")
    lines.append("|===")
    return lines


def list_to_adoc(node, ordered: bool = False) -> list[str]:
    marker = "." if ordered else "*"
    lines = []
    for li in node.xpath("./li"):
        value = text_content(li)
        if value:
            lines.append(f"{marker} {value}")
    return lines


def emit_block(node) -> list[str]:
    tag = node.tag.lower() if isinstance(node.tag, str) else ""
    if tag in SKIP_TAGS:
        return []
    if tag in {"h1", "h2", "h3", "h4", "h5", "h6"}:
        level = min(int(tag[1]) + 1, 6)
        title = text_content(node)
        if not title:
            return []
        if title == getattr(node.getroottree(), "_review_title", None):
            return []
        if title == "Contents":
            return []
        return ["=" * level + " " + title]
    if tag == "table":
        return table_to_adoc(node)
    if tag == "ul":
        return list_to_adoc(node)
    if tag == "ol":
        return list_to_adoc(node, ordered=True)
    if tag in {"p", "div", "section", "blockquote"}:
        children = [child for child in node if isinstance(child.tag, str) and child.tag.lower() not in SKIP_TAGS]
        child_tags = {child.tag.lower() for child in children}
        if child_tags and child_tags <= {"h1", "h2", "h3", "h4", "h5", "h6", "table", "ul", "ol", "p", "div", "section"}:
            lines: list[str] = []
            for child in children:
                lines.extend(emit_block(child))
                if lines and lines[-1] != "":
                    lines.append("")
            return lines
        value = text_content(node)
        return [value] if value else []
    value = text_content(node)
    return [value] if value else []


def convert(src: Path, dst: Path) -> None:
    root = html.fromstring(src.read_bytes().decode("utf-8", errors="replace"))
    body = root.find("body")
    if body is None:
        raise RuntimeError("HTML body not found")

    title = root.findtext(".//title") or "Application Software cPP Review Draft"
    root.getroottree()._review_title = clean(title)
    lines = [
        f"= {clean(title)}",
        ":doctype: book",
        ":toc: left",
        ":toclevels: 4",
        ":sectnums:",
        ":icons: font",
        ":source-highlighter: rouge",
        ":pdf-page-size: Letter",
        ":pdf-theme: default",
        "",
    ]

    for child in body:
        block = emit_block(child)
        if block:
            lines.extend(block)
            lines.append("")

    dst.write_text("\n".join(lines).replace("\n\n\n", "\n\n"), encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("src", type=Path)
    parser.add_argument("dst", type=Path)
    args = parser.parse_args()
    convert(args.src, args.dst)


if __name__ == "__main__":
    main()
