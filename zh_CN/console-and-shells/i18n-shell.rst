shell支持国际化I18N
####################

CakePHP 使用 `po files <http://en.wikipedia.org/wiki/GNU_gettext>`_ 作为
它们翻译的源文件来支持国际化功能。这让他们可以同 `poedit <http://www.poedit.net/>`_  
和其他一些常见的翻译工具整合。

i18n shell提供了一个快速和简便的方法来生成po模板文件。这些模板文件可以拿来给翻译者
这样他们就可以在他们的应用中翻译字符串。一旦你完成了翻译，pot文件可以被整合到已有
的翻译中来帮助更新你的翻译。

生成 POT 文件
====================

可以通过使用 ``extract`` 命令来为已有的应用生成POT文件。这个命令将会在你的整个应用
中搜索 ``__()`` 样式的函数命令，抽取出信息的字符串。每一个你的应用中的唯一的字符串
将会被组合进一个单独 ::

    ./Console/cake i18n extract

执行这个命令如上所示。
在抽取 ``__()`` 方法中的字符串的同时，模板中的验证信息也将会被抽取。这个命令的结
果文件保存在 ``app/Locale/default.pot`` 。你可以使用这个pot文件作为创建po文件的
模板。如果你从pot文件手动创建po文件，确保你正确的设置了“复数形式”标题行。

为插件生成POT文件
--------------------------------

你可以为指定的插件生成pot文件 ::

    ./Console/cake i18n extract --plugin <Plugin>

这个命令将生成插件中使用所需的POT文件。

模型验证信息
-------------------------

你可以在你的模型中设置需要抽取验证信息的域。如果模型已经有了一个 ``$validationDomain`` 
属性，给出的验证域设置将会被忽略 ::

    ./Console/cake i18n extract --validation-domain validation_errors

你也可以组织shell抽取模型的验证信息 ::

    ./Console/cake i18n extract --ignore-model-validation


排除目录
-----------------

你可以传递一个列表（用,隔开）来指定你想要排除的目录。任意在这之中的目录都会被忽略 ::

    ./Console/cake i18n extract --exclude Test,Vendor

跳过对已有的POT文件覆盖警告
--------------------------------------------------
.. versionadded:: 2.2

有了参数 --overwrite ,shell将会默认覆盖已有的POT文件而不发出警告 ::

    ./Console/cake i18n extract --overwrite

从CakePHP的核心库中抽取信息
Extracting messages from the CakePHP core libraries
---------------------------------------------------
.. versionadded:: 2.2

默认情况下，extract shell脚本将会询问你是否要抽取CakePHP核心库中用到的信息。设置
--extract-core为yes或no来设置默认的动作。 ::

    ./Console/cake i18n extract --extract-core yes    

或    

    ./Console/cake i18n extract --extract-core no

创建TranslateBehavior使用的表
===========================================

i18n shell也可以用来初始化 :php:class:`TranslateBehavior` 使用的默认的表 ::

    ./Console/cake i18n initdb

这个命令会创建翻译动作使用的 ``i18n`` 表。 


.. meta::
    :title lang=zh_CN: I18N shell
    :keywords lang=zh_CN: pot files,locale default,translation tools,message string,app locale,php class,validation,i18n,translations,shell,models
