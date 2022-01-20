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

### ios increment_build_number_and_commit

```sh
[bundle exec] fastlane ios increment_build_number_and_commit
```

Increment build number and commit changes to github

### ios build_develop

```sh
[bundle exec] fastlane ios build_develop
```

Build dev and upload deploygate

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

### ios upload_DeployGate

```sh
[bundle exec] fastlane ios upload_DeployGate
```

Upload DeployGate

### ios deliverToAppStore

```sh
[bundle exec] fastlane ios deliverToAppStore
```

Upload AppStore

### ios send_slack_success

```sh
[bundle exec] fastlane ios send_slack_success
```

Slack send success

### ios send_slack_unstable

```sh
[bundle exec] fastlane ios send_slack_unstable
```

Slack send unstable

### ios send_slack_failure

```sh
[bundle exec] fastlane ios send_slack_failure
```

Slack send failure

### ios send_slack

```sh
[bundle exec] fastlane ios send_slack
```

Send slack

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
