全局常量和函数
##############################
在使用CakePHP的日常工作中，都用到了其核心类库和方法。
CakePHP具有一系列方便的全局函数。许多这些函数被CakePHP使用(加载模型或组件的类)，
但使用有些函数在处理数组或字符串时会变得更加容易。

While most of your day-to-day work in CakePHP will be utilizing
core classes and methods, CakePHP features a number of global
convenience functions that may come in handy. Many of these
functions are for use with CakePHP classes (loading model or
component classes), but many others make working with arrays or
strings a little easier.

在CakePHP的应用程序中也会牵涉到一些常量。使用这些常量将使升级
时更平稳，同样在引用CakePHP程序中的特定文件和目录更加方便。

We’ll also cover some of the constants available in CakePHP
applications. Using these constants will help make upgrades more
smooth, but are also convenient ways to point to certain files or
directories in your CakePHP application.

全局函数 Global Functions
=========================

下面是CakePHP的全局函数。大部分函数封装了CakePHP的常用功能，使其使用起来
更加便利，比如调试和内容翻译。

Here are CakePHP's globally available functions. Most of them
are just convenience wrappers for other CakePHP functionality,
such as debugging and translating content.

.. php:function:: \_\_(string $string_id, [$formatArgs])

    此函数处理CakePHP应用程序的语言本地化。``$string_id`` 代表翻译语言的ID。

    This function handles localization in CakePHP applications. The
    ``$string_id`` identifies the ID for a translation.  Strings
    used for translations are treated as format strings for
    ``sprintf()``.  You can supply additional arguments to replace
    placeholders in your string::

        __('You have %s unread messages', $number);

    .. note::

        参见:doc:`/core-libraries/internationalization-and-localization`
        搜索更多信息。

        Check out the
        :doc:`/core-libraries/internationalization-and-localization`
        section for more information.

.. php:function:: __c(string $msg, integer $category, mixed $args = null)

    注意第二个参数category必须指定一个数值，而不是常量名。这些值代表：

    Note that the category must be specified with a numeric value, instead of
    the constant name. The values are:

    - 0 - LC_ALL
    - 1 - LC_COLLATE
    - 2 - LC_CTYPE
    - 3 - LC_MONETARY
    - 4 - LC_NUMERIC
    - 5 - LC_TIME
    - 6 - LC_MESSAGES

.. php:function:: __d(string $domain, string $msg, mixed $args = null)

    Allows you to override the current domain for a single message lookup.

    当国际化一个插件很有用：
    Useful when internationalizing a plugin:
    ``echo __d('PluginName', 'This is my plugin');``

.. php:function:: __dc(string $domain, string $msg, integer $category, mixed $args = null)

    Allows you to override the current domain for a single message lookup. It
    also allows you to specify a category.

    Note that the category must be specified with a numeric value, instead of
    the constant name. The values are:

    - 0 - LC_ALL
    - 1 - LC_COLLATE
    - 2 - LC_CTYPE
    - 3 - LC_MONETARY
    - 4 - LC_NUMERIC
    - 5 - LC_TIME
    - 6 - LC_MESSAGES

.. php:function:: __dcn(string $domain, string $singular, string $plural, integer $count, integer $category, mixed $args = null)

    Allows you to override the current domain for a single plural message
    lookup. It also allows you to specify a category. Returns correct plural
    form of message identified by $singular and $plural for count $count from
    domain $domain.

    Note that the category must be specified with a numeric value, instead of
    the constant name. The values are:

    - 0 - LC_ALL
    - 1 - LC_COLLATE
    - 2 - LC_CTYPE
    - 3 - LC_MONETARY
    - 4 - LC_NUMERIC
    - 5 - LC_TIME
    - 6 - LC_MESSAGES

.. php:function:: __dn(string $domain, string $singular, string $plural, integer $count, mixed $args = null)

    Allows you to override the current domain for a single plural message
    lookup. Returns correct plural form of message identified by $singular and
    $plural for count $count from domain $domain.

.. php:function:: __n(string $singular, string $plural, integer $count, mixed $args = null)

    Returns correct plural form of message identified by $singular and $plural
    for count $count. Some languages have more than one form for plural
    messages dependent on the count.

.. php:function:: am(array $one, $two, $three...)

    合并参数中所有的数组，返回合并后的数组。
    Merges all the arrays passed as parameters and returns the merged
    array.

.. php:function:: config()

    从config目录中通过include\_once加载文件。函数会检测是否已经包含并
    返回布尔值。可接收一个可选的数字参数。

    举例：``config('some_file', 'myconfig');``

    Can be used to load files from your application ``config``-folder
    via include\_once. Function checks for existence before include and
    returns boolean. Takes an optional number of arguments.

    Example: ``config('some_file', 'myconfig');``

.. php:function:: convertSlash(string $string)

    转换正斜杠为下划线，移除字符串中首个和最后一个下划线，返回转换后的字符串。
    译注:实测好像有问题
    Converts forward slashes to underscores and removes the first and
    last underscores in a string. Returns the converted string.

.. php:function:: debug(mixed $var, boolean $showHtml = null, $showFrom = true)

    如果程序的DEBUG等级是0，打印$var。如果 ``$showHTML`` 为真或null，会输出友好的内容。
    如果$showFrom为true，会从开始调用debug的行输出内容。
    参见：:doc:`/development/debugging`

    If the application's DEBUG level is non-zero, $var is printed out.
    If ``$showHTML`` is true or left as null, the data is rendered to be
    browser-friendly.
    If $showFrom is not set to false, the debug output will start with the line from
    which it was called
    Also see :doc:`/development/debugging`

.. php:function:: env(string $key)

    从可用的资源中获取环境变量。若``$_SERVER``或``$_ENV``被禁用，可作为备选

    此函数同样在不支持的服务器上模拟PHP\_SELF和DOCUMENT\_ROOT。实际上，
    使用 ``env()`` 比 ``$_SERVER`` 或 ``getenv()`` 要好(特别是准备分发代码)，
    因为他是一个完整的模拟的封装。

    Gets an environment variable from available sources. Used as a
    backup if ``$_SERVER`` or ``$_ENV`` are disabled.

    This function also emulates PHP\_SELF and DOCUMENT\_ROOT on
    unsupporting servers. In fact, it's a good idea to always use
    ``env()`` instead of ``$_SERVER`` or ``getenv()`` (especially if
    you plan to distribute the code), since it's a full emulation
    wrapper.

.. php:function:: fileExistsInPath(string $file)

    检测一个文件是否存在当前的PHP的include路径中。返回布尔值

    Checks to make sure that the supplied file is within the current
    PHP include\_path. Returns a boolean result.

.. php:function:: h(string $text, boolean $double = true, string $charset = null)

    ``htmlspecialchars()`` 的缩写。
    Convenience wrapper for ``htmlspecialchars()``.

.. php:function:: LogError(string $message)

    :php:meth:`Log::write()` 的缩写。
    Shortcut to :php:meth:`Log::write()`.

.. php:function:: pluginSplit(string $name, boolean $dotAppend = false, string $plugin = null)

    分隔一个以点命名的插件名为插件和类名。如果$name不包含点。索引0将为null

    通常这么使用 ``list($plugin, $name) = pluginSplit('Users.User');``

    Splits a dot syntax plugin name into its plugin and classname. If $name
    does not have a dot, then index 0 will be null.

    Commonly used like ``list($plugin, $name) = pluginSplit('Users.User');``

.. php:function:: pr(mixed $var)

    ``print_r()`` 简单封装，在输出结果两边加上<pre>标签。
    Convenience wrapper for ``print_r()``, with the addition of
    wrapping <pre> tags around the output.

.. php:function:: sortByKey(array &$array, string $sortby, string $order = 'asc', integer $type = SORT_NUMERIC)

    通过键名$sortby排序给定的$array
    Sorts given $array by key $sortby.

.. php:function:: stripslashes_deep(array $value)

    递归的去掉 ``$value`` 的斜杠。返回修改后数组。
    Recursively strips slashes from the supplied ``$value``. Returns
    the modified array.

核心常量 Core Definition Constants
===================================

下面的常量大部分涉及应用程序的路径
Most of the following constants refer to paths in your application.

.. php:const:: APP

   应用程序的目录
   Path to the application's directory.

.. php:const:: APP_DIR

    等价于 ``app`` 或应用程序目录的名称
    Equals ``app`` or the name of your application directory.

.. php:const:: APPLIBS

    放置应用程序库的路径
    Path to the application's Lib directory.

.. php:const:: CACHE

    放置cache缓存目录的路径。可以在不同主机共享。
    Path to the cache files directory. It can be shared between hosts in a
    multi-server setup.

.. php:const:: CAKE

    cake目录的路径
    Path to the cake directory.

.. php:const:: CAKE_CORE_INCLUDE_PATH

    放置公共库的目录路径
    Path to the root lib directory.

.. php:const:: CORE_PATH

    以目录斜杠结尾的根目录
    Path to the root directory with ending directory slash.

.. php:const:: CSS

    放置公共CSS目录的路径
    Path to the public CSS directory.

.. php:const:: CSS_URL

    放置CSS文件目录的网络路径
    Web path to the CSS files directory.

.. php:const:: DS

    PHP的DIRECTORY\_SEPARATOR缩写，在Linux上为 / 在windows上是\\。
    Short for PHP's DIRECTORY\_SEPARATOR, which is / on Linux and \\ on windows.

.. php:const:: FULL_BASE_URL

    补全url的前缀地址。比如 ``https://example.com``
    Full url prefix. Such as ``https://example.com``

.. php:const:: IMAGES

    放置公共图片的目录路径
    Path to the public images directory.

.. php:const:: IMAGES_URL

    放置公共图片的网络目录路径
    Web path to the public images directory.

.. php:const:: JS

    放置公共JavaScript文件的目录路径
    Path to the public JavaScript directory.

.. php:const:: JS_URL

    放置JS文件的网络目录路径
    Web path to the js files directory.

.. php:const:: LOGS

    放置日志文件的目录路径
    Path to the logs directory.

.. php:const:: ROOT

    放置root的目录路径
    Path to the root directory.

.. php:const:: TESTS

    放置tests的目录路径
    Path to the tests directory.

.. php:const:: TMP

    放置temporary的目录路径
    Path to the temporary files directory.

.. php:const:: VENDORS

    放置vendors的目录路径
    Path to the vendors directory.

.. php:const:: WEBROOT_DIR

    等价于 ``webroot`` 或webroot目录的名称
    Equals ``webroot`` or the name of your webroot directory.

.. php:const:: WWW\_ROOT

    webroot目录的全路径
    Full path to the webroot.


时间常量 Timing Definition Constants
======================================

.. php:const:: TIME_START

    程序启动时的浮点型微秒Unix时间戳
    Unix timestamp in microseconds as a float from when the application started.

.. php:const:: SECOND

    等于 1

.. php:const:: MINUTE

    等于 60

.. php:const:: HOUR

    等于 3600

.. php:const:: DAY

    等于 86400

.. php:const:: WEEK

    等于 604800

.. php:const:: MONTH

    等于 2592000

.. php:const:: YEAR

    等于 31536000


.. meta::
    :title lang=zh: Global Constants and Functions
    :keywords lang=zh: internationalization and localization,global constants,example config,array php,convenience functions,core libraries,component classes,optional number,global functions,string string,core classes,format strings,unread messages,placeholders,useful functions,sprintf,arrays,parameters,existence,translations
