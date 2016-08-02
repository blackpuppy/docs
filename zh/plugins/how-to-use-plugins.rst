How To Use Plugins
##################

Before you can use a plugin, you must install and enable it first.
See :doc:`/plugins/how-to-install-plugins`.

插件配置
========

Plugin Configuration
====================

load 和 loadAll 方法包含有很多插件的配置和路由参数。也许你想要自动加载所有插件，
同时要为某些插件指定自定义路由和bootstrap文件。

There is a lot you can do with the load and loadAll methods to help with
plugin configuration and routing. Perhaps you want to load all plugins
automatically, while specifying custom routes and bootstrap files for
certain plugins.

没问题::

No problem::

    CakePlugin::loadAll(array(
        'Blog' => array('routes' => true),
        'ContactManager' => array('bootstrap' => true),
        'WebmasterTools' => array('bootstrap' => true, 'routes' => true),
    ));

基于这种配置，无需再手动 include() 或 require() 加载进来一个插件的配置或路由文件 --
它会在正确的时间和地点发生。load() 方法同样有这些参数。

With this style of configuration, you no longer need to manually
include() or require() a plugin's configuration or routes file--It happens
automatically at the right time and place. The exact same parameters could
have also been supplied to the load() method, which would have loaded only those
three plugins, and not the rest.

最后，可以为loadAll指定一组默认的配置以适用于每一个插件，这样就不需要更多特定的配置。

Finally, you can also specify a set of defaults for loadAll which will apply to
every plugin that doesn't have a more specific configuration.

从所有的插件中加载 bootstrap 文件，但是使用Blog插件中的路由。

Load the bootstrap file from all plugins, and additionally the routes from the Blog plugin::

    CakePlugin::loadAll(array(
        array('bootstrap' => true),
        'Blog' => array('routes' => true)
    ));


注意，插件配置中指定的所有文件应该确实存在，否则PHP会抛出警告，哪一个文件无法加载。
当为所有插件指定默认值时尤其记住这点。

Note that all files specified should actually exist in the configured
plugin(s) or PHP will give warnings for each file it cannot load. This is
especially important to remember when specifying defaults for all plugins.

CakePHP 2.3.0 added an ``ignoreMissing``` option, that allows you to ignore any
missing routes and bootstrap files when loading plugins. You can shorten the
code needed to load all plugins using this::

    // Loads all plugins including any possible routes and bootstrap files
    CakePlugin::loadAll(array(
        array('routes' => true, 'bootstrap' => true, 'ignoreMissing' => true)
    ));

有些插件需要在数据库中建立额外的表。这种时候，通常会包含一个 schema 文件，可以使用cake的shell
命令执行：

Some plugins additionally need to create one or more tables in your database. In
those cases, they will often include a schema file which you can
call from the cake shell like this::

    user@host$ cake schema create --plugin ContactManager

大多数的插件在他们的文档中会有具体的配置和安装过程。一些插件可能需要更多的设置。

Most plugins will indicate the proper procedure for configuring
them and setting up the database in their documentation. Some
plugins will require more setup than others.

高级 Bootstrapping
==================

Advanced Bootstrapping
======================

If you like to load more than one bootstrap file for a plugin. You can specify
an array of files for the bootstrap configuration key::

    CakePlugin::loadAll(array(
        'Blog' => array(
            'bootstrap' => array(
                'config1',
                'config2'
            )
        )
    ));

You can also specify a callable function that needs to be called when the plugin
has been loaded::


    function aCallableFunction($pluginName, $config) {

    }

    CakePlugin::loadAll(array(
        'Blog' => array(
            'bootstrap' => 'aCallableFunction'
        )
    ));

Using a Plugin
==============

You can reference a plugin's controllers, models, components,
behaviors, and helpers by prefixing the name of the plugin before
the class name.

For example, say you wanted to use the ContactManager plugin's
ContactInfoHelper to output some pretty contact information in
one of your views. In your controller, your $helpers array
could look like this::

    public $helpers = array('ContactManager.ContactInfo');

You would then be able to access the ContactInfoHelper just like
any other helper in your view, such as::

    echo $this->ContactInfo->address($contact);

.. meta::
    :title lang=zh: How To Use Plugins
    :keywords lang=zh: plugin folder,configuration database,bootstrap,management module,webroot,user management,contactmanager,array,config,cakephp,models,php,directories,blog,plugins,applications
