#!bin/bash
set -e

TARGET_DIR=results/${1}

for target in `ls $TARGET_DIR/*repSup*fsf`;
do
    printf $target'\n'
    feat $target
done


for target in `ls $TARGET_DIR/*train*fsf`;
do
    printf $target'\n'
    feat $target
done
