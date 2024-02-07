#!/usr/bin/env sh

sed 's/π/pi/g' $1 | \
    sed 's/⋄/empty/g' | \
    sed 's/↑/up/g' | \
    sed 's/⇑/UUp/g' | \
    sed 's/◁/ext/g' | \
    sed 's/↦/To/g' | \
    sed 's/∨/max/g' | \
    sed 's/𝔄/Ax/g' | \
    sed 's/𝔑/Ru/g' > $2
