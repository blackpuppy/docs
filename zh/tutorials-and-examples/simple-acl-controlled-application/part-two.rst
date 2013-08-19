简单Acl控制应用 - 第 2 部分
##########################################

创建ACOs的一个自动化工具
===================================

前面已经提到了，这里没有内置的方法来将我们所有的控制器和动作
都输入到Acl。然而，我们痛恨重复的输入劳动。

为了达到这个目的，在github中有很多好用的插件。比如
`AclExtras <https://github.com/markstory/acl_extras/>`_ 可以在 `The Github Downloads page <https://github.com/markstory/acl_extras/zipball/master>`_ 下载。我们将要简要介绍下如何使用它来生成我们的 ACO's

首先获得该插件，解压后放入目录 `app/Plugin/AclExtras`. 并在 `app/Config/boostrap.php` 中激活 ::

    //app/Config/boostrap.php
    // ...
    CakePlugin::load('AclExtras');

最后在 CakePHP 的终端中执行 ::

    ./Console/cake AclExtras.AclExtras aco_sync

你可以在这里找到一个可用命令的完整指导 ::

    ./Console/cake AclExtras.AclExtras -h
    ./Console/cake AclExtras.AclExtras aco_sync -h

一旦填充完 `acos` 表后，继续创建应用的权限。

设置权限
======================

创建权限和创建 ACO's 一样，没有什么巧法，我也没什么好办法。
使用AclShell允许ARO's从shell接口访问到ACO's。怎么使用它可以
参阅AclShell的帮助 ::

    ./Console/cake acl --help

注意 : \* 需要被引号包起来 ('\*')

为了允许 ``AclComponent`` 我们会在自定义的方法中使用如下的代码 ::

    $this->Acl->allow($aroAlias, $acoAlias);

现在添加一些允许/拒绝的语句。在你的 ``UsersController`` 中添加
这些代码到一个临时的函数中然后从浏览器中访问 (e.g.
http://localhost/cake/app/users/initdb)。使用 ``SELECT * FROM aros_acos`` 你会看到一堆 1's 和 -1's。 一旦你确认了你的权限设置，删除这个函数 ::


    public function beforeFilter() {
        parent::beforeFilter();
        $this->Auth->allow('initDB'); // We can remove this line after we're finished
    }

    public function initDB() {
        $group = $this->User->Group;
        //Allow admins to everything
        $group->id = 1;
        $this->Acl->allow($group, 'controllers');

        //allow managers to posts and widgets
        $group->id = 2;
        $this->Acl->deny($group, 'controllers');
        $this->Acl->allow($group, 'controllers/Posts');
        $this->Acl->allow($group, 'controllers/Widgets');

        //allow users to only add and edit on posts and widgets
        $group->id = 3;
        $this->Acl->deny($group, 'controllers');
        $this->Acl->allow($group, 'controllers/Posts/add');
        $this->Acl->allow($group, 'controllers/Posts/edit');
        $this->Acl->allow($group, 'controllers/Widgets/add');
        $this->Acl->allow($group, 'controllers/Widgets/edit');
        //we add an exit to avoid an ugly "missing views" error message
        echo "all done";
        exit;
    }

我们已经建立了一些基本的访问规则。我们允许administrators可以
做任何事。Managers可以访问任何的posts 和 widgets。而users
只可以在posts 和 widgets中访问add 和 edit。

我们得为 ``Group`` 模型建立一个引用，并且修改它的id让它指定
我们想要的ARO，这个因为 ``AclBehavior``并不设置表 ``aros`` 中
的别名字段，我们必须使用对象引用或者一个数据来引用我们想要用
的ARO。

你可能已经注意到我故意的在Acl权限中略掉了index和view。我们要
让view和index在 ``PostsController`` 和 ``WidgetsController`` 中
是公开动作，这允许无需认证的users来查看这些页面。然而，你也
可以随时在 ``AuthComponent::allowedActions``  中删除这些动作
，恢复到在Acl中的设置。

这是 ``Auth->allowedActions`` 的设置参考，在posts 和 widgets 的控制器中添加如下代码 ::

    public function beforeFilter() {
        parent::beforeFilter();
        $this->Auth->allow('index', 'view');
    }

这些去掉了我们在前面的users 和 groups 控制器中的 'off switches' ，并
允许对posts和widgets控制器可以公开访问其index和view动作。在 ``AppController::beforeFilter()`` 中添加 ::

     $this->Auth->allow('display');

这让 'display' 动作公开。让我们的 PagesController::display() 公开。
这是重要的，因为通常默认路由会将你的这一行动视为访问应用的主页。


登入
==========

我们的应用现在有了访问控制，并且任何试图访问非公开页面的动作
都会被重定向到登录页面。然后，我们需要在任何用户能够登录之前
创建一个登录视图。创建 ``app/View/Users/login.ctp``  :

.. code-block:: php

    <h2>Login</h2>
    <?php
    echo $this->Form->create('User', array('url' => array('controller' => 'users', 'action' => 'login')));
    echo $this->Form->input('User.username');
    echo $this->Form->input('User.password');
    echo $this->Form->end('Login');
    ?>

如果一个用户已经登录了，重定向到首页，添加到 UsersController::

    public function login() {
        if ($this->Session->read('Auth.User')) {
            $this->Session->setFlash('You are logged in!');
            $this->redirect('/', null, false);
        }
    }

你应该已经登录了而且所有的东西都应该自动工作了。如果你添加了
``echo $this->Session->flash('auth')`` ，当你访问被拒绝的时候
就会看到Auth的消息。

登出
======

现在实现登出。在 ``UsersController::logout()`` 中添加 ::

    $this->Session->setFlash('Good-Bye');
    $this->redirect($this->Auth->logout());

设置了提示信息，并且使用Auth 的 logout 方法登出。这个方法
基本上是删除 Auth的Session Key并且返回一个可用于重定向的url。
如果有其他的session数据需要被删除也是在这里添加代码。

齐活了（译者注：北京方言，意为都搞定了。）
========

现在你应该已经让你的应用使用Auth 和 Acl来控制访问了。
用户的权限在其所在的组中设置，此时是不能对单个user进行权限
设置的。你也可以以全局，每一个控制器和每个动作为基础设置权限。
此外，你可以随着你的应用的扩张，写一些可重用的代码来方便扩展
你的ACO表。


.. meta::
    :title lang=en: Simple Acl controlled Application - part 2
    :keywords lang=en: shell interface,magic solution,aco,unzipped,config,sync,syntax,cakephp,php,running,acl
