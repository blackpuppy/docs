SessionHelper
#############

.. php:class:: SessionHelper(View $view, array $settings = array())

Session助手是与Session组件对应的，它复制了Session组件中大部分功能使得能够在视图中使用。

As a natural counterpart to the Session Component, the Session
Helper replicates most of the components functionality and makes it
available in your view.

Session助手与Session组件最大的区别是助手*不能*将内容写入session。

The major difference between the Session Helper and the Session
Component is that the helper does *not* have the ability to write
to the session.

跟Session组件一样，读数据使用点记法:term:`dot notation`来表达数组格式。
As with the Session Component, data is read by using
:term:`dot notation` array structures::

    array('User' => array(
        'username' => 'super@example.com'
    ));

若要读取上面给定中数组的内容，可以使用``User.username``，使用点来表示嵌套数组。
这种记法适用于所有的Session助手的`$key``键名中。

Given the previous array structure, the node would be accessed by
``User.username``, with the dot indicating the nested array. This
notation is used for all Session helper methods wherever a ``$key`` is
used.

.. php:method:: read(string $key)

    :rtype: mixed

    读取Session内容，返回字符串或数组，取决于session内容。
    Read from the Session. Returns a string or array depending on the
    contents of the session.

.. php:method:: check(string $key)

    :rtype: boolean

    检测键名是否存在于Session中，返回布尔值。
    Check to see if a key is in the Session. Returns a boolean on the
    key's existence.

.. php:method:: error()

    :rtype: string

    返回上一个session中遇到的错误。
    Returns last error encountered in a session.

.. php:method:: valid()

    :rtype: boolean

    用来检测一个session是否在view中有效。
    Used to check is a session is valid in a view.

Displaying notifications or flash messages
展示提示或闪动消息
==========================================

.. php:method:: flash(string $key = 'flash', array $params = array())

    :rtype: string

    在:ref:`creating-notification-messages`已经解释过，通过:php:meth:`SessionComponent::setFlash()`
    可以创建一次性的提示信息。消息内容一旦显示，就会被移除不会再次出现。
    As explained in :ref:`creating-notification-messages` you can
    create one-time notifications for feedback. After creating messages
    with :php:meth:`SessionComponent::setFlash()` you will want to
    display them. Once a message is displayed, it will be removed and
    not displayed again::

        echo $this->Session->flash();

    上面的代码将输出一段带有简短消息内容的html:
    The above will output a simple message, with the following html:

    .. code-block:: html

        <div id="flashMessage" class="message">
            Your stuff has been saved.
        </div>

 	通过组件方法可以设置额外的属性并且自定义作用于哪个element元素，在控制器中可以这么写。
    As with the component method you can set additional properties
    and customize which element is used. In the controller you might
    have code like::

        // in a controller
        $this->Session->setFlash('The user could not be deleted.');

    当输出这个消息，可以选择用于展示内容的元素。
    When outputting this message, you can choose the element used to display
    this message::

        // in a layout.
        echo $this->Session->flash('flash', array('element' => 'failure'));

    这样的话会使用``View/Elements/failure.ctp``来渲染。消息内容适用于元素中的``$message``。
    This would use ``View/Elements/failure.ctp`` to render the message.  The
    message text would be available as ``$message`` in the element.

    在failure元素文件中，内容可能是这样的:
    Inside the failure element file would be something like
    this:

    .. code-block:: php

        <div class="flash flash-failure">
            <?php echo $message; ?>
        </div>

    仍然可以为``flash()``方法传入额外的参数，这样就可以产生自定义消息了::
    You can also pass additional parameters into the ``flash()`` method, which
    allow you to generate customized messages::

        // In the controller
        $this->Session->setFlash('Thanks for your payment %s');

        // In the layout.
        echo $this->Session->flash('flash', array(
            'params' => array('name' => $user['User']['name'])
            'element' => 'payment'
        ));

        // View/Elements/payment.ctp
        <div class="flash payment">
            <?php printf($message, h($name)); ?>
        </div>


.. meta::
    :title lang=zh: SessionHelper
    :description lang=zh: As a natural counterpart to the Session Component, the Session Helper replicates most of the components functionality and makes it available in your view.
    :keywords lang=zh: session helper,flash messages,session flash,session read,session check
