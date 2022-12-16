# Borat with GCS & Redis dependency

This Demo app uses both GCS and a Redis dependencies by implementing the following features:

- stores a gif image into the storage bucket and then uses it to render in the HTML page. 
- counts the number of page views by incrementing a counter in Redis on each page load.

Folder structure:

- `src` - contains the app source code along with dependencies
- `infra` - contains the base infrastructure for the application
- `codepipes-bundle` - contains bundle yaml files that be used to setup demo on codepipes.

####To run locally:

There is a docker-compose.yml file which can be used to build and run the app:

$ docker compose -f docker-compose.yml build

To run it, you need to set 2 environnment variables and be signed into GCP with
application-default credentials.

$ export BUCKET_NAME=<name of some existing bucket that you have write access to>
$ export GCP_PROJECT=<name of GCP project where bucket is>
$ docker compose -f docker-compose.yml up -d

You can then use your browser at localhost:8080 and the Borat image should come up.
