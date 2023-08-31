import { App } from "aws-cdk-lib";
import { PhitnestStack } from "./phitnest-stack";

const app = new App();
new PhitnestStack(app);
