fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios runTests

```sh
[bundle exec] fastlane ios runTests
```

Run Unit tests and UI tests

### ios install_cocoa_pods

```sh
[bundle exec] fastlane ios install_cocoa_pods
```

Cocoapods

### ios build_local_dev

```sh
[bundle exec] fastlane ios build_local_dev
```

Build ad-hoc app in dev environment in local machine

### ios build_local_pre_prod_ad_hoc

```sh
[bundle exec] fastlane ios build_local_pre_prod_ad_hoc
```

Build ad-hoc app in pre_prod environment in local machine

### ios build_local_pre_prod_enterprise

```sh
[bundle exec] fastlane ios build_local_pre_prod_enterprise
```

Build enterprise(in-house) app in pre-prod environment in local machine

### ios build_local_prod_enterprise

```sh
[bundle exec] fastlane ios build_local_prod_enterprise
```

Build enterprise(in-house) app in prod environment in local machine

### ios build_develop

```sh
[bundle exec] fastlane ios build_develop
```

Build dev

### ios build_pre_prod_ad_hoc

```sh
[bundle exec] fastlane ios build_pre_prod_ad_hoc
```

Build pre-prod Ad-Hoc

### ios build_pre_prod_enterprise

```sh
[bundle exec] fastlane ios build_pre_prod_enterprise
```

Build pre-prod Enterprise

### ios build_prod_ad_hoc

```sh
[bundle exec] fastlane ios build_prod_ad_hoc
```

Build prod Ad-Hoc

### ios build_prod_enterprise

```sh
[bundle exec] fastlane ios build_prod_enterprise
```

Build Prod Enterprise

### ios upload_deploy_gate

```sh
[bundle exec] fastlane ios upload_deploy_gate
```

Upload DeployGate

### ios deliverToAppStore

```sh
[bundle exec] fastlane ios deliverToAppStore
```

Upload AppStore

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
