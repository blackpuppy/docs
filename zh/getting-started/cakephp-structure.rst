CakePHP的结构
#################

CakePHP包括控制器 (Controller)，模型 (Model) 及视图 (View) 。还包括一些能使 MVC 编程更快更容易的附加的类和对象。组件 (Component)、行为 (Behavior) 及助手 (Helper)就是这样的类，它们提供扩展和利用，以使你能在基于 MVC 类的应用程序中快速添加功能。 现在我们将保持在一个较高水平上现在，我们将站在较高的层级上，接着开始寻找一些关于如何使用这些工具的细节。

应用程序扩展
======================

控制器 (Controller)、助手 (Helper)、模型 (Model) 都有各自的父类，你可以用它来定义应用程序内的变化。 AppController (位于
``/app/Controller/AppController.php``), AppHelper (位于
``/app/View/Helper/AppHelper.php``) 和 AppModel (位于
``/app/Model/AppModel.php``) 是放置你要在所有控制器、助手和模型中共享的方法的好地方。

尽管它们不是类或者文件，路由(Route)仍然在 CakePHP 请求中充当重要角色。路由定义告诉 CakePHP 如何将 URL 映射到控制器动作。默认的路由行为将 
URL地址 ``/controller/action/var1/var2``映射到
Controller::action($var1, $var2), 但是你可以使用路由来自定URL以及它们如何对应你的应用。

总的来说，一些在应用中的功能可以打包，插件 (Plugin) 是一个实现了特定功能的程序包，包含了模型、控制器和视图，并可以延申到多个应用之中。用户管理系统或者简单的博客比较适用作为CakePHP插件。


控制器扩展(组件 Component)
====================================

组件 (Component) 是一个帮助简化控制器逻辑的类。如果你有一些想要在控制器(或应用程序)之间共享使用的逻辑，那么组件通常是很适合的。比如，框架核心提供的 EmailComponent 组件使得创建及发送 email 成为一个轻松的工作。所以并不是在一个控制器内编写一个方法实现这样的逻辑，而是包装这样的逻辑以便在整个应用中被其他控制器共享使用。

控制器也同样配有回调函数(Callback)。当你需要在 CakePHP 核心操作之间插入一些逻辑时，可利用这些回调函数。可利用的回调函数包括：

-  ``beforeFilter()``, 在所有控制器动作逻辑前执行。
-  ``beforeRender()``, 在控制器动作逻辑之后视图渲染之前执行。
-  ``afterFilter()``, 在所有的控制器动作逻辑包括视图渲染之后执行。afterRender()和afterFilter() 之间没有什么不同，除非你在控制器动作中手动调用render()，并在调用后已经包含了一些逻辑。

模型扩展(行为 Behavior)
==============================

同样的，行为 (Behavior) 是用来在模型之间加入共用功能。举例来说，如果你将用户资料储存在树形结构中，你可以具体指定你的User 模型行为像树形结构，并在你的树形结构中自由操作移除、新增和搬移节点的功能。

模型 (Model) 也支持另一个叫做 DataSource 的类。DataSource 是一个让模型以一致的方式操作不同类别数据的抽象层。虽然在 CakePHP 应用中主要的数据来源通常是数据库，但你也可以编写附加的 DataSource 来使模型表达 RSS feeds、CSV 文件、LDAP目录数据或iCal 事件。DataSources 允许你从不同的数据来源来操作记录，而不只限制在使用 SQL 语句。DataSources也允许你通过LDAP 模型关联到许多 iCal 事件。
Models also are supported by another class called a DataSource.
DataSources are an abstraction that enable models to manipulate
different types of data consistently. While the main source of data
in a CakePHP application is often a database, you might write
additional DataSources that allow your models to represent RSS
feeds, CSV files, LDAP entries, or iCal events. DataSources allow
you to associate records from different sources: rather than being
limited to SQL joins, DataSources allow you to tell your LDAP model
that it is associated to many iCal events.

和控制器一样，模型同样也支持回调函数：

-  beforeFind()
-  afterFind()
-  beforeValidate()
-  beforeSave()
-  afterSave()
-  beforeDelete()
-  afterDelete()

通过这些回调函数的名称，就应该可以了解它们的作用。你可以在模型章节找到更详细的信息。


视图扩展(助手 Helper)
===========================

助手 (Helper) 是用来辅助扩展视图逻辑的类。如同控制器中的组件, 助手可在多个视图中存取及共享显示逻辑。核心助手中之一，JsHelper，使得在视图中使用 Ajax 请求更容易，并且提供 jQuery（默认）、Prototype 和 Mootools 支持。

大多数的应用程序都会有许多重复使用的视图代码片段。CakePHP 使用布局 (layout) 及元素 (elements) 使得重用视图代码更为容易。预设的情况下，每个被控制器渲染的视图都出现在一个布局内。当多个视图需要反复重用小片段代码的内容。可以把这些内容封装为元素。


.. meta::
    :title lang=zh_CN: CakePHP Structure
    :keywords lang=zh_CN: user management system,controller actions,application extensions,default behavior,maps,logic,snap,definitions,aids,models,route map,blog,plugins,fit
