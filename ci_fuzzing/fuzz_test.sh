#! /bin/bash

git clone https://github.com/AFLplusplus/AFLplusplus.git
cd AFLplusplus
make
cd ..
mkdir seeds
echo input >> seeds/inp1 
AFLplusplus/afl-gcc -o fuzz test_fuzzing.c

if [ -z "$AFL_STOP_MANUALLY" ];
then AFLplusplus/afl-fuzz -i seeds -o out ./fuzz
else timeout --preserve-status 10s AFLplusplus/afl-fuzz -i seeds -o out ./fuzz
fi
