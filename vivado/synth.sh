#!/bin/bash

set -uo pipefail

cd "$(dirname "$0")" || exit $?
set -e
git clean -dfx build
mkdir build
cd build
mkdir ip
vivado -mode tcl -source ../synth.tcl
