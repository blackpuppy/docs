缓存
#######

缓存经常用来缩短创建或读取其它资源的时间。缓存经常用来使读取昂贵的资源不那么昂贵。你可以容易地把不经常变化的昂贵的查询、或者对远程网络服务的访问的结果，保存在缓存中。一旦在缓存中，从缓存中重新读取保存的资源就比访问远程资源代价要小多了。

Caching is frequently used to reduce the time it takes to create or read from
other resources. Caching is often used to make reading from expensive
resources less expensive. You can easily store the results of expensive queries,
or remote webservice access that doesn't frequently change in a cache. Once
in the cache, re-reading the stored resource from the cache is much cheaper
than accessing the remote resource.

CakePHP 中的缓存主要是由 :php:class:`Cache` 类来协助(处理)的。该类有一组静态方法，提供了统一的 API 来处理不同类型的缓存实现。CakePHP 带有几个内置的缓存引擎，并提供了简单的系统来实现你自己的缓存系统。内置的缓存引擎为:

* ``FileCache`` 文件缓存是使用本地文件的简单缓存。这是最慢的缓存引擎，且没有为原子化操作提供那么多功能。不过，既然硬盘存储通常都相当便宜，使用文件存储大的对象、或者不经常写的元素，很管用。这是2.3+版本的默认缓存引擎。
* ``ApcCache`` APC 缓存使用 PHP 的 `APC <http://php.net/apc>`_ 扩展。这个扩展用网站服务器上的共享内存来保存对象。这使它非常快，而且能够提供原子化的读/写功能。默认情况下 CakePHP 2.0-2.2 会使用该缓存引擎，如果可用的话。
* ``Wincache`` Wincache 使用 `Wincache <http://php.net/wincache>`_ 扩展。Wincache 在功能和性能上类似于 APC，但针对 Windows 和 微软的IIS 做了优化。
* ``XcacheEngine`` `Xcache <http://xcache.lighttpd.net/>`_ 是一个 PHP 扩展，提供类似 APC 的功能。
* ``MemcacheEngine`` 使用 `Memcache <http://php.net/memcache>`_ 扩展。Memcache 提供了非常快速的缓存系统，可以分布于很多台服务器，而且提供原子化操作。
* ``MemcachedEngine`` 使用 `Memcached <http://php.net/memcached>`_ 扩展。它也与 memcache 接口，但提供更好的性能。
* ``RedisEngine`` 使用 `phpredis <https://github.com/nicolasff/phpredis>`_ 扩展。Redis 类似于 memcached，提供了快速和可持久化的缓存系统，也提供原子化操作。

Caching in CakePHP is primarily facilitated by the :php:class:`Cache` class.
This class provides a set of static methods that provide a uniform API to
dealing with all different types of Caching implementations. CakePHP
comes with several cache engines built-in, and provides an easy system
to implement your own caching systems. The built-in caching engines are:

* ``FileCache`` File cache is a simple cache that uses local files. It
  is the slowest cache engine, and doesn't provide as many features for
  atomic operations. However, since disk storage is often quite cheap,
  storing large objects, or elements that are infrequently written
  work well in files. This is the default Cache engine for 2.3+
* ``ApcCache`` APC cache uses the PHP `APC <http://php.net/apc>`_ extension.
  This extension uses shared memory on the webserver to store objects.
  This makes it very fast, and able to provide atomic read/write features.
  By default CakePHP in 2.0-2.2 will use this cache engine if it's available.
* ``Wincache`` Wincache uses the `Wincache <http://php.net/wincache>`_
  extension. Wincache is similar to APC in features and performance, but
  optimized for Windows and Microsoft IIS.
* ``XcacheEngine`` `Xcache <http://xcache.lighttpd.net/>`_
  is a PHP extension that provides similar features to APC.
* ``MemcacheEngine`` Uses the `Memcache <http://php.net/memcache>`_
  extension. Memcache provides a very fast cache system that can be
  distributed across many servers, and provides atomic operations.
* ``MemcachedEngine`` Uses the `Memcached <http://php.net/memcached>`_
  extension. It also interfaces with memcache but provides better performance.
* ``RedisEngine`` Uses the `phpredis <https://github.com/nicolasff/phpredis>`_
  extension. Redis provides a fast and persistent cache system similar to
  memcached, also provides atomic operations.

.. versionchanged:: 2.3
    FileEngine 总是默认的缓存引擎。曾经有些人在 cli + web 两种环境中都遇到困难而无法正确设置和部署 APC。使用文件(缓存)，应当使得配置 CakePHP 对新的开发人员来说更简单了。
    FileEngine is always the default cache engine. In the past a number of people
    had difficulty setting up and deploying APC correctly both in cli + web.
    Using files should make setting up CakePHP simpler for new developers.

.. versionchanged:: 2.5
    The Memcached engine was added. And the Memcache engine was deprecated.
    增加了Memcached引擎，Memcache引擎作废了。

不论你选择使用哪种缓存引擎，你的应用程序与 :php:class:`Cache` 类以一致的方式交互。这意味着你可以随着应用程序的增长而容易地替换缓存引擎。除了 :php:class:`Cache` 类，:doc:`/core-libraries/helpers/cache` 允许缓存整个页面，这也能极大地改善性能。

Regardless of the CacheEngine you choose to use, your application interacts with
:php:class:`Cache` in a consistent manner. This means you can easily swap cache engines
as your application grows. In addition to the :php:class:`Cache` class, the
:doc:`/core-libraries/helpers/cache` allows for full page caching, which
can greatly improve performance as well.

配置 Cache 类
=======================

Configuring Cache class
=======================

配置Cache类可以在任何地方进行，但通常会在 ``app/Config/bootstrap.php`` 中配置Cache类。你可以设置任意数量的缓存配置，使用任意缓存引擎的组合。CakePHP在内部使用两个缓存配置，这两个配置在 ``app/Config/core.php`` 中设置。如果你使用APC或者Memcache，你一定要为核心缓存设置唯一的键。这将防止多个应用程序互相覆盖缓存的数据。

Configuring the Cache class can be done anywhere, but generally
you will want to configure Cache in ``app/Config/bootstrap.php``. You
can configure as many cache configurations as you need, and use any
mixture of cache engines. CakePHP uses two cache configurations internally,
which are configured in ``app/Config/core.php``. If you are using APC or
Memcache you should make sure to set unique keys for the core caches. This will
prevent multiple applications from overwriting each other's cached data.

使用多个缓存配置可以帮助减少你需要调用 :php:func:`Cache::set()` 的次数，同时集中所有的缓存设置。使用多个配置也让你按照需求逐步改变存储。

Using multiple cache configurations can help reduce the
number of times you need to use :php:func:`Cache::set()` as well as
centralize all your cache settings. Using multiple configurations
also lets you incrementally change the storage as needed.

.. note::

    你必须指定使用的引擎。它 **不** 会使用文件(缓存)为默认值。

    You must specify which engine to use. It does **not** default to
    File.

例如::

Example::

    Cache::config('short', array(
        'engine' => 'File',
        'duration' => '+1 hours',
        'path' => CACHE,
        'prefix' => 'cake_short_'
    ));

    // 长期
    // long
    Cache::config('long', array(
        'engine' => 'File',
        'duration' => '+1 week',
        'probability' => 100,
        'path' => CACHE . 'long' . DS,
    ));

把上面的代码放在``app/Config/bootstrap.php``中，你就多了两个缓存配置。这两个配置的名称'short'或'long'会作为 :php:func:`Cache::write()` 和 :php:func:`Cache::read()` 方法的 ``$config`` 参数。

By placing the above code in your ``app/Config/bootstrap.php`` you will
have two additional Cache configurations. The name of these
configurations 'short' or 'long' is used as the ``$config``
parameter for :php:func:`Cache::write()` and :php:func:`Cache::read()`.

.. note::

    当使用文件引擎时，你也许要使用 ``mask`` 选项，来保证缓存文件会有正确的权限。

    When using the FileEngine you might need to use the ``mask`` option to
    ensure cache files are made with the correct permissions.

.. versionadded:: 2.4

    在调试模式下，当使用文件引擎时，会自动创建不存在的目录，以避免不必要的错误。

    In debug mode missing directories will now be automatically created to avoid unnecessary
    errors thrown when using the FileEngine.

为缓存创建存储引擎
===================================

Creating a storage engine for Cache
===================================

你可以在 ``app/Lib`` 目录以及在插件的 ``$plugin/Lib`` 目录中提供自定义的 ``Cache`` 适配器。App/插件的缓存引擎也可以覆盖核心的引擎。缓存适配器必须在 cache 目录中。如果你有一个叫做 ``MyCustomCacheEngine`` 的缓存引擎，它就会被放在 ``app/Lib/Cache/Engine/MyCustomCacheEngine.php`` 作为 app/libs，或者在 ``$plugin/Lib/Cache/Engine/MyCustomCacheEngine.php`` 作为插件的一部分。插件的缓存配置需要使用插件的点语法。::

You can provide custom ``Cache`` adapters in ``app/Lib`` as well
as in plugins using ``$plugin/Lib``. App/plugin cache engines can
also override the core engines. Cache adapters must be in a cache
directory. If you had a cache engine named ``MyCustomCacheEngine``
it would be placed in either ``app/Lib/Cache/Engine/MyCustomCacheEngine.php``
as an app/libs or in ``$plugin/Lib/Cache/Engine/MyCustomCacheEngine.php`` as
part of a plugin. Cache configs from plugins need to use the plugin
dot syntax. ::

    Cache::config('custom', array(
        'engine' => 'CachePack.MyCustomCache',
        // ...
    ));

.. note::

    App和插件的缓存引擎应当在 ``app/Config/bootstrap.php`` 文件中配置。如果你试图在core.php中配置，它们就不会正常工作。

    App and Plugin cache engines should be configured in
    ``app/Config/bootstrap.php``. If you try to configure them in core.php
    they will not work correctly.

自定义的缓存引擎必须扩展 :php:class:`CacheEngine` 类，该类定义了一些抽象的方法，也提供了一些初始化方法。

Custom Cache engines must extend :php:class:`CacheEngine` which defines
a number of abstract methods as well as provides a few initialization
methods.

CacheEngine 必需的 API 为

The required API for a CacheEngine is

.. php:class:: CacheEngine

    缓存使用的所有缓存引擎的基类。

    The base class for all cache engines used with Cache.

.. php:method:: write($key, $value, $config = 'default')

    :return: 成功与否的布尔值。

    :return: boolean for success.

    将一个键的值写入缓存，可省略的字符串 $cofig 指定要写入的(缓存)配置的名称。

    Write value for a key into cache, optional string $config
    specifies configuration name to write to.

.. php:method:: read($key, $config = 'default')

    :return: 缓存的值，或者在失败时为 false。

    :return: The cached value or false for failure.

    从缓存读取一个键，可省略的字符串 $cofig 指定要读取的(缓存)配置的名称。返回 false 表明该项已经过期了或者不存在。

    Read a key from the cache, optional string $config
    specifies configuration name to read from. Return false to
    indicate the entry has expired or does not exist.

.. php:method:: delete($key, $config = 'default')

    :return: 成功时为布尔值 true。

    :return: Boolean true on success.

    从缓存中删除一个键，可省略的字符串 $cofig 指定要删除的(缓存)配置的名称。返回 false，表明该项不存在或者无法删除。

    Delete a key from the cache, optional string $config
    specifies configuration name to delete from. Return false to
    indicate that the entry did not exist or could not be deleted.

.. php:method:: clear($check)

    :return: 成功时为布尔值 true。

    :return: Boolean true on success.

    从缓存删除所有键。如果 $check 为 true，你应当验证每个值实际上已经过期。

    Delete all keys from the cache. If $check is true, you should
    validate that each value is actually expired.

.. php:method:: clearGroup($group)

    :return: 成功时为布尔值 true。

    :return: Boolean true on success.

    从缓存删除所有属于同一组的键。

    Delete all keys from the cache belonging to the same group.

.. php:method:: decrement($key, $offset = 1)

    :return: 成功时为减一后的值，否则为布尔值 false。

    :return: The decremented value on success, boolean false otherwise.

    把键对应的数字减一，并返回减一后的值。

    Decrement a number under the key and return decremented value

.. php:method:: increment($key, $offset = 1)

    :return: 成功时为增一后的值，否则为布尔值 false。

    :return: The incremented value on success, boolean false otherwise.

    把键对应的数字增一，并返回增一后的值。

    Increment a number under the key and return incremented value

.. php:method:: gc()

    不要求，但在资源失效时用于清理。
    文件引擎用它来删除包含过期内容的文件。

    Not required, but used to do clean up when resources expire.
    FileEngine uses this to delete files containing expired content.

用缓存来存储公用的查询结果
=========================================

Using Cache to store common query results
=========================================

你可以把不经常变化的结果、或者被大量读取的结果放入缓存，从而极大地改善应用程序的性能。一个绝佳的例子是从:php:meth:`Model::find()`返回的结果。一个用缓存保存结果的方法可以象下面这样::

You can greatly improve the performance of your application by putting
results that infrequently change, or that are subject to heavy reads into the
cache. A perfect example of this are the results from :php:meth:`Model::find()`.
A method that uses Cache to store results could look like::

    class Post extends AppModel {

        public function newest() {
            $result = Cache::read('newest_posts', 'long');
            if (!$result) {
                $result = $this->find('all', array('order' => 'Post.updated DESC', 'limit' => 10));
                Cache::write('newest_posts', $result, 'long');
            }
            return $result;
        }
    }

你可以改进上述代码，把读取缓存的逻辑移到一个行为中，从缓存读取，或者运行关联模型的方法。不过这可以作为你的一个练习。

You could improve the above code by moving the cache reading logic into
a behavior, that read from the cache, or ran the associated model method.
That is an exercise you can do though.

在 2.5 版本中，你可以用 :php:meth:`Cache::remember()` 更简单地实现上面的代码。假设你使用PHP 5.3或更高版本，使用 ``remember()`` 方法就象这样::

As of 2.5 you can accomplish the above much more simply using
:php:meth:`Cache::remember()`. Assuming you are using PHP 5.3 or
newer, using the ``remember()`` method would look like::

    class Post extends AppModel {

        public function newest() {
            $model = $this;
            return Cache::remember('newest_posts', function() use ($model){
                return $model->find('all', array(
                    'order' => 'Post.updated DESC',
                    'limit' => 10
                ));
            }, 'long');
        }
    }

使用缓存保存计数
=============================

Using Cache to store counters
=============================

各种东西的计数很容易在缓存中保存。例如，一项竞赛中剩余‘空位’的简单倒计数，就可以保存在缓存中。Cache 类提供了原子化的方式来容易地增/减计数器的值。原子化操作对这些值很重要，因为这减少了竞争的风险，即两个用户同时把值减一，导致不正确的值。

Counters for various things are easily stored in a cache. For example, a simple
countdown for remaining 'slots' in a contest could be stored in Cache. The
Cache class exposes atomic ways to increment/decrement counter values in an easy
way. Atomic operations are important for these values as it reduces the risk of
contention, and ability for two users to simultaneously lower the value by one,
resulting in an incorrect value.

在设置一个整数值之后，你可以用 :php:meth:`Cache::increment()` 和 :php:meth:`Cache::decrement()` 方法来对它进行操作::

After setting an integer value, you can manipulate it using
:php:meth:`Cache::increment()` and :php:meth:`Cache::decrement()`::

    Cache::write('initial_count', 10);

    // 然后
    // Later on
    Cache::decrement('initial_count');

    // 或者
    // or
    Cache::increment('initial_count');

.. note::

    增一和减一无法用于文件引擎。你应当使用 APC、Redis 或者 Memcache。

    Incrementing and decrementing do not work with FileEngine. You should use
    APC, Redis or Memcached instead.


使用分组
============

Using groups
============

.. versionadded:: 2.2

有时你想要把多个缓存项标记为属于某个组或者命名空间。这是一个常见的需求，每当同一
组内的所有项共享的某些信息发生变化时，就使这些键无效。这可以通过在缓存配置中声明
分组实现::

Sometimes you will want to mark multiple cache entries to belong to a certain
group or namespace. This is a common requirement for mass-invalidating keys
whenever some information changes that is shared among all entries in the same
group. This is possible by declaring the groups in cache configuration::

    Cache::config('site_home', array(
        'engine' => 'Redis',
        'duration' => '+999 days',
        'groups' => array('comment', 'post')
    ));

比方说，你要把为主页生成的 HTML 保存在缓存中，不过每次当一个评论或帖子添加到数据
库中时，又要自动使该缓存无效。增加了分组``comment``和``post``之后，在效果上我们就
把存入这个缓存配置的任意键标记上这两个组的名字。

Let's say you want to store the HTML generated for your homepage in cache, but
would also want to automatically invalidate this cache every time a comment or
post is added to your database. By adding the groups ``comment`` and ``post``,
we have effectively tagged any key stored into this cache configuration with
both group names.

例如，每添加一个新的帖子，我们可以让缓存引擎删除所有与 ``post`` 分组相联系的项::

For instance, whenever a new post is added, we could tell the Cache engine to
remove all entries associated to the ``post`` group::

    // Model/Post.php

    public function afterSave($created, $options = array()) {
        if ($created) {
            Cache::clearGroup('post', 'site_home');
        }
    }

.. versionadded:: 2.4

:php:func:`Cache::groupConfigs()` 可以用来读取分组和配置之间的映射，即，具有相同的组::

:php:func:`Cache::groupConfigs()` can be used to retrieve mapping between
group and configurations, i.e.: having the same group::

    // Model/Post.php

    /**
     * 前一个例子的另一种写法，清楚所有具有相同分组的缓存配置
     * A variation of previous example that clears all Cache configurations
     * having the same group
     */
    public function afterSave($created, $options = array()) {
        if ($created) {
            $configs = Cache::groupConfigs('post');
            foreach ($configs['post'] as $config) {
                Cache::clearGroup('post', $config);
            }
        }
    }

分组是在使用相同引擎和相同前缀的缓存配置之间共享的。如果你使用分组，并想利用分组的删除，就为你所有的（缓存）配置选择一个共用的前缀。

Groups are shared across all cache configs using the same engine and same
prefix. If you are using groups and want to take advantage of group deletion,
choose a common prefix for all your configs.

缓存 API
=========

Cache API
=========

.. php:class:: Cache

    CakePHP 中的 Cache 类提供了针对多个后端缓存系统的一个通用前端。不同的缓存配置
    和引擎可在 app/Config/core.php 中设置。

    The Cache class in CakePHP provides a generic frontend for several
    backend caching systems. Different Cache configurations and engines
    can be set up in your app/Config/core.php

.. php:staticmethod:: config($name = null, $settings = array())

    ``Cache::config()`` 方法用来创建额外的缓存配置。这些额外的配置可以有不同于默认缓存
    配置的时间段、引擎、路径或前缀。

    ``Cache::config()`` is used to create additional Cache
    configurations. These additional configurations can have different
    duration, engines, paths, or prefixes than your default cache
    config.

.. php:staticmethod:: read($key, $config = 'default')

    ``Cache::read()`` 方法用来从 ``$config`` 配置读取 ``$key`` 键对应的缓存的值。如果
    $config 为 null，则会使用默认配置。如果是合法的缓存，``Cache::read()`` 方法会返
    回缓存的值，如果缓存已过期或不存在，就返回 ``false``。缓存的内容的值也许会为
    false，所以一定要使用严格的比较符 ``===`` 或者 ``!==``。

    ``Cache::read()`` is used to read the cached value stored under
    ``$key`` from the ``$config``. If $config is null the default
    config will be used. ``Cache::read()`` will return the cached value
    if it is a valid cache or ``false`` if the cache has expired or
    doesn't exist. The contents of the cache might evaluate false, so
    make sure you use the strict comparison operators: ``===`` or
    ``!==``.

    例如::

    For example::

        $cloud = Cache::read('cloud');

        if ($cloud !== false) {
            return $cloud;
        }

        // 生成数据 cloud
        // generate cloud data
        // ...

        // 在缓存中保存数据
        // store data in cache
        Cache::write('cloud', $cloud);
        return $cloud;


.. php:staticmethod:: write($key, $value, $config = 'default')

    ``Cache::write()`` 方法会把 $value 写入缓存。之后你可以通过对这个值的索引
    ``$key`` 来读取或删除它。你也可以指定一个可省略的（缓存）配置来保存要缓存的值。
    如果 ``$config`` 没有指定，默认（配置）就会被使用。``Cache::write()`` 方法可以保存任意类
    型的对象，很适合保存模型 find 方法调用的结果::

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

    使用 ``Cache::write()`` 和 ``Cache::read()`` 方法，可以容易地减少访问数据库读取文章
    的次数。

    Using ``Cache::write()`` and ``Cache::read()`` to easily reduce the number
    of trips made to the database to fetch posts.

.. php:staticmethod:: delete($key, $config = 'default')

    ``Cache::delete()`` 方法让你从缓存的存储中完全删除一个缓存的对象。

    ``Cache::delete()`` will allow you to completely remove a cached
    object from the Cache store.

.. php:staticmethod:: set($settings = array(), $value = null, $config = 'default')

    ``Cache::set()`` 方法让你暂时对一个操作（通常为读或写）覆盖缓存配置的设置。如果你
    用 ``Cache::set()`` 方法为写操作改变了设置，你应当在读取该数据之前也要使用
    ``Cache::set()`` 方法。如果你不这么做，读取该缓存键时，就会使用默认设置。::

    ``Cache::set()`` allows you to temporarily override a cache config's
    settings for one operation (usually a read or write). If you use
    ``Cache::set()`` to change the settings for a write, you should
    also use ``Cache::set()`` before reading the data back in. If you
    fail to do so, the default settings will be used when the cache key
    is read. ::

        Cache::set(array('duration' => '+30 days'));
        Cache::write('results', $data);

        // 之后
        // Later on

        Cache::set(array('duration' => '+30 days'));
        $results = Cache::read('results');

    如果你发现自己不断地调用 ``Cache::set()`` 方法，那么也许你应当创建一个新的
    :php:func:`Cache::config()`。这就不用调用 ``Cache::set()`` 方法了。

    If you find yourself repeatedly calling ``Cache::set()`` then perhaps
    you should create a new :php:func:`Cache::config()`. This will remove the
    need to call ``Cache::set()``.

.. php:staticmethod:: increment($key, $offset = 1, $config = 'default')

    原子化地增加存储在缓存引擎中的值。适合用于修改计数器或者信号灯（semaphore）类型的
    值。

    Atomically increment a value stored in the cache engine. Ideal for
    modifying counters or semaphore type values.

.. php:staticmethod:: decrement($key, $offset = 1, $config = 'default')

    原子化地减小存储在缓存引擎中的值。适合用于修改计数器或者信号灯（semaphore）类型的
    值。

    Atomically decrement a value stored in the cache engine. Ideal for
    modifying counters or semaphore type values.

.. php:staticmethod:: clear($check, $config = 'default')

    将一个缓存配置所有缓存的值删除。对象Apc、Memcache和Wincache这样的引擎，用缓存配
    置的前缀来删除缓存项。请确保不同的引擎配置实用不同的前缀。

    Destroy all cached values for a cache configuration. In engines like Apc,
    Memcache and Wincache, the cache configuration's prefix is used to remove
    cache entries. Make sure that different cache configurations have different
    prefixes.

.. php:method:: clearGroup($group, $config = 'default')

    :return: 当成功时为布尔值 true。

    :return: Boolean true on success.

    从缓存删除属于同一分组的所有键。

    Delete all keys from the cache belonging to the same group.

.. php:staticmethod:: gc($config)

    垃圾回收缓存配置中的项。这主要被文件（缓存）引擎使用。任何需要手动回收缓存数
    据的缓存引擎应当实现该方法。

    Garbage collects entries in the cache configuration. This is primarily
    used by FileEngine. It should be implemented by any Cache engine
    that requires manual eviction of cached data.


.. php:staticmethod:: groupConfigs($group = null)

    :return: 分组和相关联的配置名称的数组。

    :return: Array of groups and its related configuration names.

    读取分组名称和（缓存）配置的映射。

    Retrieve group names to config mapping.

.. php:staticmethod:: remember($key, $callable, $config = 'default')

    提供简单的方法来实现读－过缓存。如果缓存的键存在，就会返回（相应的值）。如果键不存在，则回调（callable）会被调用，结果存储在缓存提供的键中。

    Provides an easy way to do read-through caching. If the cache key exists
    it will be returned. If the key does not exist, the callable will be invoked
    and the results stored in the cache at the provided key.

    例如，你经常要缓存查询结果。你可以使用 ``remember()`` 方法来简化这一过程。假设你使用PHP 5.3或更新版本::

    For example, you often want to cache query results. You could use
    ``remember()`` to make this simple. Assuming you are using PHP 5.3 or
    newer::

        class Articles extends AppModel {
            function all() {
                $model = $this;
                return Cache::remember('all_articles', function() use ($model){
                    return $model->find('all');
                });
            }
        }

    .. versionadded:: 2.5
        在2.5版本中增加了remember()方法。
        remember() was added in 2.5.


.. meta::
    :title lang=zh_CN: Caching
    :keywords lang=zh_CN: uniform api,xcache,cache engine,cache system,atomic operations,php class,disk storage,static methods,php extension,consistent manner,similar features,apc,memcache,queries,cakephp,elements,servers,memory
