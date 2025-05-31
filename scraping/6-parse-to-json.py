#!/usr/bin/env python

import json
import sys
from bs4 import BeautifulSoup

def parse_soup(soup):
    results = []

    for panel in soup.select('.panel-body > .panel.panel-info'):
        word_tag = panel.select_one('.panel-title b')
        definition_tag = panel.select_one('.panel-body')
        if not (word_tag and definition_tag):
            continue

        word = word_tag.get_text(strip=True)
        for label in definition_tag.select('label[onclick^="lookupWord1"]'):
            lookup_word = label.get_text(strip=True)
            # assumes "[[lookup:" and "]]" does not exist in text
            label.replace_with(f"[[lookup:{lookup_word}]]")

        # Preserve HTML (with <lookup>) in definition
        definition = definition_tag.get_text(" ", strip=True)
        results.append({"word": word, "definition": definition})
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
