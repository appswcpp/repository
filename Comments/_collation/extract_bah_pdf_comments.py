"""Extract substantive PDF annotations from the BAH review package."""

from __future__ import annotations

import json
import re
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any

import pdfplumber
from pypdf import PdfReader


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = Path(__file__).resolve().parent


def normalize(value: Any) -> str:
    return re.sub(r"\s+", " ", str(value or "")).strip()


def pdf_date(value: Any) -> str:
    match = re.search(r"(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})", str(value or ""))
    if not match:
        return ""
    try:
        return datetime.strptime("".join(match.groups()), "%Y%m%d%H%M%S").isoformat(sep=" ")
    except ValueError:
        return ""


def rects_for(annotation: Any) -> list[tuple[float, float, float, float]]:
    quads = annotation.get("/QuadPoints")
    rects: list[tuple[float, float, float, float]] = []
    if quads:
        values = [float(x) for x in quads]
        for start in range(0, len(values), 8):
            quad = values[start : start + 8]
            if len(quad) == 8:
                xs = quad[0::2]
                ys = quad[1::2]
                rects.append((min(xs), min(ys), max(xs), max(ys)))
    if rects:
        return rects
    rect = annotation.get("/Rect") or []
    if len(rect) == 4:
        x0, y0, x1, y1 = (float(x) for x in rect)
        return [(min(x0, x1), min(y0, y1), max(x0, x1), max(y0, y1))]
    return []


def overlaps(word: dict[str, float], rect: tuple[float, float, float, float], page_height: float) -> bool:
    x0, y0, x1, y1 = rect
    word_y0 = page_height - float(word["bottom"])
    word_y1 = page_height - float(word["top"])
    return float(word["x0"]) < x1 and float(word["x1"]) > x0 and word_y0 < y1 and word_y1 > y0


def text_for_rects(page: Any, rects: list[tuple[float, float, float, float]]) -> str:
    try:
        words = page.extract_words(use_text_flow=True)
    except Exception:
        return ""
    selected: list[dict[str, float]] = []
    for word in words:
        if any(overlaps(word, rect, page.height) for rect in rects):
            selected.append(word)
    if not selected:
        return ""
    selected.sort(key=lambda w: (round(float(w["top"]) / 3), float(w["x0"])))
    return normalize(" ".join(str(word["text"]) for word in selected))


def nearby_text(page: Any, rects: list[tuple[float, float, float, float]]) -> str:
    if not rects:
        return ""
    try:
        words = page.extract_words(use_text_flow=True)
    except Exception:
        return ""
    _, y0, _, y1 = rects[0]
    center = (y0 + y1) / 2
    nearby = []
    for word in words:
        word_center = page.height - (float(word["top"]) + float(word["bottom"])) / 2
        if abs(word_center - center) <= 26:
            nearby.append(word)
    nearby.sort(key=lambda w: (round(float(w["top"]) / 3), float(w["x0"])))
    return normalize(" ".join(str(word["text"]) for word in nearby))


def initial_topic(comment: str) -> str:
    text = comment.lower()
    if any(term in text for term in ("update", "date", "remove all use", "delete")):
        return "Editorial / publication"
    if any(term in text for term in ("test", "sub-test", "evaluator activity", " ea ")):
        return "Evaluation activity / testing"
    if any(term in text for term in ("sfr", "requirement", "base pp", "selection")):
        return "Requirement alignment"
    if any(term in text for term in ("channel", "communication", "component", "server")):
        return "TOE architecture / communication"
    return "Clarification / rationale"


def analysis_group(document: str, page: int, comment: str) -> str:
    text = comment.lower()
    if text in {"update", "update dates across all documents to 2026"}:
        return "Publication metadata and referenced versions"
    if document == "SD-Application-Software-v2.0-draft-review":
        return "Managed runtime / application framework scope"
    if document == "cPP-Application-Software-v2.0-draft-review":
        if page <= 21:
            return "Managed runtime / application framework scope"
        return "Distributed TOE allocation, IPC, and loopback scope"
    if document == "PP-Configuration-Server-Agent-v2.0-draft-review":
        return "Distributed TOE allocation, IPC, and loopback scope"
    if document == "PP-Module-Server-v2.0-draft-review":
        return "Server module alignment with the base cPP"
    if document == "SD-Module-Server-v2.0-draft-review":
        if page <= 3:
            return "Publication metadata and referenced versions"
        return "Server module alignment with the base cPP"
    if document == "PP-Module-Agent-v2.0-draft-review":
        return "Agent terminology and SFR iteration cleanup"
    if document == "SD-Module-Agent-v2.0-draft-review":
        if page <= 3:
            return "Publication metadata and referenced versions"
        if "remove all use" in text or "no more iterations" in text:
            return "Agent terminology and SFR iteration cleanup"
        return "Agent registration and communication tests"
    if document == "PP-Configuration-Server-v2.0-draft-review":
        return "Publication metadata and referenced versions"
    return "Other / needs triage"


def document_label(path: Path) -> str:
    label = path.stem
    label = re.sub(r"(?:[ _-]+BAH)$", "", label, flags=re.IGNORECASE)
    return label


def main() -> None:
    records: list[dict[str, Any]] = []
    for source in sorted(ROOT.rglob("*.pdf")):
        reader = PdfReader(str(source))
        with pdfplumber.open(str(source)) as plumber:
            for page_number, reader_page in enumerate(reader.pages, start=1):
                annotations = reader_page.get("/Annots", []) or []
                for annotation_ref in annotations:
                    annotation = annotation_ref.get_object()
                    subtype = str(annotation.get("/Subtype", ""))
                    comment = normalize(annotation.get("/Contents"))
                    if not comment or subtype in {"/Link", "/Popup"}:
                        continue
                    rects = rects_for(annotation)
                    plumber_page = plumber.pages[page_number - 1]
                    anchor = text_for_rects(plumber_page, rects)
                    if not anchor:
                        anchor = nearby_text(plumber_page, rects)
                    records.append(
                        {
                            "id": "",
                            "document": document_label(source),
                            "source_file": source.name,
                            "source_path": str(source.relative_to(ROOT.parent)),
                            "page": page_number,
                            "annotation_type": subtype.removeprefix("/"),
                            "author": normalize(annotation.get("/T")),
                            "date": pdf_date(annotation.get("/M")),
                            "anchor_text": anchor,
                            "comment": comment,
                            "initial_topic": initial_topic(comment),
                            "analysis_group": analysis_group(document_label(source), page_number, comment),
                            "status": "Not reviewed",
                            "disposition": "",
                            "owner": "",
                            "resolution_notes": "",
                        }
                    )
    records.sort(key=lambda r: (r["document"], r["page"], r["date"], r["comment"]))
    for index, record in enumerate(records, start=1):
        record["id"] = f"BAH-{index:03d}"

    (OUTPUT / "bah_comment_register.json").write_text(json.dumps(records, indent=2), encoding="utf-8")

    by_document = Counter(record["document"] for record in records)
    by_topic = Counter(record["initial_topic"] for record in records)
    by_group = Counter(record["analysis_group"] for record in records)
    lines = [
        "# BAH Draft Review Comment Register",
        "",
        f"Extracted {len(records)} substantive PDF annotations from {len(by_document)} commented review documents.",
        "",
        "## Counts by document",
        "",
        "| Document | Comments |",
        "| --- | ---: |",
    ]
    lines.extend(f"| {document} | {count} |" for document, count in sorted(by_document.items()))
    lines.extend(["", "## Initial topic grouping", "", "| Topic | Comments |", "| --- | ---: |"])
    lines.extend(f"| {topic} | {count} |" for topic, count in sorted(by_topic.items()))
    lines.extend(["", "## Analysis grouping", "", "| Group | Comments |", "| --- | ---: |"])
    lines.extend(f"| {group} | {count} |" for group, count in sorted(by_group.items()))
    lines.extend(["", "## Full register", ""])
    for record in records:
        lines.extend(
            [
                f"### {record['id']} - {record['document']} (page {record['page']})",
                "",
                f"- Topic: {record['initial_topic']}",
                f"- Analysis group: {record['analysis_group']}",
                f"- Annotation: {record['annotation_type']}; author: {record['author'] or 'not recorded'}; date: {record['date'] or 'not recorded'}",
                f"- Anchor: {record['anchor_text'] or 'No text anchor recoverable'}",
                f"- Comment: {record['comment']}",
                "",
            ]
        )
    (OUTPUT / "bah_comment_register.md").write_text("\n".join(lines), encoding="utf-8")
    print(f"Extracted {len(records)} comments from {len(by_document)} documents.")


if __name__ == "__main__":
    main()
