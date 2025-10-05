#!/bin/sh

for item in content/reading/*; do
  coverfilename=static/images/reading/$(basename $item | sed 's/\.md//g' | tr "[:upper:]" "[:lower:]").jpg
  if grep -q 'cover: ' $item; then
    coverurl=$(rg -o 'cover: .*' $item | awk '{print $2}' | sed 's/"//g')
    if [ -f ${coverfilename} ] ; then
      continue
    fi
    echo "Downloading ${coverurl} as '${coverfilename}..."
    curl -Lso ${coverfilename} ${coverurl}
  fi
  if [ ! -f $coverfilename ] ; then
    echo "Missing cover for '${item}'."
  fi
done
