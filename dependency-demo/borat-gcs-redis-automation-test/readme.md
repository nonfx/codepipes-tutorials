# Borat with GCS & Redis dependency for automation test

**Note**: This bundle is used for the test automation suite and only difference from _borat-gcs-redis_ and _borat-gcs-redis-automation-test_ is as below-

- Used vanguard-api-automation-test-2 for publish the artifact as this account is used in the automation.
- Used a different GOOGLE_VPC_CONNECTOR_NAME to avoid the conflict.
- Used different IP_CIDR_RANGE to avoid the conflict.

This Demo app uses both GCS and a Redis dependencies by implementing the following features:

- stores a gif image into the storage bucket and then uses it to render in the HTML page. 
- counts the number of page views by incrementing a counter in Redis on each page load.

Folder structure:

- `src` - contains the app source code along with dependencies
- `infra` - contains the base infrastructure for the application
- `codepipes-bundle` - contains bundle yaml files that be used to setup demo on codepipes.