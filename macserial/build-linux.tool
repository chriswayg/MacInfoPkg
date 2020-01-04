#!/bin/bash

# compiles a Debian Linux version of macserial on grml 2018.12
# Debug version: DEBUG=true ./build-linux.tool

rm -rfv bin
mkdir -v bin || exit 1

VER=$(cat src/macserial.h | grep 'PROGRAM_VERSION' | cut -f2 -d'"')

if [ "$VER" == "" ]; then
  VER=unknown
fi

printf "\nVersion: $VER\n"
printf "\nCompiling macserial...\n"
if [ "$DEBUG" != "" ]; then
  gcc -v -std=c11 -Werror -Wall -Wextra -pedantic -O0 -g src/macserial.c -o bin/macserial || exit 1
else
  gcc -s -std=c11 -Werror -Wall -Wextra -pedantic -O3 src/macserial.c -o bin/macserial || exit 1
fi

printf "\nCompressing macinfo...\n"
cd bin || exit 1
rm -rfv tmp || exit 1
mkdir -v tmp || exit 1
cp -v macserial tmp || exit 1
cp -v ../../macrecovery/macrecovery.py tmp || exit 1
cp -v ../../macrecovery/recovery_urls.txt tmp || exit 1
cp -v ../FORMAT.md                     tmp || exit 1
cd tmp || exit 1

zip -ry -FS ../"macinfo-${VER}-linux.zip" * || exit 1

exit 0
