页面控制器
####################

CakePHP有一个默认过渡的控制器``PagesController.php``。这是一个提供静态页面的简单并且可选的
控制器。安装后默认的主页就是使用的这个控制器。如果有视图文件``app/View/Pages/about_us.ctp``，
可以通过url地址``http://example.com/pages/about_us``访问。你可以根据需要自由修改PagesController。

CakePHP ships with a default controller ``PagesController.php``. This is a
simple and optional controller for serving up static content. The home page
you see after installation is generated using this controller. If you make the
view file ``app/View/Pages/about_us.ctp`` you can access it using the url
``http://example.com/pages/about_us``. You are free to modify the Pages
Controller to meet your needs.

当通过CakePHP的命令行功能"bake"一个app，Pages控制器是创建在``app/Controller/``目录。
也可以从``lib/Cake/Console/Templates/skel/Controller/PagesController.php``拷贝这个文件。

When you "bake" an app using CakePHP's console utility the Pages Controller is
created in your ``app/Controller/`` folder. You can also copy the file from
``lib/Cake/Console/Templates/skel/Controller/PagesController.php``.

.. versionchanged:: 2.1
	CakePHP 2.0中Pages Controller是``lib/Cake``的一部分。从2.1起Pages Controller不在
	是核心目录的一部分而被放到app目录。
    With CakePHP 2.0 the Pages Controller was part of ``lib/Cake``. Since 2.1
    the Pages Controller is no longer part of the core but ships in the app
    folder.

.. warning::

	不要直接修改``lib/Cake``下的任何文件，避免未来升级时发生问题。
    Do not directly modify ANY file under the ``lib/Cake`` folder to avoid
    issues when updating the core in future.


.. meta::
    :title lang=zh: The Pages Controller
    :keywords lang=zh: pages controller,default controller,lib,cakephp,ships,php,file folder
