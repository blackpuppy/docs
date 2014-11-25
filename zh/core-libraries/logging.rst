日志记录
########

虽然CakePHP的核心配置类的设置可以帮助我们看到一些运行状况。但有些时候
为了查明到底发生了什么事情，我们要记录数据到磁盘中。因为在我们更加依赖SOAP和AJAX等技术
的世界上，调试变得更加困难。

While CakePHP core Configure Class settings can really help you see
what's happening under the hood, there are certain times that
you'll need to log data to the disk in order to find out what's
going on. In a world that is becoming more dependent on
technologies like SOAP and AJAX, debugging can be rather
difficult.

日志可以方便的查明在过去到底发生了什么。使用了什么搜索条件？显示给用户的是
什么错误？一个特殊的查询是多久被执行的。

Logging can also be a way to find out what's been going on in your
application over time. What search terms are being used? What sorts
of errors are my users being shown? How often is a particular query
being executed?

CakePHP中的日志记录相当简单 - log()函数是Object类的一部分，继承自CakePHP的
绝大多数类。如果是在CakePHP(模型,控制器, 组件... 几乎任何地方)的代码内容中，
都可以记录日志。也可以直接使用 ``CakeLog::write()`` 。参见 :ref:`writing-to-logs`

Logging data in CakePHP is easy - the log() function is a part of
the Object class, which is the common ancestor for almost all
CakePHP classes. If the context is a CakePHP class (Model,
Controller, Component... almost anything), you can log your data.
You can also use ``CakeLog::write()`` directly. See :ref:`writing-to-logs`

创建和配置日志流
Creating and configuring log streams
====================================

日志流处理程序可以成为应用程序的一部分，或插件的一部分。举个例子，有一个名为 ``DatabaseLogger``
的记录数据库日志的日志处理程序。作为程序的一部分它会位于 ``app/Lib/Log/Engine/DatabaseLogger.php`` 。
若作为插件的一部分会位于 ``app/Plugin/LoggingPack/Lib/Log/Engine/DatabaseLogger.php`` 。
如果在 ``CakeLog::config()`` 配置好日志处理程序，``CakeLog`` 就会试图加载，配置DataBaseLogger类似::

Log stream handlers can be part of your application, or part of
plugins. If for example you had a database logger called
``DatabaseLogger``. As part of your application it would be placed
in ``app/Lib/Log/Engine/DatabaseLogger.php``. As part of a plugin it
would be placed in
``app/Plugin/LoggingPack/Lib/Log/Engine/DatabaseLogger.php``. When
configured ``CakeLog`` will attempt to load Configuring log streams
is done by calling ``CakeLog::config()``. Configuring our
DataBaseLogger would look like::

    // for app/Lib
    CakeLog::config('otherFile', array(
        'engine' => 'DatabaseLogger',
        'model' => 'LogEntry',
        // ...
    ));

    // for plugin called LoggingPack
    CakeLog::config('otherFile', array(
        'engine' => 'LoggingPack.DatabaseLogger',
        'model' => 'LogEntry',
        // ...
    ));

配置日志流 ``引擎`` 参数是用来定位和加载日志处理程序。所有的其他配置
属性传递到日志流的构造函数是一个数组。::

When configuring a log stream the ``engine`` parameter is used to
locate and load the log handler. All of the other configuration
properties are passed to the log stream's constructor as an array.::

    App::uses('CakeLogInterface', 'Log');

    class DatabaseLogger implements CakeLogInterface {
        public function __construct($options = array()) {
            // ...
        }

        public function write($type, $message) {
            // write to the database.
        }
    }

CakePHP并不需要实现日志流，除了必须实现一个 ``write`` 的方法。这个写方法必须接收两个参数 ``$type, $message``
``$type`` 字符型，是登录信息的类型,核心值是 ``error``，
``warning``, ``info`` 和 ``debug``。此外您可以调用 ``CakeLog::write`` 定义自己的类型。

CakePHP has no requirements for Log streams other than that they
must implement a ``write`` method. This write method must take two
parameters ``$type, $message`` in that order. ``$type`` is the
string type of the logged message, core values are ``error``,
``warning``, ``info`` and ``debug``. In addition you can define
your own types by using them when you call ``CakeLog::write``.

.. note::

	请在 ``app/Config/bootstrap.php`` 中配置loggers
	在core.php文件中使用应用程序或插件的loggers会导致问题。因为应用程序的路径还没有配置。

    Always configure loggers in ``app/Config/bootstrap.php``
    Trying to use Application or plugin loggers in core.php
    will cause issues, as application paths are not yet configured.


Error and Exception logging
===========================

错误和异常同样可以被记录。需要在core.php文件配置相关的值。当debug > 0会显示错误，当debug == 0
才会记录错误。设置 ``Exception.log`` 为真以记录未捕获到的异常。参见 :doc:`/development/configuration`
了解更多内容。

Errors and Exceptions can also be logged.  By configuring the
co-responding values in your core.php file.  Errors will be
displayed when debug > 0 and logged when debug == 0. Set ``Exception.log``
to true to log uncaught exceptions. See :doc:`/development/configuration`
for more information.

与日志流交互 Interacting with log streams
=========================================

当我们反过头来查看方法 :php:meth:`CakeLog::configured()`。返回的 ``configured()`` 是一个
所有当前配置流的数组。可以使用 :php:meth:`CakeLog::drop()` 删除流。一旦日志流被移除，将不再接收消息。

You can introspect the configured streams with
:php:meth:`CakeLog::configured()`. The return of ``configured()`` is an
array of all the currently configured streams. You can remove
streams using :php:meth:`CakeLog::drop()`. Once a log stream has been
dropped it will no longer receive messages.

使用默认的FileLog类 Using the default FileLog class
======================================================

虽然CakeLog可以配置为编写大量的用户配置日志记录适配器,它还提供了一个默认的日志记录配置。
默认的日志配置使用任何时候有 *没有其他* 日志适配器配置。
一旦配置了日志适配器，也需要配置FileLog，如果你想继续文件日志记录。

While CakeLog can be configured to write to a number of user
configured logging adapters, it also comes with a default logging
configuration. The default logging configuration will be
used any time there are *no other* logging adapters configured.
Once a logging adapter has been configured you will need to also
configure FileLog if you want file logging to continue.

顾名思义FileLog将日志消息写入文件。日志消息的类型名称是由存储消息的文件的名称决定的。
如果没有提供一个类型, 将使用 LOG\_ERROR 将内容写入错误日志。默认的日志位置 ``app/tmp/logs/$type.log``::

As its name implies FileLog writes log messages to files. The type
of log message being written determines the name of the file the
message is stored in. If a type is not supplied, LOG\_ERROR is used
which writes to the error log. The default log location is
``app/tmp/logs/$type.log``::

    // Executing this inside a CakePHP class
    // 在CakePHP类内部中执行
    $this->log("Something didn't work!");

    // Results in this being appended to app/tmp/logs/error.log
    // 结果会追加到 app/tmp/logs/error.log
    // 2007-11-02 10:22:02 Error: Something didn't work!

使用第一个参数来指定一个自定义日志名。FileLog类会将内容写入以这个名字命名的文件中。

You can specify a custom log name using the first parameter. The
default built-in FileLog class will treat this log name as the file
you wish to write logs to::

    // called statically
    CakeLog::write('activity', 'A special message for activity logging');

    // Results in this being appended to app/tmp/logs/activity.log (rather than error.log)
    // 2007-11-02 10:22:02 Activity: A special message for activity logging

为使日志记录正确，存放日志的目录需要让web服务器有可写权限。

The configured directory must be writable by the web server user in
order for logging to work correctly.

还可以通过 :php:meth:`CakeLog::config()` 配置日志路径。FileLog类接收一个 ``path`` 参数来指定
日志的路径。

You can configure additional/alternate FileLog locations using
:php:meth:`CakeLog::config()`. FileLog accepts a ``path`` which allows for
custom paths to be used::

    CakeLog::config('custom_path', array(
        'engine' => 'FileLog',
        'path' => '/path/to/custom/place/'
    ));

.. _writing-to-logs:

写入日志 Writing to logs
========================

写入日志文件内容有两种方式。第一个是使用静态:php:meth:`CakeLog::write()`方法::

Writing to the log files can be done in 2 different ways. The first
is to use the static :php:meth:`CakeLog::write()` method::

    CakeLog::write('debug', 'Something did not work');

第二个是使用简写名为log()的函数，适用于任何扩展自``Object``类的内部。调用log()会调用内部的
CakeLog::write()::

The second is to use the log() shortcut function available on any
class that extends ``Object``. Calling log() will internally call
CakeLog::write()::

    // Executing this inside a CakePHP class:
    $this->log("Something did not work!", 'debug');

所有配置过的日志流会按顺序调用:php:meth:`CakeLog::write()`。为了使用日志不必先配置日志流，
如果之前没有进行过配置，会使用``FileLog``核心类的``default``流，日志文件会创建在``app/tmp/logs/``，
就按照之前版本中CakeLog做的。

All configured log streams are written to sequentially each time
:php:meth:`CakeLog::write()` is called. You do not need to configure a
stream in order to use logging. If no streams are configured when
the log is written to, a ``default`` stream using the core
``FileLog`` class will be configured to output into
``app/tmp/logs/`` just as CakeLog did in previous versions.

.. _logging-scopes:

Logging Scopes
==============

.. versionadded:: 2.2

Often times you'll want to configure different logging behavior for different
subsystems or parts of your application.  Take for example an e-commerce shop.
You'll probably want to handle logging for orders and payments differently than
you do other less critical logs.

CakePHP exposes this concept as logging scopes.  When log messages are written
you can include a scope name.  If there is a configured logger for that scope,
the log messages will be directed to those loggers.  If a log message is written
to an unknown scope, loggers that handle that level of message will log the
message. For example::

    // configure tmp/logs/shops.log to receive all types (log levels), but only
    // those with `orders` and `payments` scope
    CakeLog::config('shops', array(
        'engine' => 'FileLog',
        'types' => array('warning', 'error'),
        'scopes' => array('orders', 'payments'),
        'file' => 'shops.log',
    ));

    // configure tmp/logs/payments.log to receive all types, but only
    // those with `payments` scope
    CakeLog::config('payments', array(
        'engine' => 'FileLog',
        'types' => array('info', 'error', 'warning'),
        'scopes' => array('payments'),
        'file' => 'payments.log',
    ));

    CakeLog::warning('this gets written only to shops.log', 'orders');
    CakeLog::warning('this gets written to both shops.log and payments.log', 'payments');
    CakeLog::warning('this gets written to both shops.log and payments.log', 'unknown');

In order for scopes to work correctly, you **must** define the accepted
``types`` on all loggers you want to use scopes with.

CakeLog API
===========

.. php:class:: CakeLog

	写入日志的简单类
    A simple class for writing to logs.

.. php:staticmethod:: config($name, $config)

    :param string $name: Name for the logger being connected, used
        to drop a logger later on.
    :param array $config: Array of configuration information and
        constructor arguments for the logger.

    Connect a new logger to CakeLog.  Each connected logger
    receives all log messages each time a log message is written.

.. php:staticmethod:: configured()

    :returns: An array of configured loggers.

    Get the names of the configured loggers.

.. php:staticmethod:: drop($name)

    :param string $name: Name of the logger you wish to no longer receive
        messages.

.. php:staticmethod:: write($level, $message, $scope = array())

    Write a message into all the configured loggers.
    $level indicates the level of log message being created.
    $message is the message of the log entry being written to.

    .. versionchanged:: 2.2 ``$scope`` was added

.. versionadded:: 2.2 Log levels and scopes

.. php:staticmethod:: levels()

    Call this method without arguments, eg: ``CakeLog::levels()`` to
    obtain current level configuration.

    To append the additional levels 'user0' and 'user1' to the default
    log levels use::

        CakeLog::levels(array('user0', 'user1'));
        // or
        CakeLog::levels(array('user0', 'user1'), true);

    Calling ``CakeLog::levels()`` will result in::

        array(
            0 => 'emergency',
            1 => 'alert',
            // ...
            8 => 'user0',
            9 => 'user1',
        );

    To set/replace an existing configuration, pass an array with the second
    argument set to false::

        CakeLog::levels(array('user0', 'user1'), false);

    Calling ``CakeLog::levels()`` will result in::

        array(
            0 => 'user0',
            1 => 'user1',
        );

.. php:staticmethod:: defaultLevels()

    :returns: An array of the default log levels values.

    Resets log levels to their original values::

        array(
            'emergency' => LOG_EMERG,
            'alert'     => LOG_ALERT,
            'critical'  => LOG_CRIT,
            'error'     => LOG_ERR,
            'warning'   => LOG_WARNING,
            'notice'    => LOG_NOTICE,
            'info'      => LOG_INFO,
            'debug'     => LOG_DEBUG,
        );

.. php:staticmethod:: enabled($streamName)

    :returns: boolean

    Checks whether ``$streamName`` has been enabled.

.. php:staticmethod:: enable($streamName)

    :returns: void

    Enable the stream ``$streamName``.

.. php:staticmethod:: disable($streamName)

    :returns: void

    Disable the stream ``$streamName``.

.. php:staticmethod:: stream($streamName)

    :returns: Instance of ``BaseLog`` or ``false`` if not found.

    Gets ``$streamName`` from the active streams.

Convenience methods
-------------------

.. versionadded:: 2.2

The following convenience methods were added to log ``$message`` with the
appropriate log level.

.. php:staticmethod:: emergency($message, $scope = array())
.. php:staticmethod:: alert($message, $scope = array())
.. php:staticmethod:: critical($message, $scope = array())
.. php:staticmethod:: notice($message, $scope = array())
.. php:staticmethod:: debug($message, $scope = array())
.. php:staticmethod:: info($message, $scope = array())

.. meta::
    :title lang=zh_CN: Logging
    :description lang=zh_CN: Log CakePHP data to the disk to help debug your application over longer periods of time.
    :keywords lang=zh_CN: cakephp logging,log errors,debug,logging data,cakelog class,ajax logging,soap logging,debugging,logs
