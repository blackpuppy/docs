缓存
#######

缓存经常用来减少创建或读取其它资源的时间。缓存经常用来使读取昂贵的资源不那么昂
贵。你可以容易地把不经常变化的昂贵的查询、或者对远程网络服务的访问的结果，保存在
缓存中。一旦在缓存中，从缓存中重新读取保存的资源就比访问远程资源代价要小多了。

CakePHP 中的缓存主要是由:php:class:`Cache`类来协助(处理)的。该类有了一组静态
方法，提供了统一的 API 来处理不同类型的缓存实现。CakePHP 带有几个内置的缓存引擎，
并提供了简单的系统来实现你自己的缓存系统。内置的缓存引擎有:

* ``FileCache`` 文件缓存是使用本地文件的简单缓存。它是最慢的缓存引擎，且没有为
原子化操作提供很多特性。不过，既然硬盘存储通常都相当便宜，使用文件存储大的对象、
或者不经常写的元素，很管用。这是2.3+版本的缺省缓存引擎。
* ``ApcCache`` APC 缓存使用 PHP 的`APC <http://php.net/apc>`_扩展。
  这个扩展用网站服务器上的共享内存来保存对象。
  这使它非常快，而且能够提供原子化的读/写特性。
  缺省情况下 CakePHP 2.0-2.2 会使用该缓存引擎，如果可用的话。
* ``Wincache`` Wincache 使用`Wincache <http://php.net/wincache>`_扩展。Wincache 
在特性和性能上类似于 APC，但针对 Windows 和 IIS 做了优化。
* ``XcacheEngine`` `Xcache <http://xcache.lighttpd.net/>`_是一个 PHP 扩展，提供
类似 APC 的特性。
* ``MemcacheEngine`` 使用`Memcache <http://php.net/memcache>`_扩展。
Memcache 提供了非常快速的缓存系统，可以分布于多台服务器，而且提供原子化操作。
* ``RedisEngine`` 使用`phpredis <https://github.com/nicolasff/phpredis>`_扩展。
Redis 类似于 memcached，提供了快速和可持久化的缓存系统，也提供原子化操作。

.. versionchanged:: 2.3
    FileEngine 总是缺省的缓存引擎。曾经一些人在 cli + web 两种环境中，遇到困难
    而无法正确设置和部署 APC。
    使用文件(缓存)，应当使得配置 CakePHP 对新的开发人员来说更简单了。

不论你选择使用哪种缓存引擎，你的应用程序与:php:class:`Cache`以一致的方式交互。
这意味着你可以随着应用程序的增长而容易地替换缓存引擎。除了:php:class:`Cache`类，
:doc:`/core-libraries/helpers/cache`允许整个页面的缓存，这也极大地改善了性能。


配置 Cache 类
=======================

配置 Cache 类可以在任何地方进行，但通常你会在``app/Config/bootstrap.php``中配置
Cache 类。你可以设置任意数量的缓存配置，使用任意缓存引擎的组合。在内部，CakePHP 
使用两个缓存配置，这两个配置在``app/Config/core.php``中设置。如果你使用 APC 或者
Memcache，你一定要为核心缓存设置唯一的键。这会防止多个应用程序互相覆盖缓存的数据。

使用多个缓存配置可以帮助减少你需要调用:php:func:`Cache::set()`的次数，同时集中所
有的缓存设置。使用多个配置也让你按照需求逐步改变存储。

.. note::

    你必须指定使用的引擎。它**不**会使用文件(缓存)为缺省值。

例如::

    Cache::config('short', array(
        'engine' => 'File',
        'duration' => '+1 hours',
        'path' => CACHE,
        'prefix' => 'cake_short_'
    ));

    // 长期
    Cache::config('long', array(
        'engine' => 'File',
        'duration' => '+1 week',
        'probability' => 100,
        'path' => CACHE . 'long' . DS,
    ));

把上面的代码放在``app/Config/bootstrap.php``中，你就多了两个缓存配置。这两个配置
的名称'short'或'long'会作为:php:func:`Cache::write()`和:php:func:`Cache::read()`
方法的``$config``参数。

.. note::

    当使用文件引擎时，你也许要使用``mask``选项，来保证缓存文件会有正确的权限。

为缓存创建存储引擎
===================================

你可以在``app/Lib``以及在插件的``$plugin/Lib``中提供定制的``Cache``适配器。App/插
件的缓存引擎也会覆盖核心的引擎。缓存适配器必须在 cache 目录中。如果你有一个叫作
``MyCustomCacheEngine``的缓存引擎，它就会被放在
``app/Lib/Cache/Engine/MyCustomCacheEngine.php``作为 app/libs，或者在
``$plugin/Lib/Cache/Engine/MyCustomCacheEngine.php``作为插件的一部分。插件的缓
存配置需要使用插件的点语法。::

    Cache::config('custom', array(
        'engine' => 'CachePack.MyCustomCache',
        // ...
    ));

.. note::

    App 和插件的缓存引擎应当在``app/Config/bootstrap.php``中配置。如果你试图在
    core.php 中配置，它们不会正常工作。

定制的缓存引擎必须扩展:php:class:`CacheEngine`，这个类定义了一些抽象的方法，也
提供了一些初始化方法。

CacheEngine 必需的 API 有

.. php:class:: CacheEngine

    缓存使用的所有缓存引擎的基类。

.. php:method:: write($key, $value, $config = 'default')

    :return: 成功与否的布尔值。

    将一个键的值写入缓存，可省略的字符串 $cofig 指定要写入的(缓存)配置名称。

.. php:method:: read($key)

    :return: 缓存的值，或者在失败时为 false。

    从缓存读取一个键。返回 false 表明该项已失效或者不存在。

.. php:method:: delete($key)

    :return: 成功时为布尔值 true。

    从缓存中删除一个键。返回 false，表明该项不存在或者无法删除。

.. php:method:: clear($check)

    :return: 成功时为布尔值 true。

    从缓存删除所有键。如果 $check 为 true，你应当验证每个值实际上已经过期。

.. php:method:: clearGroup($group)

    :return: 成功时为布尔值 true。

    从缓存删除所有属于同一组的键。

.. php:method:: decrement($key, $offset = 1)

    :return: 成功时为布尔值 true。

    把键对应的数字减一，并返回减一后的值。(译注: 这里存在矛盾，成功时究竟是减
    一后的值还是布尔值 true？但原文如此，建议参看 API 为准。)

.. php:method:: increment($key, $offset = 1)

    :return: 成功时为布尔值 true。

    把键对应的数字增一，并返回增一后的值。(译注: 这里存在矛盾，成功时究竟是增
    一后的值还是布尔值 true？但原文如此，建议参看 API 为准。)

.. php:method:: gc()

    不要求，但在资源失效时用于清理。
    文件引擎用它来删除包含过期内容的文件。


用缓存来存储一般的查询结果
=========================================

你可以把不经常变化的结果、或者被大量读取的结果放入缓存，从而极大地改善应用程序的
性能。一个绝佳的例子是从:php:meth:`Model::find()`返回的结果。一个用缓存保存结果
的方法可以象下面这样::

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

你可以改进上述代码，把读取缓存的逻辑移到一个行为中，从缓存读取，或者运行关联模型
方法。不过这可以作为你的一个练习。


使用缓存保存计数
=============================

各种东西的计数很容易在缓存中保存。例如，一项竞赛中剩余空位的简单倒计数，就可以保
存在缓存中。Cache 类提供了简单的方式来原子化地增/减计数器的值。原子化操作对这些
值很重要，因为这减少了竞争的风险，即两个用户同时把值减一，导致不正确的值。

在设置一个整数值之后，你可以用:php:meth:`Cache::increment()`和
:php:meth:`Cache::decrement()`来操纵它::

    Cache::write('initial_count', 10);

    // 然后
    Cache::decrement('initial_count');

    // 或者
    Cache::increment('initial_count');

.. note::

    增一和减一无法用于文件引擎。你应当使用 APC、Redis 或者 Memcache。


使用分组
============

.. versionadded:: 2.2

有时你想要把多个缓存项标记为属于某个组或者命名空间。这是一个常见的需求，每当同一
组内的所有项共享的某些信息发生变化时，就使这些键无效。这可以通过在缓存配置中声明
分组::

    Cache::config('site_home', array(
        'engine' => 'Redis',
        'duration' => '+999 days',
        'groups' => array('comment', 'post')
    ));

比方说，你要把为主页生成的 HTML 保存在缓存中，不过每次当一个评论或帖子添加到数据
库中时，又要自动使该缓存无效。增加了分组``comment``和``post``之后，在效果上我们就
把存入这个缓存配置的任意键标上这两个组的名字。

例如，每添加一个新的帖子，我们可以让缓存引擎删除所有与``post``分组相联系的项::

    // Model/Post.php

    public function afterSave($created) {
        if ($created) {
            Cache::clearGroup('post', 'site_home');
        }
    }

分组是在相同引擎和相同前缀的缓存配置之间共享的。如果你使用分组，并想利用分组删除，
就为你所有的(缓存)配置选择一个共用的前缀。

缓存 API
=========

.. php:class:: Cache

    CakePHP 中的 Cache 类提供了针对多个后端缓存系统的一个通用前端。不同的缓存配置
    和引擎可在 app/Config/core.php 中设置。

.. php:staticmethod:: config($name = null, $settings = array())

    ``Cache::config()``用来创建额外的缓存配置。这些额外的配置可以有不同于缺省缓存
    配置的时间段、引擎、路径或前缀。

.. php:staticmethod:: read($key, $config = 'default')

    ``Cache::read()``用来从``$config``配置读取``$key``键对应的缓存的值。如果
    $config 为 null，则会使用缺省配置。如果是合法的缓存，``Cache::read()``会返
    回缓存的值，如果缓存已过期或不存在，就返回``false``。缓存的内容也许会其值为
    false，所以一定要使用严格的比较符``===``或者``!==``。

    例如:: For example::

        $cloud = Cache::read('cloud');

        if ($cloud !== false) {
            return $cloud;
        }

        // 生成数据 cloud
        // ...

        // 在缓存中保存数据
        Cache::write('cloud', $cloud);
        return $cloud;


.. php:staticmethod:: write($key, $value, $config = 'default')

    ``Cache::write()``会把 $value 写入缓存。之后你可以通过对这个值的索引
    ``$key``来读取或删除它。你也可以指定一个可省略的(缓存)配置来保存要缓存的值。
    如果``$config``没有指定，缺省值就会被使用。``Cache::write()``可以保存任意类
    型的对象，很适合保存模型查找的结果::

        if (($posts = Cache::read('posts')) === false) {
            $posts = $this->Post->find('all');
            Cache::write('posts', $posts);
        }

    使用``Cache::write()``和``Cache::read()``，可以容易地减少访问数据库读取帖子
    的次数。

.. php:staticmethod:: delete($key, $config = 'default')

    ``Cache::delete()``让你从缓存的存储中完全删除一个缓存的对象。

.. php:staticmethod:: set($settings = array(), $value = null, $config = 'default')

    ``Cache::set()``让你暂时对一个操作(通常为读或写)覆盖缓存配置的设置。如果你
    用``Cache::set()``为写操作改变了设置，你应当在读取该数据之前也要使用
    ``Cache::set()``。如果你不这么做，读取该缓存键时，缺省设置就会被使用。::

        Cache::set(array('duration' => '+30 days'));
        Cache::write('results', $data);

        // 之后

        Cache::set(array('duration' => '+30 days'));
        $results = Cache::read('results');

    如果你发现自己不断地调用``Cache::set()``，那么也许你应当创建一个新的
    :php:func:`Cache::config()`。这就消除了调用``Cache::set()``的必要。

.. php:staticmethod:: increment($key, $offset = 1, $config = 'default')

    原子化的增加存储在缓存中的值。适合用于修改计数器或者信号灯(semaphore)类型的
    值。

.. php:staticmethod:: decrement($key, $offset = 1, $config = 'default')

    原子化的减小存储在缓存中的值。适合用于修改计数器或者信号灯(semaphore)类型的
    值。

.. php:staticmethod:: clear($check, $config = 'default')

    将一个缓存配置所有的值删除。对象 Apc、Memcache 和 Wincache 这样的引擎，缓存配
    置的前缀用来删除缓存项。请确保不同的引擎配置有不同的前缀。

.. php:method:: clearGroup($group, $config = 'default')

    :return: 当成功时为布尔值 true。

    从缓存删除属于同一组的所有键。

.. php:staticmethod:: gc($config)

    垃圾收集缓存配置中的项。这主要被文件缓存使用。这应当被任何需要手动回收缓存数
    据的缓存引擎实现。


.. meta::
    :title lang=zh_CN: Caching
    :keywords lang=zh_CN: uniform api,xcache,cache engine,cache system,atomic operations,php class,disk storage,static methods,php extension,consistent manner,similar features,apc,memcache,queries,cakephp,elements,servers,memory