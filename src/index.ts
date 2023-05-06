import { App } from "aws-cdk-lib";
import { PhitnestApiStack } from "./aws/phitnest-api-stack";

const app = new App();
new PhitnestApiStack(app);
