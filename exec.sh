#!/bin/bash

../build/bin/yaos.elf 2>&1 | tee -a "../build/out/yaos.log"
