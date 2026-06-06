#!/usr/bin/env bash

for file in $(find . \( -path ./template \) -prune -or -type f -name "*.typ" -print | sort); do
    file=${file#./}
    echo "Processing $file..."
    a=$(git log --follow --pretty="%H<SECTION>%cI<SECTION>%cN<SECTION>%s<END_COMMIT>" "$file")
    echo $a > "$file.gitinfo"
    cat << EOF >> "$file"

#let data = read("$(basename "$file").gitinfo",);#let file = "$file";#import "/template/template.typ": gitinfo;#gitinfo(data, file)
EOF
done