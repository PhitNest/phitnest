import path from "path";
import { promises as fs } from "fs";

const sourceUrl = "../phitnest-nodejs/lib/models";
const destUrl = "../phitnest-flutter/lib/models";
const models = [
  {
    node: "conversation.js",
    dart: "conversation/conversation.dart",
    customMethods: `  bool get isGroup => participants.length > 2;`,
  },

  {
    node: "message.js",
    dart: "chatMessage/message.dart",
    customMethods: `  /// Returns < 0 if this is newer
    /// Returns 0 if [other] occurred at the same time.
    /// Retuns > 0 if [other] is newer.
    int compareTimeStamps(Message other) =>
        createdAt.compareTo(other.createdAt);
  
    operator <(Message other) => compareTimeStamps(other) < 0;
  
    operator <=(Message other) => compareTimeStamps(other) <= 0;
  
    operator >(Message other) => compareTimeStamps(other) > 0;
  
    operator >=(Message other) => compareTimeStamps(other) >= 0;`,
  },

  {
    node: "user.js",
    dart: "user/user.dart",
    customMethods: `  String get fullName => '$firstName\${lastName == '' ? '' : ' '}$lastName';
`,
  },

  // {
  //   node: "userRelationship.js",
  //   dart: "userRelationship/userRelationship.dart"
  // },
];

async function recursivelyWriteFile(file, data) {
  console.log(file);
  await fs.mkdir(path.dirname(file), { recursive: true });
  await fs.writeFile(file, data);
}

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

/**
 *
 * @param {String} type
 */
function nodejsToDartTypes(type) {
  if (type === "Boolean") {
    return "bool";
  } else if (type === "Date") {
    return "DateTime";
  }
  return type;
}
function autogenWarning(url) {
  return `// THIS FILE IS AUTO GENERATED ${url ? `FROM ${url}` : ""}
// To edit this model - follow instructions in ../utils/README.md\n`;
}

async function main() {
  for (const model of models) {
    let sourceContents = await fs.readFile(path.join(sourceUrl, model.node));
    sourceContents = sourceContents.toString();

    // Find class name (e.g. Message or Conversation)
    let className =
      model.classNameOverride || sourceContents.match(/model\("(\w+)"/im)[1];

    // Find outerFields in nodejs file
    let blocks = splitCodeByBrackets(sourceContents);
    let firstBlock = blocks[0].trim();
    let secondBlock = blocks[1].trim();
    let outerFields = splitCodeByBrackets(firstBlock);
    outerFields = outerFields.map((f) => f.trim());

    // Find out if timestamp exists, if so append createdAt to dart model
    let hasTimestamps = secondBlock.includes("timestamp");

    // Get labels (e.g. "sender", "message", "createdAt")
    let both = firstBlock.split(/[\}\{]/gm);
    let rawLabels = both.filter((v, i) => i % 2 === 0);
    let labels = rawLabels.map((l) => l.match(/[a-z]+/gim)?.[0]);
    labels = labels.filter((v) => v);
    let allProps = labels.map((l, i) => {
      return { field: l, isArray: rawLabels[i].includes("[") };
    });

    // Iterate through each outField
    let labelIndex = 0;
    for (let outerField of outerFields) {
      // Iterate through each field inside { type: ..., required: ... }
      for (let field of outerField.split(",")) {
        let [fieldName, valueName] = field.split(":");
        fieldName = fieldName.trim();
        if (fieldName.trim() === "type") {
          let isRef = valueName.includes("Types.");
          let val;
          if (isRef) {
            // If mongoose ref type
            val = "String";
          } else {
            val = nodejsToDartTypes(valueName.match(/[a-z]+/gim)[0]);
          }
          allProps[labelIndex].value = val;
          allProps[labelIndex].isRef = isRef;
        }
      }
      labelIndex++;
    }
    console.log(allProps);

    // Add createdAt prop (if )
    if (hasTimestamps) {
      allProps.unshift({
        field: "createdAt",
        value: "DateTime",
        isRef: false,
        isArray: false,
      });
    }

    // Add [className]Id prop (e.g. conversationId)
    const classIdProp = {
      field: className.toLowerCase() + "Id",
      value: "String",
      isRef: false,
      isArray: false,
    };

    // Type declarations
    const typeDeclarations = [classIdProp, ...allProps]
      .map((prop) => {
        if (prop.isArray) {
          return `List<${prop.value}> ${prop.field};`;
        }
        return `${prop.value} ${prop.field};`;
      })
      .join("\n  ");

    const constructorParameters = allProps
      .map((prop) => {
        return `required this.${prop.field},`;
      })
      .join("\n    ");

    const factoryBody = allProps
      .map((prop) => {
        if (prop.isArray) {
          return `${prop.field}: (parsedJson['${prop.field}'] as List<dynamic>).cast<${prop.value}>(),`;
        }
        return `${prop.field}: parsedJson['${prop.field}'],`;
      })
      .join("\n      ");

    let outputCode = `${autogenWarning(path.join(sourceUrl, model.node))}
class ${className} {
  ${typeDeclarations}

  ${className}(this.${classIdProp.field}, {
    ${constructorParameters}
  });

  factory ${className}.fromJson(Map<String, dynamic> parsedJson) =>
    ${className}(
      parsedJson['_id'],
      ${factoryBody}
    );

  ${model.customMethods}
}`;
    await recursivelyWriteFile(path.join(destUrl, model.dart), outputCode);
    // await fs.writeFile(path.join(destUrl, model.dart), outputCode);
  }

  let exportModelsCode =
    autogenWarning() +
    "\n" +
    models.map((m) => `export '${m.dart}';`).join("\n");
  await recursivelyWriteFile(
    path.join(destUrl, "models.dart"),
    exportModelsCode
  );
}

main();
