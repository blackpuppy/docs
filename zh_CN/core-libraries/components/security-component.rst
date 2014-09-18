Security
安全
########

.. php:class:: SecurityComponent(ComponentCollection $collection, array $settings = array())

安全组件创建一个简单的方法使得应用程序更加安全，组件提供了一系列的方法能
完成以下任务。

The Security Component creates an easy way to integrate tighter
security in your application. It provides methods for various tasks like:

* 约束应用程序中接收的HTTP方法。
* CSRF(跨站请求伪造)保护。
* 表单篡改保护。
* 使用SSL安全连接。
* 限制跨控制器通信。

* Restricting which HTTP methods your application accepts.
* CSRF protection.
* Form tampering protection
* Requiring that SSL be used.
* Limiting cross controller communication.

与其他所有的组件一样，通过几种配置参数对组件进行配置。
所有的属性可以直接或通过在控制器的beforeFilter同名方法中设置。

Like all components it is configured through several configurable parameters.
All of these properties can be set directly or through setter methods of the
same name in your controller's beforeFilter.

引入Security组件将自动获得CSRF`CSRF <http://en.wikipedia.org/wiki/Cross-site_request_forgery>`_
和表单篡改保护。一个隐藏的令牌文本框会自动插入到表单中。除此之外，在某个特定静止期之后表单
才会提交，他是由``csrfExpires``时间控制。

By using the Security Component you automatically get
`CSRF <http://en.wikipedia.org/wiki/Cross-site_request_forgery>`_
and form tampering protection. Hidden token fields will
automatically be inserted into forms and checked by the Security
component. Among other things, a form submission will not be
accepted after a certain period of inactivity, which is controlled by
the ``csrfExpires`` time.

如果你正在使用安全组件的表单防御功能及其他组件。会在他们的``startup()``回调方法中
处理表单数据，确保将安全组件放置在``$components``数组中的前面。

If you are using Security component's form protection features and
other components that process form data in their ``startup()``
callbacks, be sure to place Security Component before those
components in your ``$components`` array.

.. note::

	当使用Security组件，**必须**使用FormHelper创建表单，此外，**不要**

    When using the Security Component you **must** use the FormHelper to create
    your forms. In addition, you must **not** override any of the fields' "name"
    attributes. The Security Component looks for certain indicators that are
    created and managed by the FormHelper (especially those created in
    :php:meth:`~FormHelper::create()` and :php:meth:`~FormHelper::end()`).
    Dynamically altering the fields that are submitted in a POST request (e.g.
    disabling, deleting or creating new fields via JavaScript) is likely to
    trigger a black-holing of the request. See the ``$validatePost`` or
    ``$disabledFields`` configuration parameters.

Handling blackhole callbacks
处理黑洞回调函数
============================

如果一个被Security组件限制的动作是一个非法请求，将默认产生404错误，可以通过
``$this->Security->blackHoleCallback``属性设置一个回调函数。

If an action is restricted by the Security Component it is
black-holed as an invalid request which will result in a 404 error
by default. You can configure this behavior by setting the
``$this->Security->blackHoleCallback`` property to a callback function
in the controller.

.. php:method:: blackHole(object $controller, string $error)

	黑洞是一个带有404错误的非法请求或一个自定义回调函数。如果没有回调请求将退出。
	如果一个控制器的回调在 SecurityComponent::blackHoleCallback 中进行了设置。
	黑洞将会取消并且不传递任何错误信息。

	Black-hole an invalid request with a 404 error or a custom
    callback. With no callback, the request will be exited. If a
    controller callback is set to SecurityComponent::blackHoleCallback,
    it will be called and passed any error information.

.. php:attr:: blackHoleCallback

	blackHoleCallback是处理和请求黑洞的回调函数。
    A Controller callback that will handle and requests that are
    blackholed. A blackhole callback can be any public method on a controllers.
    The callback should expect an parameter indicating the type of error::

        public function beforeFilter() {
            $this->Security->blackHoleCallback = 'blackhole';
        }

        public function blackhole($type) {
            // handle errors.
        }

    ``$type``参数可以下面的值
    The ``$type`` parameter can have the following values:

    * 'auth' Indicates a form validation error, or a controller/action mismatch
      error.
    * 'csrf' Indicates a CSRF error.
    * 'get' Indicates an HTTP method restriction failure.
    * 'post' Indicates an HTTP method restriction failure.
    * 'put' Indicates an HTTP method restriction failure.
    * 'delete' Indicates an HTTP method restriction failure.
    * 'secure' Indicates an SSL method restriction failure.

Restricting HTTP methods
限制HTTP方法
========================

.. php:method:: requirePost()

	设置动作接收到的必须是POST请求，接收任意数量的参数，
	没有参数将强制所有动作接收的必须是POST请求。

    Sets the actions that require a POST request. Takes any number of
    arguments. Can be called with no arguments to force all actions to
    require a POST.

.. php:method:: requireGet()

	设置动作接收到的必须是GET请求，接收任意数量的参数，
	没有参数将强制所有动作接收的必须是GET请求。

    Sets the actions that require a GET request. Takes any number of
    arguments. Can be called with no arguments to force all actions to
    require a GET.

.. php:method:: requirePut()

	设置动作接收到的必须是PUT请求，接收任意数量的参数，
	没有参数将强制所有动作接收的必须是PUT请求。

    Sets the actions that require a PUT request. Takes any number of
    arguments. Can be called with no arguments to force all actions to
    require a PUT.

.. php:method:: requireDelete()

	设置动作接收到的必须是DELETE请求，接收任意数量的参数，
	没有参数将强制所有动作接收的必须是DELETE请求。

    Sets the actions that require a DELETE request. Takes any number of
    arguments. Can be called with no arguments to force all actions to
    require a DELETE.


Restrict actions to SSL
限制动作为SSL
=======================

.. php:method:: requireSecure()

	设置动作接收到的必须是SSL安全的请求，接收任意数量的参数，
	没有参数将强制所有动作接收的必须是SSL安全的请求。

    Sets the actions that require a SSL-secured request. Takes any
    number of arguments. Can be called with no arguments to force all
    actions to require a SSL-secured.

.. php:method:: requireAuth()

	设置动作接收到的必须是Security组件产生的令牌，接收任意数量的参数，
	没有参数将强制所有动作接收的必须经过合法认证。

    Sets the actions that require a valid Security Component generated
    token. Takes any number of arguments. Can be called with no
    arguments to force all actions to require a valid authentication.

Restricting cross controller communication
限制跨控制器通信
==========================================

.. php:attr:: allowedControllers

    A List of Controller from which the actions of the current
    controller are allowed to receive requests from. This can be used
    to control cross controller requests.

.. php:attr:: allowedActions

    Actions from which actions of the current controller are allowed to
    receive requests. This can be used to control cross controller
    requests.

Form tampering prevention
=========================

By default ``SecurityComponent`` prevents users from tampering with forms.  It
does this by working with FormHelper and tracking which files are in a form.  It
also keeps track of the values of hidden input elements.  All of this data is
combined and turned into a hash.  When a form is submitted, SecurityComponent
will use the POST data to build the same structure and compare the hash.

.. php:attr:: unlockedFields

    Set to a list of form fields to exclude from POST validation. Fields can be
    unlocked either in the Component, or with
    :php:meth:`FormHelper::unlockField()`.  Fields that have been unlocked are
    not required to be part of the POST and hidden unlocked fields do not have
    their values checked.

.. php:attr:: validatePost

    Set to ``false`` to completely skip the validation of POST
    requests, essentially turning off form validation.

CSRF configuration
CSRF 配置
==================

.. php:attr:: csrfCheck

	是否使用CSRF保护表单，设置``false``禁用。
    Whether to use CSRF protected forms. Set to ``false`` to disable
    CSRF protection on forms.

.. php:attr:: csrfExpires

   CSRF令牌的持续时间，每个表单/页面请求会产生一个新令牌
   The duration from when a CSRF token is created that it will expire on.
   Each form/page request will generate a new token that can only
   be submitted once unless it expires.  Can be any value compatible
   with ``strtotime()``. The default is +30 minutes.

.. php:attr:: csrfUseOnce

   Controls whether or not CSRF tokens are use and burn.  Set to
   ``false`` to not generate new tokens on each request.  One token
   will be reused until it expires. This reduces the chances of
   users getting invalid requests because of token consumption.
   It has the side effect of making CSRF less secure, as tokens are reusable.


Usage
用法
=====

在控制器的beforeFilter()中使用security组件，可以指定约束规则，当动作启动时，
Security组件会启动。

Using the security component is generally done in the controller
beforeFilter(). You would specify the security restrictions you
want and the Security Component will enforce them on its startup::

    class WidgetController extends AppController {

        public $components = array('Security');

        public function beforeFilter() {
            $this->Security->requirePost('delete');
        }
    }

此例中只有接收到的是POST请求才会成功触发删除动作。

In this example the delete action can only be successfully
triggered if it receives a POST request::

    class WidgetController extends AppController {

        public $components = array('Security');

        public function beforeFilter() {
            if (isset($this->request->params['admin'])) {
                $this->Security->requireSecure();
            }
        }
    }

此例子将迫使所有操作，管理路由到安全SSL请求::
This example would force all actions that had admin routing to
require secure SSL requests::

    class WidgetController extends AppController {

        public $components = array('Security');

        public function beforeFilter() {
            if (isset($this->params['admin'])) {
                $this->Security->blackHoleCallback = 'forceSSL';
                $this->Security->requireSecure();
            }
        }

        public function forceSSL() {
            $this->redirect('https://' . env('SERVER_NAME') . $this->here);
        }
    }

此例子将迫使所有操作，管理路由到安全SSL请求。当请求被放到黑洞，将调用
指定的forceSSL()回调函数，他会将一个不安全的请求重定向到
安全的请求。
This example would force all actions that had admin routing to
require secure SSL requests. When the request is black holed, it
will call the nominated forceSSL() callback which will redirect
non-secure requests to secure requests automatically.

.. _security-csrf:

CSRF protection
===============

CSRF or Cross Site Request Forgery is a common vulnerability in web
applications.  It allows an attacker to capture and replay a previous request,
and sometimes submit data requests using image tags or resources on other
domains.

Double submission and replay attacks are handled by the SecurityComponent's CSRF
features.  They work by adding a special token to each form request.  This token
once used cannot be used again.  If an attempt is made to re-use an expired
token the request will be blackholed.

Using CSRF protection
---------------------

Simply by adding the :php:class:`SecurityComponent` to your components array,
you can benefit from the CSRF protection it provides. By default CSRF tokens are
valid for 30 minutes and expire on use. You can control how long tokens last by setting
csrfExpires on the component.::

    public $components = array(
        'Security' => array(
            'csrfExpires' => '+1 hour'
        )
    );

You can also set this property in your controller's ``beforeFilter``::

    public function beforeFilter() {
        $this->Security->csrfExpires = '+1 hour';
        // ...
    }

The csrfExpires property can be any value that is compatible with
`strtotime() <http://php.net/manual/en/function.strtotime.php>`_. By default the
:php:class:`FormHelper` will add a ``data[_Token][key]`` containing the CSRF
token to every form when the component is enabled.

Handling missing or expired tokens
----------------------------------

Missing or expired tokens are handled similar to other security violations. The
SecurityComponent's blackHoleCallback will be called with a 'csrf' parameter.
This helps you filter out CSRF token failures, from other warnings.

Using per-session tokens instead of one-time use tokens
-------------------------------------------------------

By default a new CSRF token is generated for each request, and each token can
only be used once. If a token is used twice, it will be blackholed. Sometimes,
this behaviour is not desirable, as it can create issues with single page
applications. You can toggle on longer, multi-use tokens by setting
``csrfUseOnce`` to ``false``. This can be done in the components array, or in
the ``beforeFilter`` of your controller::

    public $components = array(
        'Security' => array(
            'csrfUseOnce' => false
        )
    );

This will tell the component that you want to re-use a CSRF token until it
expires - which is controlled by the ``csrfExpires`` value. If you are having
issues with expired tokens, this is a good balance between security and ease of
use.

Disabling the CSRF protection
禁用CSRF保护
-----------------------------

There may be cases where you want to disable CSRF protection on your forms for
some reason. If you do want to disable this feature, you can set
``$this->Security->csrfCheck = false;`` in your ``beforeFilter`` or use the
components array. By default CSRF protection is enabled, and configured to use
one-use tokens.

Disabling Security Component For Specific Actions
为特定的动作禁用Security组件
=================================================

有些情况需要对某个action禁用所有的安全检测(比如, ajax请求)。
可以通过"解锁"，把这些actions放到``beforeFilter``里的``$this->Security->unlockedActions``列表中。
There may be cases where you want to disable all security checks for an action (ex. ajax request).
You may "unlock" these actions by listing them in ``$this->Security->unlockedActions`` in your
``beforeFilter``.

.. versionadded:: 2.3

.. meta::
    :title lang=zh_CN: Security
    :keywords lang=zh_CN: configurable parameters,security component,configuration parameters,invalid request,protection features,tighter security,holing,php class,meth,404 error,period of inactivity,csrf,array,submission,security class,disable security,unlockActions
