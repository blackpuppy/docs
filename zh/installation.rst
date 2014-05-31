安装
############

安装CakePHP是快速简单的。最低需求是一个web服务器和一份CakePHP的副本。
仅此而已！同时本手册主要关注在Apache服务器上(因为它最通用)，
也可以配置运行在不同的服务器上，比如LightHTTPD 或 Microsoft IIS。

CakePHP is fast and easy to install. The minimum requirements are a
webserver and a copy of Cake, that's it! While this manual focuses
primarily on setting up with Apache (because it's the most common),
you can configure Cake to run on a variety of web servers such as
LightHTTPD or Microsoft IIS.

需求 Requirements
============
-  HTTP 服务器。例如: Apache。推荐开启 mod\_rewrite 模块，但不是必须的。
-  PHP 5.2.8 或更高版本。

-  HTTP Server. For example: Apache. mod\_rewrite is preferred, but
   by no means required.
-  PHP 5.2.8 or greater.

技术上说数据库不是必须的，但是很多应用程序都要用到。CakePHP 支持如下数据库引擎：

Technically a database engine isn't required, but we imagine that
most applications will utilize one. CakePHP supports a variety of
database storage engines:

-  MySQL (4 or greater)
-  PostgreSQL
-  Microsoft SQL Server
-  SQLite

.. note::

    所有的内置驱动都需要 PDO。请确保已经正确安装了 PDO 扩展。

    The built-in drivers all require PDO.  You should make sure you have the
    correct PDO extensions installed.

许可 License
=======

CakePHP 的许可是基于 MIT license 的。这意味着你能够在保持版权声明完整的前提下自由的修改、分发和重发布其源码。
你也可以在商业或封闭源代码的应用程序中包含 CakePHP。

CakePHP is licensed under the MIT license.  This means that you are free to
modify, distribute and republish the source code on the condition that the
copyright notices are left intact.  You are also free to incorporate CakePHP
into any Commercial or closed source application.

下载 CakePHP Downloading CakePHP
===================

有两个获得 CakePHP 的最新副本的途径。从官网下载压缩文档(zip/tar.gz/tar.bz2)，或者从 git 库中获取代码。

There are two main ways to get a fresh copy of CakePHP. You can
either download an archive copy (zip/tar.gz/tar.bz2) from the main
website, or check out the code from the git repository.

要下载 CakePHP 最新的主版本，访问官网 `http://cakephp.org <http://cakephp.org>`_ 并点击 "Download Now" 链接。

To download the latest major release of CakePHP. Visit the main
website `http://cakephp.org <http://cakephp.org>`_ and
follow the "Download Now" link.

CakePHP 的当前发行版本都托管在 `Github <http://github.com/cakephp/cakephp>`_ 。
Github 同时保管了 CakePHP 自身和 CakePHP 的其它插件。
CakePHP的所有发行版本可从 `Github tags <https://github.com/cakephp/cakephp/tags>`_ 获得。

All current releases of CakePHP are hosted on
`Github <http://github.com/cakephp/cakephp>`_. Github houses both CakePHP
itself as well as many other plugins for CakePHP. The CakePHP
releases are available at
`Github tags <https://github.com/cakephp/cakephp/tags>`_.

也可以获取最新的非正式发布代码，带有全部 bug 修正和最新的增强功能。这可以通过克隆 `Github` 库来访问::
    git clone git://github.com/cakephp/cakephp.git

Alternatively you can get fresh off the press code, with all the
bug-fixes and up to the minute enhancements.
These can be accessed from github by cloning the
`Github`_ repository::

    git clone git://github.com/cakephp/cakephp.git


访问权限 Permissions
===========

CakePHP 的很多操作都要使用 app/tmp 目录，比如模块描述、缓存视图和 session 信息。

CakePHP uses the ``app/tmp`` directory for a number of different
operations. Model descriptions, cached views, and session
information are just a few examples.

因此，要确保在 CakePHP 安装中 ``app/tmp`` 及其全部子目录可以被 web 服务器用户读写。

As such, make sure the directory ``app/tmp`` and all its subdirectories in your cake installation
are writable by the web server user.

设置 Setup
=====

设置 CakePHP 可以简单到把它直接放在 web 服务器的文档根目录下，或者像你希望的那样复杂和灵活。
本节覆盖了三种主要的 CakePHP 安装类型：开发模式、生产模式和高级模式。

Setting up CakePHP can be as simple as slapping it in your web
server’s document root, or as complex and flexible as you wish.
This section will cover the three main installation types for
CakePHP: development, production, and advanced.

开发模式：容易启动，应用程序的URLs包括 CakePHP 的安装目录名，安全性较低。
生产模式：包含了配置 web 服务器根目录的能力，安全性很高。
高级模式：有如下配置，允许把 CakePHP 的关键目录放在系统的不同位置，多个 CakePHP 应用程序能够共享同一个 CakeHP 核心库。

-  Development: easy to get going, URLs for the application include
   the CakePHP installation directory name, and less secure.
-  Production: Requires the ability to configure the web server’s
   document root, clean URLs, very secure.
-  Advanced: With some configuration, allows you to place key
   CakePHP directories in different parts of the filesystem, possibly
   sharing a single CakePHP core library folder amongst many CakePHP
   applications.

开发模式 Development
===========

开发模式是安装 CakePHP 最快的方法。
本例将帮助你安装一个 CakePHP 应用程序并使它在地址 http://www.example.com/cake\_2\_0/ 上生效。
假设文档根目录设置在 /var/www/html。

A development installation is the fastest method to setup Cake.
This example will help you install a CakePHP application and make
it available at http://www.example.com/cake\_2\_0/. We assume for
the purposes of this example that your document root is set to
``/var/www/html``.

把 Cake 压缩包的内容解压到 ``/var/www/html`` 。
现在文档根目录内已经有了以版本号为后缀名的子文件夹(例如cake\_2.0.0)。
将文件夹更名为cake\_2\_0。开发模式设置完成后的文件系统类似于下面的样子::

Unpack the contents of the Cake archive into ``/var/www/html``. You now
have a folder in your document root named after the release you've
downloaded (e.g. cake\_2.0.0). Rename this folder to cake\_2\_0.
Your development setup will look like this on the file system::

    /var/www/html/
        cake_2_0/
            app/
            lib/
            plugins/
            vendors/
            .htaccess
            index.php
            README

如果 web 服务器设置正确，就可以通过 http://www.example.com/cake\_2\_0/ 访问 CakePHP 应用程序。

If your web server is configured correctly, you should now find
your Cake application accessible at
http://www.example.com/cake\_2\_0/.

多应用程序使用同一份 CakePHP
Using one CakePHP checkout for multiple applications
----------------------------------------------------

如果你正在开发几个应用程序，常常会感觉需要在它们之间共享一份 CakePHP 核心。
有几个办法能达到这个目的。最简单的是使用PHP的 ``include_path`` 。
首先，克隆 CakePHP 到一个目录。本示例中，我们使用 ``~/projects``::
    git clone git://github.com/cakephp/cakephp.git ~/projects/cakephp

If you are developing a number of applications, it often makes sense to have
them share the same CakePHP core checkout. There are a few ways in which you can
accomplish this.  Often the easiest is to use PHP's ``include_path``. To start
off, clone CakePHP into a directory.  For this example, we'll use
``~/projects``::

    git clone git://github.com/cakephp/cakephp.git ~/projects/cakephp

这会克隆 CakePHP 到 ``~/projects`` 目录。如果不想使用 git，你可以下载一个 zip 包，其它的步骤是相同的。
接下来，修改 ``php.ini`` 文件。在 *nix 系统中通常位于 ``/etc/php.ini`` ，使用 ``php -i`` 可以找到 'Loaded
Configuration File' 。一旦找到正确的 ini 文件，编辑 ``include_path`` 使其包含 ``~/projects/cakephp/lib`` 。例如：

	include_path = .:/home/mark/projects/cakephp/lib:/usr/local/php/lib/php

This will clone CakePHP into your ``~/projects`` directory.  If you don't want
to use git, you can download a zipball and the remaining steps will be the
same.  Next you'll have to locate and modify your ``php.ini``.  On \*nix systems
this is often in ``/etc/php.ini``, but using ``php -i`` and looking for 'Loaded
Configuration File'.  Once you've found the correct ini file, modify the
``include_path`` configuration to include ``~/projects/cakephp/lib``.  An
example would look like::

    include_path = .:/home/mark/projects/cakephp/lib:/usr/local/php/lib/php

然后重启 Apache，可以在 ``phpinfo()`` 中看到改变。

After restarting your webserver, you should see the changes reflected in
``phpinfo()``.

.. note::

    如果是在 windows 系统，用 ; 代替 : 分隔多个包含路径。
    If you are on windows, separate include paths with ; instead of :

一旦设置完成 ``include_path`` ，应用程序将自动找到 CakePHP。

Having finished setting up your ``include_path`` your applications should be able to
find CakePHP automatically.

生产模式 Production
==========

产品模式是更灵活地安装 Cake 的方法。这种方法允许整个域映射为单一的 CakePHP 应用程序。
本例将指导你在系统的任何位置安装 Cake，并通过 http://www.example.com 访问。
注意本安装需要正确的改变 Apache 服务器的``DocumentRoot``。

A production installation is a more flexible way to setup Cake.
Using this method allows an entire domain to act as a single
CakePHP application. This example will help you install Cake
anywhere on your filesystem and make it available at
http://www.example.com. Note that this installation may require the
rights to change the ``DocumentRoot`` on Apache webservers.

将 Cake 压缩包的内容解压到你选择的目录。
假设你选择将 Cake 安装在 /cake_install。文件系统看起来像下面的样子：

Unpack the contents of the Cake archive into a directory of your
choosing. For the purposes of this example, we assume you choose to
install Cake into /cake\_install. Your production setup will look
like this on the filesystem::

    /cake_install/
        app/
            webroot/ (this directory is set as the ``DocumentRoot``
             directive)
        lib/
        plugins/
        vendors/
        .htaccess
        index.php
        README

Apache 的``DocumentRoot``设置如下::
Developers using Apache should set the ``DocumentRoot`` directive
for the domain to::

    DocumentRoot /cake_install/app/webroot

如果 web 服务器配置正确，就可以通过 http://www.example.com/ 访问 CakePHP 应用程序。

If your web server is configured correctly, you should now find
your Cake application accessible at http://www.example.com.

高级安装和URL重写

Advanced Installation and URL Rewriting
=======================================

.. toctree::

    installation/advanced-installation
    installation/url-rewriting

启动 Fire It Up
==========

好了，让我们将 CakePHP运行起来。依赖于所用的设置，
将浏览器指向 http://example.com/  或者 http://example.com/cake\_install/。
此时，将会看到 CakePHP 的默认页面，和一条有关当前数据库连接状态的消息。

Alright, let's see CakePHP in action. Depending on which setup you
used, you should point your browser to http://example.com/ or
http://example.com/cake\_install/. At this point, you'll be
presented with CakePHP's default home, and a message that tells you
the status of your current database connection.

恭喜！你已经准备好 :doc:`create your first CakePHP
application </getting-started>`。

Congratulations! You are ready to :doc:`create your first CakePHP
application </getting-started>`.

不能正常执行？如果你得到一个有关 timezone 的错误，
将 ``app/Config/core.php`` 中和timezone有关的那行代码注释掉。
   /**
    * 注释本行，并且改正服务器时区及与日期时间相关的错误。
    *
    */
       date_default_timezone_set('UTC');

Not working? If you're getting timezone related error from PHP
uncomment one line in ``app/Config/core.php``::

   /**
    * Uncomment this line and correct your server timezone to fix
    * any date & time related errors.
    */
       date_default_timezone_set('UTC');


.. meta::
    :title lang=en: Installation
    :keywords lang=en: apache mod rewrite,microsoft sql server,tar bz2,tmp directory,database storage,archive copy,tar gz,source application,current releases,web servers,microsoft iis,copyright notices,database engine,bug fixes,lighthttpd,repository,enhancements,source code,cakephp,incorporate
