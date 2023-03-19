#!/bin/bash
output="schema.gql"
schemaDir="dgraph/schema/"

while IFS= read -r file; do
  filename=$(basename "$file")
  if [[ "${filename#*.}" == "gql" ]]; then
    contents=$(cat "$file")
    schema="$schema$contents\n"
  fi
done < <(find "$schemaDir" -type f)

echo -e "$schema" > "$output"