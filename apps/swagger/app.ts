import express from "express";
import swaggerUi from "swagger-ui-express";
import YAML from "yamljs";
import path from "path";

const app = express();
const port = 3000;

// Load OpenAPI specification
const swaggerDocument = YAML.load(
  path.join(__dirname, "goldnest_swagger.yaml")
);

app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.listen(port, () => {
  console.log(`Swagger UI available at http://localhost:${port}/api-docs`);
});
