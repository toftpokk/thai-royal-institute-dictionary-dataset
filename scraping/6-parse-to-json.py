#!/usr/bin/env python

import json
import sys
from bs4 import BeautifulSoup, NavigableString, CData, Tag, Iterator, element

def recursiveChildren(elem) -> list:
    if isinstance(elem, NavigableString):
        return [str(elem)]
    elif isinstance(elem,Tag):
        childrenStr = []
        for child in elem.children:
            childrenStr += recursiveChildren(child)
        if elem.name == "label" and "onclick" in elem.attrs:
            # special label
            return [{ 
                     "type": "label-onclick",
                     "children": childrenStr, 
                     "to": elem.attrs["onclick"],
                     }]
        elif elem.name == "i":
            return [{
                     "type": "italics",
                     "children": childrenStr, 
                     }]
        elif elem.name == "br":
            return [{
                 "type": "linebreak",
                }]
        elif elem.name == "u":
            return [{
                 "type": "underline",
                 "children": childrenStr, 
                }]
        elif elem.name == "b":
            return [{
                 "type": "bold",
                 "children": childrenStr, 
                }]
        elif elem.name == "div":
            return childrenStr
        else:
            print("Unknown Tag",elem.name)
            exit(1)
    else:
        print("Neither a Tag nor a NavigableString",str(elem))
        exit(1)


def parse_soup(soup):
    results = []

    for panel in soup.select('.panel-body > .panel.panel-info'):
        word_tag = panel.select_one('.panel-title b')
        definition_tag = panel.select_one('.panel-body')
        if not (word_tag and definition_tag):
            continue

        word = word_tag.get_text(strip=True)
        parsed = recursiveChildren(definition_tag)

        results.append({"word": word, "definition": parsed})
    return results


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("required <input> <output> files")

    content = ""
    with open(sys.argv[1],"r") as f:
        content = f.read()

    soup = BeautifulSoup(content, 'html.parser')

    results = parse_soup(soup)
    js = json.dumps(results)

    with open(sys.argv[2], "w") as f:
        f.write(js)
