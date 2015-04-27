调度器过滤器
##################

.. versionadded:: 2.2

有若干原因，要在任何控制器代码执行之前或者在响应即将被发送往客户端之前运行一段代码，例如响应缓存、标头(*header*)调整、特殊的用户验证，或者只是要在比完整请求调度周期更短的时间内提供对关键任务 API 响应的访问。

There are several reasons to want a piece of code to be run before any
controller code is executed or right before the response is sent to the client,
such as response caching, header tuning, special authentication or just to
provide access to a mission-critical
API response in lesser time than a complete
request dispatching cycle would take.

CakePHP 为这些情况提供了清晰和可扩展的接口，在调度周期中附加过滤器，类似于为每个请求提供可堆叠的服务或者例程的中间件层。我们把这些叫做 `调度器过滤器(*Dispatcher Filters*)`。

CakePHP provides for such cases a clean and extensible interface for attaching
filters to this dispatching cycle, similar to a middleware layer thought to
provide stackable services or routines for every request. We call them
`Dispatcher Filters`

配置过滤器
===================

Configuring Filters
===================

过滤器通常在 ``bootstrap.php`` 文件中配置，但你可以在请求被调度之前从任何其它配置文件容易地加载它们。添加或去除过滤器通过 `Configure` 类进行，使用特殊的键 ``Dispatcher.filters``。默认情况下 CakePHP 自带的一些过滤器类已经对所有请求启用，让我们看看它们是怎么添加的::

Filters are usually configured in the ``bootstrap.php`` file, but you could easily
load them from any other configuration file before the request is dispatched.
Adding and removing filters is done through the `Configure` class, using the
special key ``Dispatcher.filters``. By default CakePHP comes with a couple filter
classes already enabled for all requests, let's take a look at how they are
added::

    Configure::write('Dispatcher.filters', array(
        'AssetDispatcher',
        'CacheDispatcher'
    ));

每个数组值是类名，类会被实例化，添加作为在调度器级别产生的事件的监听器(*listener*)。第一个，``AssetDispatcher`` 类用来检查请求是否指向一个主题(*theme*)或插件(*plugin*)的资源文件，比如保存在插件的 webroot 目录或者主题的相应目录中的 CSS、JavaScript 或图像。如果文件存在，它会提供相应的文件，停止其余的调度周期。``CacheDispatcher`` 过滤器，当 ``Cache.check`` 配置变量为启用时，会检查响应是否已经在文件系统中对类似的请求进行了缓存，并立即提供缓存的代码。

Each of those array values are class names that will be instantiated and added
as listeners for the events generated at dispatcher level. The first one,
``AssetDispatcher`` is meant to check whether the request is referring to a theme
or plugin asset file, such as a CSS, JavaScript or image stored on either a
plugin's webroot folder or the corresponding one for a Theme. It will serve the
file accordingly if found, stopping the rest of the dispatching cycle. The ``CacheDispatcher``
filter, when ``Cache.check`` config variable is enabled, will check if the
response was already cached in the file system for a similar request and serve
the cached code immediately.

如你所见，自带的两个过滤器都负责停止进一步代码的执行，立即发送响应到客户端。但过滤器并不仅限于这样的角色，如我们在本节即将展示的。

As you can see, both provided filters have the responsibility of stopping any
further code and send the response right away to the client. But filters are not
limited to this role, as we will show shortly in this section.

你可以在过滤器列表中加入自己的类名，它们会以定义的顺序执行。也有另外一种方法来附加不涉及特殊的 ``DispatcherFilter`` 类的过滤器::

You can add your own class names to the list of filters, and they will get
executed in the order they were defined. There is also an alternative way for
attaching filters that do not involve the special ``DispatcherFilter`` classes::

    Configure::write('Dispatcher.filters', array(
        'my-filter' => array(
            'callable' => array($classInstance, 'methodName'),
            'on' => 'after'
        )
    ));

如上所述，你可以传入任何合法的 PHP  `回调(*callback*) <http://php.net/callback>`_ 类型，允许你还记得，`回调`是任何 PHP 可以用 ``call_user_func`` 函数执行的东西。我们有一个小的例外，如果提供了字符串，这将被作为类名对待，而不是可能的函数名。这当然让 PHP 5.3 的用户可以附加匿名函数作为过滤器::

As shown above, you can pass any valid PHP `callback <http://php.net/callback>`_
type, as you may remember, a `callback` is anything that PHP can execute with
``call_user_func``. We do make a little exception, if a string is provided it will
be treated as a class name, not as a possible function name. This of course
gives the ability to PHP 5.3 users to attach anonymous functions as filters::

    Configure::write('Dispatcher.filters', array(
       'my-filter' => array('callable' => function($event) {...}, 'on' => 'before'),
       //更多过滤器
       //more filters here
    ));


``on`` 键只接受 ``before`` 和 ``after`` 为合法值，很明显，这意味着过滤器应当在控制器代码执行之前或之后运行。除了用 ``callable`` 键定义过滤器，你也可以定义过滤器的优先级，如果未指定，就使用默认值 ``10``。

The ``on`` key only takes ``before`` and ``after`` as valid values, and evidently
means whether the filter should run before or after any controller code is
executed. Additionally to defining filters with the ``callable`` key, you also
get the chance to define a priority for your filters, if none is specified then
a default of ``10`` is selected for you

既然所有过滤器都具有优先级 ``10``，如果你要某个过滤器在列表中的任何其它过滤器之前运行，根据需要选择较低的优先级::

As all filters will have default priority ``10``, should you want to run a filter before
any other in the list, select lower priority numbers as needed::

    Configure::write('Dispatcher.filters', array(
       'my-filter' => array(
            'callable' => function($event) {...},
            'on' => 'before',
            'priority' => 5
        ),
        'other-filter' => array(
            'callable' => array($class, 'method'),
            'on' => 'after',
            'priority' => 1
        ),
       //更多过滤器
       //more filters here
    ));

显然，在定义优先级时，过滤器声明的顺序，对除了相同优先级的过滤器，没有关系。在以类名定义过滤器时，无法同时定义优先级，我们很快就会谈及这点。最后，CakePHP 的插件语法可以用于定义位于插件内的过滤器::

Obviously, when defining priorities the order in which filters are declared does
not matter but for those having the same. When defining filters as class names
there is no option to define priority in-line, we will get into that soon.
Finally, CakePHP's plugin notation can be used to define filters located in
plugins::

    Configure::write('Dispatcher.filters', array(
        'MyPlugin.MyFilter',
    ));

只管移除默认附加的过滤器，如果你选择使用更高级/快速的方法来提供主题和插件的资源，或者你不愿使用内置的完整页面缓存，或者只是要实现你自己的过滤器。

Feel free to remove the default attached filters if you choose to use a more
advanced/faster way of serving theme and plugin assets or if you do not wish to
use built-in full page caching, or just implement your own.

如果你需要传递构造函数参数或设置给你的调度过滤器类，你可以通过提供设置数组来这么做::

If you need to pass constructor parameters or settings to you dispatch filter
classes you can do that by providing an array of settings::

    Configure::write('Dispatcher.filters', array(
        'MyAssetFilter' => array('service' => 'google.com')
    ));

当过滤器键是一个合法的类名时，值可以是传递给调度过滤器的参数数组。默认情况下，基类会在把这些设置与类的默认值合并后，赋值给 ``$settings`` 属性。

When the filter key is a valid classname, the value can be an array of
parameters that are passed to the dispatch filter. By default the base class
will assign these settings to the ``$settings`` property after merging them with
the defaults in the class.

.. versionchanged:: 2.5
    在 2.5 版本中，你可以为调度过滤器提供构造函数设置。
    You can now provide constructor settings to dispatch filters in 2.5.

过滤器类
==============

Filter Classes
==============

调度器过滤器，在配置中以类名定义时，应当扩展在 CakePHP 的 `Routing` 目录中提供的类 ``DispatcherFilter`` 。让我们来创建一个简单的过滤器，对特殊网址作出 'Hello World' 文字的响应::

Dispatcher filters, when defined as class names in configuration, should extend
the class ``DispatcherFilter`` provided in the `Routing` CakePHP's directory.
Let's create a simple filter to respond to a specific URL with a 'Hello World'
text::

    App::uses('DispatcherFilter', 'Routing');
    class HelloWorldFilter extends DispatcherFilter {

        public $priority = 9;

        public function beforeDispatch(CakeEvent $event) {
            $request = $event->data['request'];
            $response = $event->data['response'];

            if ($request->url === 'hello-world') {
                $response->body('Hello World');
                $event->stopPropagation();
                return $response;
            }
        }
    }

该类应当保存于文件 ``app/Routing/Filter/HelloWorldFilter.php`` 中，并在启动引导(*bootstrap*)文件中按照前一节中说明的进行配置。这里有很多需要解释，让我们先从 ``$priority`` 的值开始。

This class should be saved in a file in ``app/Routing/Filter/HelloWorldFilter.php``
and configured in the bootstrap file according to how it was explained in the
previous section. There is plenty to explain here, let's begin with the
``$priority`` value.

如前所述，在使用过滤器类时你只能用类的 ``$priority`` 属性定义过滤器运行的顺序，如果声明了属性其默认值为 10，这意味着它会在 Router 类解析了请求_之后_执行。在前面的例子中我们不希望这样，因为大多数情况下你大概没有设置任何控制器来应答那个网址，所以我们选择 9 作为我们的优先级。

As mentioned before, when using filter classes you can only define the order in
which they are run using the ``$priority`` property in the class, default value is
10 if the property is declared, this means that it will get executed _after_ the
Router class has parsed the request. We do not want this to happen in our
previous example, because most probably you do not have any controller set up
for answering to that URL, hence we chose 9 as our priority.

``DispatcherFilter`` 类提供了两个方法，可以在子类中重载，即 ``beforeDispatch`` 和 ``afterDispatch`` 方法，它们分别在任何控制器执行之前或之后执行。两个方法都接受一个 :php:class:`CakeEvent` 对象，它含有 ``request`` 和 ``response`` 对象(:php:class:`CakeRequest` 和 :php:class:`CakeResponse` 实例)，以及在 ``data`` 属性中的 ``additionalParams`` 数组。后者包含的信息用于调用 ``requestAction`` 方法时的内部调度。

``DispatcherFilter`` exposes two methods that can be overridden in subclasses,
they are ``beforeDispatch`` and ``afterDispatch``, and are executed before or after
any controller is executed respectively. Both methods receive a  :php:class:`CakeEvent`
object containing the ``request`` and ``response`` objects
(:php:class:`CakeRequest` and :php:class:`CakeResponse` instances) along with an
``additionalParams`` array inside the ``data`` property. The latter contains
information used for internal dispatching when calling ``requestAction``.

在我们的例子中，我们有条件地返回 ``$response`` 对象作为结果，这会告诉调度器不要实例化任何控制器，并立即返回该对象给客户端。我们也添加了 ``$event->stopPropagation()`` 来防止在该过滤器之后运行其它过滤器。

In our example we conditionally returned the ``$response`` object as a result,
this will tell the Dispatcher to not instantiate any controller and return such
object as response immediately to the client. We also added
``$event->stopPropagation()`` to prevent other filters from being executed after
this one.

现在让我们再创建一个过滤器，来改变任何公开页面的相应标头(*header*)，在我们的情况下这将是任何从 ``PagesController` 控制器提供的东西::

Let's now create another filter for altering response headers in any public
page, in our case it would be anything served from the ``PagesController``::

    App::uses('DispatcherFilter', 'Routing');
    class HttpCacheFilter extends DispatcherFilter {

        public function afterDispatch(CakeEvent $event) {
            $request = $event->data['request'];
            $response = $event->data['response'];

            if ($request->params['controller'] !== 'pages') {
                return;
            }
            if ($response->statusCode() === 200) {
                $response->sharable(true);
                $response->expires(strtotime('+1 day'));
            }
        }
    }

该过滤器会为 pages 控制器生成的所有相应发送一个将来 1 天的过期标头(*expiration header*)。你当然可以在控制器中这么做，这只是过滤器能够做什么的一个例子，例如，除了改变响应，你可以用 :php:class:`Cache` 类缓存响应，并在 ``beforeDispatch`` 回调中提供该响应。

This filter will send a expiration header to 1 day in the future for
all responses produced by the pages controller. You could of course do the same
in the controller, this is just an example of what could be done with filters.
For instance, instead of altering the response you could cache it using the
:php:class:`Cache` class and serve the response from the ``beforeDispatch``
callback.

内嵌过滤器
==============

Inline Filters
==============

我们的最后一个例子会使用匿名函数(只适用于 PHP 5.3+)来提供 JSON 格式的文章列表，我们鼓励你用控制器和 :php:class:`JsonView` 类来达成此目的，不过让我们假设你需要为这个关键任务的 API 端点节省几毫秒::

Our last example will use an anonymous function (only available on PHP 5.3+) to
serve a list of posts in JSON format, we encourage you to do so using
controllers and the :php:class:`JsonView` class, but let's imagine you need to save a
few milliseconds for this mission-critical API endpoint::

    $postsList = function($event) {
        if ($event->data['request']->url !== 'posts/recent.json') {
            return;
        }
        App::uses('ClassRegistry', 'Utility');
        $postModel = ClassRegistry::init('Post');
        $event->data['response']->body(json_encode($postModel->find('recent')));
        $event->stopPropagation();
        return $event->data['response'];
    };

    Configure::write('Dispatcher.filters', array(
        'AssetDispatcher',
        'CacheDispatcher',
        'recent-posts' => array(
            'callable' => $postsList,
            'priority' => 9,
            'on'=> 'before'
        )
    ));

在这个例子中我们为过滤器选择了优先级 ``9``，这样就可以跳过任何在自定义过滤器或者象 CakePHP 内部路由系统这样的核心过滤器中的逻辑了。虽然并非必须，这说明如果你要针对某些请求尽可能去除多余的累赘，如何让重要代码抢先运行。

In previous example we have selected a priority of ``9`` for our filter, so to skip
any other logic either placed in custom or core filters such as CakePHP internal
routing system. Although it is not required, it shows how to make your important
code run first in case you need to trim as much fat as possible from some requests.

基于很明显的原因，这可能让你的应用程序很难维护。如果明智地运用，过滤器是极其强大的工具，为应用程序中的每个网址添加响应处理并非是对它很好的运用。但是如果你有合理的原因这么做，那么你就手握一个清晰的解决方案。请牢记，并非所有的东西都要是过滤器，`Controllers` 和 `Components` 通常是为应用程序添加请求处理更准确的选择。

For obvious reasons this has the potential of making your app very difficult
to maintain. Filters are an extremely powerful tool when used wisely, adding
response handlers for each URL in your app is not a good use for it. But if you
got a valid reason to do so, then you have a clean solution at hand. Keep in
mind that not everything needs to be a filter, `Controllers` and `Components` are
usually a more accurate choice for adding any request handling code to your app.


.. meta::
    :title lang=zh_CN: Dispatcher Filters
    :description lang=zh_CN: Dispatcher filters are a middleware layer for CakePHP allowing to alter the request or response before it is sent
    :keywords lang=zh_CN: middleware, filters, dispatcher, request, response, rack, application stack, events, beforeDispatch, afterDispatch, router
