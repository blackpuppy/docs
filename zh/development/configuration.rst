配置
####

配置 CakePHP 应用程序简直是小餐一碟。在安装完 CakePHP 后，创建一个基本的 web 应用只需设置数据库配置。

Configuring a CakePHP application is a piece of cake. After you
have installed CakePHP, creating a basic web application requires
only that you setup a database configuration.

当然，还有其它可选的配置步骤可以采用，来充分利用 CakePHP 的灵活架构。可以容易地对继承自 CakePHP 核心的功能添加(新的功能)，配置额外的/不同的网址(*URL*)映射(路由)，以及定义额外/不同的词形变化(*inflections*)。

There are, however, other optional configuration steps you can take
in order to take advantage of CakePHP flexible architecture. You
can easily add to the functionality inherited from the CakePHP
core, configure additional/different URL mappings (routes), and
define additional/different inflections.

.. index:: database.php, database.php.default
.. _database-configuration:

数据库配置
======================

Database Configuration
======================

CakePHP 期待的数据库配置信息位于 ``app/Config/database.php`` 文件中。示例数据库配置文件在 ``app/Config/database.php.default`` 。一个完成的配置应该
看起来像这样::

CakePHP expects database configuration details to be in a file at
``app/Config/database.php``. An example database configuration file can
be found at ``app/Config/database.php.default``. A finished
configuration should look something like this::

    class DATABASE_CONFIG {
        public $default = array(
            'datasource'  => 'Database/Mysql',
            'persistent'  => false,
            'host'        => 'localhost',
            'login'       => 'cakephpuser',
            'password'    => 'c4k3roxx!',
            'database'    => 'my_cakephp_project',
            'prefix'      => ''
        );
    }

(默认情况下)会使用 $default 连接数组，除非用模型的 ``$useDbConfig`` 属性指定了另外一个连接。举个例子，如果一个应用程序除了默认的数据库配置信息还有一个额外的遗留数据库，应该创建一个结构类似于$default 数组的新的 $legacy 数据库连接数组，然后在适当的模型中设置 ``public $useDbConfig = 'legacy';``，就可以使用它(指遗留数据库)了。

The $default connection array is used unless another connection is
specified by the ``$useDbConfig`` property in a model. For example, if
my application has an additional legacy database in addition to the
default one, I could use it in my models by creating a new $legacy
database connection array similar to the $default array, and by
setting ``public $useDbConfig = 'legacy';`` in the appropriate models.

填写配置数组中的键/值对以尽可能满足需求。

Fill out the key/value pairs in the configuration array to best
suit your needs.

datasource
    该配置数组的数据源名称。
    例如：Database/Mysql, Database/Sqlserver, Database/Postgres, Database/Sqlite。
    可以使用 :term:`plugin syntax` 指定要使用的插件数据源。
    The name of the datasource this configuration array is for.
    Examples: Database/Mysql, Database/Sqlserver, Database/Postgres, Database/Sqlite.
    You can use :term:`plugin syntax` to indicate plugin datasource to use.
persistent
    是否使用持久化连接数据库。
    Whether or not to use a persistent connection to the database.
host
    数据库服务器的主机名(或IP地址)。
    The database server's hostname (or IP address).
login
    账号的用户名。
    The username for the account.
password
    账号的密码。
    The password for the account.
database
    该连接要使用的数据库名称。
    The name of the database for this connection to use.
prefix (*可选*)
    数据库中每个表的前缀字符串。如果表没有前缀，设置为空字符串。
    The string that prefixes every table name in the database. If your
    tables don't have prefixes, set this to an empty string.
port (*可选*)
    用于连接服务器的 TCP 端口或 Unix 套接字(*socket*)。
    The TCP port or Unix socket used to connect to the server.
encoding
    指定了发送 SQL 语句到服务器使用的字符集。对除了 DB2 数据库以外的所有数据库，默认使用数据库的默认编码。如果对 mysql/mysqli 连接想使用 UTF-8 编码，必须使用不带连字符的'utf8'。
    Indicates the character set to use when sending SQL statements to
    the server. This defaults to the database's default encoding for
    all databases other than DB2. If you wish to use UTF-8 encoding
    with mysql/mysqli connections you must use 'utf8' without the
    hyphen.
schema
    用于 PostgreSQL 数据库设置，指定使用哪个 schema。
    Used in PostgreSQL database setups to specify which schema to use.
unix_socket
    用于支持通过 unix 套接字(*socket*)文件连接的驱动程序。如果使用 postgres 数据库想使用 unix 套接字，需要将 host 键留空。
    Used by drivers that support it to connect via unix socket files. If you are
    using postgres and want to use unix sockets, leave the host key blank.
ssl_key
    SSL 密钥(*SSL key*)文件的路径(仅为 MySQL 所支持，要求 PHP 5.3.7+)。
    The file path to the SSL key file. (Only supported by MySQL, requires PHP
    5.3.7+).
ssl_cert
    SSL 证书(*SSL certificate*)文件的路径(仅为 MySQL 所支持，要求 PHP 5.3.7+)。
    The file path to the SSL certificate file. (Only supported by MySQL,
    requires PHP 5.3.7+).
ssl_ca
    SSL 证书颁发机构(SSL certificate authority)文件的路径(仅为 MySQL 所支持，要求 PHP 5.3.7+)。
    The file path to the SSL certificate authority. (Only supported by MySQL,
    requires PHP 5.3.7+).
settings
    一个包含键值对的数组，在建立连接时应当作为 ``SET`` 命令发送到数据库服务器。该选项当前只被 MySQL、Postgres 和 SQLserver 所支持。
    An array of key/value pairs that should be sent to the database server as
    ``SET`` commands when the connection is created. This option is only
    supported by MySQL, Postgres, and SQLserver at this time.

.. versionchanged:: 2.4
    参数 ``settings`` 、 ``ssl_key`` 、 ``ssl_cert`` 和 ``ssl_ca`` 是在 2.4 版本中新增的。
    The ``settings``, ``ssl_key``, ``ssl_cert`` and ``ssl_ca`` keys
    was added in 2.4.

.. note::

    前缀设置作用于表，**而不是** 模型。举个例子，如果为 Apple 和 Flavor 模型创建了一个连接表，应当命名为 prefix\_apples\_flavors(**而不是** prefix\_apples\_prefix\_flavors)，前缀设置应设为 'prefix\_'。

    The prefix setting is for tables, **not** models. For example, if
    you create a join table for your Apple and Flavor models, you name
    it prefix\_apples\_flavors (**not**
    prefix\_apples\_prefix\_flavors), and set your prefix setting to
    'prefix\_'.

在这个时候，你也许可以看下 :doc:`/getting-started/cakephp-conventions` 。对表(以及某些字段)的正确命名让你自动获得一些功能，而且避免配置。例如，如果将表命名为 big\_boxes，模型命名为 BigBox，控制器命名为 BigBoxesController，那这一切就能够自动协作了。按照约定，数据库表名应当使用下划线分隔的小写复数形式 — 例如：bakers、pastry\_stores 和 savory\_cakes。

At this point, you might want to take a look at the
:doc:`/getting-started/cakephp-conventions`. The correct
naming for your tables (and the addition of some columns) can score
you some free functionality and help you avoid configuration. For
example, if you name your database table big\_boxes, your model
BigBox, your controller BigBoxesController, everything just works
together automatically. By convention, use underscores, lower case,
and plural forms for your database table names - for example:
bakers, pastry\_stores, and savory\_cakes.

.. todo::

    为不同数据库供应商的特定选项增加信息，比如 SQLServer、Postgres 和 MySQL。

    Add information about specific options for different database
    vendors, such as SQLServer, Postgres and MySQL.

额外的类路径
============

Additional Class Paths
======================

偶尔，在同一个系统上的应用程序之间共享 MVC 类库是很有用的。如果想要在两个应用程序间使用同一个控制器，可以使用 CakePHP 的 bootstrap.php 把这些额外的类引入视图。

It's occasionally useful to be able to share MVC classes between
applications on the same system. If you want the same controller in
both applications, you can use CakePHP's bootstrap.php to bring
these additional classes into view.

在 bootstrap.php 使用 :php:meth:`App::build()` 可以定义额外的路径，CakePHP 就会
在这些路径中搜寻类::

By using :php:meth:`App::build()` in bootstrap.php we can define additional
paths where CakePHP will look for classes::

    App::build(array(
        'Model' => array(
            '/path/to/models',
            '/next/path/to/models'
        ),
        'Model/Behavior' => array(
            '/path/to/behaviors',
            '/next/path/to/behaviors'
        ),
        'Model/Datasource' => array(
            '/path/to/datasources',
            '/next/path/to/datasources'
        ),
        'Model/Datasource/Database' => array(
            '/path/to/databases',
            '/next/path/to/database'
        ),
        'Model/Datasource/Session' => array(
            '/path/to/sessions',
            '/next/path/to/sessions'
        ),
        'Controller' => array(
            '/path/to/controllers',
            '/next/path/to/controllers'
        ),
        'Controller/Component' => array(
            '/path/to/components',
            '/next/path/to/components'
        ),
        'Controller/Component/Auth' => array(
            '/path/to/auths',
            '/next/path/to/auths'
        ),
        'Controller/Component/Acl' => array(
            '/path/to/acls',
            '/next/path/to/acls'
        ),
        'View' => array(
            '/path/to/views',
            '/next/path/to/views'
        ),
        'View/Helper' => array(
            '/path/to/helpers',
            '/next/path/to/helpers'
        ),
        'Console' => array(
            '/path/to/consoles',
            '/next/path/to/consoles'
        ),
        'Console/Command' => array(
            '/path/to/commands',
            '/next/path/to/commands'
        ),
        'Console/Command/Task' => array(
            '/path/to/tasks',
            '/next/path/to/tasks'
        ),
        'Lib' => array(
            '/path/to/libs',
            '/next/path/to/libs'
        ),
        'Locale' => array(
            '/path/to/locales',
            '/next/path/to/locales'
        ),
        'Vendor' => array(
            '/path/to/vendors',
            '/next/path/to/vendors'
        ),
        'Plugin' => array(
            '/path/to/plugins',
            '/next/path/to/plugins'
        ),
    ));

.. note::

    所有额外路径的配置应该在程序的 bootstrap.php 最开始定义。这样会确保应用程序的其余部分可以使用这些路径。

    All additional path configuration should be done at the top of your application's
    bootstrap.php. This will ensure that the paths are available for the rest of your
    application.


.. index:: core.php, configuration

核心配置
========

Core Configuration
==================

每个 CakePHP 应用程序包含一个配置文件，决定 CakePHP 的内部行为，``app/Config/core.php`` 。这个文件是一个 Configure 类变量和常量定义的集合，决定应用程序的行为。在我们深入这些特定的变量之前，你需要熟悉 :php:class:`Configure`，CakePHP的配置注册表类。

Each application in CakePHP contains a configuration file,
``app/Config/core.php``, to determine CakePHP's internal behavior.
This file is a collection of Configure class
variable definitions and constant definitions that determine how
your application behaves. Before we dive into those particular
variables, you'll need to be familiar with :php:class:`Configure`, CakePHP's
configuration registry class.

CakePHP 核心配置
----------------

CakePHP Core Configuration
--------------------------

:php:class:`Configure` 类用来管理一系列 CakePHP 配置变量。这些变量可在 ``app/Config/core.php`` 文件中找到。下面是每个变量的描述、以及如何影响到程序的。

The :php:class:`Configure` class is used to manage a set of core CakePHP
configuration variables. These variables can be found in
``app/Config/core.php``. Below is a description of each variable and
how it affects your CakePHP application.

debug
    改变 CakePHP 调试输出。
    Changes CakePHP debugging output.
    0 = 生产模式。无输出。
    0 = Production mode. No output.
    1 = 显示错误和警告。
    1 = Show errors and warnings.
    2 = 显示错误，警告和 SQL 语句。 [只有在视图或布局中添加 
    $this->element('sql\_dump') 才会显示 SQL 日志。]
    2 = Show errors, warnings, and SQL. [SQL log is only shown when you
    add $this->element('sql\_dump') to your view or layout.]

Error
    配置处理应用程序错误的错误处理器。默认使用 
    :php:meth:`ErrorHandler::handleError()`。当 debug > 0 时，使用 
    :php:class:`Debugger` 显示错误，而当 debug = 0 时，使用 :php:class:`CakeLog`
    将错误记录在日志中。
    Configure the Error handler used to handle errors for your application.
    By default :php:meth:`ErrorHandler::handleError()` is used. It will display
    errors using :php:class:`Debugger`, when debug > 0
    and log errors with :php:class:`CakeLog` when debug = 0.

    子键:
    Sub-keys:

    * ``handler`` - callback - 处理错误的回调方法。可设置为任何回调类型，包括匿名函数。
    * ``level`` - int - 要捕获的错误等级。
    * ``trace`` - boolean - 是否在日志文件中记录错误的堆栈跟踪(*stack trace*)信息。

    * ``handler`` - callback - The callback to handle errors. You can set this to any
      callback type, including anonymous functions.
    * ``level`` - int - The level of errors you are interested in capturing.
    * ``trace`` - boolean - Include stack traces for errors in log files.

Exception
    配置异常处理程序用于未捕获的异常。默认情况下，会使用 ErrorHandler::handleException()。
    对异常会显示一个 HTML 页面。当 debug > 0 时，像 Missing Controller 这样的框架错误会显示出来。
    而当 debug = 0 时，框架错误被强制转换为通常的 HTTP 错误。
    欲知更多异常处理的信息，请参见 :doc:`exceptions` 一节。
    Configure the Exception handler used for uncaught exceptions. By default,
    ErrorHandler::handleException() is used. It will display a HTML page for
    the exception, and while debug > 0, framework errors like
    Missing Controller will be displayed. When debug = 0,
    framework errors will be coerced into generic HTTP errors.
    For more information on Exception handling, see the :doc:`exceptions`
    section.

.. _core-configuration-baseurl:

App.baseUrl
    如果你不想或者无法在你的服务器上运行 mod\_rewrite (或者一些其它兼容模块），你就要使用 CakePHP 的内置美观网址了。在 ``/app/ConfigScore.php`` 中，对下面这行去掉注释::
    If you don't want or can't get mod\_rewrite (or some other
    compatible module) up and running on your server, you'll need to
    use CakePHP's built-in pretty URLs. In ``/app/Config/core.php``,
    uncomment the line that looks like::

        Configure::write('App.baseUrl', env('SCRIPT_NAME'));

    也要删除这些 .htaccess 文件::
    Also remove these .htaccess files::

        /.htaccess
        /app/.htaccess
        /app/webroot/.htaccess


    这会让网址看起来象
    This will make your URLs look like
    www.example.com/index.php/controllername/actionname/param rather
    而不是 than www.example.com/controllername/actionname/param.

    如果你把 CakePHP 安装到不是 Apache 的 web 服务器上，你可以从 :doc:`/installation/url-rewriting` 一节找到在其它服务器上使网址重写运行的指示方法。
    If you are installing CakePHP on a webserver besides Apache, you
    can find instructions for getting URL rewriting working for other
    servers under the :doc:`/installation/url-rewriting` section.
App.encoding
    定义应用程序使用的编码。该编码用来生成布局(*layout*)中的字符集，和编码实体。这应当符合为数据库指定的编码值。
    Define what encoding your application uses. This encoding
    is used to generate the charset in the layout, and encode entities.
    It should match the encoding values specified for your database.
Routing.prefixes
    如果想要使用象 admin 这样的 CakePHP 前缀路由(*prefixed routes*)，去掉对该定义的注释。设置该变量为你想要使用的路由的前缀名称数组。对此后面有更多的描述。
    Un-comment this definition if you'd like to take advantage of
    CakePHP prefixed routes like admin. Set this variable with an array
    of prefix names of the routes you'd like to use. More on this
    later.
Cache.disable
    当设置为 true 时，整个网站的持久化缓存会被禁用。这会导致所有的
    :php:class:`Cache` 读/写失败。
    When set to true, persistent caching is disabled site-wide.
    This will make all read/writes to :php:class:`Cache` fail.
Cache.check
    如果设置为 true，启用视图缓存。仍然需要在控制器中启用，但是该变量开启了这些设置的检测。
    If set to true, enables view caching. Enabling is still needed in
    the controllers, but this variable enables the detection of those
    settings.
Session
    包含设置数组，用于会话(*session*)配置。defaults 键用于定义会话的默认预设，这里声明的任何设置会覆盖默认配置的设置。
    Contains an array of settings to use for session configuration. The defaults key is
    used to define a default preset to use for sessions, any settings declared here will override
    the settings of the default config.

    子键
    Sub-keys

    * ``name`` - 要使用的，cookie 的名字。默认为'CAKEPHP' The name of the cookie to use. Defaults to 'CAKEPHP'
    * ``timeout`` - 要会话存在的分钟数。 The number of minutes you want sessions to live for.
      This timeout is handled by CakePHP
    * ``cookieTimeout`` - 要会话 coookie 存在的分钟数。 The number of minutes you want session cookies to live for.
    * ``checkAgent`` - 在启动会话时，要检查用户代理吗？ Do you want the user agent to be checked when starting sessions?
      在处理旧版 IE、Chrome Frame 或者某些网络浏览设备以及 AJAX 时，你或许想要设置该值为 false。
      You might want to set the value to false, when dealing with older versions of
      IE, Chrome Frame or certain web-browsing devices and AJAX
    * ``defaults`` - 会话使用的默认配置集。The default configuration set to use as a basis for your session.
 +      有四种内置(默认配置集): php、cake、cache、database。
 +      There are four builtins: php, cake, cache, database.
    * ``handler`` - 可以用来启用自定义会话处理器。Can be used to enable a custom session handler.
      期待可用于 `session_save_handler` 的回调数组。使用该选项会自动添加 `session.save_handler` 到 ini 数组。
      Expects an array of callables, that can be used with `session_save_handler`.
      Using this option will automatically add `session.save_handler` to the ini array.
    * ``autoRegenerate`` - 启用该设置，就打开了会话的自动延续，频繁变化的 sessionid。参看 :php:attr:`CakeSession::$requestCountdown`。
      Enabling this setting, turns on automatic renewal
      of sessions, and sessionids that change frequently.
      See :php:attr:`CakeSession::$requestCountdown`.
    * ``ini`` - 要设置的额外 ini 值的关联数组。 An associative array of additional ini values to set.

    内置默认值为：
    The built-in defaults are:

    * 'php' - 使用在 php.ini 中定义的设置。Uses settings defined in your php.ini.
    * 'cake' - 在 CakePHP 的 /tmp 目录中保存会话文件。 Saves session files in CakePHP's /tmp directory.
    * 'database' - 使用 CakePHP 的数据库会话。 Uses CakePHP's database sessions.
    * 'cache' - 使用 Cache 类保存会话。Use the Cache class to save sessions.

    要定义自定义会话处理器，把它保存在 ``app/ModelSDatasource/Session/<name>.php``。确保这个类实现了 :php:interface:`CakeSessionHandlerInterface`，并设置 Session.handler 为 <name>。
    To define a custom session handler, save it at ``app/Model/Datasource/Session/<name>.php``.
    Make sure the class implements :php:interface:`CakeSessionHandlerInterface`
    and set Session.handler to <name>

    要使用数据库会话，用 cake 控制台命令运行 ``app/ConfigSSchema/sessions.php`` 数据结构： ``cake schema create Sessions``
    To use database sessions, run the ``app/Config/Schema/sessions.php`` schema using
    the cake shell command: ``cake schema create Sessions``

Security.salt
    用于 安全哈希(*security hashing*)的一个随机字符串。
    A random string used in security hashing.
Security.cipherSeed
    随机数字字符串(只允许数字)，用来加密/解密字符串。
    A random numeric string (digits only) used to encrypt/decrypt
    strings.
Asset.timestamp
    在使用正确的助件时，在资源文件网址(CSS、JavaScript、Image)末尾附加特定文件最后修改的时间戳。
    Appends a timestamp which is last modified time of the particular
    file at the end of asset files URLs (CSS, JavaScript, Image) when
    using proper helpers.
    合法值：
    Valid values:
    (boolean) false - 什么也不做(默认) Doesn't do anything (default)
    (boolean) true - 当 debug > 0 时附加时间戳 Appends the timestamp when debug > 0
    (string) 'force' - 当 debug >= 0 时附加时间戳 Appends the timestamp when debug >= 0
Acl.classname, Acl.database
    用于 CakePHP 的访问控制列表(Access Control Access)功能的常数。欲知详情，参见访问控制列表一章。
    Constants used for CakePHP's Access Control List functionality. See
    the Access Control Lists chapter for more information.

.. note::
    在 core.php 中也有缓存配置 — 稍安勿躁，后面会讲到。
    Cache configuration is also found in core.php — We'll be covering
    that later on, so stay tuned.

:php:class:`Configure` 类可以随时用来读写核心配置设置。这很方便，例如，在应用程序中要对有限的一部分逻辑启用 debug 设置。
The :php:class:`Configure` class can be used to read and write core
configuration settings on the fly. This can be especially handy if
you want to turn the debug setting on for a limited section of
logic in your application, for instance.

配置常量
--------

Configuration Constants
-----------------------

尽管大部分配置选项由 Configure 处理，还是有一部分 CakePHP 在运行时使用的常量。

While most configuration options are handled by Configure, there
are a few constants that CakePHP uses during runtime.

.. php:const:: LOG_ERROR

    错误常量。用于区分错误日志和出错。当前 PHP'支持 LOG\_DEBUG。

    Error constant. Used for differentiating error logging and
    debugging. Currently PHP supports LOG\_DEBUG.

核心缓存配置
------------

Core Cache Configuration
------------------------

CakePHP 在内部使用两个缓存配置，``_cake_model_`` 和 ``_cake_core_``。``_cake_core_`` 用于保存文件路径和对象位置。``_cakeMmodel_`` 用于保存数据结构描述和数据源的源列表。建议对这些配置使用象 APC 或 Memcached 这样的告诉缓存存储，因为它们会在每次请求时读取。默认情况下，当 debug 大于 0 时这两个配置都是每 10 秒就过期。

CakePHP uses two cache configurations internally. ``_cake_model_`` and ``_cake_core_``.
``_cake_core_`` is used to store file paths, and object locations. ``_cake_model_`` is
used to store schema descriptions, and source listings for datasources. Using a fast
cache storage like APC or Memcached is recommended for these configurations, as
they are read on every request. By default both of these configurations expire every
10 seconds when debug is greater than 0.

就象所有缓存在 :php:class:`Class` 中的缓存数据一样，可以使用 :phpCmeth:`Cache::clear()` 清除数据。

As with all cached data stored in :php:class:`Cache` you can clear data using
:php:meth:`Cache::clear()`.

Configure 类
============

Configure Class
===============

.. php:class:: Configure

尽管很少的东西需要在 CakePHP 中配置，有时对应用程序有自己的配置规则还是有用的。过去你也许在某个文件中定义变量或常量来定义自定义配置值。这么做迫使你在每次需要这些值时必须引入那个配置文件。

Despite few things needing to be configured in CakePHP, it's
sometimes useful to have your own configuration rules for your
application. In the past you may have defined custom configuration
values by defining variable or constants in some files. Doing so
forces you to include that configuration file every time you needed
to use those values.

CakePHP 的 Configure 类可以用来保存和读取应用程序或运行时相关的值。当心，这个类允许在其中保存任何东西，然后在代码的任何部分使用它：明显诱使人打破作为 CakePHP 的设计目的的 MVC 模式。Configure 类的主要目标是保持集中的变量，可在许多对象之间共享。记得尽量保持“约定重于配置”，你就不会打破我们设定好的 MVC 结构了。

CakePHP's Configure class can be used to store and retrieve
application or runtime specific values. Be careful, this class
allows you to store anything in it, then use it in any other part
of your code: a sure temptation to break the MVC pattern CakePHP
was designed for. The main goal of Configure class is to keep
centralized variables that can be shared between many objects.
Remember to try to live by "convention over configuration" and you
won't end up breaking the MVC structure we've set in place.

这个类可以在应用程序的任何地方以静态方式调用::

This class can be called from
anywhere within your application, in a static context::

    Configure::read('debug');

.. php:staticmethod:: write($key, $value)

    :param string $key: 写入的键，可以是 :termC`dot notation` 值。The key to write, can use be a :term:`dot notation` value.
    :param mixed $value: 要存储的值。The value to store.

    用 ``write()`` 在应用程序的配置中存储数据::
    Use ``write()`` to store data in the application's configuration::

        Configure::write('Company.name','Pizza, Inc.');
        Configure::write('Company.slogan','Pizza for your body and soul');

    .. note::

        ``$key`` 参数中使用的 :term:`dot notation` 可以用来把配置设置组织成符合逻辑的分组。

        The :term:`dot notation` used in the ``$key`` parameter can be used to
        organize your configuration settings into logical groups.

    上面的例子也可以写成一个调用::

    The above example could also be written in a single call::

        Configure::write(
            'Company',
            array(
                'name' => 'Pizza, Inc.',
                'slogan' => 'Pizza for your body and soul'
            )
        );

    可以使用 ``Configure:Cwrite('debug', $int)`` 来动态切换调试和生成模式。这对与 AMF 或 SOAP 的交互尤其方便，因为调试信息回引起解析的问题。

    You can use ``Configure::write('debug', $int)`` to switch between
    debug and production modes on the fly. This is especially handy for
    AMF or SOAP interactions where debugging information can cause
    parsing problems.

.. php:staticmethod:: read($key = null)

    :param string $key: 读取的键名，可以是 :term:`dot notation` 值。 The key to read, can be a :term:`dot notation` value

    用来从应用程序中读取配置数据。默认是 CakePHP 重要的 debug 值。如果提供键，则
    返回数据。使用上面的 write() 的例子，可以读取那个数据::

    Used to read configuration data from the application. Defaults to
    CakePHP's important debug value. If a key is supplied, the data is
    returned. Using our examples from write() above, we can read that
    data back::

        Configure::read('Company.name');    //得到：yields: 'Pizza, Inc.'
        Configure::read('Company.slogan');  //得到：yields: 'Pizza for your body
                                            //and soul'

        Configure::read('Company');

        //得到：yields:
        array('name' => 'Pizza, Inc.', 'slogan' => 'Pizza for your body and soul');

    如果 $key 为 null，返回 Configure 中所有的值。

    If $key is left null, all values in Configure will be returned.

.. php:staticmethod:: check($key)

    :param string $key: 要检测的键。The key to check.

    检测键/路径是否存在，且有非 null 值。

    Used to check if a key/path exists and has not-null value.

    .. versionadded:: 2.3
        ``Configure::check()`` 是在 2.3 版本中新增的
        ``Configure::check()`` was added in 2.3

.. php:staticmethod:: delete($key)

    :param string $key: 要删除的键，可以是 :term:`dot notation` 值。The key to delete, can use be a :term:`dot notation` value

    用来从应用程序中的配置中删除信息::

    Used to delete information from the application's configuration::

        Configure::delete('Company.name');

.. php:staticmethod:: version()

    返回当前应用程序的 CakePHP 版本。

    Returns the CakePHP version for the current application.

.. php:staticmethod:: config($name, $reader)

    :param string $name: 附加的读取器(*reader*)的名称。The name of the reader being attached.
    :param ConfigReaderInterface $reader:  附加的读取器实例。The reader instance being attached.

    在 Configure 类上附加一个配置读取器。然后附加的读取器就可以加载配置文件。欲知如何读取配置文件，请参见 :ref:`loading-configuration-files`。

    Attach a configuration reader to Configure. Attached readers can
    then be used to load configuration files. See :ref:`loading-configuration-files`
    for more information on how to read configuration files.

.. php:staticmethod:: configured($name = null)

    :param string $name: 要检查的读取器的名称，如果为 null，则返回所有附加的读取器的列表。The name of the reader to check, if null
        a list of all attached readers will be returned.

    或者检查指定名称的读取器是否附加了，或者得到附加的读取器列表。

    Either check that a reader with a given name is attached, or get
    the list of attached readers.

.. php:staticmethod:: drop($name)

    去掉一个连接的读取器对象。

    Drops a connected reader object.


读写配置文件
============

Reading and writing configuration files
=======================================

CakePHP 附带两种内置的配置文件读取器。:php:class:`PhpReader` 能够读取 PHP 配置文件，与 Configure 类之前读取的格式相同。:php:class:`IniReader` 能够读取 ini 配置文件。欲知 ini 文件的更多细节，请参见 `PHP documentation <http://php.net/parse_ini_file>`_。为了使用核心配置读取器，需要使用 :php:meth:`Configure::config()` 把它附加到 Configure 类上::

CakePHP comes with two built-in configuration file readers.
:php:class:`PhpReader` is able to read PHP config files, in the same
format that Configure has historically read. :php:class:`IniReader` is
able to read ini config files. See the `PHP documentation <http://php.net/parse_ini_file>`_
for more information on the specifics of ini files.
To use a core config reader, you'll need to attach it to Configure
using :php:meth:`Configure::config()`::

    App::uses('PhpReader', 'Configure');
    // 从 app/Config 读取配置文件
    // Read config files from app/Config
    Configure::config('default', new PhpReader());

    // 从其他路径读配置文件。
    // Read config files from another path.
    Configure::config('default', new PhpReader('/path/to/your/config/files/'));

可以有多个附加到 Configure 类的读取器，每个读取不同的配置文件，或者从不同的来源读取。可以用 Configure 类的一些其它方法与附加的读取器交互。要查看附加了哪些读取器别名，可以使用 :php:meth:`Configure::configured()` 方法::

You can have multiple readers attached to Configure, each reading
different kinds of configuration files, or reading from
different types of sources. You can interact with attached readers
using a few other methods on Configure. To see check which reader
aliases are attached you can use :php:meth:`Configure::configured()`::

    // 得到附加的读取器的别名数组。
    // Get the array of aliases for attached readers.
    Configure::configured();

    // 检查是否附加了某个特定的读取器
    // Check if a specific reader is attached
    Configure::configured('default');

也可以移除附加的读取器。``Configure::drop('default')`` 方法默认的读取器别名。以后任何使用该读取器加载配置文件的企图都会失败。

You can also remove attached readers. ``Configure::drop('default')``
would remove the default reader alias. Any future attempts to load configuration
files with that reader would fail.


.. _loading-configuration-files:

加载配置文件
------------

Loading configuration files
---------------------------

.. php:staticmethod:: load($key, $config = 'default', $merge = true)

    :param string $key: 要加载的配置文件的识别符。The identifier of the configuration file to load.
    :param string $config: 配置的读取器的别名。The alias of the configured reader.
    :param boolean $merge: 是否要合并读取的文件内容，或者覆盖现有的值。Whether or not the contents of the read file
        should be merged, or overwrite the existing values.

一旦在 Configure 类上附加了配置读取器，就可以加载配置文件::

Once you've attached a config reader to Configure you can load configuration files::

    // 使用 'default' 读取器对象加载 my_file.php
    // Load my_file.php using the 'default' reader object.
    Configure::load('my_file', 'default');

加载的配置文件把它们的数据与 Configure 类中的已有的运行时配置合并。这允许对现有的运行时配置进行覆盖和增加新值。设置 ``$merge`` 为 true，值就不会覆盖已有的配置了。

Loaded configuration files merge their data with the existing runtime configuration
in Configure. This allows you to overwrite and add new values
into the existing runtime configuration. By setting ``$merge`` to true, values
will not ever overwrite the existing configuration.

创建或者修改配置文件
--------------------

Creating or modifying configuration files
-----------------------------------------

.. php:staticmethod:: dump($key, $config = 'default', $keys = array())

    :param string $key: 要创建的文件/保存的配置的名称。The name of the file/stored configuration to be created.
    :param string $config: 要保存数据的读取器的名称。The name of the reader to store the data with.
    :param array $keys: 要保存的顶层键的列表。默认为所有键。The list of top-level keys to save. Defaults to all
        keys.

把 Configure 类中的所有或部分数据保存到配置读取器支持的文件或存储系统中。例如，如果 'default' 适配器为  :php:class:`PhpReader` 类，生成的文件将会是一个 PHP 配置文件，可由 :php:class:`PhpReader` 类加载。

Dumps all or some of the data in Configure into a file or storage system
supported by a config reader. The serialization format
is decided by the config reader attached as $config. For example, if the
'default' adapter is a :php:class:`PhpReader`, the generated file will be a PHP
configuration file loadable by the :php:class:`PhpReader`

假定 'default' 读取器是一个 PhpReader 的实例。保存 Configure 类中的所有数据到文件 `my_config.php` 中::

Given that the 'default' reader is an instance of PhpReader.
Save all data in Configure to the file `my_config.php`::

    Configure::dump('my_config.php', 'default');

仅保存错误处理配置::

Save only the error handling configuration::

    Configure::dump('error.php', 'default', array('Error', 'Exception'));

``Configure::dump()`` 方法可以用来修改或覆盖可以用 :php:meth:`Configure::load()` 方法读取的配置文件。

``Configure::dump()`` can be used to either modify or overwrite
configuration files that are readable with :php:meth:`Configure::load()`

.. versionadded:: 2.2
    在 2.2 版本中增加了 ``Configure::dump()`` 方法。
    ``Configure::dump()`` was added in 2.2.

存储运行时配置
--------------

Storing runtime configuration
-----------------------------

.. php:staticmethod:: store($name, $cacheConfig = 'default', $data = null)

    :param string $name: 缓存文件的存储键。The storage key for the cache file.
    :param string $cacheConfig: 用来存储配置数据的缓存配置的名称。The name of the cache configuration to store the
        configuration data with.
    :param mixed $data: 或者为要保存的数据，或者为 null 来保存 Configure 类中的所有数据。Either the data to store, or leave null to store all data
        in Configure.

也可以保存运行时配置的值，在以后的请求使用。由于配置只记得当前请求的值，如果想要在以后的请求中使用，需要保存任何修改过的配置信息::

You can also store runtime configuration values for use in a future request.
Since configure only remembers values for the current request, you will
need to store any modified configuration information if you want to
use it in subsequent requests::

    // 保存当前配置在 'default' 缓存的 'user_1234' 键中。
    // Store the current configuration in the 'user_1234' key in the 'default' cache.
    Configure::store('user_1234', 'default');

保存的配置数据持久化在 :php:class:`Cache` 类中。这让你可以把配置信息保存在任何可以与 :php:class:`Cache` 类交互的存储引擎中。

Stored configuration data is persisted in the :php:class:`Cache` class. This allows
you to store Configuration information in any storage engine that :php:class:`Cache` can talk to.

恢复运行时配置
--------------

Restoring runtime configuration
-------------------------------

.. php:staticmethod:: restore($name, $cacheConfig = 'default')

    :param string $name: 要加载的存储键。The storage key to load.
    :param string $cacheConfig: 要加载数据的源的缓存配置。The cache configuration to load the data from.

一旦保存了运行时配置，很可能需要恢复它，从而可以再次访问。``Configure::restore()`` 方法就是做这件事情的::

Once you've stored runtime configuration, you'll probably need to restore it
so you can access it again. ``Configure::restore()`` does exactly that::

    // 从缓存恢复运行时配置。
    // restore runtime configuration from the cache.
    Configure::restore('user_1234', 'default');

在恢复配置信息时，重要的是要使用保存时使用的相同的键和缓存配置来恢复。恢复的信息会合并到现有运行时配置上。

When restoring configuration information it's important to restore it with
the same key, and cache configuration as was used to store it. Restored
information is merged on top of the existing runtime configuration.

创建自己的配置读取器
====================

Creating your own Configuration readers
=======================================

既然配置读取器是 CakePHP 可以扩展的部分，就可以在应用程序和插件中创建配置读取器。配置读取器需要实现 :php:interface:`ConfigReaderInterface` 接口。该接口定义了 read 方法为唯一必需的方法。如果你真的喜欢 XML 文件，你可以为应用程序创建一个简单的 Xml 配置读取器::

Since configuration readers are an extensible part of CakePHP,
you can create configuration readers in your application and plugins.
Configuration readers need to implement the :php:interface:`ConfigReaderInterface`.
This interface defines a read method, as the only required method.
If you really like XML files, you could create a simple Xml config
reader for you application::

    // 在 app/Lib/Configure/MyXmlReader.php 中
    // in app/Lib/Configure/MyXmlReader.php
    App::uses('Xml', 'Utility');
    class MyXmlReader implements ConfigReaderInterface {
        public function __construct($path = null) {
            if (!$path) {
                $path = APP . 'Config' . DS;
            }
            $this->_path = $path;
        }

        public function read($key) {
            $xml = Xml::build($this->_path . $key . '.xml');
            return Xml::toArray($xml);
        }

        // 在 2.3 版本中，还要求 dump() 方法
        // As of 2.3 a dump() method is also required
        public function dump($key, $data) {
            // 保存数据到文件的代码
            // code to dump data to file
        }
    }

在 ``app/Config/bootstrap.php`` 中可以附加这个读取器并使用它::

In your ``app/Config/bootstrap.php`` you could attach this reader and use it::

    App::uses('MyXmlReader', 'Configure');
    Configure::config('xml', new MyXmlReader());
    ...

    Configure::load('my_xml');

.. warning::

        把自定义配置类叫做 ``XmlReader``，可不是个好主意，因为这个类名已经是 PHP 内部的一个类了：
        `XMLReader <http://php.net/manual/en/book.xmlreader.php>`_

        It is not a good idea to call your custom configure class ``XmlReader`` because that
        class name is an internal PHP one already:
        `XMLReader <http://php.net/manual/en/book.xmlreader.php>`_

配置读取器的 ``read()`` 方法必需返回一个名为 ``$key`` 的资源包含的配置信息数组。

The ``read()`` method of a config reader, must return an array of the configuration information
that the resource named ``$key`` contains.

.. php:interface:: ConfigReaderInterface

    定义读取配置数据和在 :php:class:`Configure` 类中保存配置数据的类使用的接口。

    Defines the interface used by classes that read configuration data and
    store it in :php:class:`Configure`

.. php:method:: read($key)

    :param string $key: The key name or identifier to load.

    This method should load/parse the configuration data identified by ``$key``
    and return an array of data in the file.

.. php:method:: dump($key)

    :param string $key: 要写入的标识符。The identifier to write to.
    :param array $data: 要保存的数据。The data to dump.

    这个方法把提供的配置数据保存到 ``$key`` 所指定的键中。

    This method should dump/store the provided configuration data to a key identified by ``$key``.

.. versionadded:: 2.3
    在 2.3 版本中增加了 ``ConfigReaderInterface::dump()`` 方法。
    ``ConfigReaderInterface::dump()`` was added in 2.3.

.. php:exception:: ConfigureException

    在加载/保存/恢复配置数据时，当发生错误时抛出。:php:interface:`ConfigReaderInterface` 接口的实现在遇到错误时应当抛出这个异常。

    Thrown when errors occur when loading/storing/restoring configuration data.
    :php:interface:`ConfigReaderInterface` implementations should throw this
    error when they encounter an error.

内置配置读取器
--------------

Built-in Configuration readers
------------------------------

.. php:class:: PhpReader

    让你可以读取配保存为普通 PHP 文件的配置文件。你可以从 ``app/Config`` 目录中读取，也可以用 :term:`plugin syntax` 从插件配置目录中读取。文件 **必须** 包含 ``$config`` 变量。下面是一个配置文件示例::

    Allows you to read configuration files that are stored as plain PHP files.
    You can read either files from your ``app/Config`` or from plugin configs
    directories by using :term:`plugin syntax`. Files **must** contain a ``$config``
    variable. An example configuration file would look like::

        $config = array(
            'debug' => 0,
            'Security' => array(
                'salt' => 'its-secret'
            ),
            'Exception' => array(
                'handler' => 'ErrorHandler::handleException',
                'renderer' => 'ExceptionRenderer',
                'log' => true
            )
        );

    没有 ``$config`` 将会导致 :php:exc:`ConfigureException`。

    Files without ``$config`` will cause an :php:exc:`ConfigureException`

    在 app/Config/bootstrap.php 中插入如下代码来加载自定义配置文件：

    Load your custom configuration file by inserting the following in app/Config/bootstrap.php:

        Configure::load('customConfig');

.. php:class:: IniReader

    让你可以读取配保存为普通 .ini 文件的配置文件。ini 文件必须与 PHP 的 ``parse_ini_file`` 函数兼容，并且可以受益于如下改进

    * 点分隔的值会扩展为数组。
    * 象 'on' 和 'off' 这样的类似布尔类型的值会转化为布尔值。

    Allows you to read configuration files that are stored as plain .ini files.
    The ini files must be compatible with php's ``parse_ini_file`` function, and
    benefit from the following improvements

    * dot separated values are expanded into arrays.
    * boolean-ish values like 'on' and 'off' are converted to booleans.

    下面是一个 ini 文件示例::

    An example ini file would look like::

        debug = 0

        Security.salt = its-secret

        [Exception]
        handler = ErrorHandler::handleException
        renderer = ExceptionRenderer
        log = true

    上述 ini 文件会得到与之前的 PHP 示例相同的最终配置数据。数组结构可以通过点分隔的值或者小节创建。小节可以包含点分隔的值来实现更深的嵌套。

    The above ini file, would result in the same end configuration data
    as the PHP example above. Array structures can be created either
    through dot separated values, or sections. Sections can contain
    dot separated keys for deeper nesting.

.. _inflection-configuration:

词形变化配置
============

Inflection Configuration
========================

CakePHP 的命名约定真的很好 —— 你可以把数据库表命名为 big\_boxes，把模型命名为 BigBox，把控制器命名为 BigBoxesController，所有这一切就可以自动在一起运作。CakePHP 知道如何把这些联结在一起，是通过单词的单数和复数形式之间的词形变化。

CakePHP's naming conventions can be really nice - you can name your
database table big\_boxes, your model BigBox, your controller
BigBoxesController, and everything just works together
automatically. The way CakePHP knows how to tie things together is
by *inflecting* the words between their singular and plural forms.

偶尔(特别是对我们操非英语的朋友们)，你会遇到 CakePHP 的 :php:class:`Inflector` 类(把单词变成复数形式、单数形式、驼峰命名形式和下划线分隔形式的类)不像你希望的那样进行词形变化。如果 CakePHP 认不出你的 Foci 或者 Fish，你可以告诉 CakePHP 这些特殊情形。

There are occasions (especially for our non-English speaking
friends) where you may run into situations where CakePHP's
:php:class:`Inflector` (the class that pluralizes, singularizes, camelCases, and
under\_scores) might not work as you'd like. If CakePHP won't
recognize your Foci or Fish, you can tell CakePHP about your
special cases.

加载自定义词形变化
------------------

Loading custom inflections
--------------------------

你可以在 ``app/Config/bootstrap.php`` 文件中用 :php:meth:`Inflector::rules()` 方法加载自定义词形变化::

You can use :php:meth:`Inflector::rules()` in the file
``app/Config/bootstrap.php`` to load custom inflections::

    Inflector::rules('singular', array(
        'rules' => array(
            '/^(bil)er$/i' => '\1',
            '/^(inflec|contribu)tors$/i' => '\1ta'
        ),
        'uninflected' => array('singulars'),
        'irregular' => array('spins' => 'spinor')
    ));

或者::

or::

    Inflector::rules('plural', array('irregular' => array('phylum' => 'phyla')));

会把提供的规则合并到 lib/Cake/Utility/Inflector.php 中定义的词形变化集合中，新增的规则具有比核心规则更高的优先级。

Will merge the supplied rules into the inflection sets defined in
lib/Cake/Utility/Inflector.php, with the added rules taking precedence
over the core rules.

引导启动 CakePHP
================

Bootstrapping CakePHP
=====================

如果有任何额外的配置需求，可以使用 CakePHP 位于 app/Config/bootstrap.php 的引导文件。这个文件会在 CakePHP 的核心启动引导后执行。

If you have any additional configuration needs, use CakePHP's
bootstrap file, found in app/Config/bootstrap.php. This file is
executed just after CakePHP's core bootstrapping.

此文件非常适合用于一些常见的启动任务：

This file is ideal for a number of common bootstrapping tasks:

- 定义方便的函数。
- 注册全局常量。
- 定义额外的模型、视图和控制器路径。
- 创建缓存配置。
- 配置词形变化。
- 加载配置文件。

- Defining convenience functions.
- Registering global constants.
- Defining additional model, view, and controller paths.
- Creating cache configurations.
- Configuring inflections.
- Loading configuration files.

当向引导文件添加内容时请注意保持 MVC 的软件设计模式：也许会忍不住想把格式化函数放在那里，从而可以在控制器中使用。

Be careful to maintain the MVC software design pattern when you add
things to the bootstrap file: it might be tempting to place
formatting functions there in order to use them in your
controllers.

请忍住这种想法。以后你会庆幸你在程序后面的部分这么做的。

Resist the urge. You'll be glad you did later on down the line.

你可能考虑到也可以将代码放到 :php:class:`AppController` 类中。这个类是应用程序中所有控制器的
父类。:php:class:`AppController` 是一个方便的地方，来使用控制器回调，以及定义供所有控制器使用的方法。

You might also consider placing things in the :php:class:`AppController` class.
This class is a parent class to all of the controllers in your
application. :php:class:`AppController` is a handy place to use controller
callbacks and define methods to be used by all of your
controllers.


.. meta::
    :title lang=zh_CN: Configuration
    :keywords lang=zh_CN: finished configuration,legacy database,database configuration,value pairs,default connection,optional configuration,example database,php class,configuration database,default database,configuration steps,index database,configuration details,class database,host localhost,inflections,key value,database connection,piece of cake,basic web
