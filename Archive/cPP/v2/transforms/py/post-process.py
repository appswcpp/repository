#!/usr/bin/env python3
"""
This python module takes in xml files that have been processed and
fixes internal references and counters (which are hard to do
with XSLT).
"""

# from io import StringIO
import re
import sys
import string
import lxml.etree as ET
from xml.sax.saxutils import quoteattr, escape


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


A_UPPERCASE = ord('A')
ALPHABET_SIZE = 26

def _decompose(number):
    """Generate digits from `number` in base alphabet, least significants
    bits first.

    Since A is 1 rather than 0 in base alphabet, we are dealing with
    `number - 1` at each iteration to be able to extract the proper digits.
    """
    while number:
        number, remainder = divmod(number-1, ALPHABET_SIZE)
        yield remainder


def base_10_to_alphabet(number):
    """Convert a decimal number to its base alphabet representation"""
    return ''.join(
            chr(A_UPPERCASE + part)
            for part in _decompose(number+1)
    )[::-1]

# Does not do spaces which should be handled later
def backslashify(phrase):
    return re.sub("([_.^()-])", r"\\\1", phrase)


class State:

    def __init__(self, root, main_doc, handle_abbrs):
        self.root = root
        self.parent_map = {c: p for p in self.root.iter() for c in p}
        self.create_classmapping()
        self.abbrs = {}                       # Full set of abbreviaiotns
        self.used_abbrs = set()               # Set of abbreviations that we've seen
        self.full_abbrs = {}                  # Map from full in-text definition to abbreviation
        #                                     # full_abbrs are empty if is_handling_first_abbrs is False
        self.key_terms = []                   # List of terms we're looking for
        self.plural_to_abbr = {}              # Map from plural abbreviations to abbreviation
        self.regex = None                     # Regex used to find things of interest in the documetn
        self.main_doc = main_doc              # Points to the main document (if we're processing an SD)
        self.is_handling_first_abbrs = False  # Flag to say we're handling first abbreviations
        self.abbr_def = set()                 # Set of all full in-text definitions of abbreviations
        self.fix_test_numbers()
        self.sort_it_out() 
        self.fix_indices()
        self.fix_index_refs()
        self.fix_counters()
        self.fix_tooltips()
        self.cross_reference_cc_items()
        self.build_comp_regex()
        self.build_termtable()
        self.fix_refs_to_main_doc()


        
    def fix_test_numbers(self):
        for eapane in self.root.xpath(".//*[@class='activity_pane_body' and .//@class='test-']"):
            for el in eapane:
                if "class" in el.attrib\
                   and ( el.attrib["class"]=="component-activity-header" or\
                         el.attrib["class"]=="element-activity-header"):
                    prefix=el.text
                    self.test_number_stack=[0]
                else:
                    self.fix_test_numbers_recur(el, prefix)
        pass
        
    def fix_test_numbers_recur(self, elem, prefix):
        if "class" in elem.attrib and "test-" in elem.attrib["class"]:
            new_num=self.test_number_stack.pop() + 1
            self.test_number_stack.append(new_num)
            test_label = "Test "+prefix + ":" +".".join(map(str, self.test_number_stack))
            print(test_label)
            elem[0].text = test_label
            self.test_number_stack.append(0)
            

        for kid in elem:
            self.fix_test_numbers_recur(kid, prefix)

        if "class" in elem.attrib and "test-" in elem.attrib["class"]:
            self.test_number_stack.pop()


        
    def set_handle_first_abbrs(self, dfa):
        self.is_handling_first_abbrs = dfa
        return self
        
    def write_out(self, outfile):
        if sys.version_info >= (3, 0):
            with open(outfile, "w+", encoding="utf-8") as outstream:
                outstream.write(state.to_html())
        else:
            with open(outfile, "w+") as outstream:
                outstream.write(state.to_html().encode('utf-8'))

    def create_classmapping(self):
        self.classmap = {}
        for el in self.root.findall(".//*[@class]"):
            classes = el.attrib["class"].split(" ")
            for clazz in classes: #                                   # Go through all the classes the element is a part of
                if clazz in self.classmap: #                          # If we already have this class in the classmap
                    clazzset = self.classmap[clazz]                   # Grab the old
                    # We're working with a list here, not a set
                    # Should really only not meet this if the
                    # input document has an element where a
                    # class is listed twice
                    if el not in clazzset:
                        clazzset.append(el)
                else:
                    self.classmap[clazz] = [el]

    def getElementsByClass(self, clazz):
        if clazz in self.classmap:
            return self.classmap[clazz]
        else:
            return []

    def cross_reference_cc_items(self):
        for clazz in {"assumption", "threat", "OSP", "SOE", "SO",  "componentneeded"}:
            for el in self.getElementsByClass(clazz):
                if "id" in el.attrib:
                    term = el.attrib["id"]
                    self.add_to_regex(term)
                    wrappable = term.replace("_", "_\u200B")
                    if not term == wrappable:
                        self.add_to_regex(wrappable)
                        self.plural_to_abbr[wrappable] = term

    # https://stackoverflow.com/questions/46760856/using-python-to-sort-child-nodes-in-elementtree 
    def sort_children_by(parent, attr):
        sorted(parent, key=lambda child: child.get(attr))

    def sort_it_out(self):
        for sortable in self.getElementsByClass("sort_kids_"):
            sortable[:] = sorted(sortable, key=lambda child: child.get("data-sortkey"))

            #            sort_children_by(sortable, "data-sortkey")

    def build_comp_regex(self):
        comps = self.getElementsByClass('reqid') +\
            self.getElementsByClass('comp')
        for comp in comps:
            if 'id' in comp.attrib:
                self.add_to_regex(comp.attrib["id"])
            else:
                # The MDF has some unorthodox items
                print("Cannot find: "+comp.text)

    def add_to_inline_abbr_def(self, abbr, full):
        partial =  backslashify(full+" (" + abbr+")")
        self.abbr_def.add(re.sub(r'\s+', '\\\s+', partial))

        
    def build_termtable(self):
        for term in self.getElementsByClass('term'):
            if 'data-plural' in term.attrib:
                plural = term.attrib['data-plural']
                self.plural_to_abbr[plural] = term.text
                self.add_to_regex(plural)
            # if 'data-aliases' in term.attrib:
            #     for alias in term.attrib['data-aliases']:
            #         self.add_to_regex(alias)
            # Endif
            self.add_to_regex(term.text)
            longname = self.root.find(".//*[@id='long_abbr_"+term.text+"']")
            self.abbrs[term.text] = longname.text
            if self.is_handling_first_abbrs:
                self.add_to_inline_abbr_def(term.text, longname.text)
                fulldef = (longname.text + " ("+term.text+")").upper()
                self.full_abbrs[fulldef] = term.text
            
    def add_to_regex(self, word):
        if len(word) > 1 and not(word.startswith(".")):
            expre = backslashify(word)
            self.key_terms.append(expre)

    def to_html(self):
        try:
            # Sort them so longer terms are searched first so
            # that shorter terms embedded in larger terms don't
            # interfere with longer terms being found.
            self.key_terms.sort(key=len, reverse=True)
            if self.key_terms:
                regex_str = "(?<!-)\\b(" + "|".join(self.key_terms) + ")\\b"
                if self.abbr_def:
                    regex_str= "("+"|".join(self.abbr_def)+")|" + regex_str
                self.regex = re.compile(regex_str)
        except re.error:
            warn("Failed to compile regular expression: " +
                 regex_str[:-1]+")\\b")
        self.ancestors = []
        return """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
""" + self.to_html_helper(self.root)

    
    def is_in_non_xrefable_section(self):
        return \
            "a"    in self.ancestors or "abbr"    in self.ancestors or\
            "dt"   in self.ancestors or "no-link" in self.ancestors or\
            "h1"   in self.ancestors or "h2"      in self.ancestors or\
            "h3"   in self.ancestors or "h4"      in self.ancestors or\
            "head" in self.ancestors or "script"  in self.ancestors or\
            "svg"  in self.ancestors

    def handle_text(self, parent, text):
        etext = escape(text)
        if self.is_in_non_xrefable_section():
            return etext
        return self.discover_xref(etext)

    def discover_xref(self, etext):
        if self.regex is None:
            return etext
        last = 0
        ret = ""
        for mat in self.regex.finditer(etext):                               # For each match
            ret += etext[last:mat.start()]                                   # Append the characters between the last find and this
            last = mat.end()                                                 # Move the last indexer up
            target = mat.group()                                             # Get the next match
            if mat.group() in self.plural_to_abbr:                           # If it's a plural
                target = self.plural_to_abbr[mat.group()]                    # Set the target to the original abbr
            if target in self.abbrs:                                         # If the target is an abbr
                ret += self.get_rep_for_abbr(target, mat.group())            # Build the link to the abbr
            elif target.upper() in self.full_abbrs:                          # If all uppers matches a full definition
                ret += self.get_rep_for_full(target)                         # Get the representative for the full definition
            else:
                ret += '<a href="#'+target+'">'+mat.group()+'</a>'
        ret += etext[last:]
        return ret

    def get_rep_for_full(self, target):
        """ 
        Gets the representation for an abbreviated term when the whole
        character sequence is found.
        """
        found_abbr = self.full_abbrs[target.upper()]
        if self.is_first_abbr_usage(found_abbr):
            return target
        else:
            ret = '<abbr class="dyn-abbr"><a href="#abbr_' + found_abbr+'">'
            ret += found_abbr +'</a></abbr> '
        return ret
    
        
    
    def get_rep_for_abbr(self,target, orig):
        """
        Gets the representation for an abbreviated term when the abbreviation
        is found.
        """
        endparen = ""
        ret = ""
        if self.is_first_abbr_usage(target):
            ret += self.abbrs[target]
            if target != orig:
                ret += "s"
            ret += " ("
            endparen = ")"
        ret += '<abbr class="dyn-abbr"><a href="#abbr_' + target+'">'
        ret += orig +'</a></abbr>'+ endparen
        return ret
        
    
    def is_first_abbr_usage(self, target):
        if not(self.is_handling_first_abbrs):
            return False
        if target in self.used_abbrs:
            return False
        else:
            self.used_abbrs.add(target)
            return True

       
    def to_html_helper(self, elem):
        """Function that turns document in HTML"""
        if isinstance(elem, ET._Comment): return ""
        tagr = elem.tag.split('}')
        noname = tagr[len(tagr)-1]
        # Breaks elements are converted to empty tags
        if noname == "br":
            return "<br/>"
        if "class" in elem.attrib and "no-link" in elem.attrib["class"]:
            self.ancestors.append("no-link")
        else:
            self.ancestors.append(noname)
        # Everything else is beginning and end tags (even if they're empty)
        ret = "<" + noname
        for attrname in elem.attrib:
            ret = ret + " " + attrname + "=" + quoteattr(elem.attrib[attrname])
        ret = ret+">"
            
            

        
        if elem.text:
#            print("elem.text: " + elem.text)
            ret += self.handle_text(elem, elem.text)
        for child in elem:
            ret += self.to_html_helper(child)
            if child.tail:
                ret += self.handle_text(elem, child.tail)
        ret = ret + '</' + noname + '>'
        self.ancestors.pop()
        return ret
#
# Counters:
#    Have 'class' attribute with value is 'ctr'
#    Have 'data-counter-type' attribute with value of counter-type
#    Have a subelement with the 'class' attribute equal to counter (which is where the index is put)
#    Have 'data-myid' attribute 
#
# Counter References:
#    Have 'class' attribute with value equal to the thing their referencing plus the string '-ref'
#    Have a subelement with the 'class' attribute equal to counter (which is where the index is put)

    def fix_counters(self):
        occurs = {}
        for countable in self.getElementsByClass('ctr'):               # Go through all the counters
            typee = countable.attrib['data-counter-type']              # Get the type of counter
            if typee not in occurs:                                    # If we haven't seen it yet
                occurs[typee] = 0                                      # Make a list
            occurs[typee] += 1                                         # Increment by one
            count_str = str(occurs[typee])
            # Find the subelement with the class attribute equal to 'counter'
            # And set it's value to the counter's value.
            countable.find("*[@class='counter']").text = count_str
            self.fix_this_counter_refs(countable.attrib["data-myid"], count_str)

    def fix_this_counter_refs(self, ctr_id, count_str):
        refclass = ctr_id + "-ref"
        for ref in self.getElementsByClass(refclass):
            ref.find("*[@class='counter']").text = count_str

    def fix_refs_to_main_doc(self):
        if self.main_doc == None:
            return
        for countable in self.main_doc.getElementsByClass('ctr'):
            new_text = countable.find("*[@class='counter']").text + " in the main document"
            ctr_id = countable.attrib['data-myid']
            for ref in self.getElementsByClass(ctr_id+'-ref'):
                ref.tag = "span"
                sub_field = ref.find("*[@class='counter']") 
                sub_field.text = new_text
        for link in self.root.findall(".//a[@href]"):
            href = link.attrib["href"]
            if href.startswith('#'):
                target=href[1:]
                if self.root.find(".//*[@id='"+target+"']") == None\
                        and self.main_doc.root.find(".//*[@id='"+target+"']") != None:
                    link.tag = "span"

    def fix_tooltips(self):
        for elem in self.getElementsByClass("tooltiptext"):
            attribs = self.parent_map[elem].attrib
            if "class" in attribs:
                attribs["class"] = attribs["class"]+",tooltipped"
            else:
                attribs["class"] = "tooltipped"

    def fix_index_refs(self):
        for brokeRef in self.getElementsByClass("dynref"):
            linkend = brokeRef.attrib["href"][1:]
            target = root.find(".//*[@id='"+linkend+"']")
            if target is None:
                if hasattr(self, "main_doc") and self.main_doc != None:
                    target = self.main_doc.root.find(".//*[@id='"+linkend+"']")
                    if target is None:
                        warn("Cannot find "+linkend)
                    brokeRef.tag = "span"
                else:
                    print("Cannot find '"+linkend+"'")

            if not hasattr(target, 'text'):
                print("Target does not have text field: "+linkend)
                continue

            if not hasattr(brokeRef, 'text')\
               or brokeRef.text == None:
                brokeRef.text = ""
            try:
                # Append ref text.
                brokeRef.text = (brokeRef.text + getalltext(target)).strip()
            except AttributeError:
                warn("Failed to find an element with the id of '"+linkend+"'")

    def fix_indices(self):
        toc = self.root.find(".//*[@id='toc']")                       # Find the table of contents
        inums = [0, 0, 0, 0, 0, 0]                                    # Initialize the index number generator
        is_alpha = False                                              # Initialize the is_alpha switch
        eles = self.root.findall(".//*[@data-level]")                 # Gather all elements with a data-level
        base = -1
        for aa in range(len(eles)):                                   # Go through the elemeents
            level = eles[aa].attrib["data-level"]
            if level == 'A' and not is_alpha:                         # If this is the first time we see an appendix
                inums = [-1, 0, 0, 0, 0]
                is_alpha = True
            if level == 'A':                                          # Turn it into an index
                level = 0
            else:
                level = int(level)
                if base == -1:
                    base = level
                level = level-base
            while level > len(inums):                                 # If we have to pad out
                inums.append(0)
            if level+1 < len(inums):                                  # If we go up one set
                inums[level+1] = 0
            inums[level] += 1
            if is_alpha and level == 0:
                prefix = "Appendix " + base_10_to_alphabet(inums[0]) + " - "
            elif is_alpha:
                prefix = base_10_to_alphabet(inums[0])
            else:
                prefix = str(inums[0])
            spacer = ""
            for bb in range(1, level+1):
                prefix = prefix + "." + str(inums[bb])
                spacer = spacer + "&nbps;"


            spany = ET.Element("span")                                # Fix inline index number
            spany.text = eles[aa].text

            if eles[aa].text:
                eles[aa].text = prefix + " " + eles[aa].text
            else:
                eles[aa].text = prefix
            entry = ET.Element("a")
            # Why would an ID have to be escaped?
            # entry.attrib['href'] = '#'+escape(eles[aa].attrib['id'])
            entry.attrib['href'] = '#'+eles[aa].attrib['id']
            entry.attrib['style'] = 'text-indent:'+str(level*10) + 'px'

            entry.text = prefix
            entry.append(spany)
            toc.append(entry)

    def handle_element(self, elem):
        pass


def getalltext(elem):
    ret = ""
    if elem.text:
        ret = elem.text
    for child in elem:
        ret = ret+getalltext(child)
        if child.tail is not None:
            ret = ret +child.tail
    return ret


def safe_get_attribute(element, attribute, default=""):
    if attribute in element.attrib:
        return element.attrib[attribute]
    else:
        return default


def derive_paths(arg):
    out = arg.split("=")
    infile = out[0]
    outfile = ""
    if len(out) < 2:
        outfile = infile.split('.')[0]+".html"
    else:
        outfile = out[1]
    return infile, outfile


def parse_into_tree(path):
    if path == "-":
        return ET.fromstring(sys.stdin.read().encode('utf-8'))
    else:
        return ET.parse(path).getroot()


# def build_from_string(xmldocument):
#     root = ET.fromstring(xmldocument)
#     state = State(root)
#     return state.to_html()

class Argy:
    def __init__(self):
        self.curr = 0

    def get_next_arg(self, is_mandatory):
        """ Ignores the first argument """
        self.curr += 1
        if self.curr < len(sys.argv):
            return sys.argv[self.curr]
        if is_mandatory:
            usage = "[--define-first-abbr] <pp-processed-file>[=<output-file>] [<sd-xml-file>[=<out>]]"        
            print("Usage: " + usage)
            sys.exit(1)
        sys.exit(0)
        

if __name__ == "__main__":
    dfa = False
    argy = Argy()
    first = argy.get_next_arg(True)
    if first == '--define-first-abbr':
        dfa = True
        first = argy.get_next_arg(True)
    infile, outfile = derive_paths(first)
    root = parse_into_tree(infile)
    state = State(root, None, dfa)
    state.write_out(outfile)
    second = argy.get_next_arg(False)
    sd_infile, sd_outfile = derive_paths(second)
    root = parse_into_tree(sd_infile)
    state = State(root, state, dfa)
    state.write_out(sd_outfile)




