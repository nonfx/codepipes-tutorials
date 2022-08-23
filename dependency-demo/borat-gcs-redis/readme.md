# Borat with GCS & Redis dependency

This Demo app uses both GCS and a Redis dependencies by implementing the following features:

- stores a gif image into the storage bucket and then uses it to render in the HTML page. 
- counts the number of page views by incrementing a counter in Redis on each page load.

Folder structure:

- `src` - contains the app source code along with dependencies
- `infra` - contains the base infrastructure for the application
- `codepipes-bundle` - contains bundle yaml files that be used to setup demo on codepipes.