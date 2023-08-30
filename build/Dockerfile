#基础镜像
FROM webdevops/php-apache:8.2-alpine

#设置工作目录
WORKDIR /app

#自定义PHP参数（glpi新版本需要配置）
RUN echo session.cookie_httponly = 1 >> /opt/docker/etc/php/php.ini

#配置运行脚本
COPY glpi-start.sh /opt/
RUN chmod +x /opt/glpi-start.sh
CMD /opt/glpi-start.sh
