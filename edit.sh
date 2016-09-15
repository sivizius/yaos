#!/bin/bash

if [[ -d "src/yaos" ]]; then cd "src/yaos"; fi
line="sba.sh yaos.fasm "
if [ "$(ls -A 'code')" ]; then line="$line code/*"; fi
if [ "$(ls -A 'data')" ]; then line="$line data/*"; fi
#if [ "$(ls -A 'misc')" ]; then line="$line misc/*"; fi
if [ "$(ls -A 'resv')" ]; then line="$line resv/*"; fi
if [ "$(ls -A 'stat')" ]; then line="$line stat/*"; fi
if [ "$(ls -A 'text')" ]; then line="$line text/*"; fi
editor $line
