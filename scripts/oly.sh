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
TITLE=$0
PROBLEM=von show $TITLE -b 0
SOLUTION=von show $TITLE -b 1
MOTIVATION=von show $TITLE -b 2
FULLTEXT="${PROBLEM} ${SOLUTION} ${MOTIVATION}"

make_filename () {
    local title = $1 | tr '[:upper:]' '[:lower:]' | sed -e "s/[\/\ ]/-/g"
    echo $title
}

FILENAME=$(make_filename $TITLE)

latex_to_katexmd () {
    local katexmd = $1 
    # Replace inline math dollar signs with \(\)
    | sed -re "s/(^|[^\$])\$([^\$]+)\$([^\$]|$)/\1\\(\2\\)\3/g"
    # Replace display math dollar signs with \[\]
    | sed -re "s/(^|[^\$])\$\$([^\$]+)\$\$([^\$]|$)/\1\\[\2\\]\3/g"
    # Wrap \[\] around environments 
    | sed -re "s/(\\begin{.*}[\s\S]*?\\end{.*})/\\[\1\\]/g"
    echo $katexmd
}

write_md () {
    local text = $1
    mkdir -p ../temp/.olytemp/
    cd ../temp/.olytemp/
    printf $text > "$FILENAME".md
}

OUT=""
if [ $1 == 0 ]; then
    OUT=$(latex_to_katexmd $PROBLEM)
elif [ $1 == 1 ]; then 
    OUT=$(latex_to_katexmd $SOLUTION)
elif [ $1 == 2 ]; then
    OUT=$(latex_to_katexmd $MOTIVATION)
else 
    OUT=$(latex_to_katexmd $FULLTEXT)
fi

write_md $OUT
echo $OUT
exit 0
