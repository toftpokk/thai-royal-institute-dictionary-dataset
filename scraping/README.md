## Instructions

Scrape words from website

  1-scrape.sh 

Move everything to outputs

  mkdir -p outputs/raw/ก
  cp 1.json outputs/raw/ก
  
Sanity Check with word count

  ./3-sanity-check.sh outputs/raw

Extract words

  ./4-extract-words.sh outputs/raw

Move everything to outputs

```
  mkdir outputs/extracted
  mv *.txt outputs/extracted
```

Scrape text

  ```
  ./5-scrape.sh "myemail@mail" outputs/extracted/words_ส.txt
  mkdir ส
  mv *.html ส/
  mkdir outputs/definitions_extract
  mv ส outputs/definitions_extract
  ```

Extract to json
  
  source .venv/bin/activate
  `./7-parse-to-json-loop.sh outputs/definitions_extract outputs/definitions_json`

Grouping

  ./8-grouping-json.sh outputs/definitions_json outputs/definitions_json_grouped
  
Final sanity check

  ./sanity-checker-count outputs/extracted
  ./9-sanity-check.sh outputs/definitions_json_grouped
  
  diff <(./10-sanity-check-word.sh outputs/definitions_json_grouped | sort) <(./sanity-checker-word outputs/extracted)

## Notes

The final step extraction step tries to preserve as much data
from the html structure as possible into json format. This 
results in the definition part being a tree structure of html
tags (skipping all `<div>` tags of course). Future applications
may decide to rebuild the html structure or put it in markdown
for example.

To find the unique tags

  grep -rh "type" | sed -E "s/^\s*//" | sort | uniq
