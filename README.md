# wiki-container
Este es un Dockerfile para crear una imagen sobre nginx y php-fpm optimizado para el uso con wikimedia.
Al iniciar el contenedor se descarga el codigo de wikimedia, cuya versión de instalación se puede elegir desde el archivo scripts/start.sh

## Construir imagen
```
git clone https://github.com/Pengostores/wiki-container.git
docker build -t pengo/wiki:latest .
```

## Ejecutar

### Mysql
Dese la imagen oficial
```
docker run --name wiki_bd -e MYSQL_ROOT_PASSWORD=rootPengo -e MYSQL_DATABASE=wikimedia -e MYSQL_USER=wikimedia -e MYSQL_PASSWORD=wikiPengo -d mysql
```

### Liga con Mysql y Volumenes
```
sudo docker run --name wiki_web -p 8080:80 -v /directorio_local:/usr/share/nginx/html -link some-wiki_bd:mysql -d pengo/wiki
```
Y ya puedes trabajar desde tu browser ```http://localhost:8080```

License
----

MIT


[@deivanmiranda]: <http://ivanmiranda.me>