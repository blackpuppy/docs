CakePHP 目录结构
########################

在你下载并且解压缩CakePHP之后，会看到这样一些文件和目录：

-  app
-  lib
-  vendors
-  plugins
-  .htaccess
-  index.php
-  README

有三个主要的目录：

-  *app* 目录是放置你应用程序的地方。
-  *lib* 目录是CakePHP的核心类库请不要修改里面的东西。
-  *vendors* 目录可以放置第三方PHP类库，可以被你的应用程序调用

App目录
==============

CakePHP的app目录是应用开发中最常使用的。让我们来更仔细的看里面有些什么。

Config
    CakePHP使用的配置文件。数据库连接信息，bootstrapping，核心配置文件。
Controller
    控制器和组件。
Lib
    包含一些不是来自于第三方或外部库。这将你的内部库和外部库中分开。
Locale
    包含国际化的文件。
Model
    包含应用程序的模型、行为和数据源。
Plugin
    包含插件包
tmp
    这是用来保存CakePHP临时数据的。保存的资料是看你如何设定CakePHP，但这个目录通常用来储存模型描述、log和session信息。
    请确保此目录存在并且可写，否则 应用程序的性能将受到严重影响，在调试模式，会出现警告。
Vendor
    所有的第三方类或库应该被放置在这个目录。可以简单的用 App::import('vendor',
    'name') 方法来使用。 细心的同学会注意到和app平级目录下面也有一个vendors目录，当我们讨论到管理多个应用程序和较为复杂的系统配置时，会明白两者之间的差异。
View
    展示层的文件被放置在此处:元素(elements)、错误页面(error pages)、助手(helpers)、布局(layouts)和视图文件(view files)。
webroot
    在开发阶段，此目录是应用程序的根目录，包含CSS,图片和JavaScript 文件。


.. meta::
    :title lang=zh: CakePHP Folder Structure
    :keywords lang=zh: internal libraries,core configuration,model descriptions,external vendors,connection details,folder structure,party libraries,personal commitment,database connection,internationalization,configuration files,folders,application development,readme,lib,configured,logs,config,third party,cakephp
