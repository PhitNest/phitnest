#!/bin/bash

# The name of the file to append to the new file
base="scripts/template_base.yml"

out="template.yml"

# Create or replace the new file
> $out

# Append the contents of the append file to the new file
cat $base >> $out

root="src/lambdas"
# Loop through every file in the directory recursively
find $root -type f | while read file; do
  fileRootless=${file#$root}
  filename=$(basename $fileRootless)
  path=${fileRootless%"/$filename"}
  methodLower=${filename%.ts}
  method="N/A"
  case $methodLower in
  "get")
    method="GET"
    ;;
  "post")
    method="POST"
    ;;
  "put")
    method="PUT"
    ;;
  "delete")
    method="DELETE"
    ;;
  *)
    method="N/A"
    ;;
  esac
  if [ $method != "N/A" ]
  then
    echo "  #### $method $path ####" >> $out
    # Split the path into an array using '/'
    IFS='/' read -ra dirs <<< "$path"
    
    # Loop through the directories and capitalize the first letter
    for i in "${!dirs[@]}"; do
      dirs[$i]="$(tr '[:lower:]' '[:upper:]' <<< ${dirs[$i]:0:1})${dirs[$i]:1}"
    done
    # Join the directories back into a string
    resourceName="$(IFS=/; echo "${dirs[*]}")"
    # Remove the '/' characters
    resourceName="${resourceName//\//}"
    # Get the first character of the string
    firstMethodChar="${method:0:1}"
    # Lowercase the rest of the string
    otherMethodChars="${method:1}"
    otherMethodChars="$(tr '[:upper:]' '[:lower:]' <<< "$otherMethodChars")"
    # Concatenate the first character and the rest of the string
    resourceName="${firstMethodChar}${otherMethodChars}${resourceName}Function"
    echo "  $resourceName:" >> $out
    echo "    Type: AWS::Serverless::Function" >> $out
    echo "    Properties:" >> $out
    echo "      Handler: lambdas$path/$methodLower.invoke" >> $out
    echo "      CodeUri: src/" >> $out
    echo "      Runtime: nodejs16.x" >> $out
    echo "      Events:" >> $out
    echo "        CatchAll:" >> $out
    echo "          Type: Api" >> $out
    echo "          Properties:" >> $out
    echo "            RestApiId: !Ref PhitNestApi" >> $out
    echo "            Path: $path" >> $out
    echo "            Method: $method" >> $out
    # Search for this substring
    substring="@CognitoAuth"
    # Search for the substring in the file and set the variable to the token following it
    # with whitespace as a delimiter
    userPool=$(grep -oP "(@CognitoAuth\s+)\S+" "$file")
    # If the substring does not exist or there is no such token existing after the substring,
    # set the variable to "N/A"
    if ! [[ -z "$userPool" ]]
    then
      userPool=${userPool#"$substring "}
      userPool="${userPool}CognitoAuthorizer"
      echo "            Auth:" >> $out
      echo "              Authorizer: $userPool" >> $out
    fi
  fi
  done