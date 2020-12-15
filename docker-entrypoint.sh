#!/bin/bash

sed -i 's/127.0.0.1/0.0.0.0/g' /home/docker_user/app/web/vue/dist/UIconfig.js
sed -i 's/localhost/'${HOST}'/g' /home/docker_user/app/web/vue/dist/UIconfig.js
sed -i 's/3000/'${PORT}'/g' /home/docker_user/app/web/vue/dist/UIconfig.js
if [[ "${USE_SSL:-0}" == "1" ]] ; then
    sed -i 's/ssl: false/ssl: true/g' /home/docker_user/app/web/vue/dist/UIconfig.js
fi
exec node gekko "$@"
