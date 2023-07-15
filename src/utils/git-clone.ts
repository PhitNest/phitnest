import { exec } from "child_process";
import { promisify } from "util";

export async function gitClone(repoUrl: string, repoName: string) {
  const promiseExec = promisify(exec);
  const cloneRes = await promiseExec(`git clone ${repoUrl}`);
  if (cloneRes.stderr) {
    throw new Error(cloneRes.stderr);
  }
  const installRes = await promiseExec(`cd ${repoName} && yarn`);
  if (installRes.stderr) {
    throw new Error(installRes.stderr);
  }
}
