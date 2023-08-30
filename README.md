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

## [支持传递的变量](https://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/php-apache.html#base-environment-variables)

- `PHP.ini`变量

| 环境变量                              | 描述                              | 默认      |
| ------------------------------------- | --------------------------------- | --------- |
| `php.{setting-key}`                   | 设置`{setting-key}`as php 设置    |           |
| `PHP_DATE_TIMEZONE`                   | `date.timezone`                   | `UTC`     |
| `PHP_DISPLAY_ERRORS`                  | `display_errors`                  | `0`       |
| `PHP_MEMORY_LIMIT`                    | `memory_limit`                    | `512M`    |
| `PHP_MAX_EXECUTION_TIME`              | `max_execution_time`              | `300`     |
| `PHP_POST_MAX_SIZE`                   | `post_max_size`                   | `50M`     |
| `PHP_UPLOAD_MAX_FILESIZE`             | `upload_max_filesize`             | `50M`     |
| `PHP_OPCACHE_MEMORY_CONSUMPTION`      | `opcache.memory_consumption`      | `256`     |
| `PHP_OPCACHE_MAX_ACCELERATED_FILES`   | `opcache.max_accelerated_files`   | `7963`    |
| `PHP_OPCACHE_VALIDATE_TIMESTAMPS`     | `opcache.validate_timestamps`     | `default` |
| `PHP_OPCACHE_REVALIDATE_FREQ`         | `opcache.revalidate_freq`         | `default` |
| `PHP_OPCACHE_INTERNED_STRINGS_BUFFER` | `opcache.interned_strings_buffer` | `16`      |

- `PHP FPM`变量

| 环境变量                        | 描述                                        | 默认                   |
| ------------------------------- | ------------------------------------------- | ---------------------- |
| `fpm.global.{setting-key}`      | 设置`{setting-key}`主进程的 as fpm 全局设置 |                        |
| `fpm.pool.{setting-key}`        | 设置`{setting-key}`as fpm 池设置            |                        |
| `FPM_PROCESS_MAX`               | `process.max`                               | `distribution default` |
| `FPM_PM_MAX_CHILDREN`           | `pm.max_children`                           | `distribution default` |
| `FPM_PM_START_SERVERS`          | `pm.start_servers`                          | `distribution default` |
| `FPM_PM_MIN_SPARE_SERVERS`      | `pm.min_spare_servers`                      | `distribution default` |
| `FPM_PM_MAX_SPARE_SERVERS`      | `pm.max_spare_servers`                      | `distribution default` |
| `FPM_PROCESS_IDLE_TIMEOUT`      | `pm.process_idle_timeout`                   | `distribution default` |
| `FPM_MAX_REQUESTS`              | `pm.max_requests`                           | `distribution default` |
| `FPM_REQUEST_TERMINATE_TIMEOUT` | `request_terminate_timeout`                 | `distribution default` |
| `FPM_RLIMIT_FILES`              | `rlimit_files`                              | `distribution default` |
| `FPM_RLIMIT_CORE`               | `rlimit_core`                               | `distribution default` |

