/* eslint-disable */
const s = require("shelljs");
const config = require("./tsconfig.json");
const outDir = config.compilerOptions.outDir;

s.rm("-rf", outDir);
s.mkdir(outDir);
s.mkdir("-p", `${outDir}/openapi/swagger`);
s.cp("openapi/api.yml", `${outDir}/openapi/api.yml`);
s.mkdir("-p", `${outDir}/openapi/specs`);
const files = s.ls("openapi/specs");
for (let i = 0; i < files.length; i++) {
  s.cp(`openapi/specs/${files[i]}`, `${outDir}/openapi/specs/${files[i]}`);
}
