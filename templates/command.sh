#!/bin/bash

set -exu
exec > ${tmp_path}/bulk_file_copy.log 2>&1

%{ if destination_path != ""}
if [[ -d ${file_tmp_path} ]]; then
  files=(${file_tmp_path}/${file_pattern})
  if [[ $${#files[@]} -gt 0 ]]; then
    sudo cp ${file_tmp_path}/${file_pattern} ${destination_path}/
  fi
fi
%{ else }
echo "no privileged path specifed: noop"
%{ endif }
