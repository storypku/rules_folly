#! /bin/bash
while read -r line; do
  if [[ "${line}" =~ ^#cmakedefine ]]; then
    read -r -a elems <<< "${line}"
    val="${elems[2]}"
    if [[ "${val}" == "0" || "${val}" =~ ^@ ]]; then
      printf "//#undef %-40s\n" "${elems[1]}"
    else
      printf "#define %-40s %-20s\n" "${elems[1]}" "${val}"
    fi
  else
    echo "${line}"
  fi
done
