错误处理 Error Handling
##############

2.0中``Object::cakeError()``已经被移除。被很多异常方法替代。
所有的核心类，以前被称作cakeError，现在会抛出异常。这使得你要么选择在应用程序代码中处理错误
或者在内建的异常处理处理它们。

在CakePHP 2.0中关于错误和异常处理有更多的控制。您可以配置用哪些方法设置为默认的错误处理程序,
和异常处理程序。


错误配置 Error configuration
===================

错误配置是在项目程序的``app/Config/core.php``文件中，可以定义一个回调函数当每次程序遇到错误被触发。
异常配置部分见:doc:`/development/exceptions`，回调函数可以是个匿名函数。默认的错误处理配置可以是这样::

    Configure::write('Error', array(
        'handler' => 'ErrorHandler::handleError',
        'level' => E_ALL & ~E_DEPRECATED,
        'trace' => true
    ));

有5个内置的选项来配置错误处理:

* ``handler`` - callback - The callback to handle errors. You can set this to any
  callable type, including anonymous functions.
* ``level`` - int - The level of errors you are interested in capturing. Use the 
  built-in php error constants, and bitmasks to select the level of error you 
  are interested in.
* ``trace`` - boolean - Include stack traces for errors in log files.  Stack traces 
  will be included in the log after each error.  This is helpful for finding 
  where/when errors are being raised.
* ``consoleHandler`` - callback - The callback used to handle errors when
  running in the console.  If undefined, CakePHP's default handlers will be
  used.

ErrorHandler by default, displays errors when ``debug`` > 0, and logs errors when 
debug = 0.  The type of errors captured in both cases is controlled by ``Error.level``.
The fatal error handler will be called independent of ``debug`` level or ``Error.level``
configuration, but the result will be different based on ``debug`` level.

.. note::

    If you use a custom error handler, the trace setting will have no effect, 
    unless you refer to it in your error handling function.

.. versionadded:: 2.2
    The ``Error.consoleHandler`` option was added in 2.2.

.. versionchanged:: 2.2
    The ``Error.handler`` and ``Error.consoleHandler`` will receive the fatal error
    codes as well. The default behavior is show a page to internal server error
    (``debug`` disabled) or a page with the message, file and line (``debug`` enabled).

Creating your own error handler
===============================

You can create an error handler out of any callback type.  For example you could 
use a class called ``AppError`` to handle your errors.  The following would 
need to be done::

    //in app/Config/core.php
    Configure::write('Error.handler', 'AppError::handleError');

    //in app/Config/bootstrap.php
    App::uses('AppError', 'Lib');

    //in app/Lib/AppError.php
    class AppError {
        public static function handleError($code, $description, $file = null, $line = null, $context = null) {
            echo 'There has been an error!';
        }
    }

This class/method will print out 'There has been an error!' each time an error 
occurs.  Since you can define an error handler as any callback type, you could
use an anonymous function if you are using PHP5.3 or greater.::

    Configure::write('Error.handler', function($code, $description, $file = null, $line = null, $context = null) {
        echo 'Oh no something bad happened';
    });

It is important to remember that errors captured by the configured error handler will be php
errors, and that if you need custom error handling, you probably also want to configure
:doc:`/development/exceptions` handling as well.


Changing fatal error behavior
=============================

Since CakePHP 2.2 the ``Error.handler`` will receive the fatal error codes as well.
If you do not want to show the cake error page, you can override it like::

    //in app/Config/core.php
    Configure::write('Error.handler', 'AppError::handleError');

    //in app/Config/bootstrap.php
    App::uses('AppError', 'Lib');

    //in app/Lib/AppError.php
    class AppError {
        public static function handleError($code, $description, $file = null, $line = null, $context = null) {
            list(, $level) = ErrorHandler::mapErrorCode($code);
            if ($level === LOG_ERROR) {
                // Ignore fatal error. It will keep the PHP error message only
                return false;
            }
            return ErrorHandler::handleError($code, $description, $file, $line, $context);
        }
    }

If you want to keep the default fatal error behavior, you can call ``ErrorHandler::handleFatalError()``
from your custom handler.

.. meta::
    :title lang=en: Error Handling
    :keywords lang=en: stack traces,error constants,error array,default displays,anonymous functions,error handlers,default error,error level,exception handler,php error,error handler,write error,core classes,exception handling,configuration error,application code,callback,custom error,exceptions,bitmasks,fatal error
