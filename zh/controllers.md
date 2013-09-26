控制器
######


控制器是MVC中的“C”。通过路由，正确的控制器被确定之后，控制器的动作就会被调用。
你的控制器应当解释请求数据，确保使用正确的模型，并渲染正确的响应或视图。
控制器可以被认为是模型和视图之间的中间人。你应当保持控制器瘦，而模型胖。
这将使你更容易复用你的代码，使你的代码更容易测试。

通常，控制器用于管理关于单个模型的逻辑。例如，如果你为一个在线面包店制作网站，
你可能会有 RecipesController 和 IngredientsController，来管理你的食谱和它们的
成分。在 CakePHP 中，控制器跟随它们处理的主要模型来命名。当然也完全可以让控制器处理多个模型。

你的应用程序的控制器继承于 ``AppController`` 类，而 ``AppController`` 类
又继承于核心的 :php:class:`Controller` 类。AppController 类可以定义在
 ``/app/Controller/AppController.php`` 中，它所包含的方法应该是在你的应用程序所有的
控制器之间共享的。

控制器提供了一些方法，称为*动作*(*action*)。动作是控制器处理请求的方法。在默认情况下，
控制器所有的公有方法都是动作，可以从网址(*URL*)访问。动作负责解释请求，并生成响应。
通常响应是以渲染视图的方式产生，但也可以用其他的方式来生成响应。


.. _app-controller:

App控制器
The App Controller
==================

如介绍中说所说， AppController 控制器是你应用程序中所有控制器的父类。 AppController 本身扩展了 CakePHP 核心库中的 Controller 类。由此， AppController 定义在 ``/app/Controller/AppController.php`` 中，象这样::
As stated in the introduction, the AppController class is the
parent class to all of your application's controllers.
AppController itself extends the Controller class included in the
CakePHP core library. As such, AppController is defined in
``/app/Controller/AppController.php`` like so::

    class AppController extends Controller {
    }

在你的 AppController 中创建的控制器的属性和方法， 可以被你应用程序中所有的控制器所使用。这是为你应用程序中所有的控制器编写共用代码的理想地方。组件(你以后将会了解到)最好用于很多(但不一定是所有)控制器中用到的代码。
Controller attributes and methods created in your AppController
will be available to all of your application's controllers. It is
the ideal place to create code that is common to all of your
controllers. Components (which you'll learn about later) are best
used for code that is used in many (but not necessarily all)
controllers.

虽然通常的面向对象继承规则依然适用， CakePHP 针对特殊的控制器属性做了一些额外的工作。组件(*components*)和助件(*helpers*)列表被控制器特别对待。对这两个列表， AppController 中的值会和控制器子类中的(同名)数组合并。子类中的值总是覆盖 AppController 中的值。
While normal object-oriented inheritance rules apply, CakePHP
does a bit of extra work when it comes to special controller
attributes. The list of components and helpers used by a
controller are treated specially. In these cases, AppController
value arrays are merged with child controller class arrays. The values in the
child class will always override those in AppController.

.. note::

    CakePHP 将下列变量从 AppController 合并到你应用程序的控制器:
    CakePHP merges the following variables from the AppController to
    your application's controllers:

    -  $components
    -  $helpers
    -  $uses

如果你在你的 AppController 中定义 var ``$helpers``，记住加入缺省的 Html 和 Form 助件。
Remember to add the default Html and Form helpers, if you define
var ``$helpers`` in your AppController

也请记住在控制器子类的回调方法中调用 AppController 的回调方法，以达到最好的效果::
Please also remember to call AppController's callbacks within child
controller callbacks for best results::

    public function beforeFilter() {
        parent::beforeFilter();
    }

请求参数
Request parameters
==================

当一个请求提交给 CakePHP 应用程序时， CakePHP 的 :php:class:`Router` 和
:php:class:`Dispatcher` 类使用 :ref:`routes-configuration` 来查找和创建正确的控制器。请求数据被封装在一个请求对象中。 CakePHP 把所有重要的请求信息放在 ``$this->request`` 属性中。关于 CakePHP 请求对象的更多信息，请参看 :ref:`cake-request` 这一节。
When a request is made to a CakePHP application, CakePHP's :php:class:`Router` and
:php:class:`Dispatcher` classes use :ref:`routes-configuration` to find and
create the correct controller. The request data is encapsulated into a request
object. CakePHP puts all of the important request information into the
``$this->request`` property.  See the section on
:ref:`cake-request` for more information on the CakePHP request object.

控制器动作
Controller actions
==================

控制器动作负责将请求参数转换成对提交请求的浏览器/用户的响应。 CakePHP 使用约定使这个过程自动化，去掉一些否则你要写的 boiler-plate 代码。
Controller actions are responsible for converting the request parameters into a
response for the browser/user making the request.  CakePHP uses conventions to
automate this process and remove some boiler-plate code you would otherwise need
to write.

根据约定 CakePHP 会渲染一个以动作名称的 inflected 版本命名的视图。回到我们在线烹饪的例子，我们的 RecipesController 也许会有 ``view()``，``share()`` 和 ``search()`` 动作。控制器可以在 ``/app/Controller/RecipesController.php`` 文件中找到，有如下内容::
By convention CakePHP renders a view with an inflected version of the action
name.  Returning to our online bakery example, our RecipesController might contain the
``view()``, ``share()``, and ``search()`` actions. The controller would be found
in ``/app/Controller/RecipesController.php`` and contain::

        # /app/Controller/RecipesController.php

        class RecipesController extends AppController {
            public function view($id) {
                //这里是动作逻辑 action logic goes here..
            }

            public function share($customerId, $recipeId) {
                //这里是动作逻辑 action logic goes here..
            }

            public function search($query) {
                // 这里是动作逻辑 action logic goes here..
            }
        }

这些动作的视图文件将会是 ``app/View/Recipes/view.ctp``，``app/View/Recipes/share.ctp`` 和 ``app/View/Recipes/search.ctp``。根据约定，视图文件名是动作名称的下划线分隔的小写版本。
The view files for these actions would be ``app/View/Recipes/view.ctp``,
``app/View/Recipes/share.ctp``, and ``app/View/Recipes/search.ctp``.  The
conventional view file name is the lower cased and underscored version of the
action name.

控制器动作通常用 :php:meth:`~Controller::set()` 创建上下文，供 :php:class:`View` 来渲染视图。正是得益于 CakePHP 使用的约定，你不必手动创建和渲染视图。而是，一旦控制器动作完成， CakePHP 会处理视图的渲染和发送。
Controller actions generally use :php:meth:`~Controller::set()` to create a
context that :php:class:`View` uses to render the view.  Because of the
conventions that CakePHP uses, you don't need to create and render the view
manually. Instead once a controller action has completed, CakePHP will handle
rendering and delivering the View.

如果出于某种原因，你想要跳过缺省的行为，下面的两种技术都可以跳过缺省的视图渲染过程。
If for some reason you'd like to skip the default behavior.  Both of the
following techniques will by-pass the default view rendering behavior.

* 如果你从你的控制器动作返回字符串，或者可以转换成字符串的对象，这就会被作为响应体。
  If you return a string, or an object that can be converted to a string from
  your controller action, it will be used as the response body.
* 你可以返回一个 :php:class:`CakeResponse` 对象，包含创建的完整响应。
  You can return a :php:class:`CakeResponse` object with the completely created
  response.

当控制器方法用于 :php:meth:`~Controller::requestAction()` 时，你经常想返回不是字符串的数据。如果你有用于正常网页请求+ requestAction 的控制器方法，你应当在返回前检查请求类型::
When controller methods are used with :php:meth:`~Controller::requestAction()`
you will often want to return data that isn't a string.  If you have controller
methods that are used for normal web requests + requestAction you should check
the request type before returning::

    class RecipesController extends AppController {
        public function popular() {
            $popular = $this->Recipe->popular();
            if (!empty($this->request->params['requested'])) {
                return $popular;
            }
            $this->set('popular', $popular);
        }
    }

上面的控制器动作是一例，说明同一个方法如何用于 ``requestAction()`` 和正常的请求。对非 requestAction 请求返回数组数据会引起错误，应当避免。关于使用 ``requestAction()`` 的更多提示，请参看 :php:meth:`Controller::requestAction()` 一节。
The above controller action is an example of how a method can be used with
``requestAction()`` and normal requests. Returning an array data to a
non-requestAction request will cause errors and should be avoided.  See the
section on :php:meth:`Controller::requestAction()` for more tips on using
``requestAction()``

为了让你在自己的应用程序中有效地使用控制器，我们介绍一些 CakePHP 的控制器提供的核心属性和方法。
In order for you to use a controller effectively in your own application, we'll
cover some of the core attributes and methods provided by CakePHP's controllers.

.. _controller-life-cycle:

请求生命周期回调
Request Life-cycle callbacks
============================

.. php:class:: Controller

CakePHP 控制器带有的回调，让你可以用来在请求生命周期的各个阶段加入逻辑:
CakePHP controllers come fitted with callbacks you can use to
insert logic around the request life-cycle:

.. php:method:: beforeFilter()

    这个函数在控制器每个动作之前执行。
    这里可以方便地检查有效的会话，或者检查用户的权限。
    This function is executed before every action in the controller.
    It's a handy place to check for an active session or inspect user
    permissions.

    .. note::

        对未找到的动作和脚手架动作，beforeFilter() 方法也会被调用。
        The beforeFilter() method will be called for missing actions,
        and scaffolded actions.

.. php:method:: beforeRender()

    在控制器动作逻辑之后，但在视图渲染之前被调用。这个回调不常用，但如果你在一个动作结束前自己调用 render()，就可能会需要。
    Called after controller action logic, but before the view is
    rendered. This callback is not used often, but may be needed if you
    are calling render() manually before the end of a given action.

.. php:method:: afterFilter()

    在每个动作之后，且在渲染完成之后，才调用。这是控制器运行的最后一个方法。
    Called after every controller action, and after rendering is
    complete. This is the last controller method to run.

除了控制器生命周期的回调， :doc:`/controllers/components` 也提供了一组类似的回调。
In addition to controller life-cycle callbacks, :doc:`/controllers/components`
also provide a similar set of callbacks.

.. _controller-methods:

控制器方法
Controller Methods
==================

如果想要知道控制器方法的完整列表和描述，请查阅 CakePHP API， `http://api20.cakephp.org/class/controller <http://api20.cakephp.org/class/controller>`_。
For a complete list of controller methods and their descriptions
visit the CakePHP API. Check out
`http://api20.cakephp.org/class/controller <http://api20.cakephp.org/class/controller>`_.

与视图交互
Interacting with Views
----------------------

控制器有多若干种方式与视图交流互。首先可以用 ``set()`` 传递数据给视图。你也可以决定用哪个视图类，从控制器渲染哪个视图文件。
Controllers interact with the view in a number of ways. First they
are able to pass data to the views, using ``set()``. You can also
decide which view class to use, and which view file should be
rendered from the controller.

.. php:method:: set(string $var, mixed $value)

    ``set()`` 方法是从你的控制器传递数据到你的视图的主要方式。一旦你用了 ``set()``，变量就可以在你的视图中访问到。
    The ``set()`` method is the main way to send data from your
    controller to your view. Once you've used ``set()``, the variable
    can be accessed in your view::

        // 首先从控制器传递数据: First you pass data from the controller:

        $this->set('color', 'pink');

        // 然后，在视图里，你可以运用该数据: Then, in the view, you can utilize the data:
        ?>

        你为蛋糕选择了 You have selected <?php echo $color; ?> 色的糖霜。 icing for the cake.

    ``set()`` 方法也接受关联数组作为其第一个参数。这经常是快速为视图设置一组信息的方法。
    The ``set()`` method also takes an associative array as its first
    parameter. This can often be a quick way to assign a set of
    information to the view.

    .. versionchanged:: 1.3
        数组的键在赋值给视图前，不再会被 inflected 了('underscored\_key' 不再会变成 'underscoredKey'，等等)
        Array keys will no longer be inflected before they are assigned
        to the view ('underscored\_key' does not become 'underscoredKey'
        anymore, etc.):

    ::

        $data = array(
            'color' => 'pink',
            'type' => 'sugar',
            'base_price' => 23.95
        );

        // 使 $color，$type 和 $base_price 能够被视图使用: make $color, $type, and $base_price
        // available to the view:

        $this->set($data);


    属性 ``$pageTitle`` 不再存在，用 ``set()`` 设置标题::
    The attribute ``$pageTitle`` no longer exists, use ``set()`` to set
    the title::

        $this->set('title_for_layout', 'This is the page title');


.. php:method:: render(string $view, string $layout)

    ``render()`` 方法在每个请求的控制器动作结束时会被自动调用。这个方法执行所有的视图逻辑(使用你用 ``set()`` 方法给出的数据)，将视图放入其布局中，并把视图提供给最终用户。
    The ``render()`` method is automatically called at the end of each
    requested controller action. This method performs all the view
    logic (using the data you’ve given in using the ``set()`` method),
    places the view inside its layout and serves it back to the end
    user.

    渲染使用的缺省视图文件由约定决定。如果请求的是 RecipesController 的 ``search()`` 动作，视图文件 /app/View/Recipes/search.ctp 将被渲染::
    The default view file used by render is determined by convention.
    If the ``search()`` action of the RecipesController is requested,
    the view file in /app/View/Recipes/search.ctp will be rendered::

        class RecipesController extends AppController {
        // ...
            public function search() {
                // 渲染视图 /View/Recipes/search.ctp Render the view in /View/Recipes/search.ctp
                $this->render();
            }
        // ...
        }

    虽然 CakePHP 会在每个动作的逻辑之后自动调用它(除非你设置了 ``$this->autoRender`` 为 false)，你仍然可以用该方法通过用 ``$action`` 指定一个控制器的动作来指定另外一个视图文件。
    Although CakePHP will automatically call it (unless you’ve set
    ``$this->autoRender`` to false) after every action’s logic, you can
    use it to specify an alternate view file by specifying an action
    name in the controller using ``$action``.

    如果 ``$view`` 以 '/' 开头，就被认为是相对于 ``/app/View`` 的视图或者元素文件。这允许直接渲染元素，在 ajax 请求中很有用。
    If ``$view`` starts with '/' it is assumed to be a view or
    element file relative to the ``/app/View`` folder. This allows
    direct rendering of elements, very useful in ajax calls.
    ::

        // 渲染 /View/Elements/ajaxreturn.ctp 中的元素 Render the element in /View/Elements/ajaxreturn.ctp
        $this->render('/Elements/ajaxreturn');

    ``$layout`` 参数允许你指定视图渲染于其中的布局。
    The ``$layout`` parameter allows you to specify the layout the
    view is rendered in.

渲染某个视图
Rendering a specific view
~~~~~~~~~~~~~~~~~~~~~~~~~

在你的控制器中你也许想要渲染与约定不同的视图。为此你可以直接调用 ``render()``。你一旦调用了 ``render()``， CakePHP 就不会试图再次渲染该视图了::
In your controller you may want to render a different view than
what would conventionally be done. You can do this by calling
``render()`` directly. Once you have called ``render()`` CakePHP
will not try to re-render the view::

    class PostsController extends AppController {
        public function my_action() {
            $this->render('custom_file');
        }
    }

这会渲染 ``app/View/Posts/custom_file.ctp``，而不是 ``app/View/Posts/my_action.ctp``。
This would render ``app/View/Posts/custom_file.ctp`` instead of
``app/View/Posts/my_action.ctp``


你也可以用下面的语法渲染插件中的视图: ``$this->render('PluginName.PluginController/custom_file')``。例如::
You can also render views inside plugins using the following syntax:
``$this->render('PluginName.PluginController/custom_file')``.
For example::

    class PostsController extends AppController {
        public function my_action() {
            $this->render('Users.UserDetails/custom_file');
        }
    }

这会渲染 ``app/Plugin/Users/View/UserDetails/custom_file.ctp``。
This would render ``app/Plugin/Users/View/UserDetails/custom_file.ctp``

流程控制
Flow Control
------------

.. php:method:: redirect(mixed $url, integer $status, boolean $exit)

    你最常用到的流程控制方法是 ``redirect()``。这个方法的第一个参数接受的是 CakePHP 相对网址的形式。当一个用户成功地提交了一份订单之后，你也许想要引导他们到一个收据页面。::
    The flow control method you’ll use most often is ``redirect()``.
    This method takes its first parameter in the form of a
    CakePHP-relative URL. When a user has successfully placed an order,
    you might wish to redirect them to a receipt screen.::

        public function place_order() {
            // 这里是确认订单的逻辑Logic for finalizing order goes here
            if ($success) {
                $this->redirect(array('controller' => 'orders', 'action' => 'thanks'));
            } else {
                $this->redirect(array('controller' => 'orders', 'action' => 'confirm'));
            }
        }

    $url 参数可以使用相对或者绝对路径::
    You can also use a relative or absolute URL as the $url argument::

        $this->redirect('/orders/thanks'));
        $this->redirect('http://www.example.com');

    你也可以传递数据给动作::
    You can also pass data to the action::

        $this->redirect(array('action' => 'edit', $id));

    ``redirect()`` 的第二个参数允许你指定伴随跳转的 HTTP 状态编码。你也许要根据跳转的性质，使用301(页面永久性移动)或者303(参见其他页面)。
    The second parameter of ``redirect()`` allows you to define an HTTP
    status code to accompany the redirect. You may want to use 301
    (moved permanently) or 303 (see other), depending on the nature of
    the redirect.

    该方法会在跳转后调用 ``exit()``，除非你设置第三个参数为 ``false``。
    The method will issue an ``exit()`` after the redirect unless you
    set the third parameter to ``false``.

    如果你需要跳转到 referer 页面，你可以用::
    If you need to redirect to the referer page you can use::

        $this->redirect($this->referer());

    该方法也支持命名的参数。如果你要跳转到类似 ``http://www.example.com/orders/confirm/product:pizza/quantity:5`` 的页面，你可以用::
    The method also supports name based parameters. If you want to redirect
    to a URL like: ``http://www.example.com/orders/confirm/product:pizza/quantity:5``
    you can use::

        $this->redirect(array('controller' => 'orders', 'action' => 'confirm', 'product' => 'pizza', 'quantity' => 5));

.. php:method:: flash(string $message, string|array $url, integer $pause, string $layout)

    如同 ``redirect()``，``flash()`` 方法用于在一项操作之后引导用户到一个新的页面。 ``flash()`` 方法的不同之处在于，它会显示一条信息，然后才引导用户到另一个网址。
    Like ``redirect()``, the ``flash()`` method is used to direct a
    user to a new page after an operation. The ``flash()`` method is
    different in that it shows a message before passing the user on to
    another URL.

    第一个参数应当为要显示的信息，而第二个参数是 CakePHP 的相对地址。 CakePHP 会显示 ``$message`` 并停留 ``$pause`` 秒，再引导用户跳转。
    The first parameter should hold the message to be displayed, and
    the second parameter is a CakePHP-relative URL. CakePHP will
    display the ``$message`` for ``$pause`` seconds before forwarding
    the user on.

    如果你有想用某个模板来显示你的跳转信息，你可以在 ``$layout`` 参数指定那个布局的名字。
    If there's a particular template you'd like your flashed message to
    use, you may specify the name of that layout in the ``$layout``
    parameter.

    对于页面内的闪现提示信息，请务必参考 SessionComponent 组件的 setFlash() 方法。
    For in-page flash messages, be sure to check out SessionComponent’s
    setFlash() method.

回调
Callbacks
---------

除了 :ref:`controller-life-cycle`， CakePHP 还支持脚手架相关的的回调。
In addition to the :ref:`controller-life-cycle`.
CakePHP also supports callbacks related to scaffolding.

.. php:method:: beforeScaffold($method)

    $method 是调用的方法名，例如 index，edit，等等。 name of method called example index, edit, etc.

.. php:method:: afterScaffoldSave($method)

    $method 是调用的方法名，为 edit 或 update。 name of method called either edit or update.

.. php:method:: afterScaffoldSaveError($method)

    $method 是调用的方法名，为 edit 或 update。 name of method called either edit or update.

.. php:method:: scaffoldError($method)

    $method 是调用的方法名，例如 index，edit，等等。 name of method called example index, edit, etc.

其它有用的方法
Other Useful Methods
--------------------

.. php:method:: constructClasses

    这个方法加载控制器需要的模型。此加载过程通常由 CakePHP 执行，但在不同的情况下使用控制器时，有该方法就很方便。如果你在命令行脚本或者一些其它外部应用中需要 CakePHP，那么 constructClasses() 就会很方便。
    This method loads the models required by the controller. This
    loading process is done by CakePHP normally, but this method is
    handy to have when accessing controllers from a different
    perspective. If you need CakePHP in a command-line script or some
    other outside use, constructClasses() may come in handy.

.. php:method:: referer(mixed $default = null, boolean $local = false)

    返回当前请求的 referring 网址。如果 HTTP\_REFERER 无法从请求头部读出，参数 ``$default`` 可以用来提供一个缺省的网址。所以与其这样::
    Returns the referring URL for the current request. Parameter
    ``$default`` can be used to supply a default URL to use if
    HTTP\_REFERER cannot be read from headers. So, instead of doing
    this::

        class UserController extends AppController {
            public function delete($id) {
                // 删除的代码在这里，然后... delete code goes here, and then...
                if ($this->referer() != '/') {
                    $this->redirect($this->referer());
                } else {
                    $this->redirect(array('action' => 'index'));
                }
            }
        }

    你可以这样::
    you can do this::

        class UserController extends AppController {
            public function delete($id) {
                // 删除的代码在这里，然后... delete code goes here, and then...
                $this->redirect($this->referer(array('action' => 'index')));
            }
        }

    如果 ``$default`` 没有设置，该功能的缺省值为域的根目录 - '/'。
    If ``$default`` is not set, the function defaults to the root of
    your domain - '/'.

    参数 ``$local`` 如果设为 ``true``， referring 网址会被限制为本地服务器。
    Parameter ``$local`` if set to ``true``, restricts referring URLs
    to local server.

.. php:method:: disableCache

    用来告诉用户的**浏览器**不要缓存当前请求的结果。这不同于视图缓存，稍后的章节会介绍到。
    Used to tell the user’s **browser** not to cache the results of the
    current request. This is different than view caching, covered in a
    later chapter.

    在此作用下发送的(响应)头部信息为::
    The headers sent to this effect are::

        Expires: Mon, 26 Jul 1997 05:00:00 GMT
        Last-Modified: [current datetime] GMT
        Cache-Control: no-store, no-cache, must-revalidate
        Cache-Control: post-check=0, pre-check=0
        Pragma: no-cache

.. php:method:: postConditions(array $data, mixed $op, string $bool, boolean $exclusive)

    用此方法来将一组提交(POSTed)的模型数据(来自与 HtmlHelper 兼容的输入)转换成一组模型的查找条件。这个函数提供了一个建立查找逻辑的快捷方式。例如，管理人员也许想要能够查找订单，以便知道发送什么货物。你可以用 CakePHP 的 :php:class:`FormHelper` 和 :php:class:`HtmlHelper` 来快速创建基于 Order 模型的表单。然后控制器的动作就能够用从该表单提交的数据创建出查找条件::
    Use this method to turn a set of POSTed model data (from
    HtmlHelper-compatible inputs) into a set of find conditions for a
    model. This function offers a quick shortcut on building search
    logic. For example, an administrative user may want to be able to
    search orders in order to know which items need to be shipped. You
    can use CakePHP's :php:class:`FormHelper` and :php:class:`HtmlHelper`
    to create a quick form based on the Order model. Then a controller action
    can use the data posted from that form to craft find conditions::

        public function index() {
            $conditions = $this->postConditions($this->request->data);
            $orders = $this->Order->find('all', compact('conditions'));
            $this->set('orders', $orders);
        }

    如果 ``$this->request->data['Order']['destination']`` 等于 "Old Towne Bakery"， postConditions 方法会把该条件转换成 Model->find() 方法可以使用的数组。在此例中，将是 ``array('Order.destination' => 'Old Towne Bakery')``。
    If ``$this->request->data['Order']['destination']`` equals "Old Towne Bakery",
    postConditions converts that condition to an array compatible for
    use in a Model->find() method. In this case,
    ``array('Order.destination' => 'Old Towne Bakery')``.

    如果你要在条件间使用不同的 SQL 运算符，用第二个参数指定::
    If you want to use a different SQL operator between terms, supply them
    using the second parameter::

        /*
        Contents of $this->request->data
        array(
            'Order' => array(
                'num_items' => '4',
                'referrer' => 'Ye Olde'
            )
        )
        */

        // 让我们得到至少4份包含 'Ye Olde' 的订单 Let's get orders that have at least 4 items and contain 'Ye Olde'
        $conditions = $this->postConditions(
            $this->request->data,
            array(
                'num_items' => '>=',
                'referrer' => 'LIKE'
            )
        );
        $orders = $this->Order->find('all', compact('conditions'));

    第三个参数让你可以告诉 CakePHP 在查找条件之间使用什么 SQL 逻辑运算符。象 ‘AND’，‘OR’ 和 ‘XOR’ 这样的字符串都是合法的值。
    The third parameter allows you to tell CakePHP what SQL boolean
    operator to use between the find conditions. Strings like ‘AND’,
    ‘OR’ and ‘XOR’ are all valid values.

    最后，如果最后一个参数设为 true，而 $op 参数是一个数组， $op 未包含的字段将不会出现在返回的条件中。
    Finally, if the last parameter is set to true, and the $op
    parameter is an array, fields not included in $op will not be
    included in the returned conditions.

.. php:method:: paginate()

    该方法用于将模型得到的结果分页。你可以指定分页大小，模型的查找条件，等等。请参看 :doc:`pagination <core-libraries/components/pagination>` 一节以得到关于如何使用  paginate 的更多细节。
    This method is used for paginating results fetched by your models.
    You can specify page sizes, model find conditions and more. See the
    :doc:`pagination <core-libraries/components/pagination>` section for more details on
    how to use paginate.

.. php:method:: requestAction(string $url, array $options)

    该函数从任何地方调用一个控制器的动作，并从该动作返回数据。传入的 ``$url`` 参数是一个 CakePHP 网址(/controllername/actionname/params)。要给接受的控制器动作传入更多数据，就加入到 $options 数组中。
    This function calls a controller's action from any location and
    returns data from the action. The ``$url`` passed is a
    CakePHP-relative URL (/controllername/actionname/params). To pass
    extra data to the receiving controller action add to the $options
    array.

    .. note::

        从 options 参数传入 'return'，你就能用 ``requestAction()`` 得到完整渲染的视图: ``requestAction($url, array('return'));``。重要的是，请注意，从控制器方法用 'return' 调用 requestAction，可能引起脚本和 css 标签工作不正常。
        You can use ``requestAction()`` to retrieve a fully rendered view
        by passing 'return' in the options:
        ``requestAction($url, array('return'));``. It is important to note
        that making a requestAction using 'return' from a controller method
        can cause script and css tags to not work correctly.

    .. warning::

        如果不使用缓存， ``requestAction`` 会导致糟糕的性能。所以在控制器或者模型中都极少适用。
        If used without caching ``requestAction`` can lead to poor
        performance. It is rarely appropriate to use in a controller or
        model.

    ``requestAction`` 最好和(缓存的)元素一起使用 —— 作为一种在渲染前为元素获取数据的方法。让我们用一个把“近期评论”的元素放入布局的例子。首先我们要增加一个控制器函数来返回数据::
    ``requestAction`` is best used in conjunction with (cached)
    elements – as a way to fetch data for an element before rendering.
    Let's use the example of putting a "latest comments" element in the
    layout. First we need to create a controller function that will
    return the data::

        // Controller/CommentsController.php
        class CommentsController extends AppController {
            public function latest() {
                if (empty($this->request->params['requested'])) {
                    throw new ForbiddenException();
                }
                return $this->Comment->find('all', array('order' => 'Comment.created DESC', 'limit' => 10));
            }
        }

    你应当总是包括确保 requestAction 方法的调用确实源自 ``requestAction`` 的检查。不做此检查，将允许 requestAction 可以从网址直接访问，通常这样不好。
    You should always include checks to make sure your requestAction methods are
    actually originating from ``requestAction``.  Failing to do so will allow
    requestAction methods to be directly accessible from a URL, which is
    generally undesirable.

    如果我们现在增加一个简单的元素来调用此函数::
    If we now create a simple element to call that function::

        // View/Elements/latest_comments.ctp

        $comments = $this->requestAction('/comments/latest');
        foreach ($comments as $comment) {
            echo $comment['Comment']['title'];
        }

    然后我们就可以象下面这样，把这个元素放在任何地方，得到输出::
    We can then place that element anywhere to get the output
    using::

        echo $this->element('latest_comments');

    用这样的写法，任何时候元素被渲染，都会有一个请求被提交到控制器来获取数据，数据会被处理并返回。当然，与上面的警告相一致，最好使用元素缓存，来避免不必要的处理。这样修改对元素的调用::
    Written in this way, whenever the element is rendered, a request
    will be made to the controller to get the data, the data will be
    processed, and returned. However in accordance with the warning
    above it's best to make use of element caching to prevent needless
    processing. By modifying the call to element to look like this::

        echo $this->element('latest_comments', array('cache' => '+1 hour'));

    只要缓存的元素视图文件还存在并有效， ``requestAction`` 就不会被调用。
    The ``requestAction`` call will not be made while the cached
    element view file exists and is valid.

    另外，现在 requestAction 接受基于数组的 Cake 风格的网址::
    In addition, requestAction now takes array based cake style urls::

        echo $this->requestAction(
            array('controller' => 'articles', 'action' => 'featured'),
            array('return')
        );

    这允许 requestAction 的调用略过 Router::url 的使用，从而可以改善性能。基于网址的数组与 :php:meth:`HtmlHelper::link()` 使用的相同，除了有一点区别 - 如果你使用命名参数或者传入参数(named or passed parameters)，你必须把它们放入第二个数组并配以正确的键。这是因为 requestAction 会把命名参数数组(requestAction 的第二个参数)与 Controller::params 成员数组合并，而不把命名参数数组明确地放在 'named' 键中； ``$option`` 数组中的其它成员也可以在请求的动作的 Controller::params 数组中可以得到::
    This allows the requestAction call to bypass the usage of
    Router::url which can increase performance. The url based arrays
    are the same as the ones that :php:meth:`HtmlHelper::link()` uses with one
    difference - if you are using named or passed parameters, you must put them
    in a second array and wrap them with the correct key. This is because
    requestAction merges the named args array (requestAction's 2nd parameter)
    with the Controller::params member array and does not explicitly place the
    named args array into the key 'named'; Additional members in the ``$option``
    array will also be made available in the requested action's
    Controller::params array::

        echo $this->requestAction('/articles/featured/limit:3');
        echo $this->requestAction('/articles/view/5');

    以数组形式在 requestAction 中就会是::
    As an array in the requestAction would then be::

        echo $this->requestAction(
            array('controller' => 'articles', 'action' => 'featured'),
            array('named' => array('limit' => 3))
        );

        echo $this->requestAction(
            array('controller' => 'articles', 'action' => 'view'),
            array('pass' => array(5))
        );

    .. note::

        不像其它地方地方，数组网址和字符串网址类似，requestAction 对他们的处理不同。
        Unlike other places where array urls are analogous to string urls,
        requestAction treats them differently.

    当把数组网址和 requestAction() 一起使用时，你一定要给出请求的动作所需要的**所有**参数。这包括象 ``$this->request->data`` 这样的参数。除了传入所有需要的参数外，命名参数和传入参数必须在第二个数组提供，如上面所示。
    When using an array url in conjunction with requestAction() you
    must specify **all** parameters that you will need in the requested
    action. This includes parameters like ``$this->request->data``.  In addition
    to passing all required parameters, named and pass parameters must be done
    in the second array as seen above.


.. php:method:: loadModel(string $modelClass, mixed $id)

    当你要使用的模型不是控制器的缺省模型或者关联模型时，``loadModel`` 函数就很方便::
    The ``loadModel`` function comes handy when you need to use a model
    which is not the controller's default model or its associated
    model::

        $this->loadModel('Article');
        $recentArticles = $this->Article->find('all', array('limit' => 5, 'order' => 'Article.created DESC'));

        $this->loadModel('User', 2);
        $user = $this->User->read();


控制器属性
Controller Attributes
=====================

控制器属性及其描述的完整列表，请参看 CakePHP API，`http://api20.cakephp.org/class/controller <http://api20.cakephp.org/class/controller>`_。
For a complete list of controller attributes and their descriptions
visit the CakePHP API. Check out
`http://api20.cakephp.org/class/controller <http://api20.cakephp.org/class/controller>`_.

.. php:attr:: name

    ``$name`` 属性应当置为控制器名称。通常这只是控制器使用的模型的复数形式。该属性可以省略，如果 CakePHP 不 inflecting 它的话。
    The ``$name`` attribute should be set to the
    name of the controller. Usually this is just the plural form of the
    primary model the controller uses. This property can be omitted,
    but saves CakePHP from inflecting it::

        // $name 控制器属性用法示例 $name controller attribute usage example
        class RecipesController extends AppController {
           public $name = 'Recipes';
        }


$components, $helpers 和 $uses
$components, $helpers and $uses
-------------------------------

下一个最常用的控制器属性告诉 CakePHP 当前控制器使用什么助件，组件和模型。使用这些属性让由 ``$components`` 和 ``$uses`` 指定的 MVC 类成为类变量(例如 ``$this->模型名称``)可以为控制器所用，而由 ``$helpers`` 指定的类作为对象引用变量(``$this->{$helpername}``)可以被视图使用。
The next most often used controller attributes tell CakePHP what
helpers, components, and models you’ll be using in conjunction with
the current controller. Using these attributes make MVC classes
given by ``$components`` and ``$uses`` available to the controller
as class variables (``$this->ModelName``, for example) and those
given by ``$helpers`` to the view as an object reference variable
(``$this->{$helpername}``).

.. note::

    每个控制器缺省就有这些类中的某些，所以你也许完全不用配置你的控制器。
    Each controller has some of these classes available by default, so
    you may not need to configure your controller at all.

.. php:attr:: uses

    缺省情况下，控制器可以访问它们的主模型。我们的 RecipesController 可以用 ``$this->Recipe`` 访问 Recipe 模型类，而我们的 ProductsController 也可以通过 ``$this->Product`` 来访问 Product 模型。然而，当要使用 ``$uses`` 变量让控制器访问更多的模型时，当前控制器的(主要)模型名称一定也要包括在内。这可由下面的例子说明。
    Controllers have access to their primary model available by
    default. Our RecipesController will have the Recipe model class
    available at ``$this->Recipe``, and our ProductsController also
    features the Product model at ``$this->Product``. However, when
    allowing a controller to access additional models through the
    ``$uses`` variable, the name of the current controller's model must
    also be included. This is illustrated in the example below.

    如果你在控制器中不想使用(任何)模型，就设置 ``public $uses = array()``。这允许你使用控制器，而不需要相应的模型文件。然而 ``AppController`` 中定义的模型仍然会加载。你也可以用 ``false`` 来完全不加载任何模型，即使是 ``AppController`` 中定义的模型。
    If you do not wish to use a Model in your controller, set
    ``public $uses = array()``. This will allow you to use a controller
    without a need for a corresponding Model file. However, the models
    defined in the ``AppController`` will still be loaded.  You can also use
    ``false`` to not load any models at all.  Even those defined in the
    ``AppController``.

    .. versionchanged:: 2.1
        Uses 变量现在有了新的缺省值，而且它对 ``false`` 的处理也不同了。
        Uses now has a new default value, it also handles ``false`` differently.

.. php:attr:: helpers

    缺省情况下 Html, Form 和 Session 助件都是可用的，就像 SessionComponent 组件一样。但如果你选择在 AppController 中定义你自己的 ``$helpers`` 数组，记得包括 ``Html`` 和 ``Form``，如果你还想让它们在控制器中缺省就可用的话。要了解更多关于这些类的信息，就请查看本手册后面的相关章节。
    The Html, Form, and Session Helpers are available by
    default, as is the SessionComponent. But if you choose to define
    your own ``$helpers`` array in AppController, make sure to include
    ``Html`` and ``Form`` if you want them still available by default
    in your Controllers. To learn more about these classes, be sure
    to check out their respective sections later in this manual.

    让我们来看看如何让 CakePHP 控制器知道你打算使用额外的 MVC 类::
    Let’s look at how to tell a CakePHP controller that you plan to use
    additional MVC classes::

        class RecipesController extends AppController {
            public $uses = array('Recipe', 'User');
            public $helpers = array('Js');
            public $components = array('RequestHandler');
        }

    这些变量每个都会与它们继承的值合并，所以没有必要(比如)再次声明 Form 助件，或者任何你在 App 控制器中已经声明的东西。
    Each of these variables are merged with their inherited values,
    therefore it is not necessary (for example) to redeclare the Form
    helper, or anything that is declared in your App controller.

.. php:attr:: components

    数组 components 允许你设置控制器要用哪个 :doc:`/controllers/components`。如同 ``$helpers`` 一样，你可以传递参数给组件(*components*)。更多信息请参看 :ref:`configuring-components`。
    The components array allows you to set which :doc:`/controllers/components`
    a controller will use.  Like ``$helpers`` and ``$uses`` components in your
    controllers are merged with those in ``AppController``.  As with
    ``$helpers`` you can pass settings into components.  See :ref:`configuring-components`
    for more information.

其它属性
Other Attributes
----------------

虽然你可以在 API 中查看所有控制器属性的细节，还有其它一些控制器属性值得在手册中有它们自己单独的章节。
While you can check out the details for all controller attributes
in the API, there are other controller attributes that merit their
own sections in the manual.

.. php:attr: cacheAction

    cacheAction 属性用来指定完整页面缓存的时间长度和其它信息。你可以在 :php:class:`CacheHelper` 文档中读到更多信息。
    The cacheAction attribute is used to define the duration and other
    information about full page caching.  You can read more about
    full page caching in the :php:class:`CacheHelper` documentation.

.. php:attr: paginate

    paginate 属性是废弃了的兼容性属性。用它来加载和配置 :php:class:`PaginatorComponent`。建议你更新你的代码，使用正常的组件设置::
    The paginate attribute is a deprecated compatibility property.  Using it
    loads and configures the :php:class:`PaginatorComponent`.  It is recommended
    that you update your code to use normal component settings::

        class ArticlesController extends AppController {
            public $components = array(
                'Paginator' => array(
                    'Article' => array(
                        'conditions' => array('published' => 1)
                    )
                )
            );
        }

.. todo::

    本章应当是较少关于控制器编程接口，更多示例，控制器属性一节内容繁多，一开始不好理解。本章应当以例子控制器及它们做什么开始。
    This chapter should be less about the controller api and more about
    examples, the controller attributes section is overwhelming and difficult to
    understand at first. The chapter should start with some example controllers
    and what they do.

关于控制器的更多内容
More on controllers
===================

.. toctree::

    controllers/request-response
    controllers/scaffolding
    controllers/pages-controller
    controllers/components


.. meta::
    :title lang=en: Controllers
    :keywords lang=en: correct models,controller class,controller controller,core library,single model,request data,middle man,bakery,mvc,attributes,logic,recipes