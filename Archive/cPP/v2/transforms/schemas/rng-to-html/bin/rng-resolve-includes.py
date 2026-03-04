#!/usr/bin/env python3
""" 
Executable that will accept an rng and remove includes by recursively diving into them and gathering
the definitions.
"""

RNG_NS="http://relaxng.org/ns/structure/1.0"
NS={"rng":RNG_NS}


from pathlib import Path
from io import BytesIO
import sys
import xml.etree.ElementTree as ET

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


def resolve(root, path):
    "Resolves"
    for includes in root.findall(".//rng:include", NS):    
        subpath=Path(includes.attrib["href"])
        if not subpath.is_absolute():
            subpath=path / subpath
        included=ET.parse(subpath.open()).getroot()
        included=resolve(included, subpath)

        for subdefined in included.findall(".//rng:define", NS):
            redef = includes.find(
                ".//rng:define[@name='"+subdefined.attrib['name']+"']",
                NS
            )
            if not redef:
                redef=subdefined
            root.insert(0, redef)
    return root

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: <in-rng>")
        sys.exit(0)

    # Split on double colon
    out=sys.argv[1].split("::")
    infile=out[0]
    outfile=""
    if len(out) < 2:
        outfile=infile.split('.')[0]+".html"
    else:
        outfile=out[1]

        
    if infile=="-":
        root=ET.fromstring(sys.stdin.read())
        path=Path(".")
    else:
        root=ET.parse(infile).getroot()
        path=Path(infile).parent
        

    root = resolve(root, path)

    buf=BytesIO()
    ET.ElementTree(root).write(buf, encoding='utf-8')
    print(buf.getvalue().decode('utf-8'))
    # if outfile == "-":
    #     print(buf.getvalue().decode('utf-8'))
    # else:
    #     with open(outfile, "w") as fout:
    #         fout.write(buf.getvalue().decode('utf-8'))



