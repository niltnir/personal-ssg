#!/usr/bin/bash
# nodalynn.com - Personal Website of Lynn Noda
#
# Copyright © 2023-2024 Lynn Noda <lynn@nodalynn.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# ./oly "Japan 2010/4" 0
TITLE=$1
BLOCK_NUM=$2

make_filename () {
    echo "$TITLE $BLOCK_NUM" | tr '[:upper:]' '[:lower:]' | sed -e "s/[\/\ ]/-/g"
}

FILENAME=$(make_filename)

latex_to_katex () {
    local katex="$(echo "$1" |
    # Replace LaTeX quotes with normal ones
    perl -0777 -pe 's/``/\"/g' |
    perl -0777 -pe 's/\x27\x27/\"/g' |
    # Replace display math dollar signs with \[\]
    perl -0777 -pe 's/(^|[^\\\$])\$\$(.+?)\$\$/$1\\[$2\\]/sg' |
    # Replace inline math dollar signs with \(\)
    perl -0777 -pe 's/(^|[^\\\$])\$(.+?)\$/$1\\($2\\)/sg' |
    # Wrap \[\] around environments 
    perl -0777 -pe 's/(\\begin{.*}[\s\S]*?\\end{.*})/\\[$1\\]/g' |
    # Remove potential \[\] around displayed environments
    perl -0777 -pe 's/(\\\[[^\]]*?)(\\\[)(.*?)(\\\])(.*?\\\])/$1$3$5/sg')"
    echo "$katex"
}

write_md () {
    local text="$1"
    mkdir -p ./.tmp/oly/
    cd ./.tmp/oly/
    echo "Writing to $FILENAME.md..."
    echo "$text" > "$FILENAME".md
}

OUT="$(latex_to_katex "$(python -m von show "$TITLE" -b "$BLOCK_NUM")")"
write_md "$OUT"
exit 0
