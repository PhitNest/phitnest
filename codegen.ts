import type { CodegenConfig } from "@graphql-codegen/cli";

const config: CodegenConfig = {
  schema: ["./schema.gql", "./dgraph/fragment.gql"],
  generates: {
    "src/generated/dgraph-schema.ts": {
      plugins: ["typescript"],
    },
  },
};

export default config;
