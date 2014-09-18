主题
######

你可以利用视图，快速简便地改变你的页面的风格。

使用主题，在控制器中加入 ::

    class ExampleController extends AppController {
        public $theme = 'Example';
    }

.. 版本变更:: 2.1
   版本 2.1 之前的需要设置 ``$this->viewClass = 'Theme'``.
   2.1 不再需要，默认在 ``View`` 类中支持主题。

设置或改变主题的名字可以通过动作或者``beforeFilter`` 或 
``beforeRender`` 回调函数 ::

    $this->theme = 'AnotherExample';

主题视图文件需要放在 ``/app/View/Themed/`` 目录。在主题目录，
创建一个和你的主题名字一样的目录，例如，上面的代码中的主题可以在目录
``/app/View/Themed/AnotherExample`` 中找到。注意到CakePHP喜欢
驼峰样式来命名主题名字。主题内容的目录结构和 ``/app/View/`` 是一样的。

例如，Posts的控制器的视图文件是 ``/app/View/Themed/Example/Posts/edit.ctp``. 布局文件是 ``/app/View/Themed/Example/Layouts/``.

如果一个视图文件不能在主题中找到, CakePHP会在目录 ``/app/View/`` 中定位。
这样的话，你可以创建主要的视图文件并简单的在你的主题中再单独重写。

主题资源
------------

主题可以包含一些和视图文件一样的静态资源。一个主题可以包含在webroot
目录中的任何必须的资源。这让主题的打包和发布更简便。在开发时，
对主题资源的请求是由 :php:class:`Dispatcher` 来处理的，为了提高生产环境中的性能，推荐使用
符号链接或者是复制主题资源到应用的webroot中。更多信息参考如下资源。

为了使用新的主题创建如下目录 
``app/View/Themed/<themeName>/webroot<path_to_file>`` 。
这个 Dispatcher 将会在视图路径中负责寻找正确的主题。

所有 CakePHP 内建的 helpers 会自动识别主题并创建正确的路径。
像视图文件，如果一个文件不在主题目录中，它会默认到主webroot目录 ::

    //When in a theme with the name of 'purple_cupcake'
    $this->Html->css('main.css');
     
    //creates a path like
    /theme/purple_cupcake/css/main.css
     
    //and links to
    app/View/Themed/PurpleCupcake/webroot/css/main.css 

提升插件和主题资源的性能
-------------------------------------------------

众所周知，通过PHP来提供资源的效率低于不调用PHP来提供资源。
同时，核心团队也在尽可能的提高插件和主题的服务的速度。如果对
性能要求高的话，这会造成一些麻烦。在这样的状况下，建议你要么
使用符号链接，要么将插件/主题资源复制到 ``app/webroot`` 下与CakePHP使用的路径匹配的目录中。


-  ``app/Plugin/DebugKit/webroot/js/my_file.js`` 变为
   ``app/webroot/debug_kit/js/my_file.js``
-  ``app/View/Themed/Navy/webroot/css/navy.css`` 变为
   ``app/webroot/theme/Navy/css/navy.css``


.. meta::
    :title lang=zh_CN: Themes
    :keywords lang=zh_CN: production environments,theme folder,layout files,development requests,callback functions,folder structure,default view,dispatcher,symlink,case basis,layouts,assets,cakephp,themes,advantage
