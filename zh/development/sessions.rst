会话
########

CakePHP 在 PHP 的 ``session`` 扩展之上，提供了封装和一套工具。会话(*session*)让你可以跨多个请求辨识用户，为特定用户持续存储数据。跟 Cookies 不同，会话无法在客户端使用。通常在 CakePHP 中应当避免使用 ``$_SESSION``，而最好使用 Session 类。

CakePHP provides a wrapper and suite of utility features on top of PHP's native
``session`` extension. Sessions allow you to identify unique users across the
requests and store persistent data for specific users. Unlike Cookies, session
data is not available on the client side. Usage of ``$_SESSION`` is generally
avoided in CakePHP, and instead usage of the Session classes is preferred.


会话的配置
=====================

Session Configuration
=====================

会话的配置保存在 ``Configure`` 中,位于顶级的 ``Session`` 键之下，有一些选项可用：

Session configuration is stored in ``Configure`` under the top
level ``Session`` key, and a number of options are available:

* ``Session.cookie`` — 改变 session cookie 的名字。

* ``Session.cookie`` - Change the name of the session cookie.

* ``Session.timeout`` — *分钟* 数，之后 CakePHP 的会话处理器会让会话过期。这会影响到 ``Session.autoRegenerate`` (见下)，是由 CakeSession 类处理的。

* ``Session.timeout`` - The number of *minutes* before CakePHP's session handler expires the session.
  This affects ``Session.autoRegenerate`` (below), and is handled by CakeSession.

* ``Session.cookieTimeout`` — *分钟* 数，之后 session cookie 会过期。如果没有定义，会使用和 ``Session.timeout`` 同样的值。这会影响到 session cookie，是由 PHP 本身处理的。

* ``Session.cookieTimeout`` — The number of *minutes* before the session cookie expires.
  If this is undefined, it will use the same value as ``Session.timeout``.
  This affects the session cookie, and is handled by PHP itself.

* ``Session.checkAgent`` - 是否应当对每个请求查看用户代理。如果用户代理不匹配，会话就会被销毁。Should the user agent be checked, on each request. If
  the user agent does not match the session will be destroyed.

* ``Session.autoRegenerate`` - 开启该设置，就会打开会话的自动更新，导致频繁变化的会话标识(id)。开启该值，会使用会话的 ``Config.countdown`` 值来跟踪请求。一旦倒计数达到 0，会话标识(id)就会重新生成。对于由于安全原因而需要频繁改变会话标识的应用程序，这是很好的选项。你可以通过改变 :php:attr:`CakeSession::$requestCountdown` 来控制重新生成会话所需要的请求数。Enabling this setting, turns on automatic
  renewal of sessions, and session ids that change frequently. Enabling this
  value will use the session's ``Config.。countdown`` value to keep track of requests.
  Once the countdown reaches 0, the session id will be regenerated. This is a
  good option to use for applications that need frequently
  changing session ids for security reasons. You can control the number of requests
  needed to regenerate the session by modifying :php:attr:`CakeSession::$requestCountdown`.

* ``Session.defaults`` - 让你可以使用内置默认会话配置之一作为会话配置的基础。Allows you to use one the built-in default session
  configurations as a base for your session configuration.

* ``Session.handler`` - 让你定义自定义会话处理器。核心数据库和缓存会话处理器使用该选项。这个选项代替了旧版本的 ``Session.save``。后面有会话处理器的更多信息。Allows you to define a custom session handler. The core
  database and cache session handlers use this. This option replaces
  ``Session.save`` in previous versions. See below for additional information on
  Session handlers.

* ``Session.ini`` - 让你可以设置配置的额外会话的 ini 设置。这和 ``Session.handler`` 一起代替了旧版本的自定义会话处理功能。Allows you to set additional session ini settings for your
  config. This combined with ``Session.handler`` replace the custom session
  handling features of previous versions

当应用程序使用 SSL协议时，CakePHP 默认设置 ``session.cookie_secure`` 为 true。如果应用程序同时使用 SSL 和非 SSL 协议，你也许会有会话丢失的问题。如果你要在  SSL 和非 SSL 域中访问会话，就应该关闭这个::

CakePHP's defaults to setting ``session.cookie_secure`` to true, when your
application is on an SSL protocol. If your application serves from both SSL and
non-SSL protocols, then you might have problems with sessions being lost. If
you need access to the session on both SSL and non-SSL domains you will want to
disable this::

    Configure::write('Session', array(
        'defaults' => 'php',
        'ini' => array(
            'session.cookie_secure' => false
        )
    ));

在 2.0 版本中，Session cookie 路径默认是 ``/``，要改变它，可以设置 ``session.cookie_path``
ini 标识为应用程序的目录路径::

Session cookie paths default to ``/`` in 2.0, to change this you can use the
``session.cookie_path`` ini flag to the directory path of your application::

    Configure::write('Session', array(
        'defaults' => 'php',
        'ini' => array(
            'session.cookie_path' => '/app/dir'
        )
    ));

内置会话处理器和配置
=========================================

Built-in Session handlers & configuration
=========================================

CakePHP 提供几个内置的会话配置。你可以用这些作为配置的基础，也可以创建完全自定义配置。要使用默认配置，只需把'defaults' 键设置为你要使用的默认配置的名称。然后你就可以在会话配置中声明它来覆盖任何子设置::

CakePHP comes with several built-in session configurations. You can either use
these as the basis for your session configuration, or you can create a fully
custom solution. To use defaults, simply set the 'defaults' key to the name of
the default you want to use. You can then override any sub setting by declaring
it in your Session config::

    Configure::write('Session', array(
        'defaults' => 'php'
    ));

上面的代码使用内置的 'php' 会话配置。你象下面增强部分或全部配置::

The above will use the built-in 'php' session configuration. You could augment
part or all of it by doing the following::


    Configure::write('Session', array(
        'defaults' => 'php',
        'cookie' => 'my_app',
        'timeout' => 4320 //3 天 3 days
    ));

上面的代码会覆盖 'php' 会话配置的 timeout 和 cookie 的名称。内置的配置如下：

The above overrides the timeout and cookie name for the 'php' session
configuration. The built-in configurations are:

* ``php`` - 以 php.ini 文件中的标准设置保存会话。Saves sessions with the standard settings in your php.ini file.
* ``cake`` - 保存会话为 ``app/tmp/sessions`` 目录中的文件。当所在的主机不允许你写到你的用户目录之外时，这是很好的选项。Saves sessions as files inside ``app/tmp/sessions``. This is a
  good option when on hosts that don't allow you to write outside your own home
  dir.
* ``database`` - 使用内置的数据库会话。欲知详情，请参看后面的部分。Use the built-in database sessions. See below for more information.
* ``cache`` - 使用内置的缓存会话。欲知详情，请参看后面的部分。Use the built-in cache sessions. See below for more information.

会话处理器
------------

Session Handlers
----------------

会话处理器也可以定义在会话配置数组中。定义之后，它们让你可以把各种 ``session_save_handler`` 值映射到你要用于保存会话的类或对象。有两种方式使用'处理器'。第一种是提供含有 5 个 callable 的数组。然后这些 callable 应用于 ``session_set_save_handler``::

Session handlers can also be defined in the session config array. When defined
they allow you to map the various ``session_save_handler`` values to a class or
object you want to use for session saving. There are two ways to use the
'handler'. The first is to provide an array with 5 callables. These callables
are then applied to ``session_set_save_handler``::

    Configure::write('Session', array(
        'userAgent' => false,
        'cookie' => 'my_cookie',
        'timeout' => 600,
        'handler' => array(
            array('Foo', 'open'),
            array('Foo', 'close'),
            array('Foo', 'read'),
            array('Foo', 'write'),
            array('Foo', 'destroy'),
            array('Foo', 'gc'),
        ),
        'ini' => array(
            'cookie_secure' => 1,
            'use_trans_sid' => 0
        )
    ));

第二种模式是定义一个 'engine' 键。该键应当是一个实现了 ``CakeSessionHandlerInterface`` 接口的类的名称。实现该接口让 CakeSession 可以自动为处理器映射方法。缓存(*Cache*)和数据库(*Database*)会话的处理器都使用这种方法来保存会话。处理器的额外设置应当放在处理器数组内。你可以在处理器内读出这些值。

The second mode is to define an 'engine' key. This key should be a class name
that implements ``CakeSessionHandlerInterface``. Implementing this interface
will allow CakeSession to automatically map the methods for the handler. Both
the core Cache and Database session handlers use this method for saving
sessions. Additional settings for the handler should be placed inside the
handler array. You can then read those values out from inside your handler.

你也可以在插件内使用会话处理器。只需把引擎设置为类似 ``MyPlugin.PluginSessionHandler`` 这样。这会加载和使用应用程序中 MyPlugin 插件内的 ``PluginSessionHandler`` 类。

You can also use session handlers from inside plugins. By setting the engine to
something like ``MyPlugin.PluginSessionHandler``. This will load and use the
``PluginSessionHandler`` class from inside the MyPlugin of your application.


CakeSessionHandlerInterface 接口
--------------------------------

该接口用于 CakePHP 中所有的自定义会话处理器，而且可以用来创建自定义的用户会话处理器。只需在类中实现该接口，并设置创建的类名为 ``Session.handler.engine``。CakePHP 会尝试从 ``app/Model/Datasource/Session/$classname.php`` 内加载处理器。所以如果类名为 ``AppSessionHandler``，文件就应当是 ``app/Model/Datasource/Session/AppSessionHandler.php``。

This interface is used for all custom session handlers inside CakePHP, and can
be used to create custom user land session handlers. Simply implement the
interface in your class and set ``Session.handler.engine``  to the class name
you've created. CakePHP will attempt to load the handler from inside
``app/Model/Datasource/Session/$classname.php``. So if your class name is
``AppSessionHandler`` the file should be
``app/Model/Datasource/Session/AppSessionHandler.php``.

数据库会话
----------

Database sessions
-----------------

会话配置的改动改变了如何定义数据库会话。大多数情况下只需在配置中设置 ``Session.handler.model``，以及选择数据库默认值::

The changes in session configuration change how you define database sessions.
Most of the time you will only need to set ``Session.handler.model`` in your
configuration as well as choose the database defaults::


    Configure::write('Session', array(
        'defaults' => 'database',
        'handler' => array(
            'model' => 'CustomSession'
        )
    ));

以上代码会告诉 CakeSession 使用内置的 'database' 默认值，并且指定叫做 ``CustomSession`` 的模型负责保存会话信息到数据库中。

The above will tell CakeSession to use the built-in 'database' defaults, and
specify that a model called ``CustomSession`` will be the delegate for saving
session information to the database.

如果你不需要完全自定义的处理器，但是仍然要求以数据库为基础保存会话，可以简化上述代码为::

If you do not need a fully custom session handler, but still require
database-backed session storage, you can simplify the above code to::

    Configure::write('Session', array(
        'defaults' => 'database'
    ));

这样的配置会要求增加一个数据库表，含有至少这些字段::

This configuration will require a database table to be added with
at least these fields::

    CREATE TABLE `cake_sessions` (
      `id` varchar(255) NOT NULL DEFAULT '',
      `data` text,
      `expires` int(11) DEFAULT NULL,
      PRIMARY KEY (`id`)
    );

你也可以使用 schema 外壳用默认应用程序骨架中提供的数据结构文件来创建该表::

You can also use the schema shell to create this table using the schema file
provided in the default app skeleton::

    $ Console/cake schema create sessions

缓存会话
-----------

Cache Sessions
--------------

Cache 类也可以用来保存会话。这让你可以把会话保存在象 APC、memcache 或者 Xcache 这样的缓存中，因此如果用光了缓存的容量，随着记录被清理，会话就会开始过期。

The Cache class can be used to store sessions as well. This allows you to store
sessions in a cache like APC, memcache, or Xcache. There are some caveats to
using cache sessions, in that if you exhaust the cache space, sessions will
start to expire as records are evicted.

要使用基于缓存的会话，可以这样配置会话::

To use Cache based sessions you can configure you Session config like::

    Configure::write('Session', array(
        'defaults' => 'cache',
        'handler' => array(
            'config' => 'session'
        )
    ));

这会配置 CakeSession 使用 ``CacheSession`` 类负责保存会话。可以用 'config' 指定使用哪个缓存配置。默认的缓存配置为 ``'default'``。

This will configure CakeSession to use the ``CacheSession`` class as the
delegate for saving the sessions. You can use the 'config' key to specify which cache
configuration to use. The default cache configuration is ``'default'``.

Setting ini directives
======================

The built-in defaults attempt to provide a common base for session
configuration. You may need to tweak specific ini flags as well. CakePHP
exposes the ability to customize the ini settings for both default
configurations, as well as custom ones. The ``ini`` key in the session settings,
allows you to specify individual configuration values. For example you can use
it to control settings like ``session.gc_divisor``::

    Configure::write('Session', array(
        'defaults' => 'php',
        'ini' => array(
            'session.gc_divisor' => 1000,
            'session.cookie_httponly' => true
        )
    ));


Creating a custom session handler
=================================

Creating a custom session handler is straightforward in CakePHP. In this
example we'll create a session handler that stores sessions both in the Cache
(apc) and the database. This gives us the best of fast IO of apc,
without having to worry about sessions evaporating when the cache fills up.

First we'll need to create our custom class and put it in
``app/Model/Datasource/Session/ComboSession.php``. The class should look
something like::

    App::uses('DatabaseSession', 'Model/Datasource/Session');

    class ComboSession extends DatabaseSession implements CakeSessionHandlerInterface {
        public $cacheKey;

        public function __construct() {
            $this->cacheKey = Configure::read('Session.handler.cache');
            parent::__construct();
        }

        // read data from the session.
        public function read($id) {
            $result = Cache::read($id, $this->cacheKey);
            if ($result) {
                return $result;
            }
            return parent::read($id);
        }

        // write data into the session.
        public function write($id, $data) {
            Cache::write($id, $data, $this->cacheKey);
            return parent::write($id, $data);
        }

        // destroy a session.
        public function destroy($id) {
            Cache::delete($id, $this->cacheKey);
            return parent::destroy($id);
        }

        // removes expired sessions.
        public function gc($expires = null) {
            return Cache::gc($this->cacheKey) && parent::gc($expires);
        }
    }

Our class extends the built-in ``DatabaseSession`` so we don't have to duplicate
all of its logic and behavior. We wrap each operation with a :php:class:`Cache`
operation. This lets us fetch sessions from the fast cache, and not have to
worry about what happens when we fill the cache. Using this session handler is
also easy. In your ``core.php`` make the session block look like the following::

    Configure::write('Session', array(
        'defaults' => 'database',
        'handler' => array(
            'engine' => 'ComboSession',
            'model' => 'Session',
            'cache' => 'apc'
        )
    ));

    // Make sure to add a apc cache config
    Cache::config('apc', array('engine' => 'Apc'));

Now our application will start using our custom session handler for reading &
writing session data.


.. php:class:: CakeSession

Reading & writing session data
==============================

Depending on the context you are in, your application has different classes
that provide access to the session. In controllers you can use
:php:class:`SessionComponent`. In the view, you can use
:php:class:`SessionHelper`. In any part of your application you can use
``CakeSession`` to access the session as well. Like the other interfaces to the
session, ``CakeSession`` provides a simple CRUD interface.

.. php:staticmethod:: read($key)

You can read values from the session using :php:meth:`Set::classicExtract()`
compatible syntax::

    CakeSession::read('Config.language');

.. php:staticmethod:: write($key, $value)

``$key`` should be the dot separated path you wish to write ``$value`` to::

    CakeSession::write('Config.language', 'eng');

.. php:staticmethod:: delete($key)

When you need to delete data from the session, you can use delete::

    CakeSession::delete('Config.language');

You should also see the documentation on
:doc:`/core-libraries/components/sessions` and
:doc:`/core-libraries/helpers/session` for how to access Session data
in the controller and view.


.. meta::
    :title lang=zh_CN: Sessions
    :keywords lang=zh_CN: session defaults,session classes,utility features,session timeout,session ids,persistent data,session key,session cookie,session data,last session,core database,security level,useragent,security reasons,session id,attr,countdown,regeneration,sessions,config
