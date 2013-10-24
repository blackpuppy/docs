组件 Components
##########

组件是在多个控制器之间共享的逻辑的封装。如果你发现自己要在控制器间复制粘贴代码，
就可以考虑将这些功能封装为一个组件。
Components are packages of logic that are shared between
controllers. If you find yourself wanting to copy and paste things
between controllers, you might consider wrapping some functionality
in a component.

CakePHP还配备了一套不错的核心组件。
CakePHP also comes with a fantastic set of core components you can
use to aid in:

- 安全
- Sessions会话
- 访问控制列表
- 电子邮件
- Cookies
- 权限认证
- 请求处理
- 分页

- Security
- Sessions
- Access control lists
- Emails
- Cookies
- Authentication
- Request handling
- Pagination

每个核心组件的详细信息都在他们各自的章节。现在，我们将展示如果建立自己的组件。
创建组件可以保持控制器代码简洁并且在不同的项目间复用代码。

Each of these core components are detailed in their own chapters.
For now, we’ll show you how to create your own components. Creating
components keeps controller code clean and allows you to reuse code
between projects.

.. _configuring-components:

配置组件 Configuring Components
======================

大多数的核心组件需要进行配置。配置示例在:doc:`/core-libraries/components/authentication`
:doc:`/core-libraries/components/cookie` 和 :doc:`/core-libraries/components/email`。
通常，在控制器的 ``beforeFilter()`` 方法中的 ``$components`` 数组里进行配置。

Many of the core components require configuration. Some examples of
components requiring configuration are
:doc:`/core-libraries/components/authentication`, :doc:`/core-libraries/components/cookie`
and :doc:`/core-libraries/components/email`. Configuration for these
components, and for components in general, is usually done in the
``$components`` array or your controller's ``beforeFilter()``
method::

    class PostsController extends AppController {
        public $components = array(
            'Auth' => array(
                'authorize' => array('controller'),
                'loginAction' => array('controller' => 'users', 'action' => 'login')
            ),
            'Cookie' => array('name' => 'CookieMonster')
        );

这是使用 ``$components`` 数组配置组件的例子。所有的核心组件都允许使用这种方式进行配置。
此外，你也可以在控制器的 ``beforeFilter()`` 方法中配置组件。
这种方式通常用在你需要将一个函数的结果赋与一个组件属性的情况下。上面的例子还可以表示成::

Would be an example of configuring a component with the
``$components`` array. All core components allow their
configuration settings to be set in this way. In addition you can
configure components in your controller's ``beforeFilter()``
method. This is useful when you need to assign the results of a
function to a component property. The above could also be expressed
as::

    public function beforeFilter() {
        $this->Auth->authorize = array('controller');
        $this->Auth->loginAction = array('controller' => 'users', 'action' => 'login');

        $this->Cookie->name = 'CookieMonster';
    }

然而，也有这种可能：一个组件的特定配置选项要在控制器的 ``beforeFilter()`` 运行前设置。
最后，一些组件允许在``$components`` 数组中设置配置选项：

It's possible, however, that a component requires certain
configuration options to be set before the controller's
``beforeFilter()`` is run. To this end, some components allow
configuration options be set in the ``$components`` array::

    public $components = array(
        'DebugKit.Toolbar' => array('panels' => array('history', 'session'))
    );

通过查阅相关文档可以确定每个组件都提供哪些配置选项。

Consult the relevant documentation to determine what configuration
options each component provides.

``className`` 是一个公用的设置选项，你可以借此给组件起个别名。
当用自定义的组件来替换 ``$this->Auth`` 或者其它公用组件时，这个选项非常有用::

One common setting to use is the ``className`` option, which allows you to
alias components.  This feature is useful when you want to
replace ``$this->Auth`` or another common Component reference with a custom
implementation::

    // app/Controller/PostsController.php
    class PostsController extends AppController {
        public $components = array(
            'Auth' => array(
                'className' => 'MyAuth'
            )
        );
    }

    // app/Controller/Component/MyAuthComponent.php
    App::uses('AuthComponent', 'Controller/Component');
    class MyAuthComponent extends AuthComponent {
        // 添加你的代码重写核心 AuthComponent
        // Add your code to override the core AuthComponent
    }

上例的控制器中 ``$this->Auth`` 的别名为 ``MyAuthComponent`` 。

The above would *alias* ``MyAuthComponent`` to ``$this->Auth`` in your
controllers.

.. note::

    在任何用到有别名的组件时，都要使用别名，包括在其它组件内引用。

    Aliasing a component replaces that instance anywhere that component is used,
    including inside other Components.

使用组件 Using Components
================

一旦你已经在控制器中包含了一些组件，用起来是非常简单的。
在控制器中每个元件都以属性的方式使用。如果你已经在控制器中加载了 :php:class:`SessionComponent` 和 :php:class:`CookieComponent` ，你就可以像下面这样访问它们：

Once you've included some components in your controller, using them is
pretty simple.  Each component you use is exposed as a property on your
controller.  If you had loaded up the :php:class:`SessionComponent` and
the :php:class:`CookieComponent` in your controller, you could access
them like so::

    class PostsController extends AppController {
        public $components = array('Session', 'Cookie');

        public function delete() {
            if ($this->Post->delete($this->request->data('Post.id')) {
                $this->Session->setFlash('Post deleted.');
                $this->redirect(array('action' => 'index'));
            }
        }

.. note::

    由于以属性身份加入到控制器中的模型和组件共享相同的 ‘命名空间’，你需要确保不给组件和模型相同的命名。
    Since both Models and Components are added to Controllers as
    properties they share the same 'namespace'.  Be sure to not give a
    component and a model the same name.

动态加载组件 Loading components on the fly
-----------------------------

你可能不需要在控制器的所有动作action中使用所有组件。
这种情况，你可以在实行时使用:doc:`Component Collection </core-libraries/collections>` 载入组件。从控制器内部，你可以用以下方法::

You might not need all of your components available on every controller
action. In situations like this you can load a component at runtime using the
:doc:`Component Collection </core-libraries/collections>`. From inside a
controller's method you can do the following::

    $this->OneTimer = $this->Components->load('OneTimer');
    $this->OneTimer->getTime();

.. note::

    切记动态加载组件并不会调用自己的构造方法，如果需要的话需要在加载后手动调用。

    Keep in mind that loading a component on the fly will not call its
    initialize method. If the component you are calling has this method you
    will need to call it manually after load.


组件回调 Component Callbacks
===================

组件提供了一些请求生命周期的回调函数，来增加请求周期。请参考 :ref:`component-api` 来获取更多组件的回调函数的信息。

Components also offer a few request life-cycle callbacks that allow them
to augment the request cycle.  See the base :ref:`component-api` for
more information on the callbacks components offer.

创建组件 Creating a Component
====================

设想我们现在有这么一个在线的应用，它需要对很多不同的部分执行一个相同的很复杂的数学运算。我们现在就来创建一个组件把这个数学运算给封装起来，这样我们可以在不同的控制器中使用它。

Suppose our online application needs to perform a complex
mathematical operation in many different parts of the application.
We could create a component to house this shared logic for use in
many different controllers.

第一步是创建一个新的组件的类和保存该类的文件。创建``/app/Controller/Component/MathComponent.php``.php文件。组件的基本构造如下::

The first step is to create a new component file and class. Create
the file in ``/app/Controller/Component/MathComponent.php``. The basic
structure for the component would look something like this::

    App::uses('Component', 'Controller');
    class MathComponent extends Component {
        public function doComplexOperation($amount1, $amount2) {
            return $amount1 + $amount2;
        }
    }

.. note::

    所有的MathComponent必须继承 Component。如果不这样做，会导致异常。

    All components must extend :php:class:`Component`.  Failing to do this
    will trigger an exception.

控制器中使用组件 Including your component in your controllers
--------------------------------------------

一旦编写好了组件，就可以在控制器中通过 ``$components`` 数组引用组件的名称（名称不带"Component"字样）来使用它。
系统会自动分配给控制器一个以组件名称命名的属性，通过这个属性就可以访问组件实例了：

Once our component is finished, we can use it in the application's
controllers by placing the component's name (minus the "Component"
part) in the controller's ``$components`` array. The controller will
automatically be given a new attribute named after the component,
through which we can access an instance of it::

    /* Make the new component available at $this->Math,
    as well as the standard $this->Session */
    public $components = array('Math', 'Session');

在``AppController``控制器中声明的组件会与其它控制器中声明的组件进行合并。
因此没有必要对同一组件声明两次。

Components declared in ``AppController`` will be merged with those
in your other controllers. So there is no need to re-declare the
same component twice.

在控制器中引用组件时，同样也可以声明一些参数，它可以传递给组件的构造器。这些参数可以被组件进行处理。

When including Components in a Controller you can also declare a
set of parameters that will be passed on to the Component's
constructor. These parameters can then be handled by
the Component::

    public $components = array(
        'Math' => array(
            'precision' => 2,
            'randomGenerator' => 'srand'
        ),
        'Session', 'Auth'
    );

上面的例子会将包括precision和randomGenerator的数组作为第二个参数传递给``MathComponent::__construct()``方法。
所有与传过来的设定中的关键字同名的控制器的公共属性，将会获得设定中该关键字对应的值。

The above would pass the array containing precision and
randomGenerator to ``MathComponent::__construct()`` as the
second parameter.  By convention, any settings that have been passed
that are also public properties on your component will have the values
set based on the settings.


在自定义组件中使用其他组件 Using other Components in your Component
----------------------------------------

有时候自定义组件里面可能会用到其它的组件。在自定义组件中使用组件的方法和在控制器中使用组件一样。
使用``$components``变量::

Sometimes one of your components may need to use another component.
In this case you can include other components in your component the exact same
way you include them in controllers - using the ``$components`` var::

    // app/Controller/Component/CustomComponent.php
    App::uses('Component', 'Controller');
    class CustomComponent extends Component {
        // the other component your component uses
        public $components = array('Existing');

        public function initialize(Controller $controller) {
            $this->Existing->foo();
        }

        public function bar() {
            // ...
       }
    }

    // app/Controller/Component/ExistingComponent.php
    App::uses('Component', 'Controller');
    class ExistingComponent extends Component {

        public function foo() {
            // ...
        }
    }

Note that in contrast to a component included in a controller no callbacks will be triggered on an component's component.

.. _component-api:

组件API Component API
=============

.. php:class:: Component

    Component基类通过ComponentCollection提供了一些延迟加载其他组件的方法。
    也提供所有的回调函数的原型。

    The base Component class offers a few methods for lazily loading other
    Components through :php:class:`ComponentCollection` as well as dealing
    with common handling of settings.  It also provides prototypes for all
    the component callbacks.

.. php:method:: __construct(ComponentCollection $collection, $settings = array())

    Component基类的构造器。
    所有的与 ``$settings`` 的关键字同名的公共属性的值会变成 ``$settings`` 中改关键字对应的值。

    Constructor for the base component class.  All ``$settings`` that
    are also public properties will have their values changed to the
    matching value in ``$settings``.

回调方法 Callbacks
---------

.. php:method:: initialize(Controller $controller)

    initialize()方法在控制器的beforeFilter()方法执行前被自动调用。

    The initialize method is called before the controller's
    beforeFilter method.

.. php:method:: startup(Controller $controller)

    startup()方法在beforeFilter方法执行之后但在控制器执行当前action处理之前被自动调用。

    The startup method is called after the controller's beforeFilter
    method but before the controller executes the current action
    handler.

.. php:method:: beforeRender(Controller $controller)

    beforeRender()方法在控制器执行请求的的方法之后但在控制器输出视图和布局之前被调用。

    The beforeRender method is called after the controller executes the
    requested action's logic but before the controller's renders views
    and layout.

.. php:method:: shutdown(Controller $controller)

    shutdown方法在被送到浏览器之前被调用。

    The shutdown method is called before output is sent to browser.

.. php:method:: beforeRedirect(Controller $controller, $url, $status=null, $exit=true)

    beforeRedirect方法在控制器的redirect方法调用时但在进行其它操作之前进行调用。
    如果该方法返回false则控制器会中断该redirect请求。
    $url, $status和$exit变量与控制器方法的相应变量含义相同。
    也可以返回一个字符串作为redirect的url或者返回包括关键字'url'和可选关键字'status'、'exit'的数组。

    The beforeRedirect method is invoked when the controller's redirect
    method is called but before any further action. If this method
    returns false the controller will not continue on to redirect the
    request. The $url, $status and $exit variables have same meaning as
    for the controller's method. You can also return a string which
    will be interpreted as the url to redirect to or return associative
    array with key 'url' and optionally 'status' and 'exit'.



.. meta::
    :title lang=en: Components
    :keywords lang=en: array controller,core libraries,authentication request,array name,access control lists,public components,controller code,core components,cookiemonster,login cookie,configuration settings,functionality,logic,sessions,cakephp,doc
