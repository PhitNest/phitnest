# PhitNest

Here is the official PhitNest development documentation.

# Applications

Go to a specific application's README.

- [backend](./backend/README.md)
- [phitnest_mobile](./phitnest_mobile/README.md)

# Using Git

### **‘master’ branch:**

The ‘master’ branch is reserved for stable code. All code on the master branch has been thoroughly reviewed. Do not commit directly to master ever.

### **‘dev’ branch:**

The ‘dev’ branch is a working branch. You may make commits that have under 20 lines of diffs directly to this branch. Any larger commits must be made to an experimental branch, and when that branch is considered working you may open a pull request to merge it into the dev branch.

### **Experimental branches:**

Any commits that modify more than 5-10 lines of code must be made to an experimental branch prior to being merged into ‘dev’. Before merging large branches into ‘dev’, get at least one other person to review your pull request.

### **Branch naming:**

All experimental branches must begin with a prefix to denote their purpose. Following the prefix, you can specify a title for your branch and separate it from the prefix with a ‘/’.

Example branch name: feature/prefer-lowercase-titles-with-dashes

### **Branch prefixes:**

- **feature:** this is a branch intended to create or expand upon functionality. This includes creating new test cases (to cover bugs that do not yet exist)
- **bug:** this is a branch intended to fix existing functionality. You may also create new test cases related to the bug fix on this branch.
- **enhancement:** this is a branch intended to improve existing functionality. This includes providing comments for clarifying existing code or refactoring.

# System Architecture

_coming soon..._
