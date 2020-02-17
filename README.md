# Docker Php with Apache

#### 介绍
已安装的包括：`Php`, `Apache`, `Composer`

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
        - PHP_VERSION=7.3 # 你需要的版本
    environment:
      - PHP_ENABLE_XDEBUG
      - RUNTIME_ENVIROMENT
    ports:
      - 80:80
    volumes:
      - ./app:/app:delegated # 你的Web主目录（必须）
      - ./config/apache.conf:/etc/apache2/sites-available/000-default.conf:delegated  # 你的Apache的配置文件（可选）
      - ./config/xdebug.ini:/usr/local/etc/php/conf.d/xdebug.ini:delegated # 你的Xdebug的配置文件（可选）
```

#### 问题与解决方法
***在Centos系统中执行`docker-compose up -d`启动容器报以下错误***
```shell script
ERROR: error initializing submodules: usage: git submodule [--quiet] add [-b <branch>] [-f|--force] [--name <name>] [--reference <repository>] [--] <repository> [<path>]
   or: git submodule [--quiet] status [--cached] [--recursive] [--] [<path>...]
   or: git submodule [--quiet] init [--] [<path>...]
   or: git submodule [--quiet] deinit [-f|--force] [--] <path>...
   or: git submodule [--quiet] update [--init] [--remote] [-N|--no-fetch] [-f|--force] [--rebase] [--reference <repository>] [--merge] [--recursive] [--] [<path>...]
   or: git submodule [--quiet] summary [--cached|--files] [--summary-limit <n>] [commit] [--] [<path>...]
   or: git submodule [--quiet] foreach [--recursive] <command>
   or: git submodule [--quiet] sync [--recursive] [--] [<path>...]
: exit status 1
```
解决方法：
> 参考：https://github.com/moby/moby/issues/36965

升级git版本，执行命令：
```shell script
# for EL7
sudo yum install https://centos7.iuscommunity.org/ius-release.rpm
sudo yum swap git git2u
```



