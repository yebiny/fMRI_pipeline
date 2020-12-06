#!/bin/bash
# author: mgsimon@princeton.edu
# edited by: atompary@gmail.com
# downloads raw DICOM data for the specified subject from sun and compresses it
# into a gzipped tar file at the file path specified by output_path
# 3/10/11 added option to choose data collected on skyra

set -e # fail immediately on error

if [ $# -ne 1 ]; then
  echo "
usage: `basename $0` scanner

Retrieves raw DICOM data from the specified scanner's server and compresses it
into a gzipped tar file.

If you're retrieving data from skyra, add an s, separated by a space, after
you write out the script name. if retrieving from allegra, use an a.

example: `basename $0` s
  "
  exit
fi
scanner=$1

source globals.sh

tmp_dir="$(mktemp -d)"
data_dir=$tmp_dir/$SUBJ
dicom_rename -$scanner -patid $SUBJ -destdir $tmp_dir -prefix $SUBJ > /dev/null  


output_file=raw.tar.gz
output_dir=$DATA_DIR
pushd $data_dir > /dev/null
tar --create --gzip --file=$output_file *
popd > /dev/null
mv $data_dir/$output_file $output_dir

rm -rf $tmp_dir
