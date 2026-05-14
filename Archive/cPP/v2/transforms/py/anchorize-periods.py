#!/usr/bin/env python3
"""
Converts many text periods in an XHTML document to anchors.
"""

# from io import StringIO
import re
import sys
import xml.etree.ElementTree as ET

period_regex = re.compile("\\.(\\s|$)")


def recursive_descent(elem):
    elname_nonamespace = elem.tag.split('}')[-1]
    if elname_nonamespace == 'a' or elname_nonamespace == 'abbr':
        return
    child_stack = []
    index = 0
    if elem.text:
        (elem.text, subnodes) = handle_text(elem, elem.text)
        child_stack.append((index, subnodes))
    for child in elem:
        recursive_descent(child)
        index += 1
        if child.tail:
            (child.tail, subnodes) = handle_text(elem, child.tail)
            child_stack.append((index, subnodes))
    insert_child_placeholders(child_stack, elem)


def insert_child_placeholders(child_stack, parent):
    while len(child_stack) > 0:
        (index, subnodes) = child_stack.pop()
        for subnode in subnodes:
            parent.insert(index, subnode)
            index += 1


period_ctr = 0


def make_linkable_period(text):
    """
    Makes a link with tail of the given text.
    In the ElementTree model this means the text is a sibling of the linkable
    period.
    """
    global period_ctr
    newelem = ET.Element("a")
    newelem.text = ". "
    uid = "period_"+str(period_ctr)
    newelem.attrib["id"] = uid
    newelem.attrib["href"] = "#"+uid
    period_ctr += 1
    newelem.tail = text
    return newelem


def handle_text(elem, text):
    last = 0
    first_text = text
    new_children = []
    for mat in period_regex.finditer(text):
        # Not elegant
        if last == 0:
            first_text = text[0:mat.start()]
        else:
            new_children.append(make_linkable_period(text[last:mat.start()]))
        last = mat.end()
    if last != 0:
        new_children.append(make_linkable_period(text[last:]))
    return (first_text, new_children)


if __name__ == "__main__":
    argc = len(sys.argv)
    if argc != 3 and argc != 2:
        #        0                        1
        print("Usage: <protection-profile> [<output-file>]")
        sys.exit(0)

    infile = sys.argv[1]
    if infile == "-":
        tree = ET.fromstring(sys.stdin.read())
        outfile = "linkable.html"
    else:
        tree = ET.parse(infile)
        outfile = infile.split('.html')[0]+"-linkable.html"
    recursive_descent(tree.getroot().find(".//body"))
    if argc == 3:
        outfile = sys.argv[2]
    tree.write(outfile, method="html")

