## 使用[docker](https://hub.docker.com/repository/docker/jackywn/glpi)部署

```shell
#创建带有卷的MariaDB容器
docker run \
--name glpi-db \
--hostname glpi-db \
-e MARIADB_ROOT_PASSWORD="abc123%%" \
-e MARIADB_DATABASE="glpi" \
-e MARIADB_USER="glpi" \
-e MARIADB_PASSWORD="glpi" \
-v /data/glpi/mariadb:/var/lib/mysql \
-d mariadb:10.7

#默认情况下docker run将使用最新版本的GLPI
docker run \
--name glpi-www \
--hostname glpi-www \
--link glpi-db:glpi-db \
-v /data/glpi/www:/app \
-p 8000:80 \
-e VERSION_GLPI="9.5.9" \
-d jackywn/glpi
```

## 使用docker-compose部署

```shell
#全新环境初始化部署
git clone https://github.com/Jack-Ywn/glpi-docker.git
cd glpi-docker
docker-compose up -d

#初始化安装完成后删除安装文件
cd glpi-docker
rm -rf glpi/install

#访问http://ip:8000即可安装或者使用GLPI
默认管理员帐号是 glpi/glpi
技术员帐号是 tech/tech
普通帐号是 normal/normal
只能发布的帐号是 post-only/postonly
```

## 构建容器镜像

```shell
git clone https://github.com/Jack-Ywn/glpi-docker.git
cd glpi-docker/build
docker image build -t "jackywn/glpi" .
```

## Nginx反向代理GLPI容器

```shell
server {
    listen 80;
    listen 443 ssl http2;

    server_name                example.com;
    server_name_in_redirect    on;
    port_in_redirect           on;

    if ( $scheme = http ) { return 301 https://$host$request_uri; }

    ssl_certificate          example.com.cer;
    ssl_certificate_key      example.com.key;

    location / {
        proxy_pass  http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
    }
}
```
