How To Install Plugins
######################

There are four ways to install a CakePHP plugin:

- Through Composer
- Manually
- As Git Submodule
- By Git Cloning

But don't forget to :ref:`enable-plugins` afterwards.

Manually
========

安装一个插件，首先把插件放到 app/Plugin 目录。如果安装一个名为 'ContactManager'
的插件，在 app/Plugin 目录下面应该有一个名为 'ContactManager' 的目录。在它下面有
插件的视图，模型，控制器，webroot和其他目录等。

To install a plugin manually, you just have to drop the plugin folder
into your app/Plugin/ folder. If you're installing a plugin named
'ContactManager' then you should have a folder in app/Plugin/
named 'ContactManager' under which are the plugin's View, Model,
Controller, webroot and any other directories.

Composer
========

If you aren't familiar with the dependency management tool named Composer,
take the time to read the
`Composer documentation <https://getcomposer.org/doc/00-intro.md>`_.

To install the imaginary plugin 'ContactManager' through Composer,
add it as dependency to your project's ``composer.json``::

    {
        "require": {
            "cakephp/contact-manager": "1.2.*"
        }
    }

If a CakePHP plugin is of the type ``cakephp-plugin``, as it should,
Composer will install it inside your /Plugin directory,
rather than in the usual vendors folder.

.. note::

    Consider using "require-dev" if you only want to include
    the plugin for your development environment.

Alternatively, you can use the
`Composer CLI tool to require <https://getcomposer.org/doc/03-cli.md#require>`_
(and install) plugins::

    php composer.phar require cakephp/contact-manager:1.2.*

Git Clone
=========

If the plugin you want to install is hosted as a Git repo, you can also clone it.
Let's assume the imaginary plugin 'ContactManager' is hosted on GitHub.
You could clone it by executing the following command in your app/Plugin/ folder::

    git clone git://github.com/cakephp/contact-manager.git ContactManager

Git Submodule
=============

If the plugin you want to install is hosted as a Git repo,
but you prefer not to clone it, you can also integrate it as a Git submodule.
Execute the following commands in your app folder::

    git submodule add git://github.com/cakephp/contact-manager.git Plugin/ContactManager
    git submodule init
    git submodule update


.. _enable-plugins:

Enable the Plugin
=================

CakePHP 2.0中，插件需要在 app/Config/bootstrap.php 文件中手动加载。

Plugins need to be loaded manually in ``app/Config/bootstrap.php``.

可以一次性全部加载或者只加载一个：

You can either load one by one or all of them in a single call::

    CakePlugin::loadAll(); // 一次性加载所有插件 Loads all plugins at once
    CakePlugin::load('ContactManager'); // 加载一个特定的插件 Loads a single plugin

loadAll()方法会加载所有可用的插件,同时允许您设置加载特定的插件。
``load()`` 工作类似,但只加载指定的某个插件。

``loadAll()`` loads all plugins available, while allowing you to set certain
settings for specific plugins. ``load()`` works similarly, but only loads the
plugins you explicitly specify.


.. meta::
    :title lang=en: How To Install Plugins
    :keywords lang=en: plugin folder, install, git, zip, tar, submodule, manual, clone, contactmanager, enable