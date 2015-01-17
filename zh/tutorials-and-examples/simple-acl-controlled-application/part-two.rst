简单的 Acl 控制的应用 - 第 2 部分
##########################################

创建 ACO 的自动化工具
===================================

An Automated tool for creating ACOs
===================================

正如前面提到的，这里没有预建的方法来把所有的控制器和动作都输入到 Acl 中。然而，我们都痛恨重复的工作，比如键入一个大型应用程序中的上百个动作。

As mentioned before, there is no pre-built way to input all of our
controllers and actions into the Acl. However, we all hate doing
repetitive things like typing in what could be hundreds of actions
in a large application.

为此，在 Github 中有一个很方便的插件，叫做 `AclExtras <https://github.com/markstory/acl_extras/>`_，可以在 `The Github 下载页面 <https://github.com/markstory/acl_extras/zipball/master>`_ 下载。我们会简要介绍如何使用它来生成 ACO。

For this purpose exists a very handy plugin available on GitHub, called
`AclExtras <https://github.com/markstory/acl_extras/>`_ which can
be downloaded in `The GitHub Downloads page <https://github.com/markstory/acl_extras/zipball/master>`_.
We're going to briefly describe how to use it to generate all our ACO's

首先，获取一份该插件的拷贝，解压或用 git 克隆，放入目录 `app/Plugin/AclExtras`。并在 `app/Config/boostrap.php` 文件中启用::

First grab a copy of the plugin and unzipped or clone it using git into
`app/Plugin/AclExtras`. Then activate the plugin in your `app/Config/boostrap.php`
file as shown below::

    //app/Config/boostrap.php
    // ...
    CakePlugin::load('AclExtras');

最后，在 CakePHP 终端中执行如下命令::

Finally execute the following command in the CakePHP console::


    ./Console/cake AclExtras.AclExtras aco_sync

可以在这样获得所有可用命令的完整指导::

You can get a complete guide for all available commands like this::

    ./Console/cake AclExtras.AclExtras -h
    ./Console/cake AclExtras.AclExtras aco_sync -h

一旦填充完 `acos` 表之后，继续创建应用的权限。

Once populated your `acos` table proceed to create your application permissions.

设置权限
======================

Setting up permissions
======================

创建权限很像创建 ACO，没有什么巧法，我也没什么好办法。要允许 ARO 访问到 ACO，从外壳(*shell*)接口使用 AclShell。欲知如何使用，可以运行下面的命令来查看 AclShell 的帮助::

Creating permissions much like creating ACO's has no magic solution, nor will I
be providing one. To allow ARO's access to ACO's from the shell interface use
the AclShell. For more information on how to use it consult the AclShell help
which can be accessed by running::

    ./Console/cake acl --help

注意 : \* 需要被引号包起来 ('\*')

Note: \* needs to be quoted ('\*')

要用 ``AclComponent`` 允许(权限)，要在自定义的方法中使用如下的核心语法::

In order to allow with the ``AclComponent`` we would use the
following code syntax in a custom method::

    $this->Acl->allow($aroAlias, $acoAlias);

现在要添加一些允许/拒绝的语句。在 ``UsersController`` 中添加下面的代码到一个临时的函数中，然后从浏览器中访问来运行(例如 http://localhost/cake/app/users/initdb)。使用 ``SELECT * FROM aros_acos`` 你会看到很多 1 和 -1。一旦确认了权限设置好了，就可以删除这个函数::

We are going to add in a few allow/deny statements now. Add the
following to a temporary function in your ``UsersController`` and
visit the address in your browser to run them (e.g.
http://localhost/cake/app/users/initdb). If you do a
``SELECT * FROM aros_acos`` you should see a whole pile of 1's and
-1's. Once you've confirmed your permissions are set, remove the
function::


    public function beforeFilter() {
        parent::beforeFilter();
        $this->Auth->allow('initDB'); // We can remove this line after we're finished
    }

    public function initDB() {
        $group = $this->User->Group;

        // Allow admins to everything
        $group->id = 1;
        $this->Acl->allow($group, 'controllers');

        // allow managers to posts and widgets
        $group->id = 2;
        $this->Acl->deny($group, 'controllers');
        $this->Acl->allow($group, 'controllers/Posts');
        $this->Acl->allow($group, 'controllers/Widgets');

        // allow users to only add and edit on posts and widgets
        $group->id = 3;
        $this->Acl->deny($group, 'controllers');
        $this->Acl->allow($group, 'controllers/Posts/add');
        $this->Acl->allow($group, 'controllers/Posts/edit');
        $this->Acl->allow($group, 'controllers/Widgets/add');
        $this->Acl->allow($group, 'controllers/Widgets/edit');
        
        // allow basic users to log out
        $this->Acl->allow($group, 'controllers/users/logout');

        // we add an exit to avoid an ugly "missing views" error message
        echo "all done";
        exit;
    }

我们已经建立了一些基本的访问规则。我们允许 administrators 做任何事情。Managers 可以访问任何 posts 和 widgets。而 users 只能访问 posts 和 widgets 的 add 和 edit 动作。

We now have set up some basic access rules. We've allowed
administrators to everything. Managers can access everything in
posts and widgets. While users can only access add and edit in
posts & widgets.

我们需要获得 ``Group`` 模型的引用，并且修改它的 id，来它指定需要的 ARO，这是因为 ``AclBehavior`` 行为的工作方式。 ``AclBehavior`` 行为并不设置 ``aros`` 表中的别名(*alias*)字段，所以我们必须使用对象引用或者数组来引用我们想要的 ARO。

We had to get a reference of a ``Group`` model and modify its id to
be able to specify the ARO we wanted, this is due to how
``AclBehavior`` works. ``AclBehavior`` does not set the alias field
in the ``aros`` table so we must use an object reference or an
array to reference the ARO we want.

你可能已经注意到我故意的在 Acl 权限中略掉了 index 和 view。我们要让 view 和 index 在 ``PostsController`` 和 ``WidgetsController`` 中是公开动作，这允许未经身份验证的用户来查看这些页面，即是公开页面。然而，你也可以随时从 ``AuthComponent::allowedActions`` 中删除这些动作，恢复到在Acl中的设置。

You may have noticed that I deliberately left out index and view
from my Acl permissions. We are going to make view and index public
actions in ``PostsController`` and ``WidgetsController``. This
allows non-authorized users to view these pages, making them public
pages. However, at any time you can remove these actions from
``AuthComponent::allowedActions`` and the permissions for view and
edit will revert to those in the Acl.

这是 ``Auth->allowedActions`` 的设置参考，在posts 和 widgets 的控制器中添加如下代码 ::

Now we want to take out the references to ``Auth->allowedActions``
in your users and groups controllers. Then add the following to
your posts and widgets controllers::

    public function beforeFilter() {
        parent::beforeFilter();
        $this->Auth->allow('index', 'view');
    }

这些去掉了我们在前面的users 和 groups 控制器中的 'off switches' ，并允许对posts和widgets控制器可以公开访问其index和view动作。在 ``AppController::beforeFilter()`` 中添加 ::

This removes the 'off switches' we put in earlier on the users and
groups controllers, and gives public access on the index and view
actions in posts and widgets controllers. In
``AppController::beforeFilter()`` add the following::

     $this->Auth->allow('display');

这让 'display' 动作公开。让我们的 PagesController::display() 公开。这是重要的，因为通常默认路由会将你的这一行动视为访问应用的主页。

This makes the 'display' action public. This will keep our
PagesController::display() public. This is important as often the
default routing has this action as the home page for your
application.

登录
==========

Logging in
==========

我们的应用现在有了访问控制，并且任何试图访问非公开页面的动作都会被重定向到登录页面。然后，我们需要在任何用户能够登录之前创建一个登录视图。创建 ``app/View/Users/login.ctp``  :

Our application is now under access control, and any attempt to
view non-public pages will redirect you to the login page. However,
we will need to create a login view before anyone can login. Add
the following to ``app/View/Users/login.ctp`` if you haven't done
so already:

.. code-block:: php

    <h2>Login</h2>
    <?php
    echo $this->Form->create('User', array(
        'url' => array(
            'controller' => 'users', 
            'action' => 'login'
        )
    ));
    echo $this->Form->input('User.username');
    echo $this->Form->input('User.password');
    echo $this->Form->end('Login');
    ?>

如果一个用户已经登录了，重定向到首页，添加到 UsersController::

If a user is already logged in, redirect him by adding this to your
UsersController::

    public function login() {
        if ($this->Session->read('Auth.User')) {
            $this->Session->setFlash('You are logged in!');
            return $this->redirect('/');
        }
    }

你应该已经登录了而且所有的东西都应该自动工作了。如果你添加了 ``echo $this->Session->flash('auth')`` ，当你访问被拒绝的时候就会看到Auth的消息。

You should now be able to login and everything should work
auto-magically. When access is denied Auth messages will be
displayed if you added the ``echo $this->Session->flash('auth')``

登出
======

Logout
======

现在实现登出。在 ``UsersController::logout()`` 中添加 ::

Now onto the logout. Earlier we left this function blank, now is
the time to fill it. In ``UsersController::logout()`` add the
following::

    $this->Session->setFlash('Good-Bye');
    $this->redirect($this->Auth->logout());

设置了提示信息，并且使用Auth 的 logout 方法登出。这个方法基本上是删除 Auth的Session Key并且返回一个可用于重定向的url。如果有其他的session数据需要被删除也是在这里添加代码。

This sets a Session flash message and logs out the User using
Auth's logout method. Auth's logout method basically deletes the
Auth Session Key and returns a URL that can be used in a redirect.
If there is other session data that needs to be deleted as well add
that code here.

全部完成
========

All done
========

现在你应该已经让你的应用使用Auth 和 Acl来控制访问了。用户的权限在其所在的组中设置，此时是不能对单个user进行权限设置的。你也可以以全局，每一个控制器和每个动作为基础设置权限。此外，你可以随着你的应用的扩张，写一些可重用的代码来方便扩展你的ACO表。

You should now have an application controlled by Auth and Acl.
Users permissions are set at the group level, but you can set them
by user at the same time. You can also set permissions on a global
and per-controller and per-action basis. Furthermore, you have a
reusable block of code to easily expand your ACO table as your app
grows.


.. meta::
    :title lang=zh_CN: Simple Acl controlled Application - part 2
    :keywords lang=zh_CN: shell interface,magic solution,aco,unzipped,config,sync,syntax,cakephp,php,running,acl
