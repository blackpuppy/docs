部署
##########

一旦应用程序完成了，或者甚至在此之前，你就要部署它了。在部署 CakePHP 应用程序时有一些你应当做的事情。

Once your application is complete, or even before that you'll want to deploy it.
There are a few things you should do when deploying a CakePHP application.

检查安全性
===================

Check your security
===================

如果你要把你的应用程序放在可以公开访问的环境，最好确保它没有任何漏洞。请查看 :doc:`/core-libraries/components/security-component`，了解如何防备 CSRF 攻击、表单字段篡改，等等。进行 :doc:`/models/data-validation` 及/或 :doc:`/core-utility-libraries/sanitize` 也是保护数据库、防备 XSS 攻击很好的办法。检查确保只有 ``webroot`` 目录可以公开访问，机密信息(比如应用程序的盐和安全密钥)是秘密的，也是唯一的。

If you're throwing your application out into the wild, it's a good idea to make
sure it doesn't have any leaks. Check the :doc:`/core-libraries/components/security-component` to guard against
CSRF attacks, form field tampering, and others. Doing :doc:`/models/data-validation`, and/or
:doc:`/core-utility-libraries/sanitize` is also a great idea, for protecting your
database and also against XSS attacks. Check that only your ``webroot`` directory
is publicly visible, and that your secrets (such as your app salt and
any security keys) are private and unique as well!

设置文档根目录
=================

Set document root
=================

在应用程序中正确地设置文档根目录，是保护代码不泄漏、保证应用程序更安全的重要步骤。CakePHP 应用程序应当设置文档根目录为应用程序的 ``app/webroot`` 目录。这使得应用程序和配置文件无法通过网址访问。设置文档根目录对不同的 web 服务器是不同的。关于 web 服务器相关的信息，可以参看 :doc:`/installation/url-rewriting` 文档。

Setting the document root correctly on your application is an important step to
keeping your code secure and your application safer. CakePHP applications
should have the document root set to the application's ``app/webroot``. This
makes the application and configuration files inaccessible through a URL.
Setting the document root is different for different webservers. See the
:doc:`/installation/url-rewriting` documentation for webserver specific
information.

在所有情况下，你都应当设置虚拟主机/域(*virtual host/domain*)的文档为 ``app/webroot/``。这样就避免了 webroot 目录以外的文件被执行的可能。

In all cases you will want to set the virtual host/domain's document to be
``app/webroot/``. This removes the possibility of files outside of the webroot
directory being executed.

更新 core.php
===============

Update core.php
===============

更新 core.php，尤其是 ``debug`` 的值是极其重要的。设置 debug = 0 禁用了一系列开发功能，一般来说，是绝不应当暴露在互联网中的。禁用调试改变了下面这些事情:

* 禁止了由 :php:func:`pr()` 和 :php:func:`debug()` 产生的调试信息。
* 核心 CakePHP 缓存默认为每 999 天清理一次，而不是象在开发模式下每 10 秒清理一次。
* 错误视图(*view*)提供更少的信息，而且只给出笼统的错误消息。
* 不显示错误。
* 没有异常堆栈追踪。

Updating core.php, specifically the value of ``debug`` is extremely important.
Turning debug = 0 disables a number of development features that should never be
exposed to the Internet at large. Disabling debug changes the following types of
things:

* Debug messages, created with :php:func:`pr()` and :php:func:`debug()` are
  disabled.
* Core CakePHP caches are by default flushed every 999 days, instead of every
  10 seconds as in development.
* Error views are less informative, and give generic error messages instead.
* Errors are not displayed.
* Exception stack traces are disabled.

除了上面这些，许多插件和应用程序扩展使用 ``debug`` 来改变它们的行为。

In addition to the above, many plugins and application extensions use ``debug``
to modify their behavior.

你可以检查环境变量，从而在不同环境中动态地设置调试级别。这样就避免了部署 debug > 0 的应用程序，也省去了在每次部署到生产环境之前要改变调试级别。

You can check against an environment variable to set the debug level dynamically
between environments. This will avoid deploying an application with debug > 0 and
also save yourself from having to change the debug level each time before deploying
to a production environment.

例如，你可以在 Apache 配置中设置一个环境变量::

For example, you can set an environment variable in your Apache configuration::

	SetEnv CAKEPHP_DEBUG 2

然后就可以在 ``core.php`` 中动态地设置调试级别::

And then you can set the debug level dynamically in ``core.php``::

	if (getenv('CAKEPHP_DEBUG')) {
		Configure::write('debug', 2);
	} else {
		Configure::write('debug', 0);
	}

改善应用程序的性能
======================================

Improve your application's performance
======================================

因为通过调度器(*Dispatcher*)处理静态资源，比如插件的图像、JavaScript 和 CSS 文件，是令人难以置信的低效的，所以强烈建议在生产环境中符号链接(*symlink*)它们。比如象这样::

Since handling static assets, such as images, JavaScript and CSS files of plugins,
through the Dispatcher is incredibly inefficient, it is strongly recommended to symlink
them for production. For example like this::

    ln -s app/Plugin/YourPlugin/webroot/css/yourplugin.css app/webroot/css/yourplugin.css


.. meta::
    :title lang=zh_CN: Deployment
    :keywords lang=zh_CN: stack traces,application extensions,set document,installation documentation,development features,generic error,document root,func,debug,caches,error messages,configuration files,webroot,deployment,cakephp,applications
