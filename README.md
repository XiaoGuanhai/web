# docker php

#### 介绍
PHP服务端容器

已安装的模块包括：
`soap`, `zip`, `curl`, `bcmath`, `exif`, `gd`, `iconv`, `intl`, `mbstring`, 
`opcache`, `pdo_mysql`, `pdo_pgsql`, `mysqli`, `imagick`, `mongodb`, `igbinary`, `xdebug`, `oci8`

#### 使用说明
```yaml
services:
  web:
    build:
      context: "https://gitee.com/ddtechs/docker-php.git"
      args:
        - PHP_VERSION=7.3
    environment:
      - PHP_ENABLE_XDEBUG
      - RUNTIME_ENVIROMENT
    ports:
      - 80:80
    volumes:
      - ./app:/app:delegated # 你的Web主目录
      - ./config/apache.conf:/etc/apache2/sites-available/000-default.conf:delegated  # 你的Apache的配置文件
      - ./config/xdebug.ini:/usr/local/etc/php/conf.d/xdebug.ini:delegated # 你的Xdebug的配置文件
```
