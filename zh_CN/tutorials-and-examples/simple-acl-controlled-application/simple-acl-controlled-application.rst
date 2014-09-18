简单Acl（Access List Control）控制应用
#################################

.. 注意::

	这个教程并不适合初学者。如果你刚刚开始学习 CakePHP，我建议
	你还是先对整个框架的特点全面了解之后再开始本教程。

在这个教程中，你将会常见一个简单的应用，将会用到文档
:doc:`/core-libraries/components/authentication`  和
:doc:`/core-libraries/components/access-control-lists`  。这个教程
假设你已经阅读过这个教程 :doc:`/tutorials-and-examples/blog/blog`
，并且你已经熟悉了 :doc:`/console-and-shells/code-generation-with-bake`. 
你应该对 CakePHP 有了不少经验, 并且了解 MVC 概念。这个教程是一个
对 :php:class:`AuthComponent` 和 :php:class:`AclComponent`\. 的简单介绍。

你所需要的：


#. 一个运行中的web服务器。我们将假定你使用的是Apache,使用
   其他服务器的设置（或步骤）也差不多。 我们将会稍微改动服务
   器的配置文件, 但大多数情况下 Cake 将不需要任何配置的改动就
   可以跑起来。  
#. 一个数据库服务器。在本教程中我们将使用MySQL数据库。你将会
   需要对SQL有一定的了解以便创建一个数据库：Cake将从这里接管数据库。
#. 基础的 PHP知识。你使用面向对象编程越多越好，但如果你只是一个
   程序迷也不要害怕。

准备我们的应用
=========================

首先，让我们获取一份最新的Cake的代码拷贝。

要获得最新的代码，要访问在 GitHub 上的 CakePHP 项目:
`https://github.com/cakephp/cakephp/tags <https://github.com/cakephp/cakephp/tags>`_
并下载最新的稳定发行版 2.0。

你也可以通过git检出最新的代码
`git <http://git-scm.com/>`_.
``git clone git://github.com/cakephp/cakephp.git``


一旦你获得了最新Cake代码，设置数据库配置文件 database.php , 
修改  app/Config/core.php 中的Security.salt 的值，我们将为应用建立
一个简单的数据库结构，在你的数据库中执行如下的 SQL 语句::

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

这些是我们应用中接下来要用的表。一旦我们完成了数据库的表
结构，我们就可以开始了。参考文档 :doc:`/console-and-shells/code-generation-with-bake` 
来快速建立你的模型，控制器和视图。

为了使用Cake bake，调用  "cake bake all"  ，其会显示你插入到
mySQL中的4个表，选择 "1. Group" 并按照提示操作。对其他
3个表也进行同样的操作，最后将产生4个控制器，模型和视图。

这里避免使用 Scaffold 。使用Scaffold来bake将会严重影响
ACOs（ Aco： Access Control Object） 的生成。

当自动生成模型代码时，Cake将会自动探测出相关的模型之间的关系
让Cake提供正确的 hasMany 和 belongsTo 关系。如果你被提示
要选择 hasOne 或者 hasMany 关系，在本教程中我们需要一个
hasMany 关系。

现在先不管admin的路由，现在已经够复杂了，确保不要添加
Acl或者Auth组件到任何你baking的控制器中，因为他们是bake
出来的。我们将在后面做这个，你应该已经有了你的users，groups
，posts和widgets的模型，控制器以及视图。

准备添加 Auth
=====================

我们现在已经是一个可以 CRUD 的应用。Bake应该已经建立了
我们所需要的关系，在添加Auth和Acl组件之前我们需要先做一些
准备工作，首先是添加 login 和 logout 到 ``UsersController``::

    public function login() {
        if ($this->request->is('post')) {
            if ($this->Auth->login()) {
                $this->redirect($this->Auth->redirect());
            } else {
                $this->Session->setFlash('Your username or password was incorrect.');
            }
        }
    }

    public function logout() {
        //Leave empty for now.
    }

然后，为login创建视图 ``app/View/Users/login.ctp``::

    echo $this->Form->create('User', array('action' => 'login'));
    echo $this->Form->inputs(array(
        'legend' => __('Login'),
        'username',
        'password'
    ));
    echo $this->Form->end('Login');

接下来，我们需要更新我们的User模型，在保存到数据库之前先将
密码散列化，存储普通文本格式的密码是极其危险的，并且AuthComponent
将会期望你的密码是散列过的。在  ``app/Model/User.php``  中添加代码 ::

    App::uses('AuthComponent', 'Controller/Component');
    class User extends AppModel {
        // other code.

        public function beforeSave($options = array()) {
            $this->data['User']['password'] = AuthComponent::password($this->data['User']['password']);
            return true;
        }
    }


稍微动一下  ``AppController`` 。如果还没有就创建它 ``/app/Controller/AppController.php`` 。
记住是在 /app/Controller/ 目录下，而不是  /app/app_controllers.php.。
因为我们希望在整个网站中都使用统一的 Auth 和 Acl ，在 ``AppController`` 加入::

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
            $this->Auth->loginAction = array('controller' => 'users', 'action' => 'login');
            $this->Auth->logoutRedirect = array('controller' => 'users', 'action' => 'login');
            $this->Auth->loginRedirect = array('controller' => 'posts', 'action' => 'add');
        }
    }

首先先添加一些user和groups，使用  :php:class:`AuthComponent`  ，
当未登录的时候我们是不能访问任何动作的。我们将在这里添加一些
例外，允许创建一些groups和users。在  ``GroupsController``  和 ``UsersController`` 中都添加 ::	

    public function beforeFilter() {
        parent::beforeFilter();

        // For CakePHP 2.0
        $this->Auth->allow('*');

        // For CakePHP 2.1 and up
        $this->Auth->allow();
    }

这些语句告诉 AuthComponent 允许公开访问任何动作。
这是临时的，一旦我们在数据库中创建一些users和groups之后将会被
删除掉. 不要添加任何users和groups尽管现在还没有。

初始化 Db Acl  表
============================

在我们创建任何的users或者groups之前，我们需要连接到Acl。
然后，我们现在还没有任何Acl的表，如果你访问任意的页面，你
会得到一个表错误的提示  ("Error: Database table acos for model Aco was not
found.")。好吧，来解决它吧。在shell中执行命令 ::

    ./Console/cake schema create DbAcl

这个脚本会提示你删除和新建表，一路yes。

如果你没有shell，或者无法使用终端，你可以执行这个sql文件：
/path/to/app/Config/Schema/db\_acl.sql.

为数据输入设置了控制器，也创建了Acl表，但这还不够，还需要在
user和group模型中稍微改动，也就是说，让他们自动地附加上Acl。

充当请求者
===================

为了让 Auth 和 Acl 正确工作，我们需要将users和groups同Acl的
表进行关联。需要用到  ``AclBehavior``。 ``AclBehavior``  允许将
模型自动连接到Acl的表。使用它得要在你的模型中实现 ``parentNode()`` 
方法，在模型 ``User`` 中添加如下代码 ::

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
            } else {
                return array('Group' => array('id' => $groupId));
            }
        }
    }

在 ``Group`` 模型中添加 ::

    class Group extends AppModel {
        public $actsAs = array('Acl' => array('type' => 'requester'));

        public function parentNode() {
            return null;
        }
    }

我们所做的，就是将 ``Group`` 和 ``User`` 模型系到 Acl上，并告诉 CakePHP 
每次你创建一个User或Group的同时也要在  ``aros``  表中输入一条记录。
这使Acl的管理很简单，因为你的 AROs 在绑定你的 ``users`` 和 ``groups`` 表之后变得透明了，所以你每次创建或者删除一个 user/group 的同时
Aro 表也会更新。

我们的控制器和模型已经可以添加一些初始数据了，我们的 ``Group`` 
和 ``User`` 模型已经绑定到 Acl表了。所以访问 http://example.com/groups/add 
和 http://example.com/users/add 使用自动生成的表单添加一些
groups 和 users。 我添加了这些组 :

-  administrators
-  managers
-  users

我同时也在每个组中创建了一个用户以便后面测试。把过程记录下来
并选用容易记住的密码。如果你在myssl命令行中敲入 ``SELECT * FROM aros;`` 
你可以看到查询到的记录 ::

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

记录显示我们已经有了3个 groups 和 3个 users。用户嵌套在
组中，这样我们就可以分别对每个组和用户进行权限设置。

只限定组的 ACL
--------------

为了简单，只对每个组进行权限设置，我们需要在 ``User`` 模型中实现 ``bindNode()`` in ``User`` model::

    public function bindNode($user) {
        return array('model' => 'Group', 'foreign_key' => $user['User']['group_id']);
    }

这个方法将会告诉 ACL 忽略检查 ``User`` Aro's 而只检查 ``Group`` Aro's.

任意user都需要设置 ``group_id`` 才可起作用。

在这个例子中， ``aros`` 表会是这样::

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

现在我们已经有了users和groups(aros)，我们可以开始输入一些已经
存在的控制器到Acl中，并对我们的groups和users设置权限，并
激活登录/登出。

我们的 ARO 会在新建 users 和 groups 的时候自动创建。这有没有
什么方法通过我们的控制器和动作来自动创建 ACOs ? 坏消息是这
真没有，CakePHP 的核心并不提供这个，只是提供了一些方法来
手动创建 ACO。你可以通过Acl的shell创建 ACO 或者使用 ``AclComponent`` 。


从shell创建 Acos ::

    ./Console/cake acl create aco root controllers

使用 AclComponent ::

    $this->Acl->Aco->create(array('parent_id' => null, 'alias' => 'controllers'));
    $this->Acl->Aco->save();

这两种办法都会创建 'root'  或者被称为 'controllers' 的顶层的 ACO。
这个root节点的目的是为了在整个应用的空间内更方便地允许/拒绝访问。
并且允许对 跨控制器/动作（例如检查模型记录权限）使用Acl。
为了使用全局的root ACO，我们需要修改 ``AuthComponent`` 配置。
``AuthComponent`` 需要知道root节点是否存在，所以当进行ACL
检查的时候它可以在控制器/动作中寻找到正确的节点路径。在中确保
``AppController`` 你的 ``$components`` 数组中包含 ``actionPath`` 的定义 ::

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

转到 :doc:`part-two`  继续本教程.


.. meta::
    :title lang=zh_CN: Simple Acl controlled Application
    :keywords lang=zh_CN: core libraries,auto increment,object oriented programming,database schema,sql statements,php class,stable release,code generation,database server,server configuration,reins,access control,shells,mvc,authentication,web server,cakephp,servers,checkout,apache
