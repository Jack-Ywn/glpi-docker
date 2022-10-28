#基础镜像
FROM webdevops/php-apache:7.4-alpine

#设置工作目录
WORKDIR /app

#配置运行脚本
COPY glpi-start.sh /opt/
RUN chmod +x /opt/glpi-start.sh
CMD /opt/glpi-start.sh
