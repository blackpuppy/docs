简单的 Acl 控制的应用
###########################################

.. note::

    这不是初学者的教程。如果你刚刚开始学习 CakePHP，我建议你还是先对整个框架的特点全面了解之后再开始本教程。

    This isn't a beginner level tutorial. If you are just starting out with
    CakePHP we would advise you to get a better overall experience of the
    framework's features before trying out this tutorial.


在这个教程中，你将会使用 :doc:`/core-libraries/components/authentication` 和
:doc:`/core-libraries/components/access-control-lists` 创建一个简单的应用。这个教程假设你已经阅读过 :doc:`/tutorials-and-examples/blog/blog`，并且熟悉 :doc:`/console-and-shells/code-generation-with-bake`。你应该对 CakePHP 有了一些经验, 并且熟悉 MVC 概念。这个教程是对 :php:class:`AuthComponent` 和 :php:class:`AclComponent` 的一个简单介绍。

In this tutorial you will create a simple application with
:doc:`/core-libraries/components/authentication` and
:doc:`/core-libraries/components/access-control-lists`. This
tutorial assumes you have read the :doc:`/tutorials-and-examples/blog/blog`
tutorial, and you are familiar with
:doc:`/console-and-shells/code-generation-with-bake`. You should have
some experience with CakePHP, and be familiar with MVC concepts.
This tutorial is a brief introduction to the
:php:class:`AuthComponent` and :php:class:`AclComponent`.

你所需要的：


#. 一个可以运行的 web 服务器。我们将假定你使用的是 Apache，不过使用其他服务器的步骤也差不多。我们也许要稍微调整服务器的配置, 但大多数人完全不需要任何配置就可以让 CakePHP 运行起来。  
#. 一个数据库服务器。在本教程中我们将使用 MySQL 数据库。你将会需要对 SQL 有足够的了解以便创建一个数据库：接下来就是 CakePHP 的事情了。
#. PHP 的基础知识。你使用面向对象编程越多越好，但如果你只熟悉面向过程编程也不要害怕。

What you will need


#. A running web server. We're going to assume you're using Apache,
   though the instructions for using other servers should be very
   similar. We might have to play a little with the server
   configuration, but most folks can get CakePHP up and running without
   any configuration at all.
#. A database server. We're going to be using MySQL in this
   tutorial. You'll need to know enough about SQL in order to create a
   database: CakePHP will be taking the reins from there.
#. Basic PHP knowledge. The more object-oriented programming you've
   done, the better: but fear not if you're a procedural fan.

准备我们的应用
=========================

Preparing our Application
=========================

首先，让我们获取一份最新的 CakePHP 的代码。

First, let's get a copy of fresh CakePHP code.

要获得最新的代码，请访问在 GitHub 上的 CakePHP 项目: https://github.com/cakephp/cakephp/tags，并下载稳定发行版。对于本教程，你需要最新的 2.0 发行版本。

To get a fresh download, visit the CakePHP project at GitHub:
https://github.com/cakephp/cakephp/tags and download the stable
release. For this tutorial you need the latest 2.0 release.


你也可以使用 `git <http://git-scm.com/>`_ 检出最新的代码::

    ``git clone git://github.com/cakephp/cakephp.git``

You can also clone the repository using
`git <http://git-scm.com/>`_::

    ``git clone git://github.com/cakephp/cakephp.git``

一旦你获得了最新的 CakePHP 代码，请设置配置文件 database.php，修改 app/Config/core.php 文件中的 Security.salt 的值。在此我们将为应用重新建立一个简单的数据库结构。在数据库中执行如下的 SQL 语句::

Once you've got a fresh copy of CakePHP setup your database.php config
file, and change the value of Security.salt in your
app/Config/core.php. From there we will build a simple database
schema to build our application on. Execute the following SQL
statements into your database::

   CREATE TABLE users (
       id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
       username VARCHAR(255) NOT NULL UNIQUE,
       password CHAR(40) NOT NULL,
       group_id INT(11) NOT NULL,
       created DATETIME,
       modified DATETIME
   );


   CREATE TABLE groups (
       id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
       name VARCHAR(100) NOT NULL,
       created DATETIME,
       modified DATETIME
   );


   CREATE TABLE posts (
       id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
       user_id INT(11) NOT NULL,
       title VARCHAR(255) NOT NULL,
       body TEXT,
       created DATETIME,
       modified DATETIME
   );

   CREATE TABLE widgets (
       id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
       name VARCHAR(100) NOT NULL,
       part_no VARCHAR(12),
       quantity INT(11)
   );

这些是我们构建应用程序的其余部分要用到的表。一旦我们有了数据库的表结构，我们就可以开始了。使用 :doc:`/console-and-shells/code-generation-with-bake` 来快速创建你的模型、控制器和视图。

These are the tables we will be using to build the rest of our
application. Once we have the table structure in the database we
can start cooking. Use
:doc:`/console-and-shells/code-generation-with-bake` to quickly
create your models, controllers, and views.

要使用 cake bake，调用 "cake bake all"，这会显示你插入到 MySQL 中的4个表，选择 "1. Group" 并按照提示操作。对其他 3 个表也进行同样的操作，这会为你生成 4 个控制器、模型和相应的视图。

To use cake bake, call "cake bake all" and this will list the 4
tables you inserted into MySQL. Select "1. Group", and follow the
prompts. Repeat for the other 3 tables, and this will have
generated the 4 controllers, models and your views for you.

在这里要避免使用脚手架(*Scaffold*)。如果生成带有脚手架功能的控制器，将会严重影响 ACOs (Aco: Access Control Object) 的生成。

Avoid using Scaffold here. The generation of the ACOs will be
seriously affected if you bake the controllers with the Scaffold
feature.

当自动生成模型代码时，cake 会自动探测出模型之间的关联(即表之间的关系)。让 cake 提供正确的 hasMany 和 belongsTo 关系。如果提示你选择 hasOne 或者 hasMany 关系，在本教程中通常(只)需要 hasMany 关系。

While baking the Models cake will automagically detect the
associations between your Models (or relations between your
tables). Let cake supply the correct hasMany and belongsTo
associations. If you are prompted to pick hasOne or hasMany,
generally speaking you'll need a hasMany (only) relationships for
this tutorial.

现在先不管 admin 路由，没有它们这个话题已经够复杂的了。另外，在用 bake 生成控制器时，确保 **不要** 添加 Acl 或者 Auth 组件到任何控制器中。对此我们很快就会着手。你现在应该已经有了 users、groups、posts 和 widgets 的模型、控制器以及生成的视图。

Leave out admin routing for now, this is a complicated enough
subject without them. Also be sure **not** to add either the Acl or
Auth Components to any of your controllers as you are baking them.
We'll be doing that soon enough. You should now have models,
controllers, and baked views for your users, groups, posts and
widgets.

准备添加 Auth
=====================

Preparing to Add Auth
=====================

我们现在已经有一个运行正常的 CRUD 应用了。Bake 应该已经建立了我们所需要的关系，如果不再增加新的关系的话。在添加 Auth 和 Acl 组件之前，我们还需要先做添加一些东西。首先，添加 login 和 logout 到 ``UsersController``::

We now have a functioning CRUD application. Bake should have setup
all the relations we need, if not add them in now. There are a few
other pieces that need to be added before we can add the Auth and
Acl components. First add a login and logout action to your
``UsersController``::

    public function login() {
        if ($this->request->is('post')) {
            if ($this->Auth->login()) {
                return $this->redirect($this->Auth->redirectUrl());
            }
            $this->Session->setFlash(__('Your username or password was incorrect.'));
        }
    }

    public function logout() {
        //Leave empty for now.
    }

然后，为 login 动作创建视图 ``app/View/Users/login.ctp``::

Then create the following view file for login at
``app/View/Users/login.ctp``::

    echo $this->Form->create('User', array('action' => 'login'));
    echo $this->Form->inputs(array(
        'legend' => __('Login'),
        'username',
        'password'
    ));
    echo $this->Form->end('Login');

接下来，我们需要更新我们的 User 模型，在保存到数据库之前先将密码散列化。存储普通文本格式的密码是极其危险的，并且 AuthComponent 组件会期望你的密码是散列化过的。在 ``app/Model/User.php`` 中添加如下代码::

Next we'll have to update our User model to hash passwords before they go into
the database. Storing plaintext passwords is extremely insecure and
AuthComponent will expect that your passwords are hashed. In
``app/Model/User.php`` add the following::

    App::uses('AuthComponent', 'Controller/Component');
    class User extends AppModel {
        // other code.
        // 其它代码。

        public function beforeSave($options = array()) {
            $this->data['User']['password'] = AuthComponent::password(
              $this->data['User']['password']
            );
            return true;
        }
    }

接下来要稍微改动一下 ``AppController``。如果还没有 ``/app/Controller/AppController.php``，就创建该文件。因为我们要使用 Auth 和 Acl 组件控制整个网站，我们会在 ``AppController`` 把它们设置好::

Next we need to make some modifications to ``AppController``. If
you don't have ``/app/Controller/AppController.php``, create it. Since we want our entire
site controlled with Auth and Acl, we will set them up in
``AppController``::

    class AppController extends Controller {
        public $components = array(
            'Acl',
            'Auth' => array(
                'authorize' => array(
                    'Actions' => array('actionPath' => 'controllers')
                )
            ),
            'Session'
        );
        public $helpers = array('Html', 'Form', 'Session');

        public function beforeFilter() {
            //Configure AuthComponent
            //配置 AuthComponent 组件
            $this->Auth->loginAction = array(
              'controller' => 'users',
              'action' => 'login'
            );
            $this->Auth->logoutRedirect = array(
              'controller' => 'users',
              'action' => 'login'
            );
            $this->Auth->loginRedirect = array(
              'controller' => 'posts',
              'action' => 'add'
            );
        }
    }

在设置 ACL 组件之前，需要添加一些用户和组。使用了 :php:class:`AuthComponent` ，我们无法访问任何动作，因为还没有登录。现在我们添加一些例外，这样 :php:class:`AuthComponent` 组件就会允许我们创建一些组和用户。在 ``GroupsController`` 控制器和 ``UsersController`` 控制器中 **都** 添加::    

Before we set up the ACL at all we will need to add some users and
groups. With :php:class:`AuthComponent` in use we will not be able to access
any of our actions, as we are not logged in. We will now add some
exceptions so :php:class:`AuthComponent` will allow us to create some groups
and users. In **both** your ``GroupsController`` and your
``UsersController`` Add the following::

    public function beforeFilter() {
        parent::beforeFilter();

        // For CakePHP 2.0
        // 对 CakePHP 2.0
        $this->Auth->allow('*');

        // For CakePHP 2.1 and up
        // 对 CakePHP 2.1 及以上版本
        $this->Auth->allow();
    }

这些语句告诉 AuthComponent 组件，允许公开访问所有动作。这只是临时的，一旦我们在数据库中创建了一些用户和组之后就会去掉。只是现在还不要添加任何用户和组。

These statements tell AuthComponent to allow public access to all
actions. This is only temporary and will be removed once we get a
few users and groups into our database. Don't add any users or
groups just yet though.

初始化 Db Acl 表
============================

Initialize the Db Acl tables
============================

在我们创建任何的用户或者组之前，我们要把它们连接到 Acl 组件。不过，我们现在还没有任何 Acl 组件的表，如果你现在试图访问任何页面，你会得到一个表不存在的错误("Error: Database table acos for model Aco was not found.")。要消除这些错误，我们需要运行一个数据结构(*schema*)文件。在命令行执行下面的命令::

Before we create any users or groups we will want to connect them
to the Acl. However, we do not at this time have any Acl tables and
if you try to view any pages right now, you will get a missing
table error ("Error: Database table acos for model Aco was not
found."). To remove these errors we need to run a schema file. In a
shell run the following::

    ./Console/cake schema create DbAcl

这个脚本会提示你删除并新建表。回答 yes 来删除并创建表。

This schema will prompt you to drop and create the tables. Say yes
to dropping and creating the tables.

如果你没有访问命令行的权限，或者无法使用终端，你可以执行 sql 文件 /path/to/app/Config/Schema/db\_acl.sql。

If you don't have shell access, or are having trouble using the
console, you can run the sql file found in
/path/to/app/Config/Schema/db\_acl.sql.

为数据输入设置了控制器，也初始化了 Acl 组件的表，这就行了？这还不够，还需要在用户(*user*)和组(*group*)模型中稍做改动，也就是说，让他们自动地附加上 Acl 组件。

With the controllers setup for data entry, and the Acl tables
initialized we are ready to go right? Not entirely, we still have a
bit of work to do in the user and group models. Namely, making them
auto-magically attach to the Acl.

充当请求者
===================

Acts As a Requester
===================

为了让 Auth 组件和 Acl 组件正常工作，我们需要将用户(*users*)表和组(*groups*)表同 Acl 组件的表进行关联。为此需要用到 ``AclBehavior`` 行为。``AclBehavior`` 允许将模型自动连接到 Acl 组件的表。使用它需要在模型中实现 ``parentNode()`` 方法。在 ``User`` 模型中添加如下代码 ::

For Auth and Acl to work properly we need to associate our users
and groups to rows in the Acl tables. In order to do this we will
use the ``AclBehavior``. The ``AclBehavior`` allows for the
automagic connection of models with the Acl tables. Its use
requires an implementation of ``parentNode()`` on your model. In
our ``User`` model we will add the following::

    class User extends AppModel {
        public $belongsTo = array('Group');
        public $actsAs = array('Acl' => array('type' => 'requester'));

        public function parentNode() {
            if (!$this->id && empty($this->data)) {
                return null;
            }
            if (isset($this->data['User']['group_id'])) {
                $groupId = $this->data['User']['group_id'];
            } else {
                $groupId = $this->field('group_id');
            }
            if (!$groupId) {
                return null;
            }
            return array('Group' => array('id' => $groupId));
        }
    }

然后在 ``Group`` 模型中添加::

Then in our ``Group`` Model Add the following::

    class Group extends AppModel {
        public $actsAs = array('Acl' => array('type' => 'requester'));

        public function parentNode() {
            return null;
        }
    }

我们所做的，就是将 ``Group`` 和 ``User`` 模型与 Acl 组件联系起来，并告诉 CakePHP 每次你创建一个用户(*User*)或组(*Group*)的同时也要在 ``aros`` 表中创建一条记录。这使得 Acl 的管理轻而易举，因为 ARO 透明地与 ``users`` 和 ``groups`` 表绑定在一起了。所以，每次创建或者删除一个用户/组的同时，Aro 表也会更新。

What this does, is tie the ``Group`` and ``User`` models to the
Acl, and tell CakePHP that every-time you make a User or Group you
want an entry on the ``aros`` table as well. This makes Acl
management a piece of cake as your AROs become transparently tied
to your ``users`` and ``groups`` tables. So anytime you create or
delete a user/group the Aro table is updated.

我们的控制器和模型已经可以添加一些初始数据了，我们的 ``Group`` 和 ``User`` 模型已经绑定到 Acl 组件的表了。所以可以访问 http://example.com/groups/add 和 http://example.com/users/add 使用自动生成的表单添加一些组和用户。我添加了这些组:

Our controllers and models are now prepped for adding some initial
data, and our ``Group`` and ``User`` models are bound to the Acl
table. So add some groups and users using the baked forms by
browsing to http://example.com/groups/add and
http://example.com/users/add. I made the following groups:

-  administrators
-  managers
-  users

我同时也在每个组中创建了一个用户，这样每个不同访问权限组都有一个用户，用于之后的测试。全部记录下来，或者选用容易记住的密码。如果在 mysql 提示符后运行 ``SELECT * FROM aros;`` 应该可以看到象下面这样的记录::

I also created a user in each group so I had a user of each
different access group to test with later. Write everything down or
use easy passwords so you don't forget. If you do a
``SELECT * FROM aros;`` from a mysql prompt you should get
something like the following::

    +----+-----------+-------+-------------+-------+------+------+
    | id | parent_id | model | foreign_key | alias | lft  | rght |
    +----+-----------+-------+-------------+-------+------+------+
    |  1 |      NULL | Group |           1 | NULL  |    1 |    4 |
    |  2 |      NULL | Group |           2 | NULL  |    5 |    8 |
    |  3 |      NULL | Group |           3 | NULL  |    9 |   12 |
    |  4 |         1 | User  |           1 | NULL  |    2 |    3 |
    |  5 |         2 | User  |           2 | NULL  |    6 |    7 |
    |  6 |         3 | User  |           3 | NULL  |   10 |   11 |
    +----+-----------+-------+-------------+-------+------+------+
    6 rows in set (0.00 sec)

这告诉我们已经有了 3 个组和 3 个用户。用户嵌套在组中，这样我们就可以按组和按用户设置权限。

This shows us that we have 3 groups and 3 users. The users are
nested inside the groups, which means we can set permissions on a
per-group or per-user basis.

只按组的 ACL
--------------

Group-only ACL
--------------

如果我们要只按组设置的权限，需要在 ``User`` 模型中实现 ``bindNode()`` 方法::

In case we want simplified per-group only permissions, we need to
implement ``bindNode()`` in ``User`` model::

    public function bindNode($user) {
        return array('model' => 'Group', 'foreign_key' => $user['User']['group_id']);
    }

任何修改 ``User`` 模型的 ``actsAs`` 变量，禁用 requester 指令::

Then modify the ``actsAs`` for the model ``User`` and disable the requester directive::

    public $actsAs = array('Acl' => array('type' => 'requester', 'enabled' => false));

这两处改动会告诉 ACL 忽略检查 ``User`` Aro's，而只检查 ``Group`` Aro's。这避免了调用 afterSave 回调。

These two changes will tell ACL to skip checking ``User`` Aro's and to check only ``Group``
Aro's. This also avoids the afterSave being called.

注意：每个用户都需要设置 ``group_id`` 才行。

Note: Every user has to have ``group_id`` assigned for this to work.

现在 ``aros`` 表会是这样::

Now the ``aros`` table will look like this::

    +----+-----------+-------+-------------+-------+------+------+
    | id | parent_id | model | foreign_key | alias | lft  | rght |
    +----+-----------+-------+-------------+-------+------+------+
    |  1 |      NULL | Group |           1 | NULL  |    1 |    2 |
    |  2 |      NULL | Group |           2 | NULL  |    3 |    4 |
    |  3 |      NULL | Group |           3 | NULL  |    5 |    6 |
    +----+-----------+-------+-------------+-------+------+------+
    3 rows in set (0.00 sec)

创建 ACOs (Access Control Objects)
======================================

Creating ACOs (Access Control Objects)
======================================

现在我们已经有了用户和组(aro)，我们可以开始输入现有的控制器到 Acl 组件中，并对组和用户设置权限，并激活登录/登出。

Now that we have our users and groups (aros), we can begin
inputting our existing controllers into the Acl and setting
permissions for our groups and users, as well as enabling login /
logout.

我们的 ARO 会在新建户和组的时候自动创建。有没有什么办法从控制器和动作来自动创建 ACO？可惜 CakePHP 的核心没有这样的魔法。不过核心类提供了一些方法来手动创建 ACO。你可以通过 Acl 外壳程序或者 ``AclComponent`` 组件创建 ACO。从外壳程序创建 Aco::

Our ARO are automatically creating themselves when new users and
groups are created. What about a way to auto-generate ACOs from our
controllers and their actions? Well unfortunately there is no magic
way in CakePHP's core to accomplish this. The core classes offer a
few ways to manually create ACO's though. You can create ACO
objects from the Acl shell or You can use the ``AclComponent``.
Creating Acos from the shell looks like::

    ./Console/cake acl create aco root controllers

而使用 AclComponent 组件就是这样::

While using the AclComponent would look like::

    $this->Acl->Aco->create(array('parent_id' => null, 'alias' => 'controllers'));
    $this->Acl->Aco->save();

上面两个例子都会创建 'root' 或者顶层 ACO，叫做 'controllers' 。这个根(*root*)节点的目的，是为了在整个应用程序的范围内更容易地允许/拒绝访问，并且允许把 Acl 组件用于和控制器/动作无关的目的，比如检查模型记录的访问权限。既然我们要使用全局的根(*root*) ACO，我们要略微修改 ``AuthComponent`` 组件的配置。``AuthComponent`` 组件需要知道根节点的存在，所以当进行 ACL 检查的时候它可以在查找控制器/动作时使用正确的节点路径。在 ``AppController`` 中确保 ``$components`` 数组中包含先前定义的 ``actionPath``::

Both of these examples would create our 'root' or top level ACO
which is going to be called 'controllers'. The purpose of this root
node is to make it easy to allow/deny access on a global
application scope, and allow the use of the Acl for purposes not
related to controllers/actions such as checking model record
permissions. As we will be using a global root ACO we need to make
a small modification to our ``AuthComponent`` configuration.
``AuthComponent`` needs to know about the existence of this root
node, so that when making ACL checks it can use the correct node
path when looking up controllers/actions. In ``AppController`` ensure
that your ``$components`` array contains the ``actionPath`` defined earlier::

    class AppController extends Controller {
        public $components = array(
            'Acl',
            'Auth' => array(
                'authorize' => array(
                    'Actions' => array('actionPath' => 'controllers')
                )
            ),
            'Session'
        );

本教程在 :doc:`part-two` 中继续。

Continue to :doc:`part-two` to continue the tutorial.


.. meta::
    :title lang=zh_CN: Simple Acl controlled Application
    :keywords lang=zh_CN: core libraries,auto increment,object oriented programming,database schema,sql statements,php class,stable release,code generation,database server,server configuration,reins,access control,shells,mvc,authentication,web server,cakephp,servers,checkout,apache
