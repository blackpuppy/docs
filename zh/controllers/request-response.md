请求与响应对象
############################

请求与响应对象在 CakePHP 2.0 是新增加的。在之前的版本中，这两个对象是由数组表示的，而相关的方法是分散在 :php:class:`RequestHandlerComponent`，:php:class:`Router`，:php:class:`Dispatcher` 和 :php:class:`Controller` 之中的。关于请求对象包含什么信息，之前并没有权威性的对象。在2.0中， :php:class:`CakeRequest` 和 :php:class:`CakeResponse` 用于此目的。

.. index:: $this->request
.. _cake-request:

CakeRequest
###########

:php:class:`CakeRequest` 是 CakePHP 中缺省的请求对象。它集中了一些特性，用来查询(*interrogating*)请求数据以及与请求数据交互。对于每个请求，一个 CakeRequest 实例被创建，然后通过引用的方式，传递给应用程序中使用请求数据的各层。缺省情况下， ``CakeRequest`` 赋值给 ``$this->request``，并且在控制器，视图和助件中都可以使用。在组件中，你也可以通过控制器来访问到。 ``CakeRequest`` 履行的一些职责包括:

* 处理 GET，POST 和 FILES 数组，并放入你所熟悉的数据结构。
* 提供与请求相关的环境的查询(*introspection*)，比如，传送的文件头，客户端 IP 地址，在服务器上运行的应用程序的子域/域的信息。
* 提供数组索引和对象属性两种方式，来访问请求参数。

获取请求参数
============================

CakeRequest 提供了几种方式获取请求参数。第一种是对象属性，第二种是数组索引，第三种是通过 ``$this->request->params``::

    $this->request->controller;
    $this->request['controller'];
    $this->request->params['controller'];

上面这些都可以得到相同的值。提供多种获取参数的方式是为了便于现有应用程序的移植。所有的 :ref:`路由元素 <route-elements>` 都可以通过这些方式得到。

除了 :ref:`路由元素 <route-elements>`，你也经常需要获取 :ref:`传入参数 <passed-arguments>` 和 :ref:`命名参数 <named-parameters>`。这些也可以通过请求对象获得::

    // Passed arguments
    $this->request->pass;
    $this->request['pass'];
    $this->request->params['pass'];

    // named parameters
    $this->request->named;
    $this->request['named'];
    $this->request->params['named'];

以上这些都可以让你得到传入参数和命名参数。还有一些重要/有用的参数，在 CakePHP 内部使用，在请求参数中也可以找到:

* ``plugin`` 处理请求的插件，没有插件时为 null。
* ``controller`` 处理当前请求的控制器。
* ``action`` 处理当前请求的动作。
* ``prefix`` 当前动作的前缀。更多信息请参见 :ref:`前缀路由 <prefix-routing>`。
* ``bare`` 当请求来自 requestAction()，并且包括 bare 选项时就会出现。 Bare 请求没有布局(*layout*)被渲染。
* ``requested`` 当请求来自 requestAction() 时会出现，并置为 true。


 获取查询字符串(*Querystring*)参数
================================

查询字符串(*Querystring*)参数可以从 :php:attr:`CakeRequest::$query` 读取::

    // 网址为 /posts/index?page=1&sort=title
    $this->request->query['page'];

    // 你也可以通过数组方式获取
    $this->request['url']['page']; // BC 访问(*BC accessor*)会在将来的版本中废弃。 
你可以直接访问 query 属性，或者你可以用 :php:meth:`CakeRequest::query()` 以不会出错的方式读取网址查询数组。任何不存在的键都会返回 ``null``::

    $foo = $this->request->query('value_that_does_not_exist');
    // $foo === null

获取 POST 数据
===================

所有的 POST 数据都可以用 :php:attr:`CakeRequest::$data` 得到。任何含有 ``data`` 前缀的表单(*form*)数据，会把 data 前缀去掉。例如::

    // 一项 name 属性为 'data[MyModel][title]' 的输入，可以由此访问     $this->request->data['MyModel']['title'];

你可以直接访问 data 属性，或者使用 :php:meth:`CakeRequest::data()` 以不会出错的方式来读取 data 数组。任何不存在的键都会返回 ``null``::

    $foo = $this->request->data('Value.that.does.not.exist');
    // $foo == null

获取 PUT 或者 POST 数据
==========================

.. versionadded:: 2.2

当构建 REST 服务时，你经常接受以 ``PUT`` 和
``DELETE`` 请求方式提交的数据。自从2.2版本开始， 对 ``PUT`` 和
``DELETE`` 请求，``application/x-www-form-urlencoded`` 请求文件体(*request body*)数据会自动被解释，并设置到 ``$this->data``。如果你接受 JSON 或 XML 数据，下文会解释如何访问这些请求文件体。

访问 XML 或 JSON 数据
==========================

采用 :doc:`/development/rest` 的应用程序经常以非网址编码的 post 文件体的方式交换数据。你可以用 :php:meth:`CakeRequest::input()` 读取任何格式的输入数据。通过提供一个解码函数，你可以得到反序列化之后的内容::

    // 获得提交给 PUT/POST 动作以 JSON 编码的数据
    $data = $this->request->input('json_decode');

鉴于某些反序列化方法在调用的时候要求额外的参数，例如 ``json_decode`` 的 'as array' 参数，或者如果你要把 XML 转换成 DOMDocument 对象， :php:meth:`CakeRequest::input()` 也支持传入额外的参数::

    // 获得提交给 PUT/POST 动作的 Xml 编码的数据
    $data = $this->request->input('Xml::build', array('return' => 'domdocument'));

获取路径信息
==========================

CakeRequest 也提供与你应用程序中的路径相关的有用信息。 :php:attr:`CakeRequest::$base` 和 :php:attr:`CakeRequest::$webroot` 可用于生成网址，判断你的应用程序是否在某个子目录中。

.. _check-the-request:

检视请求
======================

判断各种请求条件，过去需要用到 :php:class:`RequestHandlerComponent`。这些方法被转移到了 ``CakeRequest`` 中，在保持向后兼容用法的同时，提供了新的接口(*interface*)::

    $this->request->is('post');
    $this->request->isPost();

两种方法调用都会返回相同的值。目前这些方法还存在于 RequestHandler 中，但已经被废弃(*deprecated*)，而且在最终发布前仍然可能会被去掉(译注：这可能是指某个特定版本的发布，有可能是最初的2.0版本的发布，但原文并没有指明，故不能确定。你仍然应当以所使用版本的 CakePHP API 的文档或源代码为依据。)。你也可以通过使用 :php:meth:`CakeRequest::addDetector()` 创建新的检测器， 容易地扩展现有的请求检测。你可以创建四种不同种类的检测器:

* 环境值比较 —— 环境变量比较，把从 :php:func:`env()` 取得的值和一个给定值，进行是否相等的比较。
* 模式值比较 —— 模式值比较让你可以把一个从 :php:func:`env()` 取得的值和一个正则表达式进行比较。
* 基于选项的比较 —— 基于选项的比较使用一组选项来创建一个正则表达式。之后再添加相同的选项检测器就会合并选项。
* 回调检测器 —— 回调检测器让你可以提供一个 'callback' 类型来进行检查。这个回调函数只接受请求对象作为唯一的参数。

下面是一些例子::

    // 添加一个环境检测器。
    $this->request->addDetector('post', array('env' => 'REQUEST_METHOD', 'value' => 'POST'));

    // 添加一个模式值检测器。
    $this->request->addDetector('iphone', array('env' => 'HTTP_USER_AGENT', 'pattern' => '/iPhone/i'));

    // 添加一个选项检测器。
    $this->request->addDetector('internalIp', array(
        'env' => 'CLIENT_IP',
        'options' => array('192.168.0.101', '192.168.0.100')
    ));

    // 添加一个回调检测器。可以是一个匿名函数，或者是一个通常的回调。
    $this->request->addDetector('awesome', array('callback' => function ($request) {
        return isset($request->awesome);
    }));


``CakeRequest`` 还有一些类似 :php:meth:`CakeRequest::domain()`，:php:meth:`CakeRequest::subdomains()` 和 :php:meth:`CakeRequest::host()` 这样的方法，可以让有子域的应用程序更容易处理。

有几个内置的检测器供你使用:

* ``is('get')`` 检查当前请求是否是 GET。
* ``is('put')`` 检查当前请求是否是 PUT。
* ``is('post')`` 检查当前请求是否是 POST。
* ``is('delete')`` 检查当前请求是否是 DELETE。
* ``is('head')`` 检查当前请求是否是 HEAD。
* ``is('options')`` 检查当前请求是否是 OPTIONS。
* ``is('ajax')`` 检查当前请求是否带有 X-Requested-with = XmlHttpRequest。
* ``is('ssl')`` 检查当前请求是否通过 SSL。
* ``is('flash')`` 检查当前请求是否带有 Flash 的用户代理(*User-Agent*)。
* ``is('mobile')`` 检查当前请求是否来自一个常见移动代理列表。


CakeRequest 和 RequestHandlerComponent
=======================================

既然 ``CakeRequest`` 提供的许多特性以前是 :php:class:`RequestHandlerComponent` 的领域，需要重新思考才能明白它(后者)如何能继续融洽的存在于整个架构中。对2.0来说，:php:class:`RequestHandlerComponent` 是作为语法糖(*sugar daddy*)而存在。它在 `CakeRequest` 提供的工具之上提供了一层语法糖。根据内容的类型或 ajax 来切换布局和视图这类语法糖，是 :php:class:`RequestHandlerComponent` 的领域。在这两个类中这种工具和语法糖的划分，让你更容易地挑选你的所求和所需。

与请求的其它方面交互
=============================================

你可以用 `CakeRequest` 查看(*introspect*)关于请求的各种信息。除了检测器，你还能从各种属性和方法中找出其它信息。

* ``$this->request->webroot`` 包含 webroot 目录。
* ``$this->request->base`` 包含 base 路径。
* ``$this->request->here`` 包含当前请求的完整地址。
* ``$this->request->query`` 含有查询字符串(*query string*)参数。


CakeRequest API
===============

.. php:class:: CakeRequest

    CakeRequest 封装了请求参数处理，和查询(*introspection*)。

.. php:method:: domain($tldLength = 1)

    返回你的应用程序运行的域名。

.. php:method:: subdomains($tldLength = 1)

    以数组的形式返回你的应用程序运行的子域名。

.. php:method:: host()

    返回你的应用程序所在的主机名。

.. php:method:: method()

    返回请求所用的 HTTP 方法。

.. php:method:: onlyAllow($methods)

    设置允许的 HTTP 方法，如果不符合就会导致 MethodNotAllowedException。
    405响应会包括必要的 'Allow' 文件头及传入的 HTTP 方法。

    .. versionadded:: 2.3

.. php:method:: referer($local = false)

    返回请求的转移源地址(*referring address*)。

.. php:method:: clientIp($safe = true)

    返回当前访问者的 IP 地址。

.. php:method:: header($name)

    让你获得请求使用的任何 ``HTTP_*`` 文件头::

        $this->request->header('User-Agent');

    会返回当前请求使用的用户代理。

.. php:method:: input($callback, [$options])

    获取请求的输入数据，并可选择使其通过一个解码函数。给解码函数的参数可以作为 input() 的参数传入。

.. php:method:: data($name)

    提供对象属性(*dot notation*)的表示方法来访问请求数据。允许读取和修改请求数据，方法调用也可以链接起来::

        // 修改一些请求数据，从而可以放到一些表单字段里面。
        $this->request->data('Post.title', 'New post')
            ->data('Comment.1.author', 'Mark');

        // 也可以读出数据。
        $value = $this->request->data('Post.title');

.. php:method:: query($name)

    提供对象属性(*dot notation*)的表示方法来读取网址查询数据::

        // 网址是 /posts/index?page=1&sort=title
        $value = $this->request->query('page');

    .. versionadded:: 2.3

.. php:method:: is($type)

    检查请求是否符合某种条件。使用内置检测规则，以及任何用 :php:meth:`CakeRequest::addDetector()` 定义的其它规则。

.. php:method:: addDetector($name, $options)

    添加检测器，供 is() 使用。详情请见 :ref:`check-the-request`。

.. php:method:: accepts($type = null)

    找出客户端接受哪些种类的内容类型(*content type*)，或者检查客户端是否接受某种类型的内容。

    获得所有类型::

        $this->request->accepts();

    检查一种类型::

        $this->request->accepts('application/json');

.. php:staticmethod:: acceptLanguage($language = null)

    或者获取客户端接受的所有语言，或者检查某种语言是否被接受。

    获得接受的语言列表::

        CakeRequest::acceptLanguage();

    检查是否接受某种语言::

        CakeRequest::acceptLanguage('es-es');

.. php:attr:: data

    POST 数据的数组。你可以用 :php:meth:`CakeRequest::data()` 来读取该属性，而又抑制错误通知。

.. php:attr:: query

    查询字符串(*query string*)参数数组。

.. php:attr:: params

    包含路由元素和请求参数的数组。

.. php:attr:: here

    返回当前请求的网址。

.. php:attr:: base

    应用程序的 base 路径，通常是 ``/``，除非 应用程序是在一个子目录内。

.. php:attr:: webroot

    当前的 webroot。

.. index:: $this->response

CakeResponse
############

:php:class:`CakeResponse` 是 CakePHP 的缺省响应类。它封装了一系列特性和功能，来为应用程序生成 HTTP 响应。它也可以帮助测试，鉴于它能被模拟/嵌入(*mocked/stubbed*)，从而让你可以检查要发送的文件头。如同 :php:class:`CakeRequest`， :php:class:`CakeResponse` 合并了一些之前在 :php:class:`Controller`，:php:class:`RequestHandlerComponent` 和 :php:class:`Dispatcher` 中的方法。这些旧方法已经废弃，请使用新方法。

``CakeResponse`` 提供了一个接口，包装了与响应有关的常见任务，比如:

* 为跳转发送文件头。
* 发送内容类型文件头。
* 发送任何文件头。
* 发送响应体。

改变响应类
===========================

CakePHP 缺省使用 ``CakeResponse``。 ``CakeResponse`` 是使用起来灵活且透明的类。但如果你需要用应用程序相关的类来代替它，你可以用你自己的类来进行替换，只需替换在 index.php 中使用的 CakeResponse 就可以了。

这会使你应用程序中的所有控制器都使用 ``CustomResponse``，而不是 :php:class:`CakeResponse`。你也可以在控制器中设置 ``$this->response`` 来替换使用的响应实例。在测试中替换响应对象是很方便的，因为这样允许你嵌入(*stub out*)与 ``header()`` 交互的方法。详情请参看 :ref:`cakeresponse-testing` 一节。

处理内容类型(*content types*)
===========================

你可以用 :php:meth:`CakeResponse::type()` 来控制你应用程序响应的内容类型(*Content-Type*)。如果你的应用程序需要处理不是 CakeResponse 内置的内容类型，你也可以用 ``type()`` 建立这些类型的对应::

    // 增加 vCard 类型
    $this->response->type(array('vcf' => 'text/v-card'));

    // 设置响应的内容类型(*Content-Type*)为 vcard。
    $this->response->type('vcf');

通常你会在控制器的 ``beforeFilter`` 回调中映射其它的内容类型，这样，如果你使用 :php:class:`RequestHandlerComponent` 的话，就可以利用它的自动切换视图的特性。

.. _cake-response-file:

发送文件
===================

有时候你需要发送文件作为对请求的响应。在2.3版本之前，你可以用 :doc:`/views/media-view` 来实现。在2.3版本中， MediaView 已被废弃，(不过)你可以用 :php:meth:`CakeResponse::file()` 来发送文件作为响应::

    public function sendFile($id) {
        $file = $this->Attachment->getFile($id);
        $this->response->file($file['path']);
        // 返回响应对象，阻止控制器渲染视图
        return $this->response;
    }

如上面的例子所示，你肯定需要为该方法提供文件路径。如果是 `CakeReponse::$_mimeTypes` 列出的已知文件类型， Cake 就会发送正确的内容类型文件头。你可以在调用 :php:meth:`CakeResponse::file()` 之前用 :php:meth:`CakeResponse::type()` 方法添加新类型。

如果需要，你也可以通过给定下面的选项，来强制文件下载，而不是显示在浏览器中::

    $this->response->file($file['path'], array('download' => true, 'name' => 'foo'));


设置文件头
===============

设置文件头可以使用 :php:meth:`CakeResponse::header()` 方法。它可以用几种不同的参数配置来调用::

    // 设置单一文件头
    $this->response->header('Location', 'http://example.com');

    // 设置多个文件头
    $this->response->header(array('Location' => 'http://example.com', 'X-Extra' => 'My header'));
    $this->response->header(array('WWW-Authenticate: Negotiate', 'Content-type: application/pdf'));

多次设置相同的文件头，会导致覆盖之前的值，就像通常的文件头调用一样。当 :php:meth:`CakeResponse::header()` 被调用时，文件头也不会被发送。它们只是被缓存起来，直到响应真正地被发送。

与浏览器缓存交互
================================

有时候你需要使浏览器不要缓存控制器动作的执行结果。 :php:meth:`CakeResponse::disableCache()` 就是为此用途::

    public function index() {
        // 做一些事情
        $this->response->disableCache();
    }

.. warning::

    从 SSL 域下载时使用 disableCache()，并试图向 Internet Explorer 发送文件，会导致错误。

你也可以使用 :php:meth:`CakeResponse::cache()`，告诉客户端你要缓存响应::

    public function index() {
        //做一些事情
        $this->response->cache('-1 minute', '+5 days');
    }

上述代码会告诉客户端把响应结果缓存5天，希望能够加快你的访问者的体验。 ``cache()`` 把 Last-Modified 的值设为传入的第一个参数。 Expires，和 Max-age 会基于第二个参数进行设置。 Cache-Control 也会被设为公有(*public*)。


.. _cake-response-caching:

微调 HTTP 缓存
======================

最好也是最容易的一种加速你的应用程序的方法是使用 HTTP 缓存。在这种缓存模式下，你只需要设置若干文件头，比如，修改时间、响应体标签(*response entity tag*)，等等，来帮助客户端决定它们是否需要使用响应的一份缓存拷贝。

你不必编写缓存的逻辑，以及一旦数据更改就使之无效(从而刷新它)。HTTP 使用两种模式，过期和有效性验证，这通常比你自己管理缓存要简单许多。

除了使用 :php:meth:`CakeResponse::cache()`，你也可以使用许多其它方法，来微调 HTTP 缓存文件头，从而利用浏览器或反向代理的缓存。

缓存控制(Cache Control)文件头
-----------------------------

.. versionadded:: 2.1

应用于过期模式下，这个文件头包括多个指示，可以改变浏览器或代理使用缓存内容的方式。一个缓存控制文件头可以象这样::

    Cache-Control: private, max-age=3600, must-revalidate

``CakeResponse`` 类有一些工具方法来帮助你设置这个文件头，并最终生成一个合法的缓存控制文件头。它们中的第一个是 :php:meth:`CakeResponse::sharable()` 方法，指示一个响应是否被不同的用户或客户端共享。这个方法实际控制这个文件头公有(*`public`*)或者私有(*`private`*)的部分。设置一个响应为私有，表示它的全部或者部分只适用于一个用户。要利用共享缓存，就需要设置控制指令为公有。

此方法的第二个参数用于指定缓存的最大年龄(*`max-age`*)，以秒为单位，这段时间过后缓存就不认为是最新的了。::

    public function view() {
        ...
        // 设置缓存为公有、3600秒
        $this->response->sharable(true, 3600);
    }

    public function my_data() {
        ...
        // 设置缓存为私有、3600秒
        $this->response->sharable(false, 3600);
    }

``CakeResponse`` 提供了单独的方法来设置缓存控制文件头中的每一部分。

过期文件头
---------------------

.. versionadded:: 2.1

同样处于缓存过期模式之下，你可以设置 `Expires` 文件头，根据 HTTP 规范，这是一个日期/时间，之后响应就被认为不是最新的了。这个文件头可以用 :php:meth:`CakeResponse::expires()` 方法来设置。

    public function view() {
        $this->response->expires('+5 days');
    }

这个方法也接受 DateTime 或者任何可以被 DateTime 解释的字符串。

Etag 文件头
---------------

.. versionadded:: 2.1

在 HTTP 中，当内容总是变化时，缓存验证是经常使用的，并要求应用程序只有当缓存不是最新的时候才生成响应内容。在这个模式下，客户端继续在缓存中保存网页，但并不直接使用，而是每次询问应用程序资源是否改变。这通常用于静态资源，比如图像和其它文件。

Etag 文件头(叫做数据项标签(*entity tag*))是一个字符串，用来唯一标识被请求的资源。这非常象一个文件的校验码，缓存会比较校验码，从而知道它们是否相同。

要真正利用这个文件头，你必须或者手动调用 :php:meth:`CakeResponse::checkNotModified()` 方法，或者把 :php:class:`RequestHandlerComponent` 包括在你的控制器中::

    public function index() {
        $articles = $this->Article->find('all');
        $this->response->etag($this->Article->generateHash($articles));
        if ($this->response->checkNotModified($this->request)) {
            return $this->response;
        }
        ...
    }

Last Modified 文件头
------------------------

.. versionadded:: 2.1

同样在 HTTP 缓存有效性验证模式下，你可以设置 `Last-Modified` 文件头，说明资源上次改变的日期和时间。设置这个文件头可以帮助 CakePHP 回答缓存客户端，基于客户端的缓存，响应是否有变化。

要真正利用这个文件头，你必须或者手动调用 :php:meth:`CakeResponse::checkNotModified()` 方法，或者把 :php:class:`RequestHandlerComponent` 包括在你的控制器中::

    public function view() {
        $article = $this->Article->find('first');
        $this->response->modified($article['Article']['modified']);
        if ($this->response->checkNotModified($this->request)) {
            return $this->response;
        }
        ...
    }

Vary 文件头
---------------

有些情况下，你也许会用同一网址提供不同的内容。这种情况通常是你有一个多语言网页，或者是根据请求资源的浏览器提供不同的 HTML。在这些情况下，你可以使用 Vary 文件头::

    $this->response->vary('User-Agent');
    $this->response->vary('Accept-Encoding', 'User-Agent');
    $this->response->vary('Accept-Language');

.. _cakeresponse-testing:

CakeResponse 和测试
========================

也许 ``CakeResponse`` 最大的好处在于，它使得测试控制器和组件更容易了。与其把方法散布于多个对象之中，现在控制器和组件只调用(*delegate*) ``CakeResponse``， 你也只需要模拟一个对象就可以了。这帮助你更加接近于“单元”测试，也使得测试控制器更容易了::

    public function testSomething() {
        $this->controller->response = $this->getMock('CakeResponse');
        $this->controller->response->expects($this->once())->method('header');
        // ...
    }

另外，你也可以更容易地从命令行运行测试了，因为你可以用模拟(*mock*)来避免在命令行界面设置文件头引起的“文件头已发送(*headers sent*)”的错误。


CakeResponse API
================

.. php:class:: CakeResponse

    CakeResponse 提供了一些有用的方法，来与你发送给客户端的响应交互。

.. php:method:: header($header = null, $value = null)

    允许你直接设置一个或多个文件头，与响应一起发送。

.. php:method:: charset($charset = null)

    设置响应使用的字符集。

.. php:method:: type($contentType = null)

    设置响应的内容类型(*content type*)。你可以使用一个已知内容类型别名，或完整的内容类型名称。

.. php:method:: cache($since, $time = '+1 day')

    允许你在响应中设置缓存文件头。

.. php:method:: disableCache()

    设置响应文件头，禁用客户端缓存。

.. php:method:: sharable($public = null, $time = null)

    设置 Cache-Control 文件头为 公有(*`public`*)或私有(*`private`*)，并可选择设置资源的 `max-age` 指令。

    .. versionadded:: 2.1

.. php:method:: expires($time = null)

    可设置过期(*`Expires`*)文件头为一个指定日期。

    .. versionadded:: 2.1

.. php:method:: etag($tag = null, $weak = false)

    设置 `Etag` 文件头，唯一地标识一个响应资源。

    .. versionadded:: 2.1

.. php:method:: modified($time = null)

    以正确的格式设置 `Last-Modified` 文件头为指定的日期和时间。

    .. versionadded:: 2.1

.. php:method:: checkNotModified(CakeRequest $request)

    比较请求对象的缓存文件头和响应的缓存文件头，决定响应是否还是最新的。如果是，删除所有响应内容，发送 `304 Not Modified` 文件头。

    .. versionadded:: 2.1

.. php:method:: compress()

    为请求打开 gzip 压缩。

.. php:method:: download($filename)

    允许你把响应作为附件发送，并设置文件名。

.. php:method:: statusCode($code = null)

    允许你设置响应的状态编码。

.. php:method:: body($content = null)

    设置响应的内容体。

.. php:method:: send()

    一旦你完成了响应的创建，调用 send() 会发送所有设置的文件头和文件体。这是在每次请求的最后由 :php:class:`Dispatcher` 自动执行的。

.. php:method:: file($path, $options = array())

    允许你设置一个文件，用于显示或下载。

    .. versionadded:: 2.3


.. meta::
    :title lang=en: Request and Response objects
    :keywords lang=en: request controller,request parameters,array indices,purpose index,response objects,domain information,request object,request data,interrogating,params,previous versions,introspection,dispatcher,rout,data structures,arrays,ip address,migration,indexes,cakephp