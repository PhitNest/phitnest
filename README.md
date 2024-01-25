# PhitNest Monorepo

### Submodules

Some of our code is split into submodules, which are just separate GitHub repositories nested inside this repository. We use submodules so that individual repositories can have their own GitHub Actions workflows/secrets independent of each other, and so that certain components of our codebase can be private and some can be public. The submodules are:

- [mobile](https://github.com/PhitNest/mobile) (public) - Flutter application for mobile
- [api](https://github.com/PhitNest/api) (private) - REST API for to serve as the backend for the mobile app.
- [aws](https://github.com/PhitNest/aws) (private) - AWS CDK application for deploying AWS components programmatically.

### To clone this repo + all submodules:

These commands will clone the monorepo, and all the submodules.

```
git clone https://github.com/phitnest/phitnest.git --recurse-submodules
git submodule foreach git checkout master
```

### To pull changes for monorepo + all submodules:

From monorepo:

```
git submodule foreach git pull
```

### To push changes:

If your changes are part of:

- apps/mobile
- apps/aws
- packages/api

Then your changes are part of a submodule. If your changes are part of a submodule, just commit directly to the submodule. I.E. for making commits to the mobile app:

```
cd apps/mobile
git add .
git commit -m "Committing to mobile app submodule"
git push
```

Commits made to submodules will be automatically propogated up to the monorepo via GitHub actions.

If your changes are not part of a submodule (I.E. dart-analysis configs, eslint configs, jest-helpers, tsconfigs, monorepo files), just commit your changes directly to the monorepo.

### TypeScript Development

Add the Prettier plugin to your IDE. This will automatically format your code on save, and will help you avoid formatting errors.
