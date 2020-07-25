#!/bin/bash

# Ensure the latest image is on the host
#docker build -t dokku/moodle:latest
name=$1
# 1 Create the app
echo "1 Create the app"
dokku apps:create $name

# 2 Create a mysql service
echo "2 Create a mysql service"
dokku mysql:create db_$name

# 3 Link the mysql service to the app
echo "3 Link the mysql service to the app"
dokku mysql:link db_$name $name

# 4 Configure environment variables and options on server.
echo "4 Configure environment variables and options on server."
dokku config:set --no-restart $name MOODLE_URL=https://$name.gpem.cl
dokku docker-options:add $name build,run,deploy "-v /var/log/moodle/apache2:/var/log/apache2"
dokku docker-options:add $name build,run,deploy "-v /var/moodle/:/var/moodledata"

# If your app uses a non-standard port (perhaps you have a dockerfile deploy exposing port 99999)
#dokku proxy:ports-add $name http:80:80

# 5 Add remote to your local repo & Push any config/dockerfile updates to dokku
echo "5 Add remote to your local repo & Push any config/dockerfile updates to dokku"
#git remote rm dokku
git remote add $name dokku@gpem.cl:$name
git push $name master

# 6 Add SSL
#dokku letsencrypt $name

echo "Configuración app"
dokku config $name
exit
