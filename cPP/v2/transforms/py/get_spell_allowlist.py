#!/usr/bin/env python3
"""
Extracts all the defined capitalizations (also incorrectly known as acronyms) from a PP
"""

import sys
import xml.etree.ElementTree as ET
import os
import re


def extract_from_doc(path):
    allowlist=set()
    ns = {'cc': "https://niap-ccevs.org/cc/v1",
      'sec': "https://niap-ccevs.org/cc/v1/section",
      'htm': "http://www.w3.org/1999/xhtml"}
    root = ET.parse(path).getroot()
    for term in root.findall(".//cc:term", ns):
        add_val_if_attrib(term, "abbr", allowlist)
        add_val_if_attrib(term, "plural", allowlist)
    for comp in root.findall(".//cc:f-component", ns)+root.findall(".//cc:a-component", ns):
        if "cc-id" in comp.attrib:
            for part in re.split('[\._0-9]', comp.attrib["cc-id"]):
                allowlist.add(part.upper())
        add_val_if_attrib(comp, "iteration", allowlist)
    for tag in root.findall(".//cc:entry/cc:tag", ns):
        allowlist.add(tag.text)
    for item in {"assumption", "threat", "SO", "SOE"}:
        for el in root.findall(".//cc:"+item, ns):
            if "name" in el.attrib:
                for part in re.split('[\._0-9]', el.attrib["name"].split(".")[1]):
                    allowlist.add(part.upper())
    for wurd in allowlist:
        print(wurd)
                

def add_val_if_attrib(el, name, allowlist):
    if name in el.attrib:
        allowlist.add(el.attrib[name])
            
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: <protection-profile>")
        sys.exit(0)
    else:
        for arg in sys.argv[1:]:
            extract_from_doc(arg)
