路由
#######

路由(*routing*)是把网址(*URL*)映射到控制器动作的功能。这个功能添加到 CakePHP 中，是为了使友好网址更容易配置和更加灵活。使用路由不要求一定要用 Apache 的 mod\_rewrite 模块，不过这会使地址栏看起来更加整洁。

Routing is a feature that maps URLs to controller actions. It was
added to CakePHP to make pretty URLs more configurable and
flexible. Using Apache's mod\_rewrite is not required for using
routes, but it will make your address bar look much more tidy.

CakePHP 的路由还包括反向路由的思想，即，参数数组可以逆转成字符串网址。使用反向路由，你就可以轻松地重构应用程序的网址结构，而无需更新所有的代码。

Routing in CakePHP also encompasses the idea of reverse routing,
where an array of parameters can be reversed into a string URL.
By using reverse routing, you can easily re-factor your application's
URL structure without having to update all your code.

.. index:: routes.php

.. _routes-configuration:

路由的配置
====================

Routes Configuration
====================

应用程序中的路由是在 ``app/Config/routes.php`` 中配置的。当处理路由被 :php:class:`Dispatcher` 引入，让你可以定义应用程序要使用的特定路由。在该文件中声明的路由从上而下处理，直到收到的请求匹配。这意味着放置路由的顺序会影响路由的解析。通常好的做法是，把最常访问的路由尽可能放在路由文件的最上面。这可以省去对每个请求不得不检查若干个不能匹配的路由。

Routes in an application are configured in ``app/Config/routes.php``.
This file is included by the :php:class:`Dispatcher` when handling routes
and allows you to define application specific routes you want used. Routes
declared in this file are processed top to bottom when incoming requests
are matched. This means that the order you place routes can affect how
routes are parsed. It's generally a good idea to place most frequently
visited routes at the top of the routes file if possible. This will
save having to check a number of routes that won't match on each request.

路由以它们连入的顺序来解析和匹配。如果你定义两个类似的路由，定义的第一个路由比后定义的那个有更高的优先级。在连接路由之后，你可以使用 :php:meth:`Router::promote()` 来操纵路由的顺序。

Routes are parsed and matched in the order they are connected in.
If you define two similar routes, the first defined route will
have higher priority over the one defined latter. After connecting routes you
can manipulate the order of routes using :php:meth:`Router::promote()`.

CakePHP 也带有一些默认的路由帮你开始。以后如果你肯定不需要它们了，可以把它们关闭。欲知如何关闭默认的路由，请参见 :ref:`disabling-default-routes`。

CakePHP also comes with a few default routes to get you started. These
can be disabled later on once you are sure you don't need them.
See :ref:`disabling-default-routes` on how to disable the default routing.


默认的路由
==========

Default Routing
===============

在了解如何配置自己的路由之前，你应当知道 CakePHP 带有一组默认的路由。CakePHP 的默认路由适用于任何应用程序的很多情况。把一个动作的名称放入请求中，就可以直接从网址访问该动作。也可以用网址传递参数到控制器动作。::

Before you learn about configuring your own routes, you should know
that CakePHP comes configured with a default set of routes.
CakePHP's default routing will get you pretty far in any
application. You can access an action directly via the URL by
putting its name in the request. You can also pass parameters to
your controller actions using the URL.::

        URL pattern default routes:
        http://example.com/controller/action/param1/param2/param3

网址 /posts/view 映射到 PostsController 的 view() 动作，而网址 /products/view\_clearance 映射到 ProductsController 的 view\_clearance() 动作。

The URL /posts/view maps to the view() action of the
PostsController, and /products/view\_clearance maps to the
view\_clearance() action of the ProductsController. If no action is
specified in the URL, the index() method is assumed.

默认的路由设置也让你可以用网址传递参数到动作。例如，对 /posts/view/25 的请求等于调用 PostsController 的 view(25)。默认的路由也提供插件的路由、前缀路由，如果你选择使用这些功能的话。

The default routing setup also allows you to pass parameters to
your actions using the URL. A request for /posts/view/25 would be
equivalent to calling view(25) on the PostsController, for
example. The default routing also provides routes for plugins,
and prefix routes should you choose to use those features.

内置的路由位于 ``Cake/Config/routes.php``。你可以通过在应用程序的 :term:`routes.php` 文件中去掉默认路由来关闭它们。

The built-in routes live in ``Cake/Config/routes.php``. You can
disable the default routing by removing them from your application's
:term:`routes.php` file.

.. index:: :controller, :action, :plugin
.. _connecting-routes:

连接路由
========

Connecting Routes
=================

定义你自己的路由让你可以定义应用程序如何对一个给定的网址作出反应。用 :php:meth:`Router::connect()` 方法在 ``app/Config/routes.php`` 文件中定义定义自己的路由。

Defining your own routes allows you to define how your application
will respond to a given URL. Define your own routes in the
``app/Config/routes.php`` file using the :php:meth:`Router::connect()`
method.

``connect()`` 方法接受最多三个参数：希望匹配的网址、路由元素的默认值、和帮助路由匹配网址中的元素的正则表达式规则。

The ``connect()`` method takes up to three parameters: the URL you
wish to match, the default values for your route elements, and
regular expression rules to help the router match elements in the
URL.

路由定义的基本格式为::

The basic format for a route definition is::

    Router::connect(
        'URL',
        array('default' => 'defaultValue'),
        array('option' => 'matchingRegex')
    );

第一个参数用来告诉路由器你要控制哪种网址。网址是斜线分隔的普通字符串，但也可以包含通配符(\*)或者 :ref:`route-elements`。使用通配符告诉路由器，你愿意接受任何提供的额外参数。不含\*的路由只匹配提供的模板模式。

The first parameter is used to tell the router what sort of URL
you're trying to control. The URL is a normal slash delimited
string, but can also contain a wildcard (\*) or :ref:`route-elements`.
Using a wildcard tells the router that you are willing to accept
any additional arguments supplied. Routes without a \* only match
the exact template pattern supplied.

一旦指定了网址，用 ``connect()`` 的最后两个参数来告诉 CakePHP，一旦一个请求匹配了，要如何处理它。第二个参数是一个关联数组。数组的键应当以网址中的路由元素来命名，或者是默认元素： ``:controller`` 、 ``:action`` 和 ``:plugin``。数组中的值是这些键的缺省值。让我们看一些基本的例子，再来看如何使用 connect() 的第三个参数::

Once you've specified a URL, you use the last two parameters of
``connect()`` to tell CakePHP what to do with a request once it has
been matched. The second parameter is an associative array. The
keys of the array should be named after the route elements in the
URL, or the default elements: ``:controller``, ``:action``, and ``:plugin``.
The values in the array are the default values for those keys.
Let's look at some basic examples before we start using the third
parameter of connect()::

    Router::connect(
        '/pages/*',
        array('controller' => 'pages', 'action' => 'display')
    );

以上这个路由在随 CakePHP 发布的 routes.php 文件中。该路由匹配任何以 ``/pages/`` 开始的网址，并把它交给 ``PagesController();`` 的 ``display()`` 动作。请求t /pages/products 会映射到``PagesController->display('products')``。

This route is found in the routes.php file distributed with CakePHP.
This route matches any URL starting with ``/pages/`` and
hands it to the ``display()`` action of the ``PagesController();``
The request /pages/products would be mapped to
``PagesController->display('products')``.

除了贪婪的星号 ``/*``，还有 ``/**`` 后缀星号语法。使用后缀双星号，会捕获网址的其余部分为一个传入参数。当你要使用含有 ``/`` 的参数时就有用了。

In addition to the greedy star ``/*`` there is also the ``/**`` trailing star
syntax. Using a trailing double star, will capture the remainder of a URL as a
single passed argument. This is useful when you want to use an argument that
included a ``/`` in it::

    Router::connect(
        '/pages/**',
        array('controller' => 'pages', 'action' => 'show')
    );

传入的网址 ``/pages/the-example-/-and-proof`` 会导致单个传入参数 ``the-example-/-and-proof``。

The incoming URL of ``/pages/the-example-/-and-proof`` would result in a single
passed argument of ``the-example-/-and-proof``.

.. versionadded:: 2.1

    在 2.1 版本中增加了后缀双星号。

    The trailing double star was added in 2.1.

你可以使用 :php:meth:`Router::connect()` 的第二个参数来提供任何由路由的默认值组成的路由参数::

You can use the second parameter of :php:meth:`Router::connect()`
to provide any routing parameters that are composed of the default values
of the route::

    Router::connect(
        '/government',
        array('controller' => 'pages', 'action' => 'display', 5)
    );

这个例子说明如何使用 ``connect()`` 方法的第二个参数来定义默认参数。如果你构建一个网站，有针对不同类别客户的产品，你也许会考虑创建一个路由。这让你可以链接 ``/government``，而不是 ``/pages/display/5``。

This example shows how you can use the second parameter of
``connect()`` to define default parameters. If you built a site
that features products for different categories of customers, you
might consider creating a route. This allows you link to
``/government`` rather than ``/pages/display/5``.

.. note::

    尽管你可以连接不同的路由，默认的路由还是会继续有效。这可能会造成某些情况下，内容会有 2 个网址。欲知如何关闭默认路由，及只提供你定义的网址，请参看 :ref:`disabling-default-routes`。

    Although you can connect alternate routes, the default routes
    will continue to work. This could create situations, where
    content could end up with 2 URLs. See :ref:`disabling-default-routes`
    to disable default routes, and only provide the URLs you define.

另一个路由器的常见用法是为控制器定义"别名"。比方说，我们不要访问通常的网址 ``/users/some_action/5``，希望能够通过 ``/cooks/some_action/5`` 来访问。下面的路由轻易地实现了::

Another common use for the Router is to define an "alias" for a
controller. Let's say that instead of accessing our regular URL at
``/users/some_action/5``, we'd like to be able to access it by
``/cooks/some_action/5``. The following route easily takes care of
that::

    Router::connect(
        '/cooks/:action/*', array('controller' => 'users')
    );

这就是告诉路由器，任何以 ``/cooks/`` 开始的网址应当交给用户控制器。调用的动作取决于 ``:action`` 参数的值。使用 :ref:`route-elements`，就能够创造路由变量，接受用户输入或者变量。上面的路由也使用了贪婪的星号。贪婪的星号告诉 :php:class:`Router`，这个路由应当接受任何给定的额外位置参数。这些参数会被放入 :ref:`passed-arguments` 数组供访问。

This is telling the Router that any url beginning with ``/cooks/``
should be sent to the users controller. The action called will
depend on the value of the ``:action`` parameter. By using
:ref:`route-elements`, you can create variable routes, that accept
user input or variables. The above route also uses the greedy star.
The greedy star indicates to :php:class:`Router` that this route
should accept any additional positional arguments given. These
arguments will be made available in the :ref:`passed-arguments`
array.

当生成网址时，也使用路由。如果上述路由最先匹配，使用 ``array('controller' => 'users', 'action' => 'some_action', 5)`` 作为网址，就会输出 /cooks/some_action/5。

When generating URLs, routes are used too. Using
``array('controller' => 'users', 'action' => 'some_action', 5)`` as
a url will output /cooks/some_action/5 if the above route is the
first match found.

默认情况下，所有命名(*named*)和传入(*passed*)参数会从匹配贪婪模板的网址中提取。不过，如果需要，可以使用 :php:meth:`Router::connectNamed()` 来配置哪个命名参数如何解析。

By default all named and passed arguments are extracted from URLs matching
greedy templates. However, you can configure how and which named arguments are
parsed using :php:meth:`Router::connectNamed()` if you need to.

.. _route-elements:

路由元素
--------

Route Elements
--------------

你可以指定自己的路由元素，这么做让你有能力能够定义控制器动作的参数在网址中应当占据的位置。当发出一个请求时，这些路由元素的值就会在控制器的 ``$this->request->params`` 中。这不同于命名参数(*named parameters*)处理的方式，所以请注意区别：命名参数(/controller/action/name:value)在 ``$this->request->params['named']`` 中，而自定义路由元素数据在 ``$this->request->params`` 中。当你定义自定义路由元素时，你可以指定可选的正则表达式 — 这告诉 CakePHP 如何判断网址的格式是否正确。如果你选择不提供正则表达式，任何非 ``/`` 字符就会被当做参数的一部分::

You can specify your own route elements and doing so gives you the
power to define places in the URL where parameters for controller
actions should lie. When a request is made, the values for these
route elements are found in ``$this->request->params`` on the controller.
This is different than how named parameters are handled, so note the
difference: named parameters (/controller/action/name:value) are
found in ``$this->request->params['named']``, whereas custom route
element data is found in ``$this->request->params``. When you define
a custom route element, you can optionally specify a regular
expression - this tells CakePHP how to know if the URL is correctly formed or not.
If you choose to not provide a regular expression, any non ``/`` will be
treated as part of the parameter::

    Router::connect(
        '/:controller/:id',
        array('action' => 'view'),
        array('id' => '[0-9]+')
    );

这个简单的例子展示了如何通过构建一个看起来象 ``/controllername/:id`` 这样的网址，来创造一个快捷的方式从任何控制器来查看模型。提供给 connect() 方法的网址指定了两个路由元素： ``:controller`` 和 ``:id``。``:controller`` 元素是 CakePHP 的默认路由元素，所以路由器知道如何匹配和辨认网址中的控制器名称。``:id`` 元素是自定义路由元素，必须在 connect() 方法的第三个参数中用正则表达式进一步说明。

This simple example illustrates how to create a quick way to view
models from any controller by crafting a URL that looks like
``/controllername/:id``. The URL provided to connect() specifies two
route elements: ``:controller`` and ``:id``. The ``:controller`` element
is a CakePHP default route element, so the router knows how to match and
identify controller names in URLs. The ``:id`` element is a custom
route element, and must be further clarified by specifying a
matching regular expression in the third parameter of connect().

.. note::

    路由元素使用的模式必须不能含有任何捕获分组(*capturing group*)。如果含有捕获分组，路由器就无法正常工作。

    Patterns used for route elements must not contain any capturing
    groups. If they do, Router will not function correctly.

一旦定义了路由，请求 ``/apples/5`` 就等同于请求 ``/apples/view/5``。二者都会调用 ApplesController 控制器的 view() 方法。在 view() 方法内，需要用 ``$this->request->params['id']`` 来访问传入的 ID。

Once this route has been defined, requesting ``/apples/5`` is the same
as requesting ``/apples/view/5``. Both would call the view() method of
the ApplesController. Inside the view() method, you would need to
access the passed ID at ``$this->request->params['id']``.

如果在应用程序中只有一个控制器，并且不想让控制器名称出现在网站中，你可以把所有网址映射到控制器的动作。例如，要把所有网址映射到 ``home`` 控制器的动作，例如，使用网址 ``/demo`` 而不是 ``/home/demo``，可以这样::

If you have a single controller in your application and you do not want
the controller name to appear in the URL, you can map all URLs to actions
in your controller. For example, to map all URLs to actions of the
``home`` controller, e.g have URLs like ``/demo`` instead of
``/home/demo``, you can do the following::

    Router::connect('/:action', array('controller' => 'home'));

如果想提供大小写无关的网址，可以使用正则表达式的内嵌修饰符(*inline modifier*)::

If you would like to provide a case insensitive URL, you can use regular
expression inline modifiers::

    Router::connect(
        '/:userShortcut',
        array('controller' => 'teachers', 'action' => 'profile', 1),
        array('userShortcut' => '(?i:principal)')
    );

再看一个例子，你就是路由专家了::

One more example, and you'll be a routing pro::

    Router::connect(
        '/:controller/:year/:month/:day',
        array('action' => 'index'),
        array(
            'year' => '[12][0-9]{3}',
            'month' => '0[1-9]|1[012]',
            'day' => '0[1-9]|[12][0-9]|3[01]'
        )
    );

这个有些复杂，但是说明了路由可以多么强大。提供的网址有四个路由元素。第一个我们很熟悉：这是默认路由元素，告诉 CakePHP 这是控制器名称。

This is rather involved, but shows how powerful routes can really
become. The URL supplied has four route elements. The first is
familiar to us: it's a default route element that tells CakePHP to
expect a controller name.

接着，我们指定一些缺省值。不管控制器是什么，我们都要调用 index() 动作。

Next, we specify some default values. Regardless of the controller,
we want the index() action to be called.

最后，我们指定一些正则表达式，匹配数字形式的年、月和日。注意，在这个正则表达式中是不支持括号(分组)的。你可以使用其它的，象上面那样，但是不能用括号分组。

Finally, we specify some regular expressions that will match years,
months and days in numerical form. Note that parenthesis (grouping)
are not supported in the regular expressions. You can still specify
alternates, as above, but not grouped with parenthesis.

一旦定义好，路由就可以匹配 ``/articles/2007/02/01`` 、 ``/posts/2004/11/16``，把请求传递给相应控制器的 index() 动作，并把日期参数放入 ``$this->request->params`` 中。

Once defined, this route will match ``/articles/2007/02/01``,
``/posts/2004/11/16``, handing the requests to
the index() actions of their respective controllers, with the date
parameters in ``$this->request->params``.

有几个路由元素在 CakePHP 中有特殊意义，不应当使用，除非你需要这种特殊意义。

* ``controller`` 用于命名路由的控制器。
* ``action`` 用于命名路由的控制器动作。
* ``plugin`` 用于命名控制器所在的插件(*plugin*)。
* ``prefix`` 用于 :ref:`prefix-routing`。
* ``ext`` 用于 :ref:`file-extensions` 路由。

There are several route elements that have special meaning in
CakePHP, and should not be used unless you want the special meaning

* ``controller`` Used to name the controller for a route.
* ``action`` Used to name the controller action for a route.
* ``plugin`` Used to name the plugin a controller is located in.
* ``prefix`` Used for :ref:`prefix-routing`
* ``ext`` Used for :ref:`file-extensions` routing.

传递参数给动作
----------------------------

Passing Parameters to Action
----------------------------

当使用 :ref:`route-elements` 连接路由时，你也许想要路由的元素转而作为传入参数(*passed arguments*)。使用 :php:meth:`Router::connect()` 方法的第三个参数，你可以定义哪个路由元素应当也被作为传入参数::

When connecting routes using :ref:`route-elements` you may want
to have routed elements be passed arguments instead. By using the 3rd
argument of :php:meth:`Router::connect()` you can define which route
elements should also be made available as passed arguments::

    // SomeController.php
    public function view($articleId = null, $slug = null) {
        // 这里是一些代码...
        // some code here...
    }

    // routes.php
    Router::connect(
        '/blog/:id-:slug', // 例如 /blog/3-CakePHP_Rocks
        array('controller' => 'blog', 'action' => 'view'),
        array(
            // 顺序有关，因为这会简单地把 ":id" 映射到动作中的 $articleId 参数
            // order matters since this will simply map ":id" to
            // $articleId in your action
            'pass' => array('id', 'slug'),
            'id' => '[0-9]+'
        )
    );

那么现在，得益于反向路由的功能，你可以传入下面这样的网址，而 CakePHP 就能够知道如何构成路由中定义的网址::

And now, thanks to the reverse routing capabilities, you can pass
in the url array like below and CakePHP will know how to form the URL
as defined in the routes::

    // view.ctp
    // 这会返回链接 /blog/3-CakePHP_Rocks
    // this will return a link to /blog/3-CakePHP_Rocks
    echo $this->Html->link('CakePHP Rocks', array(
        'controller' => 'blog',
        'action' => 'view',
        'id' => 3,
        'slug' => 'CakePHP_Rocks'
    ));

每个路由的命名参数
--------------------------

Per-Route Named Parameters
--------------------------

尽管你可以用 :php:meth:`Router::connectNamed()` 在全局范围控制命名参数(*named parameter*)，你也可以用 ``Router::connect()`` 的第三个参数控制在路由级别的命名参数::

While you can control named parameters on a global scale using
:php:meth:`Router::connectNamed()` you can also control named parameter
behavior at the route level using the 3rd argument of ``Router::connect()``::

    Router::connect(
        '/:controller/:action/*',
        array(),
        array(
            'named' => array(
                'wibble',
                'fish' => array('action' => 'index'),
                'fizz' => array('controller' => array('comments', 'other')),
                'buzz' => 'val-[\d]+'
            )
        )
    );

以上路由定义使用 ``named`` 键来定义应当如何 处理几个命名参数。让我们仔细看看每个不同的规则：

* 'wibble' 没有额外信息。这意味着，如果在匹配该路由的网址中找到，总是会解析。
* 'fish' 有条件数组，包含 'action' 键。这意味着，仅当动作也是索引时，fish 才会被解析为命名参数。
* 'fizz' 也有条件数组。不过，它含有两个控制器，这意味着，仅当控制器匹配数组中的一个时，'fizz' 才会被解析。
* 'buzz' 有字符串条件。字符串条件被作为正则表达式片段。只有符合模式的 buzz 值才会被解析。

The above route definition uses the ``named`` key to define how several named
parameters should be treated. Lets go through each of the various rules
one-by-one:

* 'wibble' has no additional information. This means it will always parse if
  found in a URL matching this route.
* 'fish' has an array of conditions, containing the 'action' key. This means
  that fish will only be parsed as a named parameter if the action is also index.
* 'fizz' also has an array of conditions. However, it contains two controllers,
  this means that 'fizz' will only be parsed if the controller matches one of the
  names in the array.
* 'buzz' has a string condition. String conditions are treated as
  regular expression fragments. Only values for buzz matching the pattern will
  be parsed.

如果使用了命名参数，但它不符合提供的条件，就会被当作传入参数(*passed argument*)，而非命名参数。

If a named parameter is used and it does not match the provided criteria, it will
be treated as a passed argument instead of a named parameter.

.. index:: admin routing, prefix routing
.. _prefix-routing:

前缀路由
--------------

Prefix Routing
--------------

许多应用程序要求有一个管理区，特权用户可以进行改动。这经常是通过一个特殊的网址来完成的，比如 ``/admin/users/edit/5``。在 CakePHP 中，前缀路由(*prefix routing*)可以在核心配置文件中通过使用 Routing.prefixes 设置前缀来开启。注意，前缀虽然和路由器有关，却是在 ``app/Config/core.php`` 中配置的::

Many applications require an administration section where
privileged users can make changes. This is often done through a
special URL such as ``/admin/users/edit/5``. In CakePHP, prefix routing
can be enabled from within the core configuration file by setting
the prefixes with Routing.prefixes. Note that prefixes, although
related to the router, are to be configured in
``app/Config/core.php``::

    Configure::write('Routing.prefixes', array('admin'));

在控制器中，任何以 ``admin_`` 前缀开始的动作就可以被调用了。在用户的例子中，访问网址 ``/admin/users/edit/5`` 就会调用 ``UsersController`` 控制器的方法 ``admin_edit``，传入 5 作为第一个参数。使用的视图文件为 ``app/View/Users/admin_edit.ctp``。

In your controller, any action with an ``admin_`` prefix will be
called. Using our users example, accessing the URL
``/admin/users/edit/5`` would call the method ``admin_edit`` of our
``UsersController`` passing 5 as the first parameter. The view file
used would be ``app/View/Users/admin_edit.ctp``

可以用下面的路由映射网址 /admin 到 pages 控制器的 ``admin_index`` 动作::

You can map the URL /admin to your ``admin_index`` action of pages
controller using following route::

    Router::connect(
        '/admin',
        array('controller' => 'pages', 'action' => 'index', 'admin' => true)
    );

也可以通过添加更多的值到 ``Routing.prefixes`` 来配置路由器使用多个前缀。如果设置::

You can configure the Router to use multiple prefixes too. By
adding additional values to ``Routing.prefixes``. If you set::

    Configure::write('Routing.prefixes', array('admin', 'manager'));

CakePHP 会自动生成 admin 和 manager 两个前缀的路由。每个配置的前缀会有如下生成的路由::

CakePHP will automatically generate routes for both the admin and
manager prefixes. Each configured prefix will have the following
routes generated for it::

    Router::connect(
        "/{$prefix}/:plugin/:controller",
        array('action' => 'index', 'prefix' => $prefix, $prefix => true)
    );
    Router::connect(
        "/{$prefix}/:plugin/:controller/:action/*",
        array('prefix' => $prefix, $prefix => true)
    );
    Router::connect(
        "/{$prefix}/:controller",
        array('action' => 'index', 'prefix' => $prefix, $prefix => true)
    );
    Router::connect(
        "/{$prefix}/:controller/:action/*",
        array('prefix' => $prefix, $prefix => true)
    );

和 admin 路由很类似，所有的前缀动作应当加上前缀名称。所以 ``/manager/posts/add`` 就会映射到 ``PostsController::manager_add()``。

Much like admin routing all prefix actions should be prefixed with
the prefix name. So ``/manager/posts/add`` would map to
``PostsController::manager_add()``.

而且，当前前缀在控制器方法中可以通过 ``$this->request->prefix`` 得到。

Additionally, the current prefix will be available from the controller methods through ``$this->request->prefix``

当使用前缀路由时，重要的是要记住，使用 HTML 助件来构建链接会帮助维护前缀调用。下面是如何使用 HTML 助件来构建链接::

When using prefix routes it's important to remember, using the HTML
helper to build your links will help maintain the prefix calls.
Here's how to build this link using the HTML helper::

    // 进入前缀路由。
    // Go into a prefixed route.
    echo $this->Html->link(
        'Manage posts',
        array('manager' => true, 'controller' => 'posts', 'action' => 'add')
    );

    // 离开前缀
    // leave a prefix
    echo $this->Html->link(
        'View Post',
        array('manager' => false, 'controller' => 'posts', 'action' => 'view', 5)
    );

.. index:: plugin routing

插件路由
--------------

Plugin Routing
--------------

插件路由使用 **plugin** 键。你可以创建指向插件的链接，但需在网址数组中添加 plugin 键::

Plugin routing uses the **plugin** key. You can create links that
point to a plugin, but adding the plugin key to your URL array::

    echo $this->Html->link(
        'New todo',
        array('plugin' => 'todo', 'controller' => 'todo_items', 'action' => 'create')
    );

相反如果当前有效请求是对插件的请求，而你又要创建不带插件的链接，你可以这么做::

Conversely if the active request is a plugin request and you want
to create a link that has no plugin you can do the following::

    echo $this->Html->link(
        'New todo',
        array('plugin' => null, 'controller' => 'users', 'action' => 'profile')
    );

通过设置 ``plugin => null``，你告诉路由器你要创建的链接不是插件的一部分。

By setting ``plugin => null`` you tell the Router that you want to
create a link that is not part of a plugin.

.. index:: file extensions
.. _file-extensions:

文件扩展名
---------------

File Extensions
---------------

要让你的路由处理不同的文件扩展名，你需要在路由配置文件中多加一行::

To handle different file extensions with your routes, you need one
extra line in your routes config file::

    Router::parseExtensions('html', 'rss');

这会告诉路由器去掉任何匹配的文件扩展名，解析剩余的部分。

This will tell the router to remove any matching file extensions,
and then parse what remains.

如果你要创建象 /page/title-of-page.html 这样的网址，你可以创建如下所示的路由::

If you want to create a URL such as /page/title-of-page.html you
would create your route as illustrated below::

    Router::connect(
        '/page/:title',
        array('controller' => 'pages', 'action' => 'view'),
        array(
            'pass' => array('title')
        )
    );

然后，要创建映射回上述路由的链接，简单地使用::

Then to create links which map back to the routes simply use::

    $this->Html->link(
        'Link title',
        array(
            'controller' => 'pages',
            'action' => 'view',
            'title' => 'super-article',
            'ext' => 'html'
        )
    );

文件扩展名被 :php:class:`RequestHandlerComponent` 用来进行基于内容类型的自动视图切换。欲知详情，请参看 RequestHandlerComponent。

File extensions are used by :php:class:`RequestHandlerComponent` to do automatic
view switching based on content types. See the RequestHandlerComponent for
more information.

.. _route-conditions:

使用额外条件匹配路由
------------------------------------------------

Using Additional Conditions When Matching Routes
------------------------------------------------

当创建路由时，你也许要基于特定的请求/环境设置来限制某些网址。一个很好的例子是 :doc:`rest` 路由。你可以在 :php:meth:`Router::connect()` 的 ``$defaults`` 参数指定额外的条件。默认情况下 CakePHP 提供3个环境条件，但是你可以用 :ref:`custom-route-classes` 添加更多(的条件)。内置的选项为：

When creating routes you might want to restrict certain URL's based on specific
request/environment settings. A good example of this is :doc:`rest`
routing. You can specify additional conditions in the ``$defaults`` argument for
:php:meth:`Router::connect()`. By default CakePHP exposes 3 environment
conditions, but you can add more using :ref:`custom-route-classes`. The built-in
options are:

- ``[type]`` 只匹配特定内容类型的请求。Only match requests for specific content types.
- ``[method]`` 只匹配有特定 HTTP 动词的请求。Only match requests with specific HTTP verbs.
- ``[server]`` 只有当 $_SERVER['SERVER_NAME'] 匹配给定值时才会匹配。Only match when $_SERVER['SERVER_NAME'] matches the given value.

我们在这里提供一个简单的例子，说明如何使用 ``[method]`` 选项来创建自定义 RESTful 路由::

We'll provide a simple example here of how you can use the ``[method]``
option to create a custom RESTful route::

    Router::connect(
        "/:controller/:id",
        array("action" => "edit", "[method]" => "PUT"),
        array("id" => "[0-9]+")
    );

以上路由只会匹配 ``PUT`` 请求。使用这些条件，你能够创建自定义 REST 路由，或者其它依赖于请求数据的信息。

The above route will only match for ``PUT`` requests. Using these conditions,
you can create custom REST routing, or other request data dependent information.

.. index:: passed arguments
.. _passed-arguments:

传入参数
========

Passed Arguments
================

传入参数(*passed argument*)是发起请求时使用的其它参数或路径片段。它们经常用来给控制器方法传递参数。::

Passed arguments are additional arguments or path segments that are
used when making a request. They are often used to pass parameters
to your controller methods.::

    http://localhost/calendars/view/recent/mark

在上面的例子中，``recent`` 和 ``mark`` 都是 ``CalendarsController::view()`` 的参数。传入参数以三种方式提供给控制器。首先可以作为被调用动作方法的参数，其次可以在 ``$this->request->params['pass']`` 中作为数字索引的数组访问。最后，可以在 ``$this->passedArgs`` 中通过和第二种同样的方式访问。在使用自定义路由时，你也可以强制特定的参数作为传入参数。

In the above example, both ``recent`` and ``mark`` are passed
arguments to ``CalendarsController::view()``. Passed arguments are
given to your controllers in three ways. First as arguments to the
action method called, and secondly they are available in
``$this->request->params['pass']`` as a numerically indexed array. Lastly
there is ``$this->passedArgs`` available in the same way as the
second one. When using custom routes you can force particular
parameters to go into the passed arguments as well.

如果你访问上面提到的网址，控制器动作如下::

If you were to visit the previously mentioned URL, and you
had a controller action that looked like::

    CalendarsController extends AppController {
        public function view($arg1, $arg2) {
            debug(func_get_args());
        }
    }

你就会得到如下输出::

You would get the following output::

    Array
    (
        [0] => recent
        [1] => mark
    )

同样的数据也可以在控制器、视图和助件中通过 ``$this->request->params['pass']`` 和 ``$this->passedArgs`` 得到。在 pass 数组中的值以它们在调用的网址中出现的顺序作为数字索引。

This same data is also available at ``$this->request->params['pass']``
and ``$this->passedArgs`` in your controllers, views, and helpers.
The values in the pass array are numerically indexed based on the
order they appear in the called URL::

    debug($this->request->params['pass']);
    debug($this->passedArgs);

上面的任何一个都会输出::

Either of the above would output::

    Array
    (
        [0] => recent
        [1] => mark
    )

.. note::

    $this->passedArgs 也可能会包含命名参数(*named parameter*)，因为命名数组和传入参数混杂在一起。

    $this->passedArgs may also contain named parameters as a named
    array mixed with Passed arguments.

在生成网址时，使用 :term:`routing array`，你可以添加不带字符串索引的值作为传入参数::

When generating URLs, using a :term:`routing array` you add passed
arguments as values without string keys in the array::

    array('controller' => 'posts', 'action' => 'view', 5)

因为 ``5`` 有数字键，所以它会被当作传入参数。

Since ``5`` has a numeric key, it is treated as a passed argument.

.. index:: named parameters

.. _named-parameters:

命名参数
========

Named Parameters
================

你可以给参数命名并用网址传递它们的值。对 ``/posts/view/title:first/category:general`` 的请求会导致对 PostsController 控制器的 view() 动作的调用。在这个动作中，你可以在 ``$this->params['named']`` 中得到 title 和 category 参数的值。它们也可以在 ``$this->passedArgs`` 中得到。在这两种情况中，都可以用它们的名称作为索引来访问。如果省略了命名参数，它们就不会(在这两个数组中)被设置。

You can name parameters and send their values using the URL. A
request for ``/posts/view/title:first/category:general`` would result
in a call to the view() action of the PostsController. In that
action, you'd find the values of the title and category parameters
inside ``$this->params['named']``. They are also available inside
``$this->passedArgs``. In both cases you can access named parameters using their
name as an index. If named parameters are omitted, they will not be set.


.. note::

    什么会被解析为命名参数，是由 :php:meth:`Router::connectNamed()` 方法控制的。如果你的命名参数不支持反向路由，或不能正确解析，你就需要让 :php:class:`Router` 知道它们(的存在)。

    What is parsed as a named parameter is controlled by
    :php:meth:`Router::connectNamed()`. If your named parameters are not
    reverse routing, or parsing correctly, you will need to inform
    :php:class:`Router` about them.

一些默认路由的总结性例子也许有用::

Some summarizing examples for default routes might prove helpful::

    使用默认路由从网址到控制器动作的映射：
    URL to controller action mapping using default routes:

    网址： URL: /monkeys/jump
    映射： Mapping: MonkeysController->jump();

    网址： URL: /products
    映射： Mapping: ProductsController->index();

    网址： URL: /tasks/view/45
    映射： Mapping: TasksController->view(45);

    网址： URL: /donations/view/recent/2001
    映射： Mapping: DonationsController->view('recent', '2001');

    网址： URL: /contents/view/chapter:models/section:associations
    映射： Mapping: ContentsController->view();
    $this->passedArgs['chapter'] = 'models';
    $this->passedArgs['section'] = 'associations';
    $this->params['named']['chapter'] = 'models';
    $this->params['named']['section'] = 'associations';

当制定自定义路由时，一个常见错误是，使用命名参数会破坏你的自定义路由。为了解决这个问题，你应当告诉路由器哪个参数要作为命名参数。不知道这个，路由器就无法决定命名的参数实际上是要作为命名参数还是路由参数，而会默认认为你要它们作为路由参数。要在路由器中使用命名参数，请使用 :php:meth:`Router::connectNamed()` 方法::

When making custom routes, a common pitfall is that using named
parameters will break your custom routes. In order to solve this
you should inform the Router about which parameters are intended to
be named parameters. Without this knowledge the Router is unable to
determine whether named parameters are intended to actually be
named parameters or routed parameters, and defaults to assuming you
intended them to be routed parameters. To connect named parameters
in the router use :php:meth:`Router::connectNamed()`::

    Router::connectNamed(array('chapter', 'section'));

这会确保反向路由正确地处理你的 chapter 和 section 参数。

Will ensure that your chapter and section parameters reverse route
correctly.

当生成网址时，使用 :term:`routing array` 就可以把和名称匹配的字符串键及其值添加为命名参数::

When generating URLs, using a :term:`routing array` you add named
parameters as values with string keys matching the name::

    array('controller' => 'posts', 'action' => 'view', 'chapter' => 'association')

因为 'chapter' 不匹配任何定义的路由元素，它就会被认为是命名参数。

Since 'chapter' doesn't match any defined route elements, it's treated
as a named parameter.

.. note::

    命名参数和路由元素共享相同的键空间。最好避免对路由元素和命名参数重用同一个键。

    Both named parameters and route elements share the same key-space.
    It's best to avoid re-using a key for both a route element and a named
    parameter.

命名参数也支持使用数组来生成和解析网址。语法和 GET 参数的数组语法非常类似。当生成网址时可以使用以下语法::

Named parameters also support using arrays to generate and parse
URLs. The syntax works very similar to the array syntax used
for GET parameters. When generating URLs you can use the following
syntax::

    $url = Router::url(array(
        'controller' => 'posts',
        'action' => 'index',
        'filter' => array(
            'published' => 1,
            'frontpage' => 1
        )
    ));

以上代码会生成网址 ``/posts/index/filter[published]:1/filter[frontpage]:1``。然后参数会被解析，并作为数组存储在控制器的 passedArgs 变量中，就象你把它们发送给 :php:meth:`Router::url` 一样::

The above would generate the URL ``/posts/index/filter[published]:1/filter[frontpage]:1``.
The parameters are then parsed and stored in your controller's passedArgs variable
as an array, just as you sent them to :php:meth:`Router::url`::

    $this->passedArgs['filter'] = array(
        'published' => 1,
        'frontpage' => 1
    );

数组也可以深度嵌套，让你在传递参数时有更多的灵活性::

Arrays can be deeply nested as well, allowing you even more flexibility in
passing arguments::

    $url = Router::url(array(
        'controller' => 'posts',
        'action' => 'search',
        'models' => array(
            'post' => array(
                'order' => 'asc',
                'filter' => array(
                    'published' => 1
                )
            ),
            'comment' => array(
                'order' => 'desc',
                'filter' => array(
                    'spam' => 0
                )
            ),
        ),
        'users' => array(1, 2, 3)
    ));

你就会得到象这样相当长的网址(折行是为了便于阅读)::

You would end up with a pretty long url like this (wrapped for easy reading)::

    posts/search
      /models[post][order]:asc/models[post][filter][published]:1
      /models[comment][order]:desc/models[comment][filter][spam]:0
      /users[]:1/users[]:2/users[]:3

得到的要传递给控制器的数组，和传递给路由器的是一致的::

And the resulting array that would be passed to the controller would match that
which you passed to the router::

    $this->passedArgs['models'] = array(
        'post' => array(
            'order' => 'asc',
            'filter' => array(
                'published' => 1
            )
        ),
        'comment' => array(
            'order' => 'desc',
            'filter' => array(
                'spam' => 0
            )
        ),
    );

.. _controlling-named-parameters:

控制命名参数
----------------------------

Controlling Named Parameters
----------------------------

你可以在路由级别或者在全局级别控制命名参数的配置。全局控制通过 ``Router::connectNamed()`` 进行。下面是一些例子，说明如何使用 connectNamed() 方法来控制命名参数的解析。

You can control named parameter configuration at the per-route-level
or control them globally. Global control is done through ``Router::connectNamed()``
The following gives some examples of how you can control named parameter parsing
with connectNamed().

不解析任何命名参数::

Do not parse any named parameters::

    Router::connectNamed(false);

只解析 CakePHP 用于分页的默认参数::

Parse only default parameters used for CakePHP's pagination::

    Router::connectNamed(false, array('default' => true));

只有当 page 参数是数字时才只解析它::

Parse only the page parameter if its value is a number::

    Router::connectNamed(
        array('page' => '[\d]+'),
        array('default' => false, 'greedy' => false)
    );

只解析 page 参数，不论它是什么::

Parse only the page parameter no matter what::

    Router::connectNamed(
        array('page'),
        array('default' => false, 'greedy' => false)
    );

如果当前动作是 'index'，只解析 page 参数::

Parse only the page parameter if the current action is 'index'::

    Router::connectNamed(
        array('page' => array('action' => 'index')),
        array('default' => false, 'greedy' => false)
    );

如果当前动作是 'index' 而且控制器是 'pages'，只解析 page 参数::

Parse only the page parameter if the current action is 'index' and the controller is 'pages'::

    Router::connectNamed(
        array('page' => array('action' => 'index', 'controller' => 'pages')),
        array('default' => false, 'greedy' => false)
    );


connectNamed() 方法支持一些选项：

* ``greedy`` 设置为 true 会使路由器解析所有命名参数。设置为 false 则只会解析连接的命名参数。
* ``default`` 设置为 true 会合并入默认的一组命名参数。
* ``reset`` 设置为 true 来清除现有的规则，从头开始。
* ``separator`` 改变在命名参数中用来分隔键和值的字符串。默认为 `:`。

connectNamed() supports a number of options:

* ``greedy`` Setting this to true will make Router parse all named params.
  Setting it to false will parse only the connected named params.
* ``default`` Set this to true to merge in the default set of named parameters.
* ``reset`` Set to true to clear existing rules and start fresh.
* ``separator`` Change the string used to separate the key & value in a named
  parameter. Defaults to `:`

反向路由
==========

Reverse Routing
===============

反向路由是 CakePHP 中的特性，用来让你容易地改变网址结构，而不必改动所有代码。使用 :term:`路由数组 <routing array>` 来定义网址，以后你就可以配置路由，而生成的网址就会自动更新。

Reverse routing is a feature in CakePHP that is used to allow you to
easily change your URL structure without having to modify all your code.
By using :term:`routing arrays <routing array>` to define your URLs, you can
later configure routes and the generated URLs will automatically update.

如果象下面这样用字符串创建网址::

If you create URLs using strings like::

    $this->Html->link('View', '/posts/view/' + $id);

而后来决定 ``/posts`` 实际上应该叫做 'articles'，你就不得不查看整个应用程序的代码，替换网址。然而，如果象下面这样定义链接::

And then later decide that ``/posts`` should really be called
'articles' instead, you would have to go through your entire
application renaming URLs. However, if you defined your link like::

    $this->Html->link(
        'View',
        array('controller' => 'posts', 'action' => 'view', $id)
    );

那么当你决定改变网址时，你可以只定义一个路由就达到目的。这不但会改变接收网址的映射，也改变了生成的网址。

Then when you decided to change your URLs, you could do so by defining a
route. This would change both the incoming URL mapping, as well as the
generated URLs.

在使用数组网址时，你可以使用特殊的键来定义查询字符串(*query string*)参数和文档片段(*document fragment*)::

When using array URLs, you can define both query string parameters and
document fragments using special keys::

    Router::url(array(
        'controller' => 'posts',
        'action' => 'index',
        '?' => array('page' => 1),
        '#' => 'top'
    ));

    // 会生成类似这样的网址
    // will generate a URL like.
    /posts/index?page=1#top

.. _redirect-routing:

重定向路由
============

Redirect Routing
================

重定向路由让你可以对收到的路由发送 HTTP 状态 30x 重定向，把它们指向不同的网址。这可以用于当你想要通知客户端应用程序，一个资源被移动了，而你又不想为同一内容分配两个网址。

Redirect routing allows you to issue HTTP status 30x redirects for
incoming routes, and point them at different URLs. This is useful
when you want to inform client applications that a resource has moved
and you don't want to expose two URLs for the same content

重定向路由不同于普通路由，因为如果遇到匹配的网址，实际上会执行文件头重定向。重定向可以指向应用程序内的目标，也可以指向外部的地址::

Redirection routes are different from normal routes as they perform an actual
header redirection if a match is found. The redirection can occur to
a destination within your application or an outside location::

    Router::redirect(
        '/home/*',
        array('controller' => 'posts', 'action' => 'view'),
        // 或者对视图动作等待 $id 作为参数的默认路由，使用
        // array('persist'=>array('id'))
        // or array('persist'=>array('id')) for default routing where the
        // view action expects $id as an argument
        array('persist' => true)
    );

重定向 ``/home/*`` 到 ``/posts/view``，并传递参数到 ``/posts/view``。使用数组作为重定向目标让你可以使用其它路由来定义字符串网址应该重定向到哪里。你可以使用字符串网址作为目标重定向到外部地址::

Redirects ``/home/*`` to ``/posts/view`` and passes the parameters to
``/posts/view``. Using an array as the redirect destination allows
you to use other routes to define where a URL string should be
redirected to. You can redirect to external locations using
string URLs as the destination::

    Router::redirect('/posts/*', 'http://google.com', array('status' => 302));

这会以 HTTP 状态 302 重定向 ``/posts/*`` 到 ``http://google.com``。

This would redirect ``/posts/*`` to ``http://google.com`` with a
HTTP status of 302.

.. _disabling-default-routes:

关闭默认路由
============

Disabling the Default Routes
============================

如果你完全自定义了全部路由，并想要避免任何可能来自搜索引擎的重复内容惩罚，你可以从应用程序的 routes.php 文件删除 CakePHP 提供的默认路由来去掉它们。

If you have fully customized all your routes, and want to avoid any
possible duplicate content penalties from search engines, you can
remove the default routes that CakePHP offers by deleting them from your
application's routes.php file.

当用户试图访问通常由 CakePHP 提供但没有显式连接的网址，就会引起 CakePHP 报错。

This will cause CakePHP to serve errors, when users try to visit
URLs that would normally be provided by CakePHP but have not
been connected explicitly.

.. _custom-route-classes:

自定义路由类
============

Custom Route Classes
====================

自定义路由类让你可以扩展并改变单个路由如何解析请求和处理反向路由。自定义路由应当在 ``app/Routing/Route`` 目录中创建，而且应当扩展 :php:class:`CakeRoute` 并实现 ``match()``
和``parse()`` 两个方法中的一个或全部。``parse()`` 方法用于解析请求，而 ``match()`` 方法用于处理反向路由。

Custom route classes allow you to extend and change how individual
routes parse requests and handle reverse routing. A custom route class
should be created in ``app/Routing/Route`` and should extend
:php:class:`CakeRoute` and implement one or both of ``match()``
and/or ``parse()``. ``parse()`` is used to parse requests and
``match()`` is used to handle reverse routing.

要使用自定义路由，你可以在指定路由时使用 ``routeClass`` 选项，并且在使用它之前加载包含路由(类)的文件::

You can use a custom route class when making a route by using the
``routeClass`` option, and loading the file containing your route
before trying to use it::

    App::uses('SlugRoute', 'Routing/Route');

    Router::connect(
         '/:slug',
         array('controller' => 'posts', 'action' => 'view'),
         array('routeClass' => 'SlugRoute')
    );

这个路由会创建一个 ``SlugRoute`` 类的实例，让你可以实现自定义参数处理。

This route would create an instance of ``SlugRoute`` and allow you
to implement custom parameter handling.

路由 API
==========

Router API
==========

.. php:class:: Router

    路由器管理发出网址的生成、解析接收的请求网址为 CakePHP 可以调配的参数集。

    Router manages generation of outgoing URLs, and parsing of incoming
    request uri's into parameter sets that CakePHP can dispatch.

.. php:staticmethod:: connect($route, $defaults = array(), $options = array())

    :param string $route: 描述路由模板的字符串。
    :param array $defaults: 描述默认路由参数的数组。这些参数默认会被使用，可以被提供非动态的路由参数。
    :param array $options: 路由中命名元素和对应的元素应当匹配的正则表达式构成的数组。也包含额外的参数，比如哪个路由参数应当移入传入参数，提供路由参数的模式，以及提供自定义路由类的名称。

    :param string $route: A string describing the template of the route
    :param array $defaults: An array describing the default route parameters.
        These parameters will be used by default
        and can supply routing parameters that are not dynamic.
    :param array $options: An array matching the named elements in the route
        to regular expressions which that element should match. Also contains
        additional parameters such as which routed parameters should be
        shifted into the passed arguments, supplying patterns for routing
        parameters and supplying the name of a custom routing class.

    路由是一种连接请求网址和应用程序中的对象的方法。在其核心，路由是用于匹配请求到目的地的一组正则表达式。

    Routes are a way of connecting request URLs to objects in your application.
    At their core routes are a set of regular expressions that are used to
    match requests to destinations.

    例如 Examples::

        Router::connect('/:controller/:action/*');

    第一个参数被当作控制器名称，而第二个参数被当作当作名称。'/\*' 语法使该路由贪婪，这样它就会匹配象 `/posts/index` 以及象 ``/posts/edit/1/foo/bar`` 这样的请求。::

    The first parameter will be used as a controller name while the second is
    used as the action name. The '/\*' syntax makes this route greedy in that
    it will match requests like `/posts/index` as well as requests like
    ``/posts/edit/1/foo/bar`` .::

        Router::connect(
            '/home-page',
            array('controller' => 'pages', 'action' => 'display', 'home')
        );

    上面这个说明路由参数默认值的用法。而为静态路由提供路由参数。::

    The above shows the use of route parameter defaults. And providing routing
    parameters for a static route.::

        Router::connect(
            '/:lang/:controller/:action/:id',
            array(),
            array('id' => '[0-9]+', 'lang' => '[a-z]{3}')
        );

    说明连接路由和自定义路由参数，以及为这些参数提供模式。路由参数的模式不需要捕
    获分组(*capturing group*)，因为每个路由参数都会(自动)添加一个(捕获分组)。

    Shows connecting a route with custom route parameters as well as providing
    patterns for those parameters. Patterns for routing parameters do not need
    capturing groups, as one will be added for each route params.

    $options 参数提供了三个'特殊的'键。``pass`` 、 ``persist`` 和 ``routeClass``
    在 $options 数组中有特殊的含义。

    $options offers three 'special' keys. ``pass``, ``persist`` and ``routeClass``
    have special meaning in the $options array.

    * ``pass`` 用于定义那个路由参数应当移入 pass 数组。添加参数到 pass 数组会把
      它从正常的路由数组中删除。例如 ``'pass' => array('slug')``。
      is used to define which of the routed parameters should be
      shifted into the pass array. Adding a parameter to pass will remove
      it from the regular route array. Ex. ``'pass' => array('slug')``

    * ``persist`` 用于定义在生成新网址时哪个路由参数应当自动包括在内。你可以覆盖
      持久参数，只需在网址中重新定义它们，或者通过设置该参数为 ``false``。例如 
      ``'persist' => array('lang')``。
      is used to define which route parameters should be automatically
      included when generating new URLs. You can override persistent parameters
      by redefining them in a URL or remove them by setting the parameter to
      ``false``. Ex. ``'persist' => array('lang')``

    * ``routeClass`` 用于通过自定义路由类来扩展和改变单个路由如何解析请求及处理反向路由。例如 ``'routeClass' => 'SlugRoute'``。
      is used to extend and change how individual routes parse
      requests and handle reverse routing, via a custom routing class.
      Ex. ``'routeClass' => 'SlugRoute'``

    * ``named`` 用于在路由级别配置命名参数。该键使用与 :php:meth:`Router::connectNamed()` 相同的键。
      is used to configure named parameters at the route level.
      This key uses the same options as :php:meth:`Router::connectNamed()`

.. php:staticmethod:: redirect($route, $url, $options = array())

    :param string $route: 路由模板，决定哪些网址要重定向。
    :param mixed $url: 重定向目的地，或者是 :term:`routing array` 或者是字符串网址。
    :param array $options: 重定向选项数组。

    :param string $route: A route template that dictates which URLs should
        be redirected.
    :param mixed $url: Either a :term:`routing array` or a string url
        for the destination of the redirect.
    :param array $options: An array of options for the redirect.

    连接路由器中新的重定向路由。欲知详情，请参见 :ref:`redirect-routing`。

    Connects a new redirection Route in the router.
    See :ref:`redirect-routing` for more information.

.. php:staticmethod:: connectNamed($named, $options = array())

    :param array $named: 命名参数列表。接受键值对，值为要匹配的正则表达式、或者数组。
    :param array $options: 可以控制所有设置：separator, greedy, reset, default。

    :param array $named: A list of named parameters. Key value pairs are accepted where
        values are either regex strings to match, or arrays.
    :param array $options: Allows control of all settings:
        separator, greedy, reset, default

    指定 CakePHP 应当从接收的网址中解析哪些命名参数。默认情况下，CakePHP 会从接收的网址中解析所有命名参数。欲知详情，请参见 :ref:`controlling-named-parameters`。

    Specifies what named parameters CakePHP should be parsing out of
    incoming URLs. By default CakePHP will parse every named parameter
    out of incoming URLs. See :ref:`controlling-named-parameters` for
    more information.

.. php:staticmethod:: promote($which = null)

    :param integer $which: 从零开始的数组索引，代表要移动的路由。例如，如果添加了 3 个路由，最后一个路由就是 2。

    :param integer $which: A zero-based array index representing the route to move.
        For example, if 3 routes have been added, the last route would be 2.

    把一个路由(默认情况下，是最后一个添加的)提前到列表的最开始。

    Promote a route (by default, the last one added) to the beginning of the list.

.. php:staticmethod:: url($url = null, $full = false)

    :param mixed $url: CakePHP 的相对网址，比如 "/products/edit/92" 或者
        "/presidents/elect/4" 或者一个 :term:`routing array`
    :param mixed $full: 如果是 (boolean) true，完整的根目录网址会加在结果前面。如果是数组，则接受如下的键
        to the result. If an array accepts the following keys

           * escape — 用于当生成嵌入 HTML 的网址时，转义查询字符串'&'
           * full — 如果为 true，完整的根目录网址会加在前面。

    :param mixed $url: Cake-relative URL, like "/products/edit/92" or
        "/presidents/elect/4" or a :term:`routing array`
    :param mixed $full: If (boolean) true, the full base URL will be prepended
        to the result. If an array accepts the following keys

           * escape - used when making URLs embedded in HTML escapes query
             string '&'
           * full - if true the full base URL will be prepended.

    生成指定地址的网址。返回网址指向控制器和动作合成的网址。$url 可以是：

    * Empty — 方法会寻找真正的控制器/动作。
    * '/' — 方法会寻找应用程序的根目录网址。
    * 控制器/动作的组合 — 方法会寻找对应的网址。

    Generate a URL for the specified action. Returns a URL pointing
    to a combination of controller and action. $url can be:

    * Empty - the method will find the address to the actual controller/action.
    * '/' - the method will find the base URL of application.
    * A combination of controller/action - the method will find the URL for it.

    有一些'特殊'的参数会改变最终生成的网址：

    * ``base`` — 设置为 false 来去掉生成的网址中的根路径。如果你的应用程序不在根目录，这可以用来生成'CakePHP 的相对'网址。CakePHP 的相对网址在使用 requestAction 是必须的。
      If your application is not in the root directory, this can be used to
      generate URLs that are 'cake relative'. CakePHP relative URLs are required
      when using requestAction.
    * ``?`` — 接受查询字符串数组参数
    * ``#`` — 让你可以设置网址哈希片段(*hash fragment*)。
    * ``full_base`` — 如果是 true，:php:meth:`Router::fullBaseUrl()` 的值会附件在生成的网址的前面。
      be prepended to generated URLs.

    There are a few 'special' parameters that can change the final URL string that is generated:

    * ``base`` - Set to false to remove the base path from the generated URL.
      If your application is not in the root directory, this can be used to
      generate URLs that are 'cake relative'. CakePHP relative URLs are required
      when using requestAction.
    * ``?`` - Takes an array of query string parameters
    * ``#`` - Allows you to set URL hash fragments.
    * ``full_base`` - If true the value of :php:meth:`Router::fullBaseUrl()` will
      be prepended to generated URLs.

.. php:staticmethod:: mapResources($controller, $options = array())

    创建给定控制器的 REST 资源路由。欲知详情，请参见 :doc:`/development/rest` 一节。

    Creates REST resource routes for the given controller(s). See
    the :doc:`/development/rest` section for more information.

.. php:staticmethod:: parseExtensions($types)

    用在 routes.php 文件中来声明应用程序支持哪个 :ref:`file-extensions`。不提供参数，则支持所有的文件扩展名。

    Used in routes.php to declare which :ref:`file-extensions` your application
    supports. By providing no arguments, all file extensions will be supported.

.. php:staticmethod:: setExtensions($extensions, $merge = true)

    .. versionadded:: 2.2

    设置或添加合法的扩展名。要解析扩展名，你仍然必须调用 :php:meth:`Router::parseExtensions()` 方法。

    Set or add valid extensions. To have the extensions parsed, you are still
    required to call :php:meth:`Router::parseExtensions()`.

.. php:staticmethod:: defaultRouteClass($classname)

    .. versionadded:: 2.1

    设置将来连接路由时使用的默认路由。

    Set the default route to be used when connecting routes in the future.

.. php:staticmethod:: fullBaseUrl($url = null)

    .. versionadded:: 2.4

    获得或设置生成网址时使用的根网址。设置该值时，应当确保引入完全验证域名包括协议。

    Get or set the baseURL used for generating URL's. When setting this value
    you should be sure to include the fully qualified domain name including
    protocol.

    用该方法设置值，也会更新 :php:class:`Configure` 中的 ``App.fullBaseUrl``。

    Setting values with this method will also update ``App.fullBaseUrl`` in
    :php:class:`Configure`.

.. php:class:: CakeRoute

    自定义路由基于的基类。

    The base class for custom routes to be based on.

.. php:method:: parse($url)

    :param string $url: 要解析的字符串网址。The string URL to parse.

    解析收到的网址，并生成请求参数数组，供 Dispatcher 处理。扩展这个方法让你可以自定义如何把收到的网址转换成数组。从网址返回 ``false`` 来表示不匹配。

    Parses an incoming URL, and generates an array of request parameters
    that Dispatcher can act upon. Extending this method allows you to customize
    how incoming URLs are converted into an array. Return ``false`` from
    URL to indicate a match failure.

.. php:method:: match($url)

    :param array $url: 要转换成字符串网址的路由数组。The routing array to convert into a string URL.

    试图匹配网址数组。如果网址匹配路由参数和设置，就返回生成的字符串网址。如果网址不匹配路由参数，返回 false。该方法处理网址数组的反向路由或转换为字符串网址。

    Attempt to match a URL array. If the URL matches the route parameters
    and settings, then return a generated string URL. If the URL doesn't
    match the route parameters, false will be returned. This method handles
    the reverse routing or conversion of URL arrays into string URLs.

.. php:method:: compile()

    强制路由编译它的正则表达式。

    Force a route to compile its regular expression.


.. meta::
    :title lang=zh_CN: Routing
    :keywords lang=zh_CN: controller actions,default routes,mod rewrite,code index,string url,php class,incoming requests,dispatcher,url url,meth,maps,match,parameters,array,config,cakephp,apache,router
