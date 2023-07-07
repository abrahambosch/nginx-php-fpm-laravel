# nginx-php-fpm-laravel

## Docker build
```
cd nginx-php-fpm
docker build . -t abrahambosch/nginx-php-fpm-laravel:latest
```

## Docker publish
```
docker push abrahambosch/nginx-php-fpm-laravel:latest
```

## docker run
```
docker run --rm --name nginx-php-fpm-laravel abrahambosch/nginx-php-fpm-laravel:latest
```

## docker exec
```
docker exec -it nginx-php-fpm-laravel bash
```

