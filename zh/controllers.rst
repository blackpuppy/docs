控制器
######

控制器是MVC中的“C”。当经过路由处理，找到正确的控制器之后，就会调用控制器的动作。控制器用来解释请求数据，
使用相应的模型，并渲染相应的响应或视图。控制器可以被认为是模型和视图之间的中间人。
应当保持控制器瘦，而模型胖。这将使更容易复用代码，代码更容易测试。

通常，控制器用于管理单个模型的逻辑。例如，如果你在制作一个在线面包店网站，可能会创建RecipesController来管理食谱
，IngredientsController来管理它们的成分。控制器可以处理多个模型。在CakePHP中，控制器的名称会依照主模型的名字来命名。

应用程序中的控制器继承于 ``AppController`` 类，而 ``AppController`` 类又继承于核心的
:php:class:`Controller` 类。``AppController`` 类定义在
``/app/Controller/AppController.php`` 中，它所包含的方法是应用程序所有的控制器之间共享的。

控制器提供了一些处理请求的方法，称为 *动作(action)* 。在默认情况下，控制器所有的公有方法都是动作，
可通过URL访问。动作负责解释请求并生成响应。通常响应是以渲染视图的方式产生，但也可以用其他的方式来生成。


.. _app-controller:

App 控制器
==================

如介绍中说所说， ``AppController`` 控制器是应用程序中所有控制器的父类。 ``AppController`` 本身扩展了CakePHP
核心库中的 :php:class:`Controller` 类。由此， AppController 定义在
``/app/Controller/AppController.php`` 中，象这样::

    class AppController extends Controller {
    }

在  ``AppController`` 中创建的控制器的属性和方法， 可以在你的应用程序中所有的控制器所使用。
这是为你的应用程序中所有的控制器编写共用代码的理想地方。组件(你以后将会了解到)最好用于多个
(但不一定是所有)控制器中用到的代码。

虽然依然适用通常的面向对象继承规则， CakePHP 针对特殊的控制器属性做了一些额外的工作。
控制器使用的(*components组件*)和(*helpers助件*)列表被特别处理。对这两个列表， AppController
中的值会和控制器子类中的(同名)数组合并。子类中的值总是覆盖 AppController 中的值。

.. note::

    CakePHP 将下列变量从 AppController 合并到你应用程序的控制器:

    -  :php:attr:`~Controller::$components`
    -  :php:attr:`~Controller::$helpers`
    -  :php:attr:`~Controller::$uses`

如果你在你的 ``AppController`` 中定义 :php:attr:`~Controller::$helpers`，
记住加入默认的 Html 和 Form 助手。

也请记住，最好在控制器子类的回调方法中调用 ``AppController`` 的回调方法::

    public function beforeFilter() {
        parent::beforeFilter();
    }

请求参数
==================

当一个请求提交给 CakePHP 应用程序时， CakePHP 的 :php:class:`Router` 和
:php:class:`Dispatcher` 类使用 :ref:`routes-configuration` 来查找和创建正确的控制器。
请求数据被封装在一个请求对象中。 CakePHP 把所有重要的请求信息放在 ``$this->request`` 属性中。
关于 CakePHP 请求对象的更多信息，请参看 :ref:`cake-request` 这一节。

控制器动作
==================

控制器动作负责将请求参数转换成对提交请求的浏览器/用户的响应。 CakePHP 使用约定使这个过程自动化，
去掉一些否则你要自己写的(*boiler-plate样板*)代码。

根据约定 CakePHP 会渲染一个以动作名称的 inflected 版本命名的视图。回到我们在线面包店的例子，
我们的 RecipesController 也许会有 ``view()``，``share()`` 和 ``search()`` 动作。
控制器可以是 ``/app/Controller/RecipesController.php`` ，其内容如下::

        # /app/Controller/RecipesController.php

        class RecipesController extends AppController {
            public function view($id) {
                // 这里是动作逻辑 ...
            }

            public function share($customerId, $recipeId) {
                // 这里是动作逻辑 ...
            }

            public function search($query) {
                // 这里是动作逻辑 ...
            }
        }

这些动作的视图文件将会是 ``app/View/Recipes/view.ctp``，``app/View/Recipes/share.ctp``
和 ``app/View/Recipes/search.ctp``。根据约定，视图文件名是动作名称的下划线分隔的小写格式。

控制器动作通常用 :php:meth:`~Controller::set()` 创建上下文，供 :php:class:`View` 来渲染视图。
正是得益于 CakePHP 使用的约定，你不必手动创建和渲染视图。而是一旦控制器动作完成，
CakePHP 会处理视图的渲染和发送。

如果出于某种原因，想要跳过默认的行为，下面的两种技术都可以跳过默认的视图渲染过程。

* 如果你从你的控制器动作返回一个字符串，或者可以转换成字符串的对象，这就会被作为响应体。
* 你可以返回一个 :php:class:`CakeResponse` 对象，包含创建的完整响应。

当控制器方法用于 :php:meth:`~Controller::requestAction()` 时，你经常想返回不是字符串的数据。
如果你有用于正常网页请求+ requestAction 的控制器方法，你应当在返回前检查请求类型::

    class RecipesController extends AppController {
        public function popular() {
            $popular = $this->Recipe->popular();
            if (!empty($this->request->params['requested'])) {
                return $popular;
            }
            $this->set('popular', $popular);
        }
    }

上面的控制器动作是一例，说明同一个方法如何用于 ``requestAction()`` 和正常的请求。
对非 requestAction 请求返回数组数据会引起错误，应当避免。关于使用 ``requestAction()`` 的更多窍门，
请参看 :php:meth:`Controller::requestAction()` 一节。

为了让你在自己的应用程序中有效地使用控制器，我们来介绍一些CakePHP的控制器提供的核心属性和方法。

.. _controller-life-cycle:

请求生命周期回调
============================

.. php:class:: Controller

CakePHP控制器带有回调方法，用来在请求生命周期的各个阶段插入逻辑:

.. php:method:: beforeFilter()

    这个函数在控制器每个动作之前执行。
    这里可以方便地检查有效的会话，或者检查用户的权限。

    .. note::

        对未找到的动作和脚手架动作，beforeFilter() 方法也会被调用。

.. php:method:: beforeRender()

    在控制器动作逻辑之后，但在视图渲染之前被调用。这个回调不常用，但如果你在一个动作结束前自己调用 render()，
    就可能会需要。

.. php:method:: afterFilter()

    在每个动作之后，且在渲染完成之后，才调用。这是控制器运行的最后一个方法。

除了控制器生命周期的回调， :doc:`/controllers/components` 也提供了一组类似的回调。

.. _controller-methods:

控制器方法
==================

如果想要知道控制器方法的完整列表和描述，请查阅 CakePHP API，
`http://api20.cakephp.org/class/controller <http://api20.cakephp.org/class/controller>`_。

与视图交互
----------------------

控制器有若干种方式与视图交互。首先可以用 :php:meth:`~Controller::set()` 传递数据给视图。
也可以决定使用哪个视图类和决定渲染控制器的哪个视图文件。

.. php:method:: set(string $var, mixed $value)

    :php:meth:`~Controller::set()` 方法是从控制器传递数据到视图的主要方式。
    一旦用了 :php:meth:`~Controller::set()`，变量就可以在视图中访问到。

        // 首先从控制器传递数据:

        $this->set('color', 'pink');

        // 然后，在视图里，可以使用该数据:
        ?>

        你为蛋糕选择了 <?php echo $color; ?> 色的糖霜。

    :php:meth:`~Controller::set()` 方法也接受关联数组作为其第一个参数。这经常是快速为视图设置一组信息的方法。

    .. versionchanged:: 1.3
        数组的键在赋值给视图前，不再会被 inflected 了('underscored\_key' 不再会变成 'underscoredKey'，等等)

    ::

        $data = array(
            'color' => 'pink',
            'type' => 'sugar',
            'base_price' => 23.95
        );

        // 使 $color，$type 和 $base_price 能够被视图使用:
        $this->set($data);


    属性 ``$pageTitle`` 不再存在，用 :php:meth:`~Controller::set()` 设置标题::

        $this->set('title_for_layout', '这是页面标题');


.. php:method:: render(string $view, string $layout)

    :php:meth:`~Controller::render()` 方法在每个请求的控制器动作结束时会被自动调用。这个方法执行所有的视图逻辑
    (使用你用 :php:meth:`~Controller::set()` 方法给出的数据)，将视图放入其布局中，并把视图提供给最终用户。

    渲染使用的默认视图文件由约定决定。如果请求的是 RecipesController 的 ``search()`` 动作，
    视图文件 /app/View/Recipes/search.ctp 将被渲染::

        class RecipesController extends AppController {
        // ...
            public function search() {
                // 渲染视图 /View/Recipes/search.ctp
                $this->render();
            }
        // ...
        }

    虽然 CakePHP 会在每个动作的逻辑之后自动调用它(除非设置了 ``$this->autoRender`` 为 false)，
    仍然可以用该方法通过用 ``$action`` 指定一个控制器的动作来指定另外一个视图文件。

    如果 ``$view`` 以 '/' 开头，就被认为是相对于 ``/app/View`` 的视图或者元素文件。
    可以直接渲染元素，在 ajax 请求中很有用。
    ::

        // 渲染 /View/Elements/ajaxreturn.ctp 中的元素
        $this->render('/Elements/ajaxreturn');

    ``$layout`` 参数用来指定视图渲染于其中的布局。

渲染某个视图
~~~~~~~~~~~~~~~~~~~~~~~~~

有时候，在控制器中也许想要渲染与约定不同的视图。为此可以直接调用 ``render()``。一旦调用了 ``render()``，
CakePHP 就不会试图再次渲染该视图了::

    class PostsController extends AppController {
        public function my_action() {
            $this->render('custom_file');
        }
    }

这会渲染 ``app/View/Posts/custom_file.ctp``，而不是 ``app/View/Posts/my_action.ctp``。


也可以用下面的语法渲染插件中的视图: ``$this->render('PluginName.PluginController/custom_file')`` 。例如::

    class PostsController extends AppController {
        public function my_action() {
            $this->render('Users.UserDetails/custom_file');
        }
    }

这会渲染 ``app/Plugin/Users/View/UserDetails/custom_file.ctp``。

流程控制
------------

.. php:method:: redirect(mixed $url, integer $status, boolean $exit)

    最常用到的流程控制方法是 :php:meth:`~Controller::redirect()`。这个方法的第一个参数接受的是
    CakePHP 相对网址的形式。当一个用户成功地提交了一份订单之后，也许想要引导他们到收据页面::

        public function place_order() {
            // 这里是确认订单的逻辑
            if ($success) {
                $this->redirect(array('controller' => 'orders', 'action' => 'thanks'));
            } else {
                $this->redirect(array('controller' => 'orders', 'action' => 'confirm'));
            }
        }

    $url 参数可以使用相对或者绝对路径::

        $this->redirect('/orders/thanks');
        $this->redirect('http://www.example.com');

    也可以传递数据给动作::

        $this->redirect(array('action' => 'edit', $id));

    :php:meth:`~Controller::redirect()` 的第二个参数允许你指定伴随跳转的 HTTP 状态编码。也许要根据跳转的性质，
    使用301(页面永久性移动)或者303(参见其他页面)。

    该方法会在跳转后调用 ``exit()``，除非设置第三个参数为 ``false``。

    如果需要跳转到 referer 页面，可以用::

        $this->redirect($this->referer());

    该方法也支持命名的参数。如果要跳转到类似
    ``http://www.example.com/orders/confirm/product:pizza/quantity:5`` 的页面，可以用::

        $this->redirect(array('controller' => 'orders', 'action' => 'confirm', 'product' => 'pizza',
        'quantity' => 5));

.. php:method:: flash(string $message, string|array $url, integer $pause, string $layout)

    如同 :php:meth:`~Controller::redirect()`，:php:meth:`~Controller::flash()` 方法用于
    在一项操作之后引导用户到一个新的页面。
    :php:meth:`~Controller::flash()` 方法的不同之处在于，它会显示一条信息，然后才引导用户到另一个网址。

    第一个参数应当为要显示的信息，而第二个参数是 CakePHP 的相对地址。
    CakePHP 会显示 ``$message`` 并停留 ``$pause`` 秒，再引导用户跳转。

    如果你有想用某个模板来显示你的跳转信息，你可以在 :php:attr:`~View::$layout` 参数指定那个布局的名字。

    对于页面内的闪现提示信息，请务必参考 :php:meth:`SessionComponent::setFlash()` 方法。

回调
---------

除了 :ref:`controller-life-cycle`， CakePHP 还支持脚手架相关的的回调。

.. php:method:: beforeScaffold($method)

    $method 是调用的方法名，例如 index，edit，等等。

.. php:method:: afterScaffoldSave($method)

    $method 是调用的方法名，为 edit 或 update。

.. php:method:: afterScaffoldSaveError($method)

    $method 是调用的方法名，为 edit 或 update。

.. php:method:: scaffoldError($method)

    $method 是调用的方法名，例如 index，edit，等等。

其它有用的方法
--------------------

.. php:method:: constructClasses

    这个方法加载控制器需要的模型。此加载过程通常由 CakePHP 执行，但在不同的情况下使用控制器时，
    有该方法就很方便。如果在命令行脚本或者一些其它外部应用中需要 CakePHP，
    那么 :php:meth:`~Controller::constructClasses()` 就会很方便。

.. php:method:: referer(mixed $default = null, boolean $local = false)

    返回当前请求的 referring 网址。如果 HTTP\_REFERER 无法从请求文件头部读出，
    参数 ``$default`` 可以用来提供一个缺省的网址。所以与其这样::

        class UserController extends AppController {
            public function delete($id) {
                // 删除的代码在这里，然后...
                if ($this->referer() != '/') {
                    $this->redirect($this->referer());
                } else {
                    $this->redirect(array('action' => 'index'));
                }
            }
        }

    可以这样::

        class UserController extends AppController {
            public function delete($id) {
                // 删除的代码在这里，然后...
                $this->redirect($this->referer(array('action' => 'index')));
            }
        }

    如果 ``$default`` 没有设置，该功能的缺省值为域的根目录 - '/'。

    参数 ``$local`` 如果设为 ``true``， referring 网址会被限制为本地服务器。

.. php:method:: disableCache

    用来告诉用户的**浏览器**不要缓存当前请求的结果。这不同于视图缓存，稍后的章节会介绍到。

    在此作用下发送的(响应)头部信息为::

        Expires: Mon, 26 Jul 1997 05:00:00 GMT
        Last-Modified: [current datetime] GMT
        Cache-Control: no-store, no-cache, must-revalidate
        Cache-Control: post-check=0, pre-check=0
        Pragma: no-cache

.. php:method:: postConditions(array $data, mixed $op, string $bool, boolean $exclusive)

    用此方法来将一组提交(POSTed)的模型数据(来自与 HtmlHelper 兼容的输入)转换成一组模型的查找条件。
    这个函数提供了一个建立查找逻辑的快捷方式。例如，管理人员也许想要能够查询订单，以便知道发送什么货物。
    可以用 CakePHP 的 :php:class:`FormHelper` 和 :php:class:`HtmlHelper` 来快速创建基于 Order 模型的表单。
    然后控制器的动作就能够用从该表单提交的数据创建出查找条件::

        public function index() {
            $conditions = $this->postConditions($this->request->data);
            $orders = $this->Order->find('all', compact('conditions'));
            $this->set('orders', $orders);
        }

    如果 ``$this->request->data['Order']['destination']`` 等于 "Old Towne Bakery"，
    postConditions 方法会把该条件转换成 Model->find() 方法可以使用的数组。在此例中，
    将是 ``array('Order.destination' => 'Old Towne Bakery')``。

    如果你要在条件间使用不同的 SQL 运算符，用第二个参数指定::

        /*
        Contents of $this->request->data
        array(
            'Order' => array(
                'num_items' => '4',
                'referrer' => 'Ye Olde'
            )
        )
        */

        // 得到至少4份包含 'Ye Olde' 的订单
        $conditions = $this->postConditions(
            $this->request->data,
            array(
                'num_items' => '>=',
                'referrer' => 'LIKE'
            )
        );
        $orders = $this->Order->find('all', compact('conditions'));

    第三个参数让你可以告诉 CakePHP 在查找条件之间使用什么 SQL 逻辑运算符。
    象 ‘AND’，‘OR’ 和 ‘XOR’ 这样的字符串都是合法的值。

    最后，如果最后一个参数设为 true，而 $op 参数是一个数组，$op 未包含的字段将不会出现在返回的条件中。

.. php:method:: paginate()

    该方法用于将模型得到的结果分页。你可以指定分页大小，模型的查找条件，等等。
    请参看 :doc:`pagination <core-libraries/components/pagination>` 一节以得到关于如何使用paginate的更多细节。

.. php:method:: requestAction(string $url, array $options)

    该函数从任何地方调用一个控制器的动作，并从该动作返回数据。
    传入的 ``$url`` 参数是一个 CakePHP 网址(/controllername/actionname/params)。要给接受的控制器动作传入更多数据，
    就加入到 $options 数组中。

    .. note::

        从 options 参数传入 'return'，就能用 ``requestAction()`` 得到完整渲染的视图:
        ``requestAction($url, array('return'));``。重要的是，请注意，从控制器方法用 'return'
        调用 requestAction，可能引起脚本和 css 标签工作不正常。

    .. warning::

        如果不使用缓存，``requestAction`` 会导致糟糕的性能。所以在控制器或者模型中都极少适用。

    ``requestAction`` 最好和(缓存的)元素一起使用 —— 作为一种在渲染前为元素获取数据的方法。
    让我们用一个把“近期评论”的元素放入布局的例子。首先我们要增加一个控制器函数来返回数据::

        // Controller/CommentsController.php
        class CommentsController extends AppController {
            public function latest() {
                if (empty($this->request->params['requested'])) {
                    throw new ForbiddenException();
                }
                return $this->Comment->find('all', array('order' => 'Comment.created DESC', 'limit' => 10));
            }
        }

    你应当总是包括确保 requestAction 方法的调用确实源自 ``requestAction`` 的检查。
    不做此检查，将允许 requestAction 可以从网址直接访问，通常这样不好。

    如果我们现在增加一个简单的元素来调用此函数::

        // View/Elements/latest_comments.ctp

        $comments = $this->requestAction('/comments/latest');
        foreach ($comments as $comment) {
            echo $comment['Comment']['title'];
        }

    然后我们就可以象下面这样，把这个元素放在任何地方，得到输出::

        echo $this->element('latest_comments');

    用这样的写法，任何时候元素被渲染，都会有一个请求被提交到控制器来获取数据，数据会被处理并返回。
    当然，与上面的警告相一致，最好使用元素缓存，来避免不必要的处理。这样修改对元素的调用::

        echo $this->element('latest_comments', array('cache' => '+1 hour'));

    只要缓存的元素视图文件还存在并有效， ``requestAction`` 就不会被调用。

    另外，现在 requestAction 接受基于数组的 Cake 风格的网址::

        echo $this->requestAction(
            array('controller' => 'articles', 'action' => 'featured'),
            array('return')
        );

    这允许 requestAction 的调用略过 Router::url 的使用，从而可以改善性能。
    基于网址的数组与 :php:meth:`HtmlHelper::link()` 使用的相同，
    除了有一点区别 - 如果你使用命名参数或者传入参数(named or passed parameters)，
    你必须把它们放入第二个数组并配以正确的键。这是因为 requestAction 会把命名参数数组(requestAction 的第二个参数)
    与 Controller::params 成员数组合并，而不把命名参数数组明确地放在 'named' 键中； ``$option``
    数组中其它成员也可以在请求的动作的 Controller::params 数组中可以得到::

        echo $this->requestAction('/articles/featured/limit:3');
        echo $this->requestAction('/articles/view/5');

    以数组形式在 requestAction 中就会是::

        echo $this->requestAction(
            array('controller' => 'articles', 'action' => 'featured'),
            array('named' => array('limit' => 3))
        );

        echo $this->requestAction(
            array('controller' => 'articles', 'action' => 'view'),
            array('pass' => array(5))
        );

    .. note::

        不像其它地方，数组网址和字符串网址类似，requestAction 对它们的处理不同。

    当把数组网址和 requestAction() 一起使用时，一定要给出请求的动作所需要的**所有**参数。
    这包括象 ``$this->request->data`` 这样的参数。除了传入所有需要的参数外，
    命名参数和传入参数必须在第二个数组提供，如上面所示。


.. php:method:: loadModel(string $modelClass, mixed $id)

    当要使用的模型不是控制器的缺省模型或者关联模型时，``loadModel`` 函数就很方便::

        $this->loadModel('Article');
        $recentArticles = $this->Article->find('all', array('limit' => 5, 'order' => 'Article.created DESC'));

        $this->loadModel('User', 2);
        $user = $this->User->read();


控制器属性
=====================

控制器属性的完整列表及其描述，请参看 CakePHP API，
`http://api20.cakephp.org/class/controller <http://api20.cakephp.org/class/controller>`_。

.. php:attr:: name

    ``$name`` 属性应当置为控制器名称。通常这只是控制器使用的模型的复数形式。
    该属性可以省略，如果 CakePHP 不 inflecting 它的话::

        // $name 控制器属性用法示例
        class RecipesController extends AppController {
           public $name = 'Recipes';
        }


$components，$helpers 和 $uses
-------------------------------

下一个最常用的控制器属性告诉 CakePHP 当前控制器使用什么助件，组件和模型。
使用这些属性让由 ``$components`` 和 ``$uses`` 指定的 MVC 类成为类变量(例如 ``$this->模型名称``)
可以为控制器所用，而由 ``$helpers`` 指定的类作为对象引用变量(``$this->{$helpername}``)可以被视图使用。

.. note::

    每个控制器缺省就有这些类中的某些，所以你也许完全不用配置你的控制器。

.. php:attr:: uses

    缺省情况下，控制器可以访问它们的主模型。我们的 RecipesController 可以用 ``$this->Recipe``
    访问 Recipe 模型类，而我们的 ProductsController 也可以通过 ``$this->Product``
    来访问 Product 模型。然而，当要使用 ``$uses`` 变量让控制器访问更多的模型时，
    当前控制器的(主要)模型名称一定也要包括在内。这可由下面的例子说明。(译注：原文此处无例子。)

    如果你在控制器中不想使用(任何)模型，就设置 ``public $uses = array()``。
    这允许你使用控制器，而不需要相应的模型文件。然而 ``AppController`` 中定义的模型仍然会加载。
    你也可以用 ``false`` 来完全不加载任何模型，即使是 ``AppController`` 中定义的模型。

    .. versionchanged:: 2.1
        Uses 变量现在有了新的缺省值，而且它对 ``false`` 的处理也不同了。

.. php:attr:: helpers

    默认情况下 Html，Form 和 Session 助件都是可用的，就像 SessionComponent 组件一样。
    但如果选择在 AppController 中定义你自己的 ``$helpers`` 数组，记得包括 ``Html`` 和 ``Form``，
    如果还想让它们在控制器中缺省就可用的话。要了解更多关于这些类的信息，就请查看本手册后面的相关章节。

    让我们来看看如何让 CakePHP 控制器知道你打算使用额外的 MVC 类::

        class RecipesController extends AppController {
            public $uses = array('Recipe', 'User');
            public $helpers = array('Js');
            public $components = array('RequestHandler');
        }

    这些变量每个都会与它们继承的值合并，所以没有必要(比如)再次声明 Form 助件，
    或者任何你在 App 控制器中已经声明的东西。

.. php:attr:: components

    数组 components 用来设置控制器要用哪个 :doc:`/controllers/components`。
    就像 ``$helpers`` 和 ``$uses`` 一样，控制器中的组件(*components*)会与 ``AppController`` 中的合并。
    如同 ``$helpers``，可以传递参数给组件。更多信息请参看 :ref:`configuring-components`。

其它属性
----------------

虽然你可以在 API 中查看所有控制器属性的细节，不过还有其它一些控制器属性值得我们在手册中给它们分配自己单独的章节。

.. php:attr: cacheAction

    cacheAction 属性用来指定完整页面缓存的时间段和其它信息。你可以在 :php:class:`CacheHelper`
    文档中读到更多关于完整页面缓存的内容。

.. php:attr: paginate

    paginate 属性是废弃了的兼容性属性。用它来加载和配置 :php:class:`PaginatorComponent`。
    建议你更新你的代码，使用正常的组件设置::

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

    本章应当有较少关于控制器编程接口的内容，而有更多的示例。控制器属性一节内容很多，
    一开始不容易理解。本章应当以一些控制器示例及它们做什么开始。

关于控制器的更多内容
====================

.. toctree::

    controllers/request-response
    controllers/scaffolding
    controllers/pages-controller
    controllers/components


.. meta::
    :title lang=zh_CN: Controllers
    :keywords lang=zh_CN: correct models,controller class,controller controller,core library,single model,request data,middle man,bakery,mvc,attributes,logic,recipes