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

Create database
	dokku mysql:create db_oxido

Link Database
	dokku mysql:link db_oxido oxido

Add remote to your local repo

    git remote add dokku dokku@gpem.cl:oxido

Configure environment variables and options on server, replacing ... with appropriate values

```
dokku config:set moodle \
      DB_HOST=dokku-mysql-oxido \
      DB_NAME=moodle \
      DB_USER=moodle \
      DB_PASSWORD=... \
      MOODLE_URL=https://oxido.gpem.cl
dokku docker-options:add moodle build,run,deploy "-v /var/log/moodle/apache2:/var/log/apache2"
dokku docker-options:add moodle build,run,deploy "-v /var/moodle/:/var/moodledata"
dokku proxy:ports-add moodle http:80:80
```

If the base image has been updated, ensure the latest image is on the host

    ubuntu@dokku6:~$ docker pull gpem/moodle-base:latest

Push any config/dockerfile updates to dokku. Dokku will build an image based on Dockerfile.
    
    git push dokku master

## Configure Cron

*/1 * * * * dokku --rm run  moodle /usr/bin/php /var/www/html/admin/cli/cron.php > /dev/null