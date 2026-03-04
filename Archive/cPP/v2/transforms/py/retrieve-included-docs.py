#!/usr/bin/env python3
"""
Parses a PP retrieves the packages or PPs that are requirements.
"""

# from io import StringIO
import sys
import urllib.request
import xml.etree.ElementTree as ET
import os
import pathlib
import tempfile

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


def download_url(url, path):
    """Download a file from a url and place it in root.
    Args:
        url (str): URL to download file from
        fpath(str): Full path to the destination file
    """

    try:
        print('Downloading ' + url + ' to ' + fpath, file=sys.stderr)
        urllib.request.urlretrieve(url, fpath)
    except (urllib.error.URLError, IOError) as e:
        if url[:5] == 'https':
            url = url.replace('https:', 'http:')
            print('Failed download. Trying https -> http instead.'
                  ' Downloading ' + url + ' to ' + fpath, file=sys.stderr)
            urllib.request.urlretrieve(url, fpath)

def get_effective_doc(url, branch, fpath):
    workdir = tempfile.TemporaryDirectory()
    abspath = os.path.abspath(fpath)
    commands = ("set -x; cd "+workdir.name +
                " && git clone --depth 1 --branch " + branch + " --recursive " + url +
                " && cd *" +
                " && git pull origin " + branch + 
                " && (unset PP_XML; EFF_XML=\"" + abspath + "\"  make effective)")
    print("Comamnds: " + commands)
    os.system(commands)



if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: <protection-profile> [directory]")
        sys.exit(0)
    # Split on equals
    if sys.argv[1] == "-":
        root = ET.fromstring(sys.stdin.read()).getroot()
    else:
        root = ET.parse(sys.argv[1]).getroot()
    dir = "."
    if len(sys.argv) == 3:
        dir = sys.argv[2]
    ns = {'cc': "https://niap-ccevs.org/cc/v1",
          'sec': "https://niap-ccevs.org/cc/v1/section",
          'htm': "http://www.w3.org/1999/xhtml"}
    ctr = 1
    for pkg in root.findall(".//cc:include-pkg", ns)+\
               root.findall(".//cc:base-pp", ns)+\
               root.findall(".//cc:module", ns):
        if "name" in pkg.attrib:
            continue
        filename = pkg.attrib["id"] + ".xml"
        url = "".join(pkg.find("./cc:git/cc:url", ns).text.split())
        branch = pkg.find("./cc:git/cc:branch", ns).text
        rootdir = os.path.expanduser(dir)
        if not filename:
            filename = os.path.basename(url)
        fpath = os.path.join(rootdir, filename)
        os.makedirs(rootdir, exist_ok=True)
        f_info = pathlib.Path(fpath)
        
        if not f_info.exists():
            get_effective_doc(url, branch, fpath)
#            download_url(url, fpath)
        #
#        open( str(ctr)+".xml", 'wb').write( requests.get( url ) )


