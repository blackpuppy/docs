异常
####

异常在应用程序中可以用作不同的用途。CakePHP 在内部使用异常来表示逻辑错误或用法错误。所有 CakePHP 抛出的异常都扩展了 :php:exc:`CakeException`，类/任务相关的异常扩展了这个基类。

Exceptions can be used for a variety of uses in your application. CakePHP uses
exceptions internally to indicate logic errors or misuse. All of the exceptions
CakePHP raises extend :php:exc:`CakeException`, and there are class/task
specific exceptions that extend this base class.

CakePHP 也提供了一些异常类，可用于 HTTP 错误。欲知更多信息，可参看 :ref:`built-in-exceptions` 一节。

CakePHP also provides a number of exception classes that you can use for HTTP
errors. See the section on :ref:`built-in-exceptions` for more information.

异常的配置
=======================

Exception configuration
=======================

有一些键可用于配置异常::

There are a few keys available for configuring exceptions::

    Configure::write('Exception', array(
        'handler' => 'ErrorHandler::handleException',
        'renderer' => 'ExceptionRenderer',
        'log' => true
    ));

* ``handler`` - callback - 处理异常的回调函数。可以设置它为任何回调类型，包括匿名函数。
* ``renderer`` - string - 负责渲染未捕获异常的类。如果选择自定义类，应当把这个类的文件放入 app/Lib/Error 目录中。这个类要实现 ``render()`` 方法。
* ``log`` - boolean - 为 true 时，异常 + 它们的堆栈跟踪会被记录到 CakeLog 中。
* ``consoleHandler`` - callback - 在控制台上下文中，用来处理异常的回调函数。如果没有定义，就会使用 CakePHP 默认的处理器。

* ``handler`` - callback - The callback to handle exceptions. You can set this to
  any callback type, including anonymous functions.
* ``renderer`` - string - The class responsible for rendering uncaught exceptions.
  If you choose a custom class you should place the file for that class in app/Lib/Error.
  This class needs to implement a ``render()`` method.
* ``log`` - boolean - When true, exceptions + their stack traces will be logged
  to CakeLog.
* ``consoleHandler`` - callback - The callback used to handle exceptions, in a
  console context. If undefined, CakePHP's default handler will be used.

异常的渲染在默认情况下会显示一个 HTML 页面，你可以通过改变设置来定制处理器或者渲染器。改变处理器，让你可以完全控制异常的处理过程，而改变渲染器让你容易地改变输出类型和内容，以及加进应用程序相关的异常处理。

Exception rendering by default displays an HTML page, you can customize either the
handler or the renderer by changing the settings. Changing the handler, allows
you to take full control over the exception handling process, while changing
the renderer allows you to easily change the output type/contents, as well as
add in application specific exception handling.

.. versionadded:: 2.2
    在 2.2 版本中加入了 ``Exception.consoleHandler`` 选项。
    The ``Exception.consoleHandler`` option was added in 2.2.

Exception 类
=================

Exception classes
=================

CakePHP 中有一些异常类。每个异常取代了过去的一个 ``cakeError()`` 错误消息。异常提供了更多的灵活性，因为它们可以扩展，也可以包含一些逻辑。内置的异常处理会捕获任何未捕获的异常，渲染一个有所帮助的页面。没有特意使用 400 范围的代码的异常，会被当作内部服务器错误(*Internal Server Error*)。

There are a number of exception classes in CakePHP. Each exception replaces
a ``cakeError()`` error messages from the past. Exceptions offer additional
flexibility in that they can be extended and contain some logic. The built
in exception handling will capture any uncaught exceptions and render a useful
page. Exceptions that do not specifically use a 400 range code, will be
treated as an Internal Server Error.

.. _built-in-exceptions:

CakePHP 的内置异常
===============================

Built-in Exceptions for CakePHP
===============================

在 CakePHP 中有一些内置的异常，除了框架内部的异常，有几个专门针对 HTTP 方法(*method*)的异常

There are several built-in exceptions inside CakePHP, outside of the
internal framework exceptions, there are several
exceptions for HTTP methods

.. php:exception:: BadRequestException

    用于处理 400 Bad Request 错误。
    Used for doing 400 Bad Request error.

.. php:exception::UnauthorizedException

    用于处理 401 Not found 错误。
    Used for doing a 401 Not found error.

.. php:exception:: ForbiddenException

    用于处理 403 Forbidden 错误。
    Used for doing a 403 Forbidden error.

.. php:exception:: NotFoundException

    用于处理 404 Not found 错误。
    Used for doing a 404 Not found error.

.. php:exception:: MethodNotAllowedException

    用于处理 405 Method Not Allowed 错误。
    Used for doing a 405 Method Not Allowed error.

.. php:exception:: InternalErrorException

    用于处理 500 Internal Server 错误。
    Used for doing a 500 Internal Server Error.

.. php:exception:: NotImplementedException

    用于处理 501 Not Implemented 错误。
    Used for doing a 501 Not Implemented Errors.

你可以从控制器抛出这些异常，表示错误状态或 HTTP 错误。使用 HTTP 异常的一个例子是，可以对未找到的数据渲染 404 页面::

You can throw these exceptions from you controllers to indicate failure states,
or HTTP errors. An example use of the HTTP exceptions could be rendering 404
pages for items that have not been found::

    public function view($id) {
        $post = $this->Post->findById($id);
        if (!$post) {
            throw new NotFoundException('Could not find that post');
        }
        $this->set('post', $post);
    }

对 HTTP 错误使用异常，你可以在保持代码整洁的同时，对客户端应用程序和用户提供 RESTful 响应。

By using exceptions for HTTP errors, you can keep your code both clean, and give
RESTful responses to client applications and users.

另外，还有以下框架层的异常，会从 CakePHP 的一些核心组件抛出：

In addition, the following framework layer exceptions are available, and will
be thrown from a number of CakePHP core components:

.. php:exception:: MissingViewException

    无法找到选中的视图(*view*)文件。
    The chosen view file could not be found.

.. php:exception:: MissingLayoutException

    无法找到选中的布局(*layout*)。
    The chosen layout could not be found.

.. php:exception:: MissingHelperException

    无法找到助件(*helper*)。
    A helper was not found.

.. php:exception:: MissingBehaviorException

    无法找到配置的行为(*behavior*)。
    A configured behavior could not be found.

.. php:exception:: MissingComponentException

    无法找到配置的组件(*component*)。
    A configured component could not be found.

.. php:exception:: MissingTaskException

    无法找到配置的任务。
    A configured task was not found.

.. php:exception:: MissingShellException

    无法找到外壳类(*shelll class*)。
    The shell class could not be found.

.. php:exception:: MissingShellMethodException

    选中的外壳类(*shelll class*)没有该命名的方法。
    The chosen shell class has no method of that name.

.. php:exception:: MissingDatabaseException

    无法找到配置的数据库。
    The configured database is missing.

.. php:exception:: MissingConnectionException

    模型的连接缺失。
    A model's connection is missing.

.. php:exception:: MissingTableException

    模型的表无法在 CakePHP 的缓存或数据源中找到。在向数据源添加一个新表之后，模型缓存(默认在 tmp/cache/models 目录中)必须清除。
    A model's table is missing from CakePHP's cache or the datasource. Upon adding
    a new table to a datasource, the model cache (found in tmp/cache/models by default)
    must be removed.


.. php:exception:: MissingActionException

    无法找到请求的控制器动作。
    The requested controller action could not be found.

.. php:exception:: MissingControllerException

    无法找到请求的控制器。
    The requested controller could not be found.

.. php:exception:: PrivateActionException

    访问私有动作。或者是试图访问前缀为 private/protected/_ 的动作，或者是试图不正确地访问前缀路由。
    Private action access. Either accessing
    private/protected/_ prefixed actions, or trying
    to access prefixed routes incorrectly.

.. php:exception:: CakeException

    CakePHP 的异常基类。CakePHP 抛出的所有框架层基类要扩展这个类。
    Base exception class in CakePHP. All framework layer exceptions thrown by
    CakePHP will extend this class.

这些异常类都扩展 :php:exc:`CakeException`。通过扩展 CakeException，你可以创建自己的'框架'错误。CakePHP 抛出的所有标准异常都扩展了 CakeException。

These exception classes all extend :php:exc:`CakeException`.
By extending CakeException, you can create your own 'framework' errors.
All of the standard Exceptions that CakePHP will throw also extend CakeException.

.. versionadded:: 2.3
    添加了 CakeBaseException。
    CakeBaseException was added

.. php:exception:: CakeBaseException

    CakePHP 的异常基类。所有上面的 CakeExceptions 和 HttpException 扩展这个类。
    Base exception class in CakePHP.
    All CakeExceptions and HttpExceptions above extend this class.

.. php:method:: responseHeader($header = null, $value = null)

    参看 :php:func:`CakeResponse::header()`。
    See :php:func:`CakeResponse::header()`

所有 Http 和 CakePHP 异常扩展 CakeBaseException 类，该类有一个方法添加头部信息到响应。例如在抛出 405 MethodNotAllowedException 时，rfc2616 指出：
"响应必须包括一个 Allow 头部信息，包含一个对请求的资源的合法方法的列表。"

All Http and CakePHP exceptions extend the CakeBaseException class, which has a method
to add headers to the response. For instance when throwing a 405 MethodNotAllowedException
the rfc2616 says:
"The response MUST include an Allow header containing a list of valid methods for the requested resource."

在控制器中使用 HTTP 异常
=========================================

Using HTTP exceptions in your controllers
=========================================

你可以从控制器动作中抛出任何 HTTP 相关的异常来表示错误状态。例如::

You can throw any of the HTTP related exceptions from your controller actions
to indicate failure states. For example::

    public function view($id) {
        $post = $this->Post->read(null, $id);
        if (!$post) {
            throw new NotFoundException();
        }
        $this->set(compact('post'));
    }

上述代码会使配置的 ``Exception.handler`` 捕获和处理 :php:exc:`NotFoundException`。默认情况下，这会导致一个错误页面，并记录该异常。

The above would cause the configured ``Exception.handler`` to catch and
process the :php:exc:`NotFoundException`. By default this will create an error page,
and log the exception.

.. _error-views:

异常的渲染器
==================

Exception Renderer
==================

.. php:class:: ExceptionRenderer(Exception $exception)

在 ``CakeErrorController`` 的协助下，ExceptionRenderer 类负责为所有应用程序抛出的异常渲染错误页面。

The ExceptionRenderer class with the help of ``CakeErrorController`` takes care of rendering
the error pages for all the exceptions thrown by you application.

错误页面的视图在 ``app/View/Errors/`` 目录中。对所有 4xx 和 5xx 错误，分别使用视图文件 ``error400.ctp`` 和 ``error500.ctp``。你可以根据需要定制这些视图。默认情况下，错误页面也使用布局。如果想要对错误页面使用另一个布局，例如 ``app/Layouts/my_error.ctp``，那么只需编辑错误视图，添加语句 ``$this->layout = 'my_error';`` 到 ``error400.ctp`` 和 ``error500.ctp``。

The error page views are located at ``app/View/Errors/``. For all 4xx and 5xx errors
the view files ``error400.ctp`` and ``error500.ctp`` are used respectively. You can
customize them as per your needs. By default your ``app/Layouts/default.ctp`` is used
for error pages too. If for eg. you want to use another layout ``app/Layouts/my_error.ctp``
for your error pages, then simply edit the error views and add the statement
``$this->layout = 'my_error';`` to the ``error400.ctp`` and ``error500.ctp``.

每个框架层异常都有自己位于核心模板中的视图文件，但你真的不必定制它们，因为它们只是用在开发过程中。在关闭调试后，所有框架层异常都会转变为 ``InternalErrorException``。

Each framework layer exception has its own view file located in the core templates but
you really don't need to bother customizing them as they are used only during development.
With debug turned off all framework layer exceptions are converted to ``InternalErrorException``.

.. index:: application exceptions

创建你自己的应用程序的异常
========================================

Creating your own application exceptions
========================================

你可以使用任何内置的 `SPL exceptions <http://php.net/manual/en/spl.exceptions.php>`_ 、 ``Exception``
本身或 :php:exc:`CakeException` 来创建你自己的应用程序的异常。扩展 Exception 类或者 SPL 异常的应用程序异常在生成模式下会被当作 500 错误对待。:php:exc:`CakeException` 比较特别，所有 :php:exc:`CakeException`  对象会根据它们使用的编码被强制转换为 500 或 404 错误。在开发模式下，:php:exc:`CakeException` 对象只需一个匹配类名的模板就能提供有用的信息。如果应用程序包含如下异常::

You can create your own application exceptions using any of the built
in `SPL exceptions <http://php.net/manual/en/spl.exceptions.php>`_, ``Exception``
itself, or :php:exc:`CakeException`. Application exceptions that extend
Exception or the SPL exceptions will be treated as 500 error in production mode.
:php:exc:`CakeException` is special in that all :php:exc:`CakeException` objects
are coerced into either 500 or 404 errors depending on the code they use.
When in development mode :php:exc:`CakeException` objects simply need a new template
that matches the class name in order to provide useful information. If your
application contained the following exception::

    class MissingWidgetException extends CakeException {};

你可以创建 ``app/View/Errors/missing_widget.ctp``，就能提供良好的开发错误提示。在生产模式下，上述错误会被当作 500 错误。:php:exc:`CakeException` 的构造函数被扩展了，让你可以传入数据数组。该数组会被嵌入 messageTemplate 模板、以及在开发模式下表示错误的视图中。这让你可以通过提供错误的上下文来创建富含数据的异常。你也可以提供消息模板，让原生的 ``__toString()`` 方法可以正常工作::

You could provide nice development errors, by creating
``app/View/Errors/missing_widget.ctp``. When in production mode, the above
error would be treated as a 500 error. The constructor for :php:exc:`CakeException`
has been extended, allowing you to pass in hashes of data. These hashes are
interpolated into the the messageTemplate, as well as into the view that is used
to represent the error in development mode. This allows you to create data rich
exceptions, by providing more context for your errors. You can also provide a message
template which allows the native ``__toString()`` methods to work as normal::


    class MissingWidgetException extends CakeException {
        protected $_messageTemplate = 'Seems that %s is missing.';
    }

    throw new MissingWidgetException(array('widget' => 'Pointy'));


当被内置的异常处理器捕获时，在错误视图模板中会得到一个 ``$widget`` 变量。而且，如果把异常转换(*cast*)为字符串，或者调用它的 ``getMessage()`` 方法，就会得到 ``Seems that Pointy is missing.``。'这让你可以轻松快速地创建你自己富含(信息)的开发错误，就像 CakePHP 内部使用的一样。

When caught by the built-in exception handler, you would get a ``$widget``
variable in your error view template. In addition if you cast the exception
as a string or use its ``getMessage()`` method you will get
``Seems that Pointy is missing.``. This allows you easily and quickly create
your own rich development errors, just like CakePHP uses internally.

创建自定义状态编码
----------------------------

Creating custom status codes
----------------------------

在创建异常时改变编码，就能创建自定义的 HTTP 状态编码::

You can create custom HTTP status codes by changing the code used when
creating an exception::

    throw new MissingWidgetHelperException('Its not here', 501);

就会创建一个 ``501`` 响应编码，你可以使用任何 HTTP 状态编码。在开发中，如果你的异常没有一个特定的模板，而你使用了大于等于 ``500`` 的编码，你就会看到 ``error500`` 模板。对于任何其它错误编码，就会得到 ``error400`` 模板。如果你为自定义异常定义了错误模板，在开发模式下就会使用该模板。如果你甚至在生产环境中也要使用自己的异常处理逻辑，请看下一节。

Will create a ``501`` response code, you can use any HTTP status code
you want. In development, if your exception doesn't have a specific
template, and you use a code equal to or greater than ``500`` you will
see the ``error500`` template. For any other error code you'll get the
``error400`` template. If you have defined an error template for your
custom exception, that template will be used in development mode.
If you'd like your own exception handling logic even in production,
see the next section.

扩展和实现你自己的异常处理器
======================================================

Extending and implementing your own Exception handlers
======================================================

你有几种方式实现应用程序相关的异常处理。每种方式给你提供对异常处理过程的不同控制。

- 设置 ``Configure::write('Exception.handler', 'YourClass::yourMethod');``
- 创建 ``AppController::appError();``
- 设置 ``Configure::write('Exception.renderer', 'YourClass');``

You can implement application specific exception handling in one of a
few ways. Each approach gives you different amounts of control over
the exception handling process.

- Set ``Configure::write('Exception.handler', 'YourClass::yourMethod');``
- Create ``AppController::appError();``
- Set ``Configure::write('Exception.renderer', 'YourClass');``

在下面几节中，我们会详细描述每种方式不同的方法和好处。

In the next few sections, we will detail the various approaches and the benefits each has.

用 `Exception.handler` 创建你自己的异常处理器
==========================================================

Create your own Exception handler with `Exception.handler`
==========================================================

创建你自己的异常处理器，给你提供了对异常处理过程的完全控制。你选择的类应当在 ``app/Config/bootstrap.php`` 文件中加载，这样它才能够用于处理任何异常。你可以把处理器定义为任何回调类型。设置了 ``Exception.handler``，CakePHP 就会忽略所有其它的异常设置。一个自定义异常处理设置可以象下面这样::

Creating your own exception handler gives you full control over the exception
handling process. The class you choose should be loaded in your
``app/Config/bootstrap.php``, so it's available to handle any exceptions. You can
define the handler as any callback type. By settings ``Exception.handler`` CakePHP
will ignore all other Exception settings. A sample custom exception handling setup
could look like::

    // in app/Config/core.php
    Configure::write('Exception.handler', 'AppExceptionHandler::handle');

    // in app/Config/bootstrap.php
    App::uses('AppExceptionHandler', 'Lib');

    // in app/Lib/AppExceptionHandler.php
    class AppExceptionHandler {
        public static function handle($error) {
            echo 'Oh noes! ' . $error->getMessage();
            // ...
        }
        // ...
    }

你可以在 ``handleException`` 方法中运行任何你想要运行的代码。上面的代码会输出 'Oh noes! ' 加上异常消息。你可以定义处理器为任何类型的回调，如果使用 PHP 5.3 甚至可以是匿名函数::

You can run any code you wish inside ``handleException``. The code above would
simple print 'Oh noes! ' plus the exception message. You can define exception
handlers as any type of callback, even an anonymous function if you are
using PHP 5.3::

    Configure::write('Exception.handler', function ($error) {
        echo 'Ruh roh ' . $error->getMessage();
    });

通过创建自定义异常处理器，你可以为应用程序的异常提供自定义错误处理。在提供作为异常处理器的方法中，你可以这么做::

By creating a custom exception handler you can provide custom error handling for
application exceptions. In the method provided as the exception handler you
could do the following::

    // in app/Lib/AppErrorHandler.php
    class AppErrorHandler {
        public static function handleException($error) {
            if ($error instanceof MissingWidgetException) {
                return self::handleMissingWidget($error);
            }
            // 做其它事情。
            // do other stuff.
        }
    }

.. index:: appError

使用 AppController::appError();
================================

Using AppController::appError();
================================

实现该方法是实现自定义异常处理器的另一种方法。

Implementing this method is an alternative to implementing a custom exception
handler. It's primarily provided for backwards compatibility, and is not
recommended for new applications. This controller method is called instead of
the default exception rendering. It receives the thrown exception as its only
argument. You should implement your error handling in that method::

    class AppController extends Controller {
        public function appError($error) {
            // custom logic goes here.
        }
    }

Using a custom renderer with Exception.renderer to handle application exceptions
================================================================================

If you don't want to take control of the exception handling, but want to change
how exceptions are rendered you can use ``Configure::write('Exception.renderer',
'AppExceptionRenderer');`` to choose a class that will render exception pages.
By default :php:class`ExceptionRenderer` is used. Your custom exception
renderer class should be placed in ``app/Lib/Error``. Or an ``Error```
directory in any bootstrapped Lib path. In a custom exception rendering class
you can provide specialized handling for application specific errors::

    // in app/Lib/Error/AppExceptionRenderer.php
    App::uses('ExceptionRenderer', 'Error');

    class AppExceptionRenderer extends ExceptionRenderer {
        public function missingWidget($error) {
            echo 'Oops that widget is missing!';
        }
    }


The above would handle any exceptions of the type ``MissingWidgetException``,
and allow you to provide custom display/handling logic for those application
exceptions. Exception handling methods get the exception being handled as
their argument.

.. note::

    Your custom renderer should expect an exception in its constructor, and
    implement a render method. Failing to do so will cause additional errors.

.. note::

    If you are using a custom ``Exception.handler`` this setting will have
    no effect. Unless you reference it inside your implementation.

Creating a custom controller to handle exceptions
-------------------------------------------------

In your ExceptionRenderer sub-class, you can use the ``_getController``
method to allow you to return a custom controller to handle your errors.
By default CakePHP uses ``CakeErrorController`` which omits a few of the normal
callbacks to help ensure errors always display. However, you may need a more
custom error handling controller in your application. By implementing
``_getController`` in your ``AppExceptionRenderer`` class, you can use any
controller you want::

    class AppExceptionRenderer extends ExceptionRenderer {
        protected function _getController($exception) {
            App::uses('SuperCustomError', 'Controller');
            return new SuperCustomErrorController();
        }
    }

Alternatively, you could just override the core CakeErrorController,
by including one in ``app/Controller``. If you are using a custom
controller for error handling, make sure you do all the setup you need
in your constructor, or the render method. As those are the only methods
that the built-in ``ErrorHandler`` class directly call.


Logging exceptions
------------------

Using the built-in exception handling, you can log all the exceptions
that are dealt with by ErrorHandler by setting ``Exception.log`` to true
in your core.php. Enabling this will log every exception to :php:class:`CakeLog`
and the configured loggers.

.. note::

    If you are using a custom ``Exception.handler`` this setting will have
    no effect. Unless you reference it inside your implementation.


.. meta::
    :title lang=zh_CN: Exceptions
    :keywords lang=zh_CN: uncaught exceptions,stack traces,logic errors,anonymous functions,renderer,html page,error messages,flexibility,lib,array,cakephp,php
