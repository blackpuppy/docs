.. _upgrade-shell:

升级 shell
#############

upgrade shell可以完成升级你的CakePHP从1.3到2.0的大部分工作。

升级所有 ::

    ./Console/cake upgrade all

如果您想看看shell做了什么而无需修改文件而只是首先执行，使用 --dry-run参数 ::

    ./Console/cake upgrade all --dry-run

升级插件::

    ./Console/cake upgrade all --plugin YourPluginName

你可以单个运行任何一个升级步骤。查看所有的可用步骤 ::

    ./Console/cake upgrade --help

或者查看API问文档获得更多信息 : http://api20.cakephp.org/class/upgrade-shell

升级你的App
----------------

这是一个使用upgrade shell帮助你将你的应用从1.3升级到2.0的教程。你的1.3的应用结构
大致如此 ::

    mywebsite/
        app/             <- Your App
        cake/            <- 1.3 Version of CakePHP
        plugins/
        vendors/
        .htaccess
        index.php

第一个步骤是下载或者 ``git clone`` 最新的CakePHP到另外一个你的 ``mywebsite`` 目录
之外的其他地方。先命名为 ``cakephp`` 。我们并不想下载的 ``app`` 目录覆盖了你的
应用中的目录。现在是为你的应用的目录做个备份的是否了。例如 : ``cp -R app app-backup``.

复制 ``cakephp/lib`` 目录到你的 ``mywebsite/lib`` 目录来为你的应用建立新的CakePHP
版本。 例如: ``cp -R ../cakephp/lib .``. 或者做个软链接也可以 : ``ln -s /var/www/cakephp/lib``.

在我们可以运行升级shell之前我们也需要新的终端脚本。复制 ``cakephp/app/Console``
目录到你的 ``mywebsite/app`` ，如 : ``cp -R ../cakephp/app/Console ./app``.

你的目录结构现在应该是这个样子 ::

    mywebsite/
        app/              <- Your App
            Console/      <- Copied app/Console Folder
        app-backup/       <- Backup Copy of Your App
        cake/             <- 1.3 Version of CakePHP
        lib/              <- 2.x Version of CakePHP
            Cake/
        plugins/
        vendors/
        .htaccess
        index.php

现在我们可以运行upgrade shell了，到你的 ``app`` 目录下执行 ::

    ./Console/cake upgrade all

这将会完成**大部分**工作让你的app升级到 2.x 。
检查你的升级后的 ``app`` 目录。如果一起正常就恭喜了，就可以将目录 ``mywebsite/cake``
删除了。欢迎进入2.x!

.. meta::
    :title lang=zh: .. _upgrade-shell:
    :keywords lang=zh: api docs,shell
