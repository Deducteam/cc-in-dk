#!/usr/bin/env sh

sed 's/M_temp_u/uu/g' $1 | \
    sed 's/M_temp_P/P2/g' | \
    sed 's/M_temp_0/Z/g' | \
    sed 's/M_temp_//g' > $2
