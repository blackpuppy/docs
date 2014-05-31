EmailComponent
##############

:php:class:`EmailComponent`现在已经被弃用了, 但是仍然可以工作。不幸的是，
你需要将文件从``app/views/elements/emails``移到``app/View/Emails``。
同样的，在布局路径中将``email``目录重命名为``Emails``。如果在应用程序中影响其他地方,我们建议
你创建符号链接。

:php:class:`EmailComponent` is now deprecated, but it will keep working.
Internally this class is using :php:class:`CakeEmail` to send emails.
Unfortunately, you will need to move your files from ``app/views/elements/emails``
to ``app/View/Emails``. Also, rename the directory ``email`` to ``Emails`` in the
layouts path. If it affects others places in your application, we recommend to
you create symbolic links.

我们推荐您升级代码使用:php:class:`CakeEmail`类而不是:php:class:`EmailComponent`。
下面是一些升级建议。

We recommend to you upgrade your code to use :php:class:`CakeEmail` class
instead of the :php:class:`EmailComponent`. Below some tips about the migration.

-  邮件头不会自动变为X-...开头，设置什么就会调用什么。所以记得在自定义头中添加X-前缀。
-  ``send()``方法只接收消息内容。模版和布局应该使用:php:meth:`CakeEmail::template()`
   方法设置。
-  附件列表应该是一个包含文件名作为键名(出现在邮件中的名字)和实际文件全路径作为其键值的数组。
-  遇到任何错误, :php:class:`CakeEmail`会抛出一个异常而不是返回false。建议使用try/catch确保邮件能够
   正确的投递。

-  The headers are not changed to be X-... What you set is what is used. So,
   remember to put X- in your custom headers.
-  The ``send()`` method receives only the message content. The template and
   layout should be set using :php:meth:`CakeEmail::template()` method.
-  The list of attachments should be an array of filenames (that will appear in
   email) as key and value the full path to real file.
-  At any error, :php:class:`CakeEmail` will throw an exception instead of
   return false. We recommend to you use try/catch to ensure
   your messages are delivered correctly.

下面是一些使用``EmailComponent ($component)``的例子。现在使用``CakeEmail ($lib)``：
Below some examples of using ``EmailComponent ($component)`` and now with
``CakeEmail ($lib)``:

-  From ``$component->to = 'some@example.com';`` to
   ``$lib->to('some@example.com');``
-  From ``$component->to = 'Alias <some@example.com>';`` to
   ``$lib->to('some@example.com', 'Alias');`` or
   ``$lib->to(array('some@example.com' => 'Alias'));``
-  From ``$component->subject = 'My subject';`` to
   ``$lib->subject('My subject');``
-  From ``$component->date = 'Sun, 25 Apr 2011 01:00:00 -0300';`` to
   ``$lib->addHeaders(array('Date' => 'Sun, 25 Apr 2011 01:00:00 -0300'));``
-  From ``$component->header['Custom'] = 'only my';`` to
   ``$lib->addHeaders(array('X-Custom' => 'only my'));``
-  From ``$component->send(null, 'template', 'layout');`` to
   ``$lib->template('template', 'layout')->send();``
-  From ``$component->delivery = 'smtp';`` to ``$lib->transport('Smtp');``
-  From ``$component->smtpOptions = array('host' => 'smtp.example.com');`` to
   ``$lib->config(array('host' => 'smtp.example.com'));``
-  From ``$sent = $component->httpMessage;`` to
   ``$sent = $lib->message(CakeEmail::MESSAGE_HTML);``

更多信息请阅读:doc:`/core-utility-libraries/email`文档。
For more information you should read the :doc:`/core-utility-libraries/email`
documentation.


.. meta::
    :title lang=en: EmailComponent
    :keywords lang=en: component subject,component delivery,php class,template layout,custom headers,template method,filenames,alias,lib,array,email,migration,attachments,elements,sun
