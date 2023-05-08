import { App } from "@aws-cdk/core";
import { PhitnestApiStack } from "./phitnest-api-stack";

const app = new App();
new PhitnestApiStack(app);
