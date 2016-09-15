#!/bin/bash

../build/bin/fasm "yaos.fasm" "../build/bin/yaos" 2>&1 | tee "../build/out/yaos.log"
