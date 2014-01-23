缓存
Caching
#######

缓存经常用来减少创建或读取其它资源的时间。缓存经常用来使读取昂贵的资源不那么昂贵。你可以容易地把不经常变化的昂贵的查询、或者对远程网络服务的访问的结果，保存在缓存中。一旦在缓存中，从缓存中重新读取保存的资源就比访问远程资源代价要小多了。
Caching is frequently used to reduce the time it takes to create or read from
other resources.  Caching is often used to make reading from expensive
resources less expensive.  You can easily store the results of expensive queries,
or remote webservice access that doesn't frequently change in a cache.  Once
in the cache, re-reading the stored resource from the cache is much cheaper
than accessing the remote resource.

CakePHP 中的缓存主要是由:php:class:`Cache`类来协助(处理)的。该类有了一组静态方法，提供了统一的 API 来处理不同类型的缓存实现。CakePHP 带有几个内置的缓存引擎，并提供了简单的系统来实现你自己的缓存系统。内置的缓存引擎有:
Caching in CakePHP is primarily facilitated by the :php:class:`Cache` class.
This class provides a set of static methods that provide a uniform API to
dealing with all different types of Caching implementations.  CakePHP
comes with several cache engines built-in, and provides an easy system
to implement your own caching systems. The built-in caching engines are:

* ``FileCache`` 文件缓存是使用本地文件的简单缓存。它是最慢的缓存引擎，且没有为原子化操作提供很多特性。不过，既然硬盘存储通常都相当便宜，使用文件存储大的对象、或者不经常写的元素，很管用。这是2.3+版本的缺省缓存引擎。 File cache is a simple cache that uses local files. It
  is the slowest cache engine, and doesn't provide as many features for
  atomic operations.  However, since disk storage is often quite cheap,
  storing large objects, or elements that are infrequently written
  work well in files. This is the default Cache engine for 2.3+
* ``ApcCache`` APC 缓存使用 PHP 的`APC <http://php.net/apc>`_扩展。 APC cache uses the PHP `APC <http://php.net/apc>`_ extension.
  这个扩展用网站服务器上的共享内存来保存对象。
  This extension uses shared memory on the webserver to store objects.
  这使它非常快，而且能够提供原子化的读/写特性。
  This makes it very fast, and able to provide atomic read/write features.
  缺省情况下 CakePHP 2.0-2.2 会使用该缓存引擎，如果可用的话。
  By default CakePHP in 2.0-2.2 will use this cache engine if it's available.
* ``Wincache`` Wincache 使用`Wincache <http://php.net/wincache>`_扩展。Wincache 在特性和性能上类似于 APC，但针对 Windows 和 IIS 做了优化。 Wincache uses the `Wincache <http://php.net/wincache>`_
  extension.  Wincache is similar to APC in features and performance, but
  optimized for Windows and IIS.
* ``XcacheEngine`` `Xcache <http://xcache.lighttpd.net/>`_是一个 PHP 扩展，提供类似 APC 的特性。 `Xcache <http://xcache.lighttpd.net/>`_
  is a PHP extension that provides similar features to APC.
* ``MemcacheEngine`` 使用`Memcache <http://php.net/memcache>`_扩展。Memcache 提供了非常快速的缓存系统，可以分布于多台服务器，而且提供原子化操作。 Uses the `Memcache <http://php.net/memcache>`_
  extension.  Memcache provides a very fast cache system that can be
  distributed across many servers, and provides atomic operations.
* ``RedisEngine`` 使用`phpredis <https://github.com/nicolasff/phpredis>`_扩展。Redis 类似于 memcached，提供了快速和可持久化的缓存系统，也提供原子化操作。 Uses the `phpredis <https://github.com/nicolasff/phpredis>`_
  extension. Redis provides a fast and persistent cache system similar to
  memcached, also provides atomic operations.

.. versionchanged:: 2.3
    FileEngine 总是缺省的缓存引擎。曾经一些人在 cli + web 两种环境中，遇到困难而无法正确设置和部署 APC。
    FileEngine is always the default cache engine.  In the past a number of people
    had difficulty setting up and deploying APC correctly both in cli + web.
    使用文件(缓存)，使得配置 CakePHP 对新的开发人员来说更简单了。
    Using files should make setting up CakePHP simpler for new developers.

不论你选择使用哪种缓存引擎，你的应用程序与:php:class:`Cache`以一致的方式交互。这意味着你可以随着应用程序的增长而容易地替换缓存引擎。除了:php:class:`Cache`类，:doc:`/core-libraries/helpers/cache`允许整个页面的缓存，这也极大地改善了性能。
Regardless of the CacheEngine you choose to use, your application interacts with
:php:class:`Cache` in a consistent manner.  This means you can easily swap cache engines
as your application grows. In addition to the :php:class:`Cache` class, the
:doc:`/core-libraries/helpers/cache` allows for full page caching, which
can greatly improve performance as well.


配置 Cache 类
Configuring Cache class
=======================

配置 Cache 类可以在任何地方进行，但通常你会在``app/Config/bootstrap.php``中配置 Cache 类。你可以设置任意数量的缓存配置，使用任意缓存引擎的组合。在内部，CakePHP 使用两个缓存配置，这两个配置在``app/Config/core.php``中设置。如果你使用 APC 或者 Memcache，你一定要为核心缓存设置唯一的键。这会防止多个应用程序互相覆盖缓存的数据。
Configuring the Cache class can be done anywhere, but generally
you will want to configure Cache in ``app/Config/bootstrap.php``.  You
can configure as many cache configurations as you need, and use any
mixture of cache engines.  CakePHP uses two cache configurations internally,
which are configured in ``app/Config/core.php``. If you are using APC or
Memcache you should make sure to set unique keys for the core caches.  This will
prevent multiple applications from overwriting each other's cached data.

使用多个缓存配置可以帮助减少你需要调用:php:func:`Cache::set()`的次数，同时集中所有的缓存设置。使用多个配置也让你按照需求逐步改变存储。
Using multiple cache configurations can help reduce the
number of times you need to use :php:func:`Cache::set()` as well as
centralize all your cache settings.  Using multiple configurations
also lets you incrementally change the storage as needed.

.. note::

    你必须指定使用的引擎。它**不**会使用文件(缓存)为缺省值。
    You must specify which engine to use. It does **not** default to
    File.

例如:: Example::

    Cache::config('short', array(
        'engine' => 'File',
        'duration' => '+1 hours',
        'path' => CACHE,
        'prefix' => 'cake_short_'
    ));

    // 长期 long
    Cache::config('long', array(
        'engine' => 'File',
        'duration' => '+1 week',
        'probability' => 100,
        'path' => CACHE . 'long' . DS,
    ));

把上面的代码放在``app/Config/bootstrap.php``中，你就多了两个缓存配置。这两个配置的名称'short'或'long'会作为:php:func:`Cache::write()`和:php:func:`Cache::read()`方法的``$config``参数。
By placing the above code in your ``app/Config/bootstrap.php`` you will
have two additional Cache configurations. The name of these
configurations 'short' or 'long' is used as the ``$config``
parameter for :php:func:`Cache::write()` and :php:func:`Cache::read()`.

.. note::

    当使用文件引擎时，你也许要使用``mask``选项，来保证创建的缓存文件有正确的权限。
    When using the FileEngine you might need to use the ``mask`` option to
    ensure cache files are made with the correct permissions.

为缓存创建存储引擎
Creating a storage engine for Cache
===================================

你可以在``app/Lib``以及在插件的``$plugin/Lib``中提供定制的``Cache``适配器。App/插件的缓存引擎也会覆盖核心的引擎。缓存适配器必须在 cahe 目录中。如果你有一个叫作``MyCustomCacheEngine``的缓存引擎，它就会被放在``app/Lib/Cache/Engine/MyCustomCacheEngine.php``作为 app/libs，或者在``$plugin/Lib/Cache/Engine/MyCustomCacheEngine.php``作为插件的一部分。插件的缓存配置需要使用插件的点语法。::
You can provide custom ``Cache`` adapters in ``app/Lib`` as well
as in plugins using ``$plugin/Lib``. App/plugin cache engines can
also override the core engines. Cache adapters must be in a cahe
directory. If you had a cache engine named ``MyCustomCacheEngine``
it would be placed in either ``app/Lib/Cache/Engine/MyCustomCacheEngine.php``
as an app/libs or in ``$plugin/Lib/Cache/Engine/MyCustomCacheEngine.php`` as
part of a plugin. Cache configs from plugins need to use the plugin
dot syntax.::

    Cache::config('custom', array(
        'engine' => 'CachePack.MyCustomCache',
        // ...
    ));

.. note::

    App 和插件的缓存引擎应当在``app/Config/bootstrap.php``中配置。如果你试图在 core.php 中配置，它们不会正常工作。
    App and Plugin cache engines should be configured in
    ``app/Config/bootstrap.php``. If you try to configure them in core.php
    they will not work correctly.

定制的缓存引擎必须扩展:php:class:`CacheEngine`，这个类定义了一些抽象的方法，以及提供了一些初始化方法。
Custom Cache engines must extend :php:class:`CacheEngine` which defines
a number of abstract methods as well as provides a few initialization
methods.

CacheEngine 必需的 API 有
The required API for a CacheEngine is

.. php:class:: CacheEngine

    缓存使用的所有缓存引擎的基类。
    The base class for all cache engines used with Cache.

.. php:method:: write($key, $value, $config = 'default')

    :return: 成功与否的布尔值。boolean for success.

    将一个键的值写入缓存，可省略的字符串 $cofig 指定要写入的(缓存)配置名称。
    Write value for a key into cache, optional string $config
    specifies configuration name to write to.

.. php:method:: read($key)

    :return: 缓存的值，或者在失败时为 false。 The cached value or false for failure.

    从缓存读取一个键。返回 false 表明该项已失效或者不存在。
    Read a key from the cache.  Return false to indicate
    the entry has expired or does not exist.

.. php:method:: delete($key)

    :return: 成功时为布尔值 true。 Boolean true on success.

    从缓存中删除一个键。返回 false，表明该项不存在或者无法删除。
    Delete a key from the cache. Return false to indicate that
    the entry did not exist or could not be deleted.

.. php:method:: clear($check)

    :return: 成功时为布尔值 true。 Boolean true on success.

    从缓存删除所有键。如果 $check 为 true，你应当验证每个值实际上已经过期。
    Delete all keys from the cache.  If $check is true, you should
    validate that each value is actually expired.

.. php:method:: clearGroup($group)

    :return: 成功时为布尔值 true。 Boolean true on success.

    从缓存删除所有属于同一组的键。
    Delete all keys from the cache belonging to the same group.

.. php:method:: decrement($key, $offset = 1)

    :return: 成功时为布尔值 true。 Boolean true on success.

    把键对应的数字减一，并返回减一后的值。
    Decrement a number under the key and return decremented value

.. php:method:: increment($key, $offset = 1)

    :return: 成功时为布尔值 true。 Boolean true on success.

    把键对应的数字增一，并返回增一后的值。
    Increment a number under the key and return incremented value

.. php:method:: gc()

    不要求，但在资源失效时用于清理。
    Not required, but used to do clean up when resources expire.
    文件引擎用它来删除包含过期内容的文件。
    FileEngine uses this to delete files containing expired content.


用缓存来存储一般的查询结果
Using Cache to store common query results
=========================================

你可以把不经常变化的结果、或者被大量读取的结果放入缓存。一个绝佳的例子是从:php:meth:`Model::find()`返回的结果。一个用缓存保存结果的方法可以象下面这样::
You can greatly improve the performance of your application by putting
results that infrequently change, or that are subject to heavy reads into the
cache. A perfect example of this are the results from :php:meth:`Model::find()`.
A method that uses Cache to store results could look like::

    class Post extends AppModel {

        public function newest() {
            $result = Cache::read('newest_posts', 'longterm');
            if (!$result) {
                $result = $this->find('all', array('order' => 'Post.updated DESC', 'limit' => 10));
               Cache::write('newest_posts', $result, 'longterm');
            }
            return $result;
        }
    }

你可以改进上述代码，把读取缓存的逻辑移到一个行为中，来从缓存读取，或者允许关联模型方法。不过这可以作为你的一个练习。
You could improve the above code by moving the cache reading logic into
a behavior, that read from the cache, or ran the associated model method.
That is an exercise you can do though.


使用缓存保存计数器
Using Cache to store counters
=============================

各种东西的计数器很容易在缓存中保存。例如，一项竞赛中剩余空位的简单倒计数，就可以保存在缓存中。Cache 类提供了简单的原子化的方式增/减计数器的值。原子化操作对这些值很重要，因为这减少了竞争的风险，即两个用户同时把值减一，导致不正确的值。
Counters for various things are easily stored in a cache.  For example, a simple
countdown for remaining 'slots' in a contest could be stored in Cache. The
Cache class exposes atomic ways to increment/decrement counter values in an easy
way.  Atomic operations are important for these values as it reduces the risk of
contention, and ability for two users to simultaneously lower the value by one,
resulting in an incorrect value.

在设置一个整数值之后，你可以用:php:meth:`Cache::increment()`和:php:meth:`Cache::decrement()`来操作它::
After setting an integer value, you can manipulate it using
:php:meth:`Cache::increment()` and :php:meth:`Cache::decrement()`::

    Cache::write('initial_count', 10);

    // 然后 Later on
    Cache::decrement('initial_count');

    // 或者 or
    Cache::increment('initial_count');

.. note::

    增一和减一无法用于文件引擎。你应当使用 APC、Redis 或者 Memcache。
    Incrementing and decrementing do not work with FileEngine. You should use
    APC, Redis or Memcache instead.


使用分组
Using groups
============

.. versionadded:: 2.2

有时你想要把多个缓存项标记为属于某个组或者命名空间。这是一个常见的需求，每当同一组内的所有键共享的某些信息发生变化时，就使这些键无效。这可以通过在缓存配置中声明分组::
Sometimes you will want to mark multiple cache entries to belong to a certain
group or namespace. This is a common requirement for mass-invalidating keys
whenever some information changes that is shared among all entries in the same
group. This is possible by declaring the groups in cache configuration::

    Cache::config('site_home', array(
        'engine' => 'Redis',
        'duration' => '+999 days',
        'groups' => array('comment', 'post')
    ));

比方说，你要把为主页生成的 HTML 保存在缓存中，不过每次当一个评论或帖子添加到数据库中时，又要自动使该缓存无效。增加了分组 ``comment``和``post``之后，在效果上我们就把存入这个缓存配置的任意键标识为这两个组。
Let's say you want to store the HTML generated for your homepage in cache, but
would also want to automatically invalidate this cache every time a comment or
post is added to your database. By adding the groups ``comment`` and ``post``,
we have effectively tagged any key stored into this cache configuration with
both group names.

例如，每添加一个新的帖子，我们可以让缓存引擎删除所有与``post``分组相联系的项::
For instance, whenever a new post is added, we could tell the Cache engine to
remove all entries associated to the ``post`` group::

    // Model/Post.php

    public function afterSave($created) {
        if ($created) {
            Cache::clearGroup('post', 'site_home');
        }
    }

分组是在相同引擎和相同前缀的缓存配置之间共享的。如果你使用分组，并想利用分组删除，就为你所有的(缓存)配置选择一个共用的前缀。
Groups are shared across all cache configs using the same engine and same
prefix. If you are using groups and want to take advantage of group deletion,
choose a common prefix for all your configs.

缓存 API
Cache API
=========

.. php:class:: Cache

    CakePHP 中的 Cache 类提供了针对多个后端缓存系统的一个通用前端。不同的缓存配置和引擎可在 app/Config/core.php 中设置。
    The Cache class in CakePHP provides a generic frontend for several
    backend caching systems. Different Cache configurations and engines
    can be set up in your app/Config/core.php

.. php:staticmethod:: config($name = null, $settings = array())

    ``Cache::config()``用来创建额外的缓存配置。这些额外的配置可以有不同于缺省缓存配置的时间长度、引擎、路径或前缀。
    ``Cache::config()`` is used to create additional Cache
    configurations. These additional configurations can have different
    duration, engines, paths, or prefixes than your default cache
    config.

.. php:staticmethod:: read($key, $config = 'default')

    ``Cache::read()``用来从``$config``配置读取在``$key``键的缓存的值。如果 $config 为 null，则会使用缺省配置。如果是合法的缓存，``Cache::read()``会返回缓存的值，如果缓存已过期或不存在，就返回``false``。缓存的内容也许会估值为 false，所以一定要使用严格的比较符``===``或者``!==``。
    ``Cache::read()`` is used to 比较符read the cached value stored under
    ``$key`` from the ``$config``. If $config is null the default
    config will be used. ``Cache::read()`` will return the cached value
    if it is a valid cache or ``false`` if the cache has expired or
    doesn't exist. The contents of the cache might evaluate false, so
    make sure you use the strict comparison operator ``===`` or
    ``!==``.

    例如:: For example::

        $cloud = Cache::read('cloud');

        if ($cloud !== false) {
            return $cloud;
        }

        // generate cloud data
        // ...

        // store data in cache
        Cache::write('cloud', $cloud);
        return $cloud;


.. php:staticmethod:: write($key, $value, $config = 'default')

    ``Cache::write()``会把 $value 写入缓存。之后你可以通过``$key``找到它，读取或删除这个值。你也可以指定一个可省略的(缓存)配置来保存要缓存的值。如果``$config``没有指定，缺省值就会被使用。``Cache::write()``可以保存任意类型的对象，很适合保存模型查找的结果::
    ``Cache::write()`` will write a $value to the Cache. You can read or
    delete this value later by referring to it by ``$key``. You may
    specify an optional configuration to store the cache in as well. If
    no ``$config`` is specified, default will be used. ``Cache::write()``
    can store any type of object and is ideal for storing results of
    model finds::

        if (($posts = Cache::read('posts')) === false) {
            $posts = $this->Post->find('all');
            Cache::write('posts', $posts);
        }

    使用``Cache::write()``和``Cache::read()``，可以轻易地减少访问数据库读取帖子的次数
    Using ``Cache::write()`` and ``Cache::read()`` to easily reduce the number
    of trips made to the database to fetch posts.

.. php:staticmethod:: delete($key, $config = 'default')

    ``Cache::delete()``让你从缓存的存储中完全删除一个缓存的对象。
    ``Cache::delete()`` will allow you to completely remove a cached
    object from the Cache store.

.. php:staticmethod:: set($settings = array(), $value = null, $config = 'default')

    ``Cache::set()``让你暂时对一个操作覆盖缓存配置的设置。如果你用``Cache::set()``为写操作改变了设置，你应当在读取数据之前也要使用``Cache::set()``。如果你不这么做，读取该缓存键时，缺省设置就会被使用。::
    ``Cache::set()`` allows you to temporarily override a cache config's
    settings for one operation (usually a read or write). If you use
    ``Cache::set()`` to change the settings for a write, you should
    also use ``Cache::set()`` before reading the data back in. If you
    fail to do so, the default settings will be used when the cache key
    is read.::

        Cache::set(array('duration' => '+30 days'));
        Cache::write('results', $data);

        // 之后 Later on

        Cache::set(array('duration' => '+30 days'));
        $results = Cache::read('results');

    如果你发现自己不断地调用``Cache::set()``，那么也许你应当创建一个新的:php:func:`Cache::config()`。这就消除了调用``Cache::set()``的必要。
    If you find yourself repeatedly calling ``Cache::set()`` then perhaps
    you should create a new :php:func:`Cache::config()`. This will remove the
    need to call ``Cache::set()``.

.. php:staticmethod:: increment($key, $offset = 1, $config = 'default')

    原子化的增加存储在缓存中的值。适合用于修改计数器或者信号灯(semaphore)类型的值。
    Atomically increment a value stored in the cache engine. Ideal for
    modifying counters or semaphore type values.

.. php:staticmethod:: decrement($key, $offset = 1, $config = 'default')

    原子化的减小存储在缓存中的值。适合用于修改计数器或者信号灯(semaphore)类型的值。
    Atomically decrement a value stored in the cache engine. Ideal for
    modifying counters or semaphore type values.

.. php:staticmethod:: clear($check, $config = 'default')

    将一个缓存配置所有的值删除。对象 Apc、Memcache 和 Wincache 这样的引擎，缓存配置的前缀用来生成缓存项。请确保不同的引擎配置有不同的前缀。
    Destroy all cached values for a cache configuration.  In engines like Apc,
    Memcache and Wincache, the cache configuration's prefix is used to remove
    cache entries.  Make sure that different cache configurations have different
    prefixes.

.. php:method:: clearGroup($group, $config = 'default')

    :return: 当成功时为布尔值 true。 Boolean true on success.

    从缓存删除属于同一组的所有键。
    Delete all keys from the cache belonging to the same group.

.. php:staticmethod:: gc($config)

    垃圾收集缓存配置中的项。这主要被文件缓存使用。这应当被任何需要手动回收缓存数据的缓存引擎实现。
    Garbage collects entries in the cache configuration.  This is primarily
    used by FileEngine. It should be implemented by any Cache engine
    that requires manual eviction of cached data.


.. meta::
    :title lang=en: Caching
    :keywords lang=en: uniform api,xcache,cache engine,cache system,atomic operations,php class,disk storage,static methods,php extension,consistent manner,similar features,apc,memcache,queries,cakephp,elements,servers,memory