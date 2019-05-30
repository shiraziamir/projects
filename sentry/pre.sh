#https://github.com/getsentry/onpremise

docker volume create --name=sentry-data && docker volume create --name=sentry-postgres

cp -n .env.example .env
docker-compose build
docker-compose run --rm web config generate-secret-key
# Generate a secret key. Add it to .env as SENTRY_SECRET_KEY
# upgrade sentry ==>> docker-compose run --rm web upgrade
docker-compose up -d
# Access your instance at localhost:9000
