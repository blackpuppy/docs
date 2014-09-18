使用 Bake 来生成代码
#########################

CakePHP 的 Bake 终端是另一个让你的 CakePHP 快速运行上线的利器。
Bake终端可以创建任何 CakePHP 的基本组成：模型，视图和控制器。
并不仅仅是骨架类 : Bake可以在几分钟内创建一个完整功能的应用，实际
上，一旦一个应用被搭完架子后，Bake是自然的步骤。

Bake新手(尤其是 Windows 用户) 可以在开始之前参考这篇
设置文章 `Bake screencast <http://tv.cakephp.org/video/gwoo/2010/12/24/setting_up_the_cakephp_console_on_windows>`_ 

根据你安装中的配置，你会需要将cake的bash脚本设置可执行权限，或者
使用 ./cake bake来调用。
cake终端运行的是 PHP CLI (命令行界面)。如果你在运行脚本中遇到
问题，确保你已经安装了 PHP CLI 并且激活了该组件。用户如果遇到
数据库主机 'localhost' 访问有问题的时候可以试试换成  '127.0.0.1' 。
这个也许是PHP CLI引起的。

当首次运行 Bake 时，如果你还没有创建一个的话，你会被提示创建一个数据库配置文件。

创建完之后，运行Bake将会显示给你如下选项 ::

    ---------------------------------------------------------------
    App : app
    Path: /path-to/project/app
    ---------------------------------------------------------------
    Interactive Bake Shell
    ---------------------------------------------------------------
    [D]atabase Configuration
    [M]odel
    [V]iew
    [C]ontroller
    [P]roject
    [F]ixture
    [T]est case
    [Q]uit
    What would you like to Bake? (D/M/V/C/P/F/T/Q)
    >  

换句话说，你可以直接在命令行中运行这些命令 ::

    $ cake bake db_config
    $ cake bake model
    $ cake bake view
    $ cake bake controller
    $ cake bake project
    $ cake bake fixture
    $ cake bake test
    $ cake bake plugin plugin_name
    $ cake bake all

修改由 "baked" 生产的默认的HTML
=================================================

如果你想修改 "Bake" 命令生产的默认的HTML，按照如下步骤 :

baking 自定义的视图
------------------------


#. 进入 : lib/Cake/Console/Templates/default/views
#. 注意到这里有 4 个文件
#. 复制它们到你的应用下 :
   app/Console/Templates/[themename]/views
#. 修改HTML来控制 "bake" 创建你想要的视图。

``[themename]`` 路径段是你要创建的bake主题的名字，它必须是唯一的,所以哥们就别卖萌用 'default' 了。

baking 自定义的项目
--------------------------

进入: lib/Cake/Console/Templates/skel
注意这里的基本的应用文件
复制到你的应用中 : app/Console/Templates/skel
修改HTML来控制 "bake" 创建你想要的视图。
将骨架路径参数传递给项目的任务 ::

    cake bake project -skel Console/Templates/skel

.. note::

    -  你必须运行指定的项目任务 ``cake bake project`` 这样路径参数才能被传递。
    -  模板路径使用相对于CLI当前路径的相对路径
    -  一旦需要的完整的骨架路径被手动输入，你可以指定任意目录来存放的你的模板
	来创建你想要的，包括使用多个模板。（除非 Cake 开始支持重写 skel 目录）。


1.3 中 Bake 的改进
========================

1.3 中 Bake的变化很大，包括很多的功能和改进。


-  从 bake 的主菜单中增加了两个新的任务 (FixtureTask 和 TestTask) 。
-  第三个任务 (TemplateTask) 添加到你的shells中了。
-  所有不同的bake任务现在允许你和其他的连接起来baking。使用 ``-connection`` 参数指定.
-  对插件的支持有了大的改进，你可以用  ``-plugin PluginName`` 或 ``Plugin.class`` 。
-  问题被归类，并且更容易理解。Questions have been clarified, and made easier to understand.
-  新增了对模型的多种检验功能。
-  支持通过 ``parent_id`` 的自我联想模型。比如如果你的模型名字是Thread，
	ParentThread 和 ChildThread 的联想将被创建(自动关联)。
-  Fixtures 和 Tests 可以分开来 bake 。
-  Baked Tests 包括很多测试工具，包括插件探测 (PHP4下不支持).

根据更新的功能清单，我们来花点试点来学习下新的命令，新的参数和
更新的功能。

**新的 FixtureTask, TestTask 和 TemplateTask.**

Fixture 和 test 的baking在过去是个难题。你只可以在baking类的时候生成测试，
只在baking模型的时候生成fixtures。这些将会导致以后在你的应用中添加测试或者仅仅是
重新生成fixtures有点头疼。在1.3中，我们已经将fixture和测试分离开为单独的任务。这
让你可以在你开发中随意重新运行他们--生成测试和fixture.

为了能够随时修复，baked测试现在可以尝试找到尽量多的fixtures。在过去进行这样的测
试经常会遭遇 'Missing Table' 的错误，我们希有了先进的fixture探测后能够使测试更
轻松和方便。

测试用例现在也可以为每一个类中的非继承的公有方法生成框架测试方法，节省你一个额外
的步骤。

``TemplateTask`` 是一个后台任务，它从模板中处理文件生成，在上一个版本的CakePHP中
，baked的视图是基于模板的，但其他的代码不是.在1.3中，几乎所有的bake生成的文件中
的内容是被模板和 ``TemplateTask`` 控制的。


``FixtureTask`` 并不仅仅用假数据生成fixtures，它也使用交互选项或者激活
 ``-records`` 选项，这样就可以使用实时数据来生成fixture了。

**新的 bake 命令**

加入了新的bake命令，让bake更加的简单和快速。控制器、模型、视图都可以通过 ``all`` 
子命令，一次生成所有并且让重建更加简单快速::

    cake bake model all

这是一次生成应用中所有的模型，同样的 ``cake bake controller all`` bake所有的控制
器，``cake bake view all`` 生成所有的视图文件。 ``ControllerTask`` 的参数也改变了。
``cake bake controller scaffold`` 改为 ``cake bake controller public`` 。
``ViewTask`` 增加了一个 ``-admin`` 标志，使用 ``-admin`` 允许你为
以 ``Routing.admin`` 为开头的动作bake视图。

以前提到的 ``cake bake fixture`` 和 ``cake bake test`` 是新的，每个都有一些子命令。
``cake bake fixture all`` 将会声策划那个所有的你的应用的基本的fixtures。``-count`` 
参数允许你设置要生成的 模拟/假 数据的数目。交互运行fixture任务可以让你使用你自己的
实时数据来生成fixtures。你可以使用 ``cake bake test <type> <class>`` 来为你的
应用中已经创建的对象创建测试用例。type应该是CakePHP中的一个标准的类型 
('component','controller', 'model', 'helper', 'behavior') 但并非必须是。class应
该是上面选择的类型的已经存在的对象。

**丰富的模板**

1.3中新增了很多模板。在1.2中使用模板生成视图可以被更改为修改由bake生成的视图文件。
在1.3模板中可以从bake生成所有的输出。这里有分离的模板，可以为控制器，控制器的任务集
，fixtures，模型，测试用例，以及1.2中的视图文件。同时，你也可以有多个模板集，或，
bake主题，bake主题可以在你的app中提供或者作为插件的一部分。例如使用bake主题插件的
路径可能是``app/Plugin/BakeTheme/Console/Templates/dark_red/`` 。一个bake主题名是
``blue_bunny`` 的可能会被放在 ``app/Console/Templates/blue_bunny``。你可以在
``lib/Cake/Console/Templates/default/`` 中查看那个文件和目录是一个bake主题要求的。
然而，和视图文件一样，如果你的bake主题并没有实现一个模板，其他的已经安装的主题会
被检测直到正确的模板被找到。

**额外的插件支持**

在1.3中在使用bake时新增了指定插件名字的方法。对于 ``cake bake plugin Todo controller Posts``,
这里有两种新的方式-- ``cake bake controller Todo.Posts`` 和
``cake bake controller Posts -plugin Todo`` ，在交互式bake中也可以这样用。比如
``cake bake controller -plugin Todo`` 将允许你使用交互式bake来添加控制器到你的
Todo插件。额外的/多个插件路径也被支持。在过去bake要求插件要放在 app/plugins目录。
在1.3中，bake将会寻找命名了的插件位于哪个pluginPaths，然后把那里的文件添加进来。



.. meta::
    :title lang=zh_CN: Code Generation with Bake
    :keywords lang=zh_CN: command line interface,functional application,atabase,database configuration,bash script,basic ingredients,roject,odel,path path,code generation,scaffolding,windows users,configuration file,few minutes,config,iew,shell,models,running,mysql
