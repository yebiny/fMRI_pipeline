#!/bin/bash
set -e

TARGET_DIR=results/2-reorient/sub01
OUTPUT_DIR=results/3-bet/sub01

if [ -d "$OUTPUT_DIR" ]; then
  read -t 5 -p "data has already been converted. overwrite? (y/N) " overwrite || true
  if [ "$overwrite" != "y" ]; then exit; fi
  rm -rf $OUTPUT_DIR
fi
mkdir -p $OUTPUT_DIR

bet $TARGET_DIR/sub01_t1_mprage.nii.gz $OUTPUT_DIR/sub01_t1_mprage_brain.nii.gz
