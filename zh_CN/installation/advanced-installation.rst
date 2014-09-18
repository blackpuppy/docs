高级安装
#####################

通过PEAR安装器安装CakePHP
======================================

CakePHP有PEAR的发行包,因此可以通过pear安装器安装。可以在多个应用程序间
共享CakePHP类库。若要通过pear安装CakePHP，需要执行下面的命令。

    pear channel-discover pear.cakephp.org
    pear install cakephp/CakePHP

CakePHP publishes a PEAR package that you can install using the pear installer.
Installing with the pear installer can simplify sharing CakePHP libraries
across multiple applications. To install CakePHP with pear you'll need to do the
following::

    pear channel-discover pear.cakephp.org
    pear install cakephp/CakePHP

.. note::

    在一些操作系统用pear命令安装类库需要 ``sudo`` 超级权限。
    On some systems installing libraries with pear will require ``sudo``.

使用pear安装CakePHP后，如果pear配置正确可以使用 ``cake`` 命令来创建新的应用程序。
由于CakePHP已经被包含在PHP的``include_path``，不需要再进行其他改变。

After installing CakePHP with pear, if pear is configured correctly you should
be able to use the ``cake`` command to create a new application. Since CakePHP
will be located on PHP's ``include_path`` you won't need to make any other
changes.

通过composer安装CakePHP
================================

Composer是一个支持PHP 5.3以上的依赖管理工具。解决了通过PEAR安装器安装Cake的很多问题
并且使管理多版本类库变的更加简单。由于CakePHP有PEAR发行包，可以通过`composer <http://getcomposer.org>`_
安装，在安装CakePHP之前需要建立一个 ``composer.json`` 文件，内容可以如下：

Composer is a dependency management tool for PHP 5.3+. It solves many of the
problems the PEAR installer has, and simplifies managing multiple versions of
libraries.  Since CakePHP publishes a PEAR package you can install CakePHP using
`composer <http://getcomposer.org>`_. Before installing CakePHP you'll need to
setup a ``composer.json`` file. An composer.json file for a CakePHP applications
would look like the following::

    {
        "name": "example-app",
        "repositories": [
            {
                "type": "pear",
                "url": "http://pear.cakephp.org"
            }
        ],
        "require": {
            "pear-cakephp/cakephp": ">=2.3.4"
        },
        "config": {
            "vendor-dir": "Vendor/"
        }
    }

保存这个JSON文件为 ``composer.json`` 并放到项目的根目录。接下来下载composer.phar文件到项目中。
在 ``composer.json`` 的同级目录下运行如下命令：

    $ php composer.phar install

Save this JSON into ``composer.json`` in the root directory of your project.
Next download the composer.phar file into your project. After you've downloaded
composer, install CakePHP. In the same directory as your ``composer.json`` run
the following::

    $ php composer.phar install

一旦运行结束，目录结构看起来如下：
Once composer has finished running you should have a directory structure that looks like::

    example-app/
        composer.phar
        composer.json
        Vendor/
            bin/
            autoload.php
            composer/
            pear-pear.cakephp.org/

现在可以生成应用程序的其余部分骨架
You are now ready to generate the rest of your application skeleton::

    $ Vendor/bin/cake bake project <path to project>

默认 ``bake`` 是硬编码 :php:const:`CAKE_CORE_INCLUDE_PATH`。为了使应用程序
更加的便携。我们要修改 ``webroot/index.php`` ，将 ``CAKE_CORE_INCLUDE_PATH``
改为相对路径：

By default ``bake`` will hard-code :php:const:`CAKE_CORE_INCLUDE_PATH`. To
make your application more portable you should modify ``webroot/index.php``,
changing ``CAKE_CORE_INCLUDE_PATH`` to be a relative path::

    define(
        'CAKE_CORE_INCLUDE_PATH',
        ROOT . DS . APP_DIR . '/Vendor/pear-pear.cakephp.org/CakePHP'
    );

如果使用composer安装其他任何类库，要设置autoloader，在 ``Config/bootstrap.php`` 文件中添加
如下代码：

If you're installing any other libraries with composer, you'll need to setup
the autoloader, and work around an issue in composer's autoloader. In your
``Config/bootstrap.php`` file add the following::

    // 运行 composer 自动加载.
    // Load composer autoload.
    require APP . '/Vendor/autoload.php';

    // Remove and re-prepend CakePHP's autoloader as composer thinks it is the most important.
    // See https://github.com/composer/composer/commit/c80cb76b9b5082ecc3e5b53b1050f76bb27b127b
    spl_autoload_unregister(array('App', 'load'));
    spl_autoload_register(array('App', 'load'), true, true);

用composer安装了 CakePHP 之后，你应该有了一个可以运行的CakePHP应用程序，
注意确保composer.json和composer.lock文件与其他源代码在一起。

You should now have a functioning CakePHP application with CakePHP installed via
composer. Be sure to keep the composer.json and composer.lock file with the
rest of your source code.

在多个应用程序间共享CakePHP类库
====================================================

有些情况需要把CakePHP的目录放到不同的地方，有可能是共享主机约束。
或者你只是想要一些应用程序共享相同的Cake库，
本节讲解怎样分布CakePHP的目录到不同的地方。

There may be some situations where you wish to place CakePHP's
directories on different places on the filesystem. This may be due
to a shared host restriction, or maybe you just want a few of your
apps to share the same Cake libraries. This section describes how
to spread your CakePHP directories across a filesystem.

首先，明确Cake的应用程序有三个主要部分:

First, realize that there are three main parts to a Cake
application:

#. CakePHP 核心类库, 位于 /lib/Cake.
#. 你的应用程序代码,位于 /app.
#. 应用程序的 webroot, 通常位于 /app/webroot.

#. The core CakePHP libraries, in /lib/Cake.
#. Your application code, in /app.
#. The application’s webroot, usually in /app/webroot.

每个目录可以分布在文件系统的任何位置。除了webroot，
他需要web服务器能够访问到的地方。甚至可以将webroot目录移到app
外面，只要你告诉Cake你把它放哪了。

Each of these directories can be located anywhere on your file
system, with the exception of the webroot, which needs to be
accessible by your web server. You can even move the webroot folder
out of the app folder as long as you tell Cake where you've put
it.

安装配置Cake时，需要修改下面的文件。
To configure your Cake installation, you'll need to make some
changes to the following files.

-  /app/webroot/index.php
-  /app/webroot/test.php (if you use the
   :doc:`Testing </development/testing>` feature.)

需要编辑三个常量 ``ROOT``，``APP_DIR`` 和 ``CAKE_CORE_INCLUDE_PATH``。

-  ``ROOT`` 包含你的app文件夹的目录路径
-  ``APP_DIR`` app目录的(基本 )名称
-  ``CAKE_CORE_INCLUDE_PATH`` CakePHP类库目录的路径

There are three constants that you'll need to edit: ``ROOT``,
``APP_DIR``, and ``CAKE_CORE_INCLUDE_PATH``.

-  ``ROOT`` should be set to the path of the directory that
   contains your app folder.
-  ``APP_DIR`` should be set to the (base)name of your app folder.
-  ``CAKE_CORE_INCLUDE_PATH`` should be set to the path of your
   CakePHP libraries folder.

让我们通过一个示例,在实践中实现一个高级安装。

Let’s run through an example so you can see what an advanced
installation might look like in practice. Imagine that I wanted to
set up CakePHP to work as follows:

-  CakePHP的核心类库放在/usr/lib/cake。
-  我的应用程序的webroot目录在/var/www/mysite/。
-  我的应用程序的app目录在/home/me/myapp。

-  The CakePHP core libraries will be placed in /usr/lib/cake.
-  My application’s webroot directory will be /var/www/mysite/.
-  My application’s app directory will be /home/me/myapp.

鉴于这种类型的设置，应该编辑我的webroot/index.php文件(对于这个例子中实际位置在/var/www/mysite/index.php)
像下面这种：

Given this type of setup, I would need to edit my webroot/index.php
file (which will end up at /var/www/mysite/index.php, in this
example) to look like the following::

    // /app/webroot/index.php (部分代码,注释被移除)
    // /app/webroot/index.php (partial, comments removed)

    if (!defined('ROOT')) {
        define('ROOT', DS . 'home' . DS . 'me');
    }

    if (!defined('APP_DIR')) {
        define ('APP_DIR', 'myapp');
    }

    if (!defined('CAKE_CORE_INCLUDE_PATH')) {
        define('CAKE_CORE_INCLUDE_PATH', DS . 'usr' . DS . 'lib');
    }

推荐使用 ``DS`` 常量而不是用反斜杠来分隔文件路径，这样可以避免错误，同样
使代码更加便携。

It is recommended to use the ``DS`` constant rather than slashes to
delimit file paths. This prevents any missing file errors you might
get as a result of using the wrong delimiter, and it makes your
code more portable.

Apache and mod\_rewrite (and .htaccess)
=======================================

本节内容被移到:doc:`URL rewriting </installation/url-rewriting>`。
This section was moved to :doc:`URL rewriting </installation/url-rewriting>`.


.. meta::
    :title lang=zh_CN: Advanced Installation
    :keywords lang=zh_CN: libraries folder,core libraries,application code,different places,filesystem,constants,webroot,restriction,apps,web server,lib,cakephp,directories,path
