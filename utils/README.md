# Wait-up! Don't run this code! It contains bugs as of this commit.

# Phitnest Code Nodejs-to-Dart Converter

Convert between node.js and dart code by running this script. Generates dart code from phitnest-nodejs/lib/models.

## Run locally

run `npm install`\
run `npm start`\
This will run a nodemon script to run and rerun (watch) whenever one of these files change:

- phitnest-nodejs/lib/models/\*
- phitnest-utils/model_conversions.js

## Why are the flutter models being overwritten?

The mode_conversion file automatically overwrites the flutter models. To update the methods, go to mode_conversion.js, then edit the `customMethods` properties inside the `models` object.

## Supported types

Follow this general format:

```js
const mongoose = require("mongoose");

const messageSchema = mongoose.Schema(
  {
    // Type parameter must exist. Cannot write shorthand (message: String) format.
    message: {
      type: String, // Must be JS uppercase object for type. String, not "".
      // ...
    },

    // References to other types work too! Type and ref params must exist.
    conversation: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Conversation",
      // ...
    },

    // Arrays work too! Converted to List<SomeType> in dart.
    exampleOfArray: [
      {
        type: String,
        // ...
      },
    ],
  },
  { timestamps: true }
);

const messageModel = mongoose.model("Message", messageSchema); // the code `mongoose.model("SomeModelName"` must exist to set the model name in dart.
```

\*Array of dates is not yet supported.
