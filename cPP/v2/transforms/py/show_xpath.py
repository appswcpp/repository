import sys
import lxml.etree as ET

HTM="http://www.w3.org/1999/xhtml"
default_ns = {'cc': "https://niap-ccevs.org/cc/v1",
      'sec': "https://niap-ccevs.org/cc/v1/section",
      'htm': HTM}  


def debug_node(node):
    """ 
    Converts a node into a debug string.

    :param node: The node to convert.
    :returns A string value of the node.
    """
    tag = str(node.tag)+">"
    text = "<"+tag+NoneStr(node.text)
    for child in node:
        text += debug_node(child)
        text += NoneStr(child.tail)
    return text+"</"+tag


def NoneStr(text):
    """
    :param text:
    :returns 
    """
    if text is None:
        return ""
    return text


if __name__ == "__main__":
    if len(sys.argv)!=3:
        print("Usage: <xml-file> <xpath>")
        sys.exit(0)
    root =ET.parse(sys.argv[1]).getroot()
    for xpath in sys.argv[2:]:
        print("Looking for: "+ xpath)
        results = root.xpath(xpath, namespaces = default_ns)
        if len(results) == 0:
            print("Found no results.")
        for result in results:
            print("--------------")
            print(debug_node(result))
