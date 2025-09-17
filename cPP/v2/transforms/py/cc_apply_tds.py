#!/usr/bin/env python3
import sys
import pathlib
#import xml.etree.ElementTree as ET
import lxml.etree as ET
# from lxml.builder import ElementMaker

# EM=ElementMaker(namespace=None,  nsmap={None: "https://niap-ccevs.org/cc/v1",
#                                          "htm":"http://www.w3.org/1999/xhtml"})
HTM="http://www.w3.org/1999/xhtml"
default_ns = {'cc': "https://niap-ccevs.org/cc/v1",
      'sec': "https://niap-ccevs.org/cc/v1/section",
      'htm': HTM}  

def extract_first_number(phrase):
    ret=""
    for aa in phrase:
        if aa.isdigit():
            ret+=aa
        elif ret != "":
            return ret
    return ret

    
def get_num(fullpath):
    path = pathlib.Path(fullpath)
    stem = path.stem
    num = extract_first_number(stem)
    try:
        ret = int( num )
        return ret
    except ValueError:
        return sys.maxsize
#        return 99999

def log(msg):
    sys.stderr.write(msg)
    sys.stderr.write("\n")

def get_release_notes(root):
    ret = root.find(".//cc:release-notes",default_ns)
    if ret is not None:
        log("It's not None")
        return ret
    revhist = root.find(".//cc:RevisionHistory", default_ns)
    if revhist is None:
        return None
    parent = revhist.xpath("ancestor::cc:*[1]", namespaces=default_ns)[0]
    index = parent.index(revhist)
    ret = ET.Element("{"+default_ns["cc"]+"}release-notes")    
    parent.insert(index+1, ret)
    return ret 

def maybe_append_el(parent, child):
    if parent is not None:
        parent.append(child)
    return  child

TD_ATTRS={"class":"td-"}

# TDs should really been in their own namespace
# as this decision could stomp things if "decision" was an
# element in the main CC documents.
def add_td_to_release_notes(relnote, td):
    for decision_el in td.findall(".//cc:decision", default_ns):
        if "url" in decision_el:
            newchild = ET.Element("{"+HTM+"}a", TD_ATTRS)
        else:
            newchild = ET.Element("{"+HTM+"}div", TD_ATTRS)
        
        newchild.text = decision_el.attrib["id"]
        if "date" in  decision_el.attrib:
            newchild.text+= " ("+ decision_el.attrib["date"]+")"
        log(newchild.text)
        relnote.insert(1, newchild)
        
def apply_tds(main_path, tds):
    doc = ET.parse(main_path)
    root = doc.getroot()
    parent_map = {c: p for p in root.iter() for c in p}
    relnote = get_release_notes(root)
    el = ET.Element("{"+default_ns["htm"]+"}h3", nsmap=default_ns)
    el.text= "TDs Applied"
    el = maybe_append_el(relnote, el)
    


    ET.register_namespace('cc',"https://niap-ccevs.org/cc/v1")
    ET.register_namespace('sec',"https://niap-ccevs.org/cc/v1/section")
    ET.register_namespace('h', "http://www.w3.org/1999/xhtml")
    # Need to sort
    tds.sort(key=get_num)
    for td_path in tds:
        td = ET.parse(td_path).getroot()
        add_td_to_release_notes(relnote, td)
      
        ns_el = td.find(".//cc:xpath_namespaces",default_ns)
        if ns_el is None:
            ns = default_ns
        else:
            ns =ns_el.attrib 
        replaces = td.findall(".//cc:replace", ns)
        for replace in replaces:
            for xpath_spec in replace.findall(".//cc:xpath-specified", ns):
                xpath = "."+ xpath_spec.attrib["xpath"]
                matches = root.xpath(xpath, namespaces=ns)
                #                replaced = root.find(xpath, ns)
                if not len(matches)==1:
                    log("Found "+ str(len(matches))+ " nodes using:::"  + xpath + "::: Expected 1")
                    continue
                replaced = matches[0]
                parent = parent_map[replaced]
                if parent is None:
                    log("Cannot find parent")
                    continue
                kid_cache = []
                for kid in list(parent):
                    if kid == replaced:
                        for newkids in list(xpath_spec):
                            kid_cache.append(newkids)
                    else:
                        kid_cache.append(kid)
                    parent.remove(kid)
                for kid in kid_cache:
                    parent.append(kid)
    print(ET.tostring(root, encoding='unicode', method='xml'))

    
if __name__ == "__main__":
    if len(sys.argv)==1:
        print("Usage: <input-file> [<td1> [<td2> ...]]")
        sys.exit(0)

    apply_tds(sys.argv[1], sys.argv[2:])
