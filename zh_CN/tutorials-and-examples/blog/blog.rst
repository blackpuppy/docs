Blog教程
*************

欢迎使用CakePHP。这个教程会让你了解更多有关CakePHP是如何工作的。我们的目的是提高生产力和使编码更有趣：我们希望当你深入代码时会感受到。

这个教程将指导你建立一个简单的blog应用，我们将会获得和安装Cake，建立并配置数据库，创建足够的应用逻辑去列出文章清单，添加、编辑、删除blog文章。

这是你所需要的:

#. 一个运行中的web服务器。我们将假定你使用的是 Apache,
   使用其他服务器的设置（或步骤）也差不多。. 我们将会稍微改动
   服务器的配置文件, 但大多数情况下 Cake 将不需要任何配置的改
   动就可以跑起来，确保你的PHP的版本是 5.2.8 或更高。
#. 一个数据库服务器。在本教程中我们将使用 MySQL 数据库。
   你将会需要对SQL有一定的了解以便创建一个数据库：Cake将从
   这里接管数据库。使用MySQL的同时要确保你在PHP中开启
   了 ``pdo_mysql`` 模块.
#. 基础的 PHP 知识. 你使用面向对象编程越多越好，但如果你只是
   一个程序迷也不要害怕。
#. 最后, 你将需要对MVC编程模式有基本的了解。
   在这里可以找到一个快速的简介:doc:`/cakephp-overview/understanding-model-view-controller`.
   不用担心, 只是半张纸而已.


让我们开始吧！

获取 Cake
============

首先，让我们获取一份最新的Cake的代码拷贝。

要获得最新的代码，要访问在 GitHub 上的 CakePHP 项目:
`https://github.com/cakephp/cakephp/tags <https://github.com/cakephp/cakephp/tags>`_
并下载最新的发行版 2.0

你也可以通过git检出最新的代码
`git <http://git-scm.com/>`_.
``git clone git://github.com/cakephp/cakephp.git``

不管你是通过什么方式下载的，将下载后的代码放到你的
根目录里。这些都完成后，安装的目录看起来是这样::

    /path_to_document_root
        /app
        /lib
        /plugins
        /vendors
        .htaccess
        index.php
        README

现在是个好时机去了解一下Cake是如何组织目录的：请参阅 :doc:`/getting-started/cakephp-folder-structure` 章节 。

创建 Blog 的数据库
==========================

下一步，设置blog的数据库，如果还没有做这些，就创建一个本教程要用的
空的数据库，名字随便起。现在我们要创建一个表来存储我们的文章，然后
再写入几篇文章测试用，在数据库里面执行下列SQL语句::

    /* 首先，创建我们的日志表: */
    CREATE TABLE posts (
        id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(50),
        body TEXT,
        created DATETIME DEFAULT NULL,
        modified DATETIME DEFAULT NULL
    );

    /* 然后，插入一些日志的记录方便后边测试用: */
    INSERT INTO posts (title,body,created)
        VALUES ('The title', 'This is the post body.', NOW());
    INSERT INTO posts (title,body,created)
        VALUES ('A title once again', 'And the post body follows.', NOW());
    INSERT INTO posts (title,body,created)
        VALUES ('Title strikes back', 'This is really exciting! Not.', NOW());


表和列的名字并不是随意取的，如果你遵循Cake的数据库命名约定，
以及其类的命名约定（查看文档 :doc:`/getting-started/cakephp-conventions`）
你将可以利用许多现成的功能并避免配置。
Cake是具有足够的灵活性，以适应即使最坏的
遗留的数据库架构, 并遵守约定，节省您的时间。

查看 :doc:`/getting-started/cakephp-conventions` 获得更多的信息,
但我只想说，表'posts'将会自动钩到（绑定到）我们的模型Post，对表的
'修改'和'创建'将被Cake自动地管理。

Cake 数据库 配置
===========================

接下来:让我们告诉Cake我们的数据库放在那里以及如何去连接
对于许多人来说，这将是第一次也是最后一次配置。

在``/app/Config/database.php.default``可以找到一份CakePHP的配置文件.
复制并放在这个目录中，重命名为 ``database.php``.

这个配置文件应该非常直接： 仅仅替换掉 ``$default`` 数据中相应的值即可（换成你的数据库安装配置的值）。
一个完整的配置例子看起来应该是这样::

    public $default = array(
        'datasource' => 'Database/Mysql',
        'persistent' => false,
        'host' => 'localhost',
        'port' => '',
        'login' => 'cakeBlog',
        'password' => 'c4k3-rUl3Z',
        'database' => 'cake_blog_tutorial',
        'schema' => '',
        'prefix' => '',
        'encoding' => ''
    );

一旦你已经保存了新的 ``database.php`` 文件, 你应该能够打开你的浏览器
并看到Cake的欢迎页，它会告诉你你的数据库连接文件已经被找到，Cake已经
成功连接到数据库了。

.. 注意::

    记住如果你需要使用 PDO，你需要在php.ini中激活 pdo_mysql 模块。

可选的配置
======================

这里有三个其他的选项可以设置，大多数开发者都完成了这些任务清单，
但它并不是本次教程中所必须要求的。一个是定义自定义字符串（或者‘salt’，
译者注：salt是密码保护中用于生成密码哈希的一个随机字符串）
以生成安全哈希，第二个是自定义一个数字（或者‘seed’）用来加密，第三个是
允许CakePHP对目录 ``tmp`` 拥有写权限。

安全数组是用来生成哈希的，可以在 ``/app/Config/core.php`` line 187 改变salt的值。
它并不会关心新的值是什么，因为它很难被猜出来::

    /**
     * 一个随机的字符串，将被用来生成安全的哈希
     */
    Configure::write('Security.salt', 'pl345e-P45s_7h3*S@l7!');

密码种子用来加密和解密字符串. 在 ``/app/Config/core.php`` line 192 中
改变seed的值.同salt，它同样难以被猜到::

    /**
     * 一个随机字符串 (只含有数字) ，将被用来加密和解密.
     */
    Configure::write('Security.cipherSeed', '7485712659625147843639846751');

最后的任务是让目录 ``app/tmp``  可以被web写。最好的方法是找出你的
webserver用户是谁 (``<?php echo `whoami`; ?>``) 并将目录 ``app/tmp`` 改为该用户拥有.
在 \*nix 的系统中的命令会是::

    $ chown -R www-data app/tmp

如果因为其他原因 CakePHP 不能写入到该目录, 在非生产模式中你将会被警告。

注意 mod\_rewrite
======================

偶尔一个新的用户将会遭遇到mod\_rewrite 问题. 例如如果CakePHP 的欢迎页看起来不雅观 (不显示图片，或者没有css的样式),
这就可能是 mod\_rewrite在你的系统中没起作用. 请检查你的webserver的url重写:

.. toctree::

    /installation/url-rewriting


接下来进入 :doc:`/tutorials-and-examples/blog/part-two` 开始建立第一个 CakePHP 应用.


.. meta::
    :title lang=zh_CN: Blog Tutorial
    :keywords lang=zh_CN: model view controller,object oriented programming,application logic,directory setup,basic knowledge,database server,server configuration,reins,documentroot,readme,repository,web server,productivity,lib,sql,aim,cakephp,servers,apache,downloads