App Class
#########

.. php:class:: App

app类负责路径管理，类定位和类加载。请确保遵循 :ref:`file-and-classname-conventions`。
The app class is responsible for path management, class location and class loading.
Make sure you follow the :ref:`file-and-classname-conventions`.

Packages 包
===========

CakePHP围绕包进行组织，每个类属于一个包或目录。可以使用 ``App::build('APackage/SubPackage', $paths)``
配置应用程序中每个包的位置，通知该框架应该加载每一个类。CakePHP框架中的几乎每一个类
都可以换做你自己的兼容性的实现。如果你想用你自己的类而不是框架提供的，仅需添加类到你的
类库目录并效仿CakePHP中预计查找的位置。

CakePHP is organized around the idea of packages, each class belongs to a
package or folder where other classes reside. You can configure each package
location in your application using ``App::build('APackage/SubPackage', $paths)``
to inform the framework where should each class be loaded. Almost every class in
the CakePHP framework can be swapped with your own compatible implementation. If
you wish to use you own class instead of the classes the framework provides,
just add the class to your libs folder emulating the directory location of where
CakePHP expects to find it.

举例，如果你想使用自己的HttpSocket类，把他放到::
For instance if you'd like to use your own HttpSocket class, put it under::

    app/Lib/Network/Http/HttpSocket.php

一旦这么做程序运行时会加载覆盖的文件而不是CakePHP的内部文件。
Once you've done this App will load your override file instead of the file
inside CakePHP.

Loading Classes 加载类
=======================

.. php:staticmethod:: uses(string $class, string $package)

    :rtype: void

    在CakePHP中，类会被延迟加载。然而在autoloader执行前，需要告诉应用程序，
    在哪里可以找到你的类文件。通过告诉应用程序，一个类在哪个包中可以找到，使得能够
    正确地定位文件和加载第一次使用一个类。

    Classes are lazily loaded in CakePHP, however before the autoloader
    can find your classes you need to tell App, where it can find the files.
    By telling App which package a class can be found in, it can properly locate
    the file and load it the first time a class is used.

    几个公共类型类的例子:
    Some examples for common types of classes are:

    Controller
        ``App::uses('PostsController', 'Controller');``
    Component
        ``App::uses('AuthComponent', 'Controller/Component');``
    Model
        ``App::uses('MyModel', 'Model');``
    Behaviors
        ``App::uses('TreeBehavior', 'Model/Behavior');``
    Views
        ``App::uses('ThemeView', 'View');``
    Helpers
        ``App::uses('HtmlHelper', 'View/Helper');``
    Libs
        ``App::uses('PaymentProcessor', 'Lib');``
    Vendors
        ``App::uses('Textile', 'Vendor');``
    Utility
        ``App::uses('String', 'Utility');``

    所以基本上第二个参数应该匹配类文件的目录在核心或应用程序的路径。
    So basically the second param should simply match the folder path of the class file in core or app.

.. note::

	加载vendors(第三方)的类库通常不遵循命名约定。推荐使用 ``App::import()`` 。
    Loading vendors usually means you are loading packages that do not follow
    conventions. For most vendor packages using ``App::import()`` is
    recommended.

Loading files from plugins
从插件内加载文件
--------------------------

加载插件内的类库与加载应用内的核心类库方法一样，除了一些特别的插件。
Loading classes in plugins works much the same as loading app and
core classes except you must specify the plugin you are loading
from::

	// 加载 app/Plugin/PluginName/Model/Comment.php 中的Comment类文件
    App::uses('Comment', 'PluginName.Model');

    // 加载 app/Plugin/PluginName/Controller/Component/CommentComponent.php 中的CommentComponent类
    App::uses('CommentComponent', 'PluginName.Controller/Component');


Finding paths to packages using App::path()
使用App::path()查找包路径
===========================================

.. php:staticmethod:: path(string $package, string $plugin = null)

    :rtype: array

    Used to read information stored path::

    	// 返回应用程序中的模型路径
        App::path('Model');

    这可以针对所有的包分开你的应用程序。还可以为一个插件获取路径::
    This can be done for all packages that are apart of your application. You
    can also fetch paths for a plugin::

        // return the component paths in DebugKit
        App::path('Component', 'DebugKit');

.. php:staticmethod:: paths( )

    :rtype: array

    // 从App中得到所有当前加载的路径。用于检查或存储App已知的所有路径。
    Get all the currently loaded paths from App. Useful for inspecting or
    storing all paths App knows about. For a paths to a specific package
    use :php:meth:`App::path()`

.. php:staticmethod:: core(string $package)

    :rtype: array

    查询CakePHP内包中的路径。
    Used for finding the path to a package inside CakePHP::

    	// 获取缓存引擎的路径
        // Get the path to Cache engines.
        App::core('Cache/Engine');

.. php:staticmethod:: location(string $className)

    :rtype: string

    //返回类所在位置的包名
    Returns the package name where a class was defined to be located at.

为App添加查询包路径
Adding paths for App to find packages in
========================================

.. php:staticmethod:: build(array $paths = array(), mixed $mode = App::PREPEND)

    :rtype: void

    Sets up each package location on the file system. You can configure multiple
    search paths for each package, those will be used to look for files one
    folder at a time in the specified order. All paths should be terminated
    with a directory separator.

    Adding additional controller paths for example would alter where CakePHP
    looks for controllers. This allows you to split your application up across
    the filesystem.

    Usage::

        //will setup a new search path for the Model package
        App::build(array('Model' => array('/a/full/path/to/models/')));

        //will setup the path as the only valid path for searching models
        App::build(array('Model' => array('/path/to/models/')), App::RESET);

        //will setup multiple search paths for helpers
        App::build(array('View/Helper' => array('/path/to/helpers/', '/another/path/')));


    If reset is set to true, all loaded plugins will be forgotten and they will
    be needed to be loaded again.

    Examples::

        App::build(array('controllers' => array('/full/path/to/controllers')));
        //becomes
        App::build(array('Controller' => array('/full/path/to/Controller')));

        App::build(array('helpers' => array('/full/path/to/views/helpers')));
        //becomes
        App::build(array('View/Helper' => array('/full/path/to/View/Helper')));

    .. versionchanged:: 2.0
        ``App::build()`` will not merge app paths with core paths anymore.


.. _app-build-register:

Add new packages to an application
----------------------------------

``App::build()`` can be used to add new package locations.  This is useful
when you want to add new top level packages or, sub-packages to your
application::

    App::build(array(
        'Service' => array('%s' . 'Service' . DS)
    ), App::REGISTER);

The ``%s`` in newly registered packages will be replaced with the
:php:const:`APP` path.  You must include a trailing ``/`` in registered
packages.  Once packages are registered, you can use ``App::build()`` to
append/prepend/reset paths like any other package.

.. versionchanged:: 2.1
    Registering packages was added in 2.1

Finding which objects CakePHP knows about
查询CakePHP已知的对象
=========================================

.. php:staticmethod:: objects(string $type, mixed $path = null, boolean $cache = true)

    :rtype: mixed Returns an array of objects of the given type or false if incorrect.

    查询已知的对象，举例可以使用``App::objects('Controller')``获得程序中所有的控制器
    You can find out which objects App knows about using
    ``App::objects('Controller')`` for example to find which application controllers
    App knows about.

    Example usage::

        //returns array('DebugKit', 'Blog', 'User');
        App::objects('plugin');

        //returns array('PagesController', 'BlogController');
        App::objects('Controller');

    使用插件点语法搜索插件中的对象。
    You can also search only within a plugin's objects by using the plugin dot syntax.::

        // returns array('MyPluginPost', 'MyPluginComment');
        App::objects('MyPlugin.Model');

    .. versionchanged:: 2.0

    1. 当空值或非法类型返回``array()``而不是false
    2. 不在返回核心对象，``App::objects('core')``将返回``array()``
    3. 返回完成的类名

    1. Returns ``array()`` instead of false for empty results or invalid types
    2. Does not return core objects anymore, ``App::objects('core')`` will
       return ``array()``.
    3. Returns the complete class name

Locating plugins
定位插件
================

.. php:staticmethod:: pluginPath(string $plugin)

    :rtype: string

    插件同样可以使用App定位。使用``App::pluginPath('DebugKit');``。举例，获得DebugKit的全路径。
    Plugins can be located with App as well. Using ``App::pluginPath('DebugKit');``
    for example, will give you the full path to the DebugKit plugin::

        $path = App::pluginPath('DebugKit');

Locating themes
定位主题
===============

.. php:staticmethod:: themePath(string $theme)

    :rtype: string

    ``App::themePath('purple');``查询主题，会返回名字为`purple`主题的全路径。
    Themes can be found ``App::themePath('purple');``, would give the full path to the
    `purple` theme.

.. _app-import:

Including files with App::import()
使用App::import()包含文件
==================================

.. php:staticmethod:: import(mixed $type = null, string $name = null, mixed $parent = true, array $search = array(), string $file = null, boolean $return = false)

    :rtype: boolean

	乍一看``App::import``看起来复杂,但是在大多数情况下只需两个参数。
    At first glance ``App::import`` seems complex, however in most use
    cases only 2 arguments are required.

    .. note::

    	这个方法等价于``require``加载文件。
    	重要的是要意识到类随后需要被初始化。
        This method is equivalent to ``require``'ing the file.
        It is important to realize that the class subsequently needs to be initialized.

    ::

    	// 等价于require('Controller/UsersController.php');
        // The same as require('Controller/UsersController.php');
        App::import('Controller', 'Users');

        // 需要加载这个类
        // We need to load the class
        $Users = new UsersController();

        // 如果我们需要模型关联，组件，等
        // If we want the model associations, components, etc to be loaded
        $Users->constructClasses();

     **过去使用App::import('Core', $class)加载所有的类，现在可以使用App::uses()。这个改变可以
     使框架性能提升。**

    **All classes that were loaded in the past using App::import('Core', $class) will need to be
    loaded using App::uses() referring to the correct package. This change has provided large
    performance gains to the framework.**

    .. versionchanged:: 2.0

    * 该方法不再递归寻找类，要严格使用:php:meth:`App::build()`中指定的路径值。
    * 使用 ``App::import('Component', 'Component')`` 不在生效，要使用
      ``App::uses('Component', 'Controller');`` 。
    * 不能再使用 ``App::import('Lib', 'CoreClass');`` 去加载核心类了。
    * 引入一个不存在的文件，传入 ``$name` 或 ``$file`` 一个错误的类型或包名，或空值。会返回false。
    * ``App::import('Core', 'CoreClass')`` 不再支持, 而换成
      :php:meth:`App::uses()`。
    * 加载Vendor文件不再递归查询vendors目录，不会像之前那样将文件名转成下划线的格式。

    * The method no longer looks for classes recursively, it strictly uses the values for the
      paths defined in :php:meth:`App::build()`
    * It will not be able to load ``App::import('Component', 'Component')`` use
      ``App::uses('Component', 'Controller');``.
    * Using ``App::import('Lib', 'CoreClass');`` to load core classes is no longer possible.
    * Importing a non-existent file, supplying a wrong type or package name, or
      null values for ``$name`` and ``$file`` parameters will result in a false return
      value.
    * ``App::import('Core', 'CoreClass')`` is no longer supported, use
      :php:meth:`App::uses()` instead and let the class autoloading do the rest.
    * Loading Vendor files does not look recursively in the vendors folder, it
      will also not convert the file to underscored anymore as it did in the
      past.

Overriding classes in CakePHP 重载类
======================================

可以重载框架内的几乎每一个类，除了 :php:class:`App` 和 :php:class:`Configure` 类。
只需添加你自己的类到你的app/Lib目录，效仿框架内部的目录结构。下面有几个例子。

You can override almost every class in the framework, exceptions are the
:php:class:`App` and :php:class:`Configure` classes. Whenever you like to
perform such overriding, just add your class to your app/Lib folder mimicking
the internal structure of the framework.  Some examples to follow

* To override the :php:class:`Dispatcher` class, create ``app/Lib/Routing/Dispatcher.php``
* To override the :php:class:`CakeRoute` class, create ``app/Lib/Routing/Route/CakeRoute.php``
* To override the :php:class:`Model` class, create ``app/Lib/Model/Model.php``

When you load the replaced files, the app/Lib files will be loaded instead of
the built-in core classes.

Loading Vendor Files  加载Vendor文件
========================================

可以使用``App::uses()``加载vendors目录中的类文件。遵循加载其他文件同样的规则::
You can use ``App::uses()`` to load classes in vendors directories. It follows
the same conventions as loading other files::

	// 加载app/Vendor/Geshi.php
    // Load the class Geshi in app/Vendor/Geshi.php
    App::uses('Geshi', 'Vendor');

加载子目录中的类，需要使用 ``App::build()`` 添加这些路径::
To load classes in subdirectories, you'll need to add those paths
with ``App::build()``::

	// 加载app/Vendor/SomePackage/ClassInSomePackage.php
    // Load the class ClassInSomePackage in app/Vendor/SomePackage/ClassInSomePackage.php
    App::build(array('Vendor' => array(APP . 'Vendor' . DS . 'SomePackage')));
    App::uses('ClassInSomePackage', 'Vendor');

vendor文件不必遵循命名规则，一个类可以不同于文件名或不包含其他类。
可以使用 ``App::import()`` 加载这些文件。下面的例子演示了如何从路径结构中加载vendor
文件。这些vendor文件可能位于vendor目录中的任何位置。

Your vendor files may not follow conventions, have a class that differs from
the file name or does not contain classes. You can load those files using
``App::import()``. The following examples illustrate how to load vendor
files from a number of path structures. These vendor files could be located in
any of the vendor folders.

To load **app/Vendor/geshi.php**::

    App::import('Vendor', 'geshi');

.. note::

	//切记geshi文件名必须是小写否则Cake找不到。
    The geshi file must be a lower-case file name as Cake will not
    find it otherwise.

To load **app/Vendor/flickr/flickr.php**::

    App::import('Vendor', 'flickr/flickr');

To load **app/Vendor/some.name.php**::

    App::import('Vendor', 'SomeName', array('file' => 'some.name.php'));

To load **app/Vendor/services/well.named.php**::

    App::import('Vendor', 'WellNamed', array('file' => 'services' . DS . 'well.named.php'));

如果你的vendor文件在/vendors目录内，不会有什么差别。Cake会自动找到它。
It wouldn't make a difference if your vendor files are inside your /vendors
directory. Cake will automatically find it.

To load **vendors/vendorName/libFile.php**::

    App::import('Vendor', 'aUniqueIdentifier', array('file' => 'vendorName' . DS . 'libFile.php'));

App Init/Load/Shutdown Methods
==============================

.. php:staticmethod:: init( )

    :rtype: void

    初始化缓存，注册关闭函数。
    Initializes the cache for App, registers a shutdown function.

.. php:staticmethod:: load(string $className)

    :rtype: boolean

    Method to handle the automatic class loading. It will look for each class'
    package defined using :php:meth:`App::uses()` and with this information it
    will resolve the package name to a full path to load the class from. File
    name for each class should follow the class name. For instance, if a class
    is name ``MyCustomClass`` the file name should be ``MyCustomClass.php``

.. php:staticmethod:: shutdown( )

    :rtype: void

    Object destructor. Writes cache file if changes have been made to the
    ``$_map``.

.. meta::
    :title lang=zh_CN: App Class
    :keywords lang=zh_CN: compatible implementation,model behaviors,path management,loading files,php class,class loading,model behavior,class location,component model,management class,autoloader,classname,directory location,override,conventions,lib,textile,cakephp,php classes,loaded
