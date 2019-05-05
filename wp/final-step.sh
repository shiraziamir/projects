#docker-compose down -v
#docker-compose up
cd /var/lib/docker/volumes/wp_wordpress/_data
mkdir .blog
mv * .blog
mv .blog blog
chown -R --reference=blog/index.php .

# cd /opt/docker/wp
# docker-compse up -d
