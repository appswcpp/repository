#!/usr/bin/env python3
from io import StringIO 
import re
import sys
import xml.etree.ElementTree as ET
from xml.sax.saxutils import escape



XSLNS="http://www.w3.org/1999/XSL/Transform"
HTMNS="http://www.w3.org/1999/xhtml"
ns={"xsl":XSLNS, "htm":HTMNS}


def warn(msg):
    log(2, msg)

def err(msg):
    sys.stderr.write(msg)
    sys.exit(1)

def debug(msg):
    log(5, msg)

def log(level, msg):
    sys.stderr.write(msg)
    sys.stderr.write("\n")


def handle_element(elem):
    if elem.tag.startswith("{http://www.w3.org/1999/XSL/Transform}"):
        return ""
    tagr = elem.tag.split('}')
    noname=tagr[len(tagr)-1]
    if noname=="br":
        return "<br/>"
    elif noname=="td" or noname=='tr':
        noname="div"
    ret = "<" + noname
    for attrname in elem.attrib:
        ret += " " + attrname + "='"+ escape(elem.attrib[attrname])+"'"
    ret += ">"
    ret += handle_children(elem)
    ret += '</' + noname +'>'
    return ret

def handle_children(elem):
    ret=""
    if elem.text:
        ret += escape(elem.text)
    for child in elem:
        ret += handle_element(child)
        if child.tail:
            ret += child.tail
    return ret



if __name__ == "__main__":
    if len(sys.argv) < 2:
        warn("Usage: bp-documentor <boilerplate-xsl-file>")
        sys.exit(0)

    infile=sys.argv[1]
    if infile=="-":
        root=ET.fromstring(sys.stdin.read())
    else:
        root=ET.parse(infile).getroot()

    print("<html><head><title>Boilerplates</title></head><body><table>")
    for el in root.findall(".//xsl:template[@match]", ns):
        contents = handle_children(el)
        if contents != "":
            print("<tr><td style='background: lightgreen;'>"+el.attrib["match"]+"</td></tr>")
            print("<tr><td style='background: lightblue; max-width: 900px; margin: auto;'>"+contents+"</td></tr>")
            print("<tr><td vspan='2'/><br/></tr>")
    print("</table><br/><br/>")
    print("</body></html>")

