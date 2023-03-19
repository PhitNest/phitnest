output="schema.gql"
schemaDir="schema/"

while IFS= read -r file; do
  filename=$(basename "$file")
  if [[ "${filename#*.}" == "gql" ]]; then
    contents=$(cat "$file")
    schema="$schema$contents\r"
  fi
done < <(find "$schemaDir" -type f)

echo -e "$schema" > "$output"