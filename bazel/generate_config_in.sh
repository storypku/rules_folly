#! /bin/bash
while read -r line; do
  if [[ "${line}" =~ ^#cmakedefine ]]; then
    read -r -a elems <<< "${line}"
    printf "#cmakedefine %-40s %-42s\n" "${elems[1]}" "@${elems[1]}@"
  else
    echo "${line}"
  fi
done
