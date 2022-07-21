#!/bin/bash

while true; do
    

    export http_proxy=$PROXY_SERVER
    export https_proxy=$PROXY_SERVER

    /usr/bin/apt-mirror /etc/apt/mirror-thirdparty.list > /apt-3rdparty.log

    unset http_proxy
    unset https_proxy

    /usr/bin/apt-mirror /etc/apt/mirror-main.list > /apt-main.log

    sleep 86400
done

