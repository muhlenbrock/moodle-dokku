## Building base image

This image is usually built by docker hub and pulled by the dokku host. You don't usually need to build it yourself.

```shell
docker build -t gpem/moodle-base:latest .
```

## Building app image for local testing

```shell
docker build -t gpem/moodle-dokku:latest .
```

## Run locally

```shell
docker run -d -P --name moodle -e MOODLE_URL=http://localhost:8080 -p 8080:80 gpem/moodle-dokku:latest
```

### Restart a previously-run container

docker start -i moodle

Visit it at http://localhost/

## Deploy to production

Moodle is deployed to dokku using "Dockerfile deployment". As usual, we push this repository to dokku. Dokku will see the Dockerfile and build it to create the app image and start the container as usual.

Create app
 	dokku apps:create oxido
    dokku domains:add oxido oxido.gpem.cl

Create database
	dokku mysql:create db_oxido

Link Database
	dokku mysql:link db_oxido oxido

Configure environment variables and options on server, replacing ... with appropriate values
```
dokku config:set --no-restart oxido \
    DATABASE_URL=mysql://xxxxxx \
    MOODLE_URL=https://oxido.gpem.cl \
    DOKKU_LETSENCRYPT_EMAIL=racm@live.cl
dokku docker-options:add oxido build,run,deploy "-v /var/log/moodle/apache2:/var/log/apache2"
dokku docker-options:add oxido build,run,deploy "-v /var/moodle/:/var/moodledata"
dokku proxy:ports-add oxido http:80:80
```

# Map ports
dokku ps:stop oxido
dokku config:set --no-restart oxido DOKKU_PROXY_PORT_MAP="http:80:80"
# Add SSL
dokku letsencrypt oxido

# Check if ports are mapped correctly
dokku config:get oxido DOKKU_PROXY_PORT_MAP

# Should output: "http:80:9000 https:443:9000"

If the base image has been updated, ensure the latest image is on the host

    ubuntu@dokku:~$ docker pull dokku/moodle-base:latest

Add remote to your local repo

    git remote add dokku dokku@gpem.cl:oxido

Push any config/dockerfile updates to dokku. Dokku will build an image based on Dockerfile.
    
    git push dokku master

## Configure Cron

*/1 * * * * dokku --rm run  moodle /usr/bin/php /var/www/html/admin/cli/cron.php > /dev/null