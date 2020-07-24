## Local enviroment
### Building base image

You need to build it yourself.

```shell
$ docker build -t dokku/moodle-base:latest .
```

### Building app image for local testing

```shell
$ docker build -t dokku/moodle:latest .
```

### Run locally

```shell
$ docker run -d -P --name moodle -e MOODLE_URL=http://localhost:8080 -p 8080:80 dokku/moodle:latest
```

### Restart a previously-run container

```shell
$ docker start -i moodle
```
Visit it at http://localhost:8080

## Production enviroment
### Dokku deploy

Moodle is deployed to dokku using "Dockerfile deployment". As usual, we push this repository to dokku. Dokku will see the Dockerfile and build it to create the app image and start the container as usual.

### Ensure the latest image is on the host
```shell
$ docker build -t dokku/moodle-base:latest .
```

### 1 Create the app
```shell
$ dokku apps:create oxido
```
### 2 Create a mysql service
```shell
$ dokku mysql:create db_oxido
```
### 3 Link the mysql service to the app
```shell
$ dokku mysql:link db_oxido oxido
```
### 4 Configure environment variables and options on server.
```shell
$ dokku config:set --no-restart oxido \
    MOODLE_URL=https://oxido.gpem.cl
$ dokku docker-options:add oxido build,run,deploy "-v /var/log/moodle/apache2:/var/log/apache2"
$ dokku docker-options:add oxido build,run,deploy "-v /var/moodle/:/var/moodledata"
```
If your app uses a non-standard port (perhaps you have a dockerfile deploy exposing port 99999)
```shell
$ dokku proxy:ports-add oxido http:80:80
```
### 5 Add remote to your local repo & Push any config/dockerfile updates to dokku
```shell
$ git remote add dokku dokku@gpem.cl:oxido
$ git push dokku master
```
### Add SSL
```shell
$ dokku letsencrypt oxido
```
### Check if ports are mapped correctly
```shell
$ dokku config:get oxido DOKKU_PROXY_PORT_MAP
```
Should output: "http:80:9000 https:443:9000"