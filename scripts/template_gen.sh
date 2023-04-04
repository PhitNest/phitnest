#!/bin/bash

#### Description ####################################################################
#                                                                                   #
#   This shell script is used to generate an AWS SAM template file by combining     #
#   different YAML components, inline shell scripts, and GraphQL schema files.      #
#   The generated template file includes AWS Lambda function configurations for     #
#   API Gateway based on the source files found in the specified lambda             #
#   directory. The script also supports Cognito authentication for Lambda           #
#   functions by scanning for a @CognitoAuth directive in the source files.         #
#                                                                                   #
#####################################################################################

#### Usage ##########################################################################
#                                                                                   #
#   It is critical that this script is ran from the root directory of the project   #
#   To run the shell script, simply execute it in your terminal with the stack      #
#   name as the first argument:                                                     #
#                                                                                   #
#   scripts/template_gen.sh stack_name                                              #
#                                                                                   #
#####################################################################################

#### How the Script Works ###########################################################
#                                                                                   #
#   1. The script initializes the paths for the stack file, component directory,    #
#      script directory, lambda directory, and schema directory.                    #
#   2. It creates an empty output file called template.yml and appends the          #
#      contents of the specified stack file.                                        #
#   3. It searches the component directory for YAML component files and inlines     #
#      them into the output file.                                                   #
#   4. It searches the script directory for shell script files and inlines them     #
#      into the output file.                                                        #
#   5. It concatenates all GraphQL schema files found in the schema directory and   #
#      inlines the combined schema into the output file.                            #
#   6. It searches the lambda directory for .ts files and generates AWS SAM         #
#      function configurations based on the file path and file name. It also        #
#      checks for the @CognitoAuth directive in the source files to determine if    #
#      a Cognito authorizer should be added to the function configuration.          #
#                                                                                   #
#####################################################################################

#### Variables ######################################################################
#                                                                                   #
#   stack............The stack YAML file path.                                      #         
#   componentDir.....The directory containing YAML component files.                 #  
#   scriptDir........The directory containing shell script files to be inlined.     #     
#   lambdaDir........The directory containing TypeScript Lambda source files.       #     
#   schemaDir........The directory containing GraphQL schema files.                 #     
#   out..............The output file name (default: template.yml).                  #         
#   componentPrefix..The prefix used in the output file to indicate the position    #
#                    where the component should be inlined (default: @@).           #
#   scriptPrefix.....The prefix used in the output file to indicate the position    #
#                    where the script should be inlined (default: $$).              #
#   gqlTag...........The tag used in the output file to indicate the position       #
#                    where the GraphQL schema should be inlined (default: <gql>).   #
#                                                                                   #
#####################################################################################

stack="aws/stacks/$1.yml"
componentDir="aws/components/"
scriptDir="aws/scripts/"
lambdaDir="src/lambdas"
schemaDir="dgraph/schema/"

out=".aws-sam/build/template.yml"

componentPrefix="@@"
scriptPrefix="\$\$"
gqlTag="<gql>"

> $out

cat $stack >> $out

find $componentDir -type f | while read file; do
  filename=$(basename $file)
  componentName=${filename%.yml}
  currentOutput=$(cat "$out")
  spacer=$(echo -e "$currentOutput" | grep -o "\s*$componentPrefix$componentName")
  spacer=${spacer%"$componentPrefix$componentName"}
  componentContents=$(cat "$file")
  componentContents=${componentContents//$'\n'/$'\n'$spacer}
  echo $"${currentOutput//$componentPrefix$componentName/# $filename$'\n'$spacer$componentContents}" > "$out"
done

scriptSpacer=""

while IFS= read -r file; do
  filename=$(basename $file)
  scriptName=${filename%.sh}
  currentOutput=$(cat "$out")
  scriptSpacer=$(cat "$out" | grep -o "\s*$scriptPrefix$scriptName")
  scriptSpacer=${scriptSpacer%"$scriptPrefix$scriptName"}
  scriptContents=$(cat "$file")
  scriptContents=${scriptContents//$'\n'/$'\n'$scriptSpacer}
  echo $"${currentOutput//$scriptPrefix$scriptName/# $filename$'\n'$scriptSpacer$scriptContents}" > "$out"
done < <(find "$scriptDir" -type f)

schema=""

while IFS= read -r file; do
  contents=$(cat "$file")
  schema+="$contents"$'\n'
done < <(find "$schemaDir" -type f)

schema=${schema%"\n"}
schema=${schema//$'\n'/$'\n'$scriptSpacer}
currentOutput=$(cat "$out")
echo $"${currentOutput//$gqlTag/$schema}" > "$out"

find $lambdaDir -type f | while read file; do
  fileRootless=${file#$lambdaDir}
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