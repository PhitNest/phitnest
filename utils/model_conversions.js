import path from "path";
import { promises as fs } from "fs";

const sourceUrl = "../phitnest-nodejs/lib/models";
const destUrl = "../phitnest-flutter/lib/models";

const models = [
  {
    node: "conversation.js",
    dart: "conversation/conversation_.dart",
    customMethods: `  bool get isGroup => participants.length > 2;`,
  },

  {
    node: "message.js",
    dart: "chatMessage/chat_message_.dart",
    customMethods: `  /// Returns < 0 if this is newer
    /// Returns 0 if [other] occurred at the same time.
    /// Retuns > 0 if [other] is newer.
    int compareTimeStamps(ChatMessage other) =>
        createdAt.compareTo(other.createdAt);
  
    operator <(ChatMessage other) => compareTimeStamps(other) < 0;
  
    operator <=(ChatMessage other) => compareTimeStamps(other) <= 0;
  
    operator >(ChatMessage other) => compareTimeStamps(other) > 0;
  
    operator >=(ChatMessage other) => compareTimeStamps(other) >= 0;`,
  },

  {
    node: "user.js",
    dart: "user/user_.dart",
    customMethods: ``,
  },

  // {
  //   node: "userRelationship.js",
  //   dart: "userRelationship/userRelationship.dart"
  // },
];

const buildTemplate = ({
  className,
  typeDeclarations,
  constructorParameters,
  factoryParameters,
  customMethods,
}) => `

class ${className} {
  ${typeDeclarations}

  ${className}({
    ${constructorParameters}
  })

  factory ${className}.fromJson(Map<String, dynamic> parsedJson) =>
    ${className}(
      parsedJson['_id'],
      ${factoryParameters}
    )

  ${customMethods}
}
`;

/**
 * Splits the code by brackets and returns an array of smaller code blocks
 */
function splitCodeByBrackets(code) {
  let depth = 0;
  let blocks = [];
  let blockStart = 0;
  let blockEnd = 0;
  for (let i = 0; i < code.length; i++) {
    if (code[i] === "{") {
      if (depth === 0) {
        blockStart = i;
      } // If top-level { bracket
      depth++;
    } else if (code[i] === "}") {
      depth--;
      if (depth === 0) {
        // If top-level } bracket
        blockEnd = i;
        blocks.push(code.slice(blockStart + 1, blockEnd));
      }
    }
  }
  return blocks;
}

async function main() {
  for (const model of models) {
    let sourceContents = await fs.readFile(path.join(sourceUrl, model.node));
    sourceContents = sourceContents.toString();

    // Find outerFields in nodejs file
    let blocks = splitCodeByBrackets(sourceContents);
    let firstBlock = blocks[0].trim();
    let outerFields = splitCodeByBrackets(firstBlock);
    outerFields = outerFields.map((f) => f.trim());

    // Get labels (e.g. "sender", "message", "createdAt")
    let both = firstBlock.split(/[\}\{]/gm);
    let labels = both.filter((v, i) => i % 2 === 0);
    labels = labels.map((l) => l.match(/[a-z]+/gim)?.[0]);
    labels = labels.filter((v) => v);
    let typeData = labels.map((l) => {
      return { field: l };
    });

    // Iterate through each outField
    let labelIndex = 0;
    for (let outerField of outerFields) {
      // Iterate through each field inside { type: ..., required: ... }
      for (let field of outerField.split("\n")) {
        let [fieldName, valueName] = field.split(":");
        fieldName = fieldName.trim();
        if (fieldName.trim() === "type") {
          typeData[labelIndex]["value"] = valueName.match(/[a-z]+/gim)[0];
        }
      }
      labelIndex++;
    }
    console.log(typeData);

    let outputStr = buildTemplate({
      className: "User",
      typeDeclarations:
        typeData
          .map((type) => {
            return `${type.value} ${type.field}`;
          })
          .join(";\n  ") + ";",
      customMethods: model.customMethods,
    });

    await fs.writeFile(path.join("./test.txt"), outputStr);

    return;
    // await fs.writeFile(path.join(destUrl, model.dart), outputCode);
  }
}

//
main();
