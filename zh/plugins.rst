插件
#######

CakePHP允许我们建立一个控制器，模型和视图的结合并且把他们打包为应用程序插件
可以在其他CakePHP应用程序中使用。插件可以是用户管理模块，简单的博客系统或者web服务模型。
封装为插件就可以方便的集成在其他应用中了。

CakePHP allows you to set up a combination of controllers, models,
and views and release them as a packaged application plugin that
others can use in their CakePHP applications. Have a sweet user
management module, simple blog, or web services module in one of
your applications? Package it as a CakePHP plugin so you can pop it
into other applications.

一个插件与一个应用之间的纽带主要是应用程序的配置(如数据库连接等)。否则，插件就在
它自己的空间内运行，表现的就像一个小程序一样。

The main tie between a plugin and the application it has been
installed into, is the application's configuration (database
connection, etc.). Otherwise, it operates in its own little space,
behaving much like it would if it were an application on its own.

安装插件 Installing a Plugin
===================

安装一个插件，首先把插件放到 app/Plugin 目录。如果安装一个名为 'ContactManager'
的插件，在 app/Plugin 目录下面应该有一个名为 'ContactManager' 的目录。在它下面有
插件的视图，模型，控制器，webroot和其他目录等。

To install a plugin, start by simply dropping the plugin folder in
your app/Plugin folder. If you're installing a plugin named
'ContactManager' then you should have a folder in app/Plugin
named 'ContactManager' under which are the plugin's View, Model,
Controller, webroot, and any other directories.

CakePHP 2.0中，插件需要在 app/Config/bootstrap.php 文件中手动加载。

New for CakePHP 2.0, plugins need to be loaded manually in
app/Config/bootstrap.php.

可以一次性全部加载或者只加载一个：

You can either load them one by one or all of them in a single call::

    CakePlugin::loadAll(); // 一次性加载所有插件
    CakePlugin::load('ContactManager'); //加载一个特定的插件

loadAll()方法会加载所有可用的插件,同时允许您设置加载特定的插件。
``load()`` 工作类似,但只加载指定的某个插件。

loadAll loads all plugins available, while allowing you to set certain
settings for specific plugins. ``load()`` works similarly, but only loads the
plugins you explicitly specify.

插件配置 Plugin configuration
====================

load 和 loadAll 方法包含有很多插件的配置和路由参数。也许你想要自动加载所有插件，
同时要为某些插件指定自定义路由和bootstrap文件。

There is a lot you can do with the load and loadAll methods to help with
plugin configuration and routing. Perhaps you want to load all plugins
automatically, while specifying custom routes and bootstrap files for
certain plugins.

没问题::

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

Load the bootstrap file from all plugins, and the routes from the Blog plugin::

    CakePlugin::loadAll(array(
        array('bootstrap' => true),
        'Blog' => array('routes' => true)
    ));

注意，插件配置中指定的所有文件应该确实存在，否则PHP会抛出警告，哪一个文件无法加载。
当为所有插件指定默认值时尤其记住这点。

Note that all files specified should actually exist in the configured
plugin(s) or PHP will give warnings for each file it cannot load. This is
especially important to remember when specifying defaults for all plugins.

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

高级bootstrapping  Advanced bootstrapping
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


Creating Your Own Plugins
=========================

As a working example, let's begin to create the ContactManager
plugin referenced above. To start out, we'll set up our plugin's
basic directory structure. It should look like this::

    /app
        /Plugin
            /ContactManager
                /Controller
                    /Component
                /Model
                    /Behavior
                /View
                    /Helper
                    /Layouts

Note the name of the plugin folder, '**ContactManager**'. It is important
that this folder has the same name as the plugin.

Inside the plugin folder, you'll notice it looks a lot like a CakePHP
application, and that's basically what it is. You don't actually have to
include any of those folders if you do not use them. Some plugins might
only define a Component and a Behavior, and in that case they can completely
omit the 'View' directory.

A plugin can also have basically any of the other directories that your
application can, such as Config, Console, Lib, webroot, etc.

.. note::

    If you want to be able to access your plugin with a URL, defining
    an AppController and AppModel for the plugin is required. These
    two special classes are named after the plugin, and extend the
    parent application's AppController and AppModel. Here's what they
    should look like for our ContactManager example:

::

    // /app/Plugin/ContactManager/Controller/ContactManagerAppController.php:
    class ContactManagerAppController extends AppController {
    }

::

    // /app/Plugin/ContactManager/Model/ContactManagerAppModel.php:
    class ContactManagerAppModel extends AppModel {
    }

If you forgot to define these special classes, CakePHP will hand
you "Missing Controller" errors until you’ve done so.

Please note that the process of creating plugins can be greatly
simplified by using the Cake shell.

In order to bake a plugin please use the following command::

    user@host$ cake bake plugin ContactManager

Now you can bake using the same conventions which apply to the rest
of your app. For example - baking controllers::

    user@host$ cake bake controller Contacts --plugin ContactManager

Please refer to the chapter
:doc:`/console-and-shells/code-generation-with-bake` if you
have any problems with using the command line.


Plugin Controllers
==================

Controllers for our ContactManager plugin will be stored in
/app/Plugin/ContactManager/Controller/. Since the main thing we'll
be doing is managing contacts, we'll need a ContactsController for
this plugin.

So, we place our new ContactsController in
/app/Plugin/ContactManager/Controller and it looks like so::

    // app/Plugin/ContactManager/Controller/ContactsController.php
    class ContactsController extends ContactManagerAppController {
        public $uses = array('ContactManager.Contact');

        public function index() {
            //...
        }
    }

.. note::

    This controller extends the plugin's AppController (called
    ContactManagerAppController) rather than the parent application's
    AppController.

    Also note how the name of the model is prefixed with the name of
    the plugin. This is required to differentiate between models in
    the plugin and models in the main application.

    In this case, the $uses array would not be required as
    ContactManager.Contact would be the default model for this
    controller, however it is included to demonstrate how to
    properly prepend the plugin name.

If you want to access what we’ve got going thus far, visit
/contact_manager/contacts. You should get a “Missing Model” error
because we don’t have a Contact model defined yet.

.. _plugin-models:

Plugin Models
=============

Models for the plugin are stored in /app/Plugin/ContactManager/Model.
We've already defined a ContactsController for this plugin, so let's
create the model for that controller, called Contact::

    // /app/Plugin/ContactManager/Model/Contact.php:
    class Contact extends ContactManagerAppModel {
    }

Visiting /contact_manager/contacts now (given you’ve got a table in your
database called ‘contacts’) should give us a “Missing View” error.
Let’s create that next.

.. note::

    If you need to reference a model within your plugin, you need to
    include the plugin name with the model name, separated with a dot.

For example::

    // /app/Plugin/ContactManager/Model/Contact.php:
    class Contact extends ContactManagerAppModel {
        public $hasMany = array('ContactManager.AltName');
    }

If you would prefer that the array keys for the association not
have the plugin prefix on them, use the alternative syntax::

    // /app/Plugin/ContactManager/Model/Contact.php:
    class Contact extends ContactManagerAppModel {
        public $hasMany = array(
            'AltName' => array(
                'className' => 'ContactManager.AltName'
            )
        );
    }

Plugin Views
============

Views behave exactly as they do in normal applications. Just place
them in the right folder inside of the /app/Plugin/[PluginName]/View/
folder. For our ContactManager plugin, we'll need a view for our
ContactsController::index() action, so let's include that as
well::

    // /app/Plugin/ContactManager/View/Contacts/index.ctp:
    <h1>Contacts</h1>
    <p>Following is a sortable list of your contacts</p>
    <!-- A sortable list of contacts would go here....-->

.. note::

    For information on how to use elements from a plugin, look up
    :ref:`view-elements`

Overriding plugin views from inside your application
----------------------------------------------------

You can override any plugin views from inside your app using
special paths. If you have a plugin called 'ContactManager' you
can override the view files of the plugin with more application
specific view logic by creating files using the following template
"app/View/Plugin/[Plugin]/[Controller]/[view].ctp". For the
Contacts controller you could make the following file::

    /app/View/Plugin/ContactManager/Contacts/index.ctp

Creating this file, would allow you to override
"/app/Plugin/ContactManager/View/Contacts/index.ctp".

.. _plugin-assets:


Plugin assets
=============

A plugin's web assets (but not PHP files) can be served through the
plugin's 'webroot' directory, just like the main application's assets::

    app/Plugin/ContactManager/webroot/
                                        css/
                                        js/
                                        img/
                                        flash/
                                        pdf/

You may put any type of file in any directory, just like a regular
webroot. The only restriction is that ``MediaView`` needs to know
the mime-type of that asset.

But keep in mind that handling static assets, such as images, Javascript
and CSS files of plugins, through the Dispatcher is incredibly inefficient.
It is strongly recommended to symlink them for production.
For example like this::

    ln -s app/Plugin/YourPlugin/webroot/css/yourplugin.css app/webroot/css/yourplugin.css

Linking to assets in plugins
----------------------------

Simply prepend /plugin_name/ to the beginning of a request for an
asset within that plugin, and it will work as if the asset were
in your application's webroot.

For example, linking to '/contact_manager/js/some_file.js'
would serve the asset
'app/Plugin/ContactManager/webroot/js/some_file.js'.

.. note::

    It is important to note the **/your_plugin/** prefix before the
    asset path. That makes the magic happen!

.. versionchanged:: 2.1
    Use :term:`plugin syntax` to request assets. For example in your View:
    <?php echo $this->Html->css("ContactManager.style"); ?>


Components, Helpers and Behaviors
=================================

A plugin can have Components, Helpers and Behaviors just like a
regular CakePHP application. You can even create plugins that
consist only of Components, Helpers or Behaviors which can be a
great way to build reusable components that can easily be
dropped into any project.

Building these components is exactly the same as building it within
a regular application, with no special naming convention.

Referring to your component from inside or outside of your plugin
requires only that you prefix the plugin name before the name of the
component. For example::

    // Component defined in 'ContactManager' plugin
    class ExampleComponent extends Component {
    }

    // within your controllers:
    public $components = array('ContactManager.Example');

The same technique applies to Helpers and Behaviors.

.. note::

    When creating Helpers you may find AppHelper is not automatically
    available. You should declare the resources you need with Uses::

        // Declare use of AppHelper for your Plugin's Helper
        App::uses('AppHelper', 'View/Helper');

Expand Your Plugin
==================

This example created a good start for a plugin, but there is a lot
more that you can do. As a general rule, anything you can do with your
application, you can do inside of a plugin instead.

Go ahead, include some third-party libraries in 'Vendor', add some
new shells to the cake console, and don't forget to create test cases
so your plugin users can automatically test your plugin's functionality!

In our ContactManager example, we might create add/remove/edit/delete
actions in the ContactsController, implement validation in the Contact
model, and implement the functionality one might expect when managing
their contacts. It's up to you to decide what to implement in your
plugins. Just don't forget to share your code with the community so
that everyone can benefit from your awesome, reusable components!

Plugin Tips
===========

Once a plugin has been installed in /app/Plugin, you can access it
at the URL /plugin_name/controller_name/action. In our ContactManager
plugin example, we'd access our ContactsController at
/contact_manager/contacts.

Some final tips on working with plugins in your CakePHP
applications:


-  When you don't have a [Plugin]AppController and
   [Plugin]AppModel, you'll get missing Controller errors when trying
   to access a plugin controller.
-  You can define your own layouts for plugins, inside
   app/Plugin/[Plugin]/View/Layouts. Otherwise, plugins will use the
   layouts from the /app/View/Layouts folder by default.
-  You can do inter-plugin communication by using
   ``$this->requestAction('/plugin_name/controller_name/action');`` in your
   controllers.
-  If you use requestAction, make sure controller and model names
   are as unique as possible. Otherwise you might get PHP "redefined
   class ..." errors.



.. meta::
    :title lang=zh: Plugins
    :keywords lang=zh: plugin folder,configuration database,bootstrap,management module,little space,database connection,webroot,user management,contactmanager,array,config,cakephp,models,php,directories,blog,plugins,applications
