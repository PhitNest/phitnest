#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import { PhitnestAwsStack } from "../lib/phitnest-aws-stack";

const app = new cdk.App();
new PhitnestAwsStack(app, "PhitnestAwsStack");
