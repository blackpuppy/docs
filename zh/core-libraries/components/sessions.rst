Sessions
########

.. php:class:: SessionComponent(ComponentCollection $collection, array $settings = array())

CakePHP的SessionComponent会话组件提供了一种页面间持久化客户端数据的方法。他是对``$_SESSION``封装，
同时提供了用于方便操作``$_SESSION``的几种方法。

The CakePHP SessionComponent provides a way to persist client data
between page requests. It acts as a wrapper for the ``$_SESSION`` as
well as providing convenience methods for several ``$_SESSION``
related functions.

在CakePHP中，Sessions有多种配置方法。更多信息参见:doc:`Session configuration </development/sessions>`

Sessions can be configured in a number of ways in CakePHP.  For more
information, you should see the :doc:`Session configuration </development/sessions>`
documentation.

Interacting with Session data
与Session数据交互
=============================

Session组件是用来与session交互信息。它包括基本的CRUD功能以及来创建反馈信息给用户。

The Session component is used to interact with session information.
It includes basic CRUD functions as well as features for creating
feedback messages to users.

请注意可以使用:term:`dot notation`点记法创建数组结构的Session。所以``User.username``
等同于下面的格式::

It should be noted that Array structures can be created in the
Session by using :term:`dot notation`. So ``User.username`` would
reference the following::

    array('User' => array(
        'username' => 'clark-kent@dailyplanet.com'
    ));

点记法可以用来表示嵌套数组。这种记法可用在所有的Session组件方法中。
Dots are used to indicate nested arrays. This notation is used for
all Session component methods wherever a name/key is used.

.. php:method:: write($name, $value)

	将Session的$value写入$name，$name可以是点分隔表示的数组形式。举个例子::
    Write to the Session puts $value into $name. $name can be a dot
    separated array. For example::

        $this->Session->write('Person.eyeColor', 'Green');

    将值'Green'写入Person =>eyeColor中。
    This writes the value 'Green' to the session under Person =>
    eyeColor.


.. php:method:: read($name)

	返回Session中名字是$name的值。参数$name为null会返回整个session。E.g::
    Returns the value at $name in the Session. If $name is null the
    entire session will be returned. E.g::

        $green = $this->Session->read('Person.eyeColor');

    从session中取得值Green，不存在返回null。
    Retrieve the value Green from the session. Reading data that does not exist
    will return null.

.. php:method:: check($name)

	检测一个Session是否被设置,存在返回true,不存在返回false。
    Used to check if a Session variable has been set. Returns true on
    existence and false on non-existence.

.. php:method:: delete($name)

	清除名字为$name的session数据。E.g::
    Clear the session data at $name. E.g::

        $this->Session->delete('Person.eyeColor');

    session数据中不在包含值'Green'索引eyeColor也被清除了。然后Person依然存在于Session中。
    为了删除整个Person信息需要::
    Our session data no longer has the value 'Green', or the index
    eyeColor set. However, Person is still in the Session. To delete
    the entire Person information from the session use::

        $this->Session->delete('Person');

.. php:method:: destroy()

	``destroy``方法会删除session cookie和存储在整个临时文件系统中的session数据。
	它会销毁PHP的session，然后创建一个新的session::
    The ``destroy`` method will delete the session cookie and all
    session data stored in the temporary file system. It will then
    destroy the PHP session and then create a fresh session::

        $this->Session->destroy();


.. _creating-notification-messages:

Creating notification messages
创建提示信息
==============================

.. php:method:: setFlash(string $message, string $element = 'default', array $params = array(), string $key = 'flash')

    :rtype: void

    通常在web应用程序中，在处理表单或确认数据后需要显示一次性的提示消息给用户。
    在CakePHP中，被归类为"flash messages"。可以用SessionComponent设置闪烁消息。
    然后用:php:meth:`SessionHelper::flash()`方法显示。设置使用``setFlash``方法。

    Often in web applications, you will need to display a one-time notification
    message to the user after processing a form or acknowledging data.
    In CakePHP, these are referred to as "flash messages".  You can set flash
    message with the SessionComponent and display them with the
    :php:meth:`SessionHelper::flash()`. To set a message, use ``setFlash``::

        // In the controller.
        $this->Session->setFlash('Your stuff has been saved.');

    创建一次性的消息展示给用户看，使用SessionHelper。
    This will create a one-time message that can be displayed to the user,
    using the SessionHelper::

        // In the view.
        echo $this->Session->flash();

        // The above will output.
        <div id="flashMessage" class="message">
            Your stuff has been saved.
        </div>

    可以使用额外的参数传给``setFlash()`来创建各种类型的消息。举例，错误和确定
    的提示可能看起来不同的。使用``$key``参数来表示不同种类的消息再分开输出。

    You can use the additional parameters of ``setFlash()`` to create
    different kinds of flash messages.  For example, error and positive
    notifications may look differently.  CakePHP gives you a way to do that.
    Using the ``$key`` parameter you can store multiple messages, which can be
    output separately::

        // set a bad message.
        $this->Session->setFlash('Something bad.', 'default', array(), 'bad');

        // set a good message.
        $this->Session->setFlash('Something good.', 'default', array(), 'good');

    在视图层，这些消息可以以不同的样式输出::
    In the view, these messages can be output and styled differently::

        // in a view.
        echo $this->Session->flash('good');
        echo $this->Session->flash('bad');

    ``$element``参数允许控制哪一个元素(位于``/app/View/Elements``)来进行渲染消息。
    元素中的消息内容会适用于``$message``变量。

    The ``$element`` parameter allows you to control which element
    (located in ``/app/View/Elements``) should be used to render the
    message in. In the element the message is available as ``$message``.
    First we set the flash in our controller::

        $this->Session->setFlash('Something custom!', 'flash_custom');

    然后我们创建一个文件``app/View/Elements/flash_custom.ctp``作为自定义消息元素。

    Then we create the file ``app/View/Elements/flash_custom.ctp`` and build our
    custom flash element::

        <div id="myCustomFlash"><?php echo $message; ?></div>

    ``$params``参数可使我们传递额外的视图变量在布局中渲染。参数能够影响被渲染的div，
    举个例子$params数组中添加"class"，使用``$this->Session->flash()``会在生成的``div``中
    新增该class。

    ``$params`` allows you to pass additional view variables to the
    rendered layout. Parameters can be passed affecting the rendered div, for
    example adding "class" in the $params array will apply a class to the
    ``div`` output using ``$this->Session->flash()`` in your layout or view.::

        $this->Session->setFlash('Example message text', 'default', array('class' => 'example_class'));

    使用上面的``$this->Session->flash()``会输出::
    The output from using ``$this->Session->flash()`` with the above example
    would be::

        <div id="flashMessage" class="example_class">Example message text</div>

    使用plugin插件中的元素，只需在``$params``中指定插件名::
    To use an element from a plugin just specify the plugin in the
    ``$params``::

        // Will use /app/Plugin/Comment/View/Elements/flash_no_spam.ctp
        $this->Session->setFlash('Message!', 'flash_no_spam', array('plugin' => 'Comment'));

.. meta::
    :title lang=zh: Sessions
    :keywords lang=zh: php array,dailyplanet com,configuration documentation,dot notation,feedback messages,reading data,session data,page requests,clark kent,dots,existence,sessions,convenience,cakephp
