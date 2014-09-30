页面控制器
####################

CakePHP使用 ``PagesController.php`` 作为默认的控制器。这是一个简单可选的控制器，仅用来提供静态页面。
安装后默认的主页用到的就是这个控制器。用到的视图文件位于 ``app/View/Pages/about_us.ctp``，
可以通过类似 ``http://example.com/pages/about_us`` 地址访问。你可以根据需要自行修改Pages Controller。

当通过CakePHP的命令行功能 "bake" 一个app，PagesController 会创建在 ``app/Controller/`` 目录下。
也可以从 ``lib/Cake/Console/Templates/skel/Controller/PagesController.php`` 拷贝这个文件。

.. versionchanged:: 2.1
	CakePHP 2.0中 Pages Controller 是 ``lib/Cake`` 的一部分。从2.1起 Pages Controller 不在是核心目
	录的一部分，而被放置到 app 目录中。
    With CakePHP 2.0 the Pages Controller was part of ``lib/Cake``. Since 2.1

.. warning::

	不要直接修改 ``lib/Cake`` 下的任何文件，以防未来升级时发生问题。

.. meta::
    :title lang=zh_CN: The Pages Controller
    :keywords lang=zh_CN: pages controller,default controller,lib,cakephp,ships,php,file folder
