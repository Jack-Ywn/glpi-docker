#!/bin/bash

#设置版本变量
[[ ! "$VERSION_GLPI" ]] \
&& VERSION_GLPI=$(curl -s https://api.github.com/repos/glpi-project/glpi/releases/latest | grep tag_name | cut -d '"' -f 4)

#设置下载URL链接
SRC_GLPI=https://github.com/glpi-project/glpi/releases/download/$VERSION_GLPI/glpi-$VERSION_GLPI.tgz

#解压GLPI源代码
if [ "$(ls index.php)" ];
then
    echo "已经安装GLPI"    
else
    wget $SRC_GLPI && tar xf glpi-$VERSION_GLPI.tgz
    mv glpi/* /app && rm -rf glpi glpi-$VERSION_GLPI.tgz
fi

#设置权限
chown -R 1000:1000 /app

#启动服务
/entrypoint supervisord
