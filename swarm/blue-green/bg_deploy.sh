function predeploy {
    echo "[INFO] Deploying general services"
    docker stack deploy -c stacks/general.yml prod --with-registry-auth
    echo "[INFO] General services deployment is done"
}

function deployBlue {
    echo "[INFO] Deploying blue stack"
    docker stack deploy -c stacks/blue.yml prod --with-registry-auth
    echo "Waiting 10 s to verify that all tasks are stable" && sleep 10
    docker service update --label-add "traefik.http.routers.backend-nginx-blue.priority=100" prod_php-blue && sleep 0.5
    docker service update --label-add "traefik.http.routers.backend-nginx-green.priority=0" prod_php-green && sleep 0.5
    docker service update --replicas=0 prod_php-green
    echo "[INFO] blue stack deployment is done"
}


function deployGreen {
    echo "[INFO] Deploying green stack"
    docker stack deploy -c stacks/green.yml prod --with-registry-auth
    echo "Waiting 10 s to verify that all tasks are stable" && sleep 10
    docker service update --label-add "traefik.http.routers.backend-nginx-green.priority=100" prod_php-green && sleep 0.5
    docker service update --label-add "traefik.http.routers.backend-nginx-blue.priority=0" prod_php-blue && sleep 0.5
    docker service update --replicas=0 prod_php-blue
    echo "[INFO] green stack deployment is done"
}


# check to see deploy which version
# docker service inspect prod_php-green -f '{{index .Spec.Labels "traefik.http.routers.backend-nginx-green.priority"}}'
# docker service inspect prod_php-blue -f '{{index .Spec.Labels "traefik.http.routers.backend-nginx-blue.priority"}}'
# 
predeploy


if [ `docker service inspect prod_php-green -f '{{index .Spec.Labels "traefik.http.routers.backend-nginx-green.priority"}}'` -eq 100 ]
then
    deployBlue
else
    deployGreen
fi
