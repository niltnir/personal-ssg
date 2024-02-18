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

# (oly "Japan 2010/4" 1)
cmdlist=$(grep -rohP '\(oly[\s\S]*?\)' ./pages/math/*)

echo "$cmdlist" | while read -r cmd;
do
    echo "Processing $cmd..."
    arg1=$(echo "$cmd" | grep -o '\".*\"' | grep -oE '[^\"]+')
    arg2=$(echo "$cmd" | grep -oE '[0-9]+\)' | grep -oE '[0-9]+')
    ./scripts/oly.sh "$arg1" "$arg2"
done

