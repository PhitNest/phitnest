import { App } from "aws-cdk-lib";
import { PhitnestStack } from "./phitnest-stack";
import { gitClone } from "utils/git-clone";

gitClone("https://github.com/PhitNest/phitnest-api.git", "phitnest-api");

const app = new App();
new PhitnestStack(app);
