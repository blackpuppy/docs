Schema管理和迁移
################################

Schema Shell提供了一项功能来创建schema对象、schema sql转储以及创建数据库快照和
恢复数据库快照。

生成和使用Schema文件
=================================

生成的schema文件允许你轻松地传输数据库到不可知的schema。你可以为你的数据库生
成一个schema文件 ::

    $ Console/cake schema generate

这将会生成 schema.php 文件，位于 ``app/Config/Schema`` 目录。

.. note::

    schema shell将只处理模型定义过的表。强制处理所有的表，需要在命令行中加上  ``-f``  选项。

将来从你生成的文件schema.php来重建数据库schema，执行 ::

    $ Console/cake schema create

这将会根据文件schema.php的内容删除并创建表。


Schema文件也可用来生成sql转储文件，执行 ::

    $ Console/cake schema dump --write filename.sql

filename.sql指定要保存的文件名。如果你不指定，这个指令将会输出到终端而不是存入文件。

CakeSchema 回调
====================

在生成schema后，你会想要插入一些数据到表中让你的应用跑起来。这个可以通过CakeSchema
回调来实现。每一个schema文件中都含有一个 ``before($event = array())`` 和一个
``after($event = array())`` 方法。

``$event`` 变量是一个含有两个键的数据。一个是告诉一个表是在被删除还是被创建，另一个
是错误。例如 ::

    array('drop' => 'posts', 'errors' => null)
    array('create' => 'posts', 'errors' => null)

添加数据到一个posts表的例子 ::

    App::uses('Post', 'Model');
    public function after($event = array()) {
        if (isset($event['create'])) {
            switch ($event['create']) {
                case 'posts':
                    App::uses('ClassRegistry', 'Utility');
                    $post = ClassRegistry::init('Post');
                    $post->create();
                    $post->save(
                        array('Post' =>
                            array('title' => 'CakePHP Schema Files')
                        )
                    );
                    break;
            }
        }
    }

``before()`` 和 ``after()`` 回调会在当前schema上的表被创建或者删除的时候执行。

当插入到多个表中数据时，你需要在每个表被创建后将数据库的缓存清空。缓存可以被禁止，
在before 动作中设置 ``$db->cacheSources = false`` 。 ::

    public $connection = 'default';

    public function before($event = array()) {
        $db = ConnectionManager::getDataSource($this->connection);
        $db->cacheSources = false;
        return true;
    }

使用CakePHP schema shell迁移
====================================

迁移允许你对你的数据库schema进行版本控制。这样你的开发特点
Migrations allow for versioning of your database schema, so that as
you develop features you have an easy and database agnostic way to
distribute database changes. 
迁移功能是通过SCM控制schema或者是schema快照。使用schema进行迁移很简单。如果你已经
有了一个schema文件，执行 ::

    $ Console/cake schema generate

进行选择 ::

    Generating Schema...
    Schema file exists.
     [O]verwrite
     [S]napshot
     [Q]uit
    Would you like to do? (o/s/q)

选择 [s] (snapshot) 将会创建增量的 schema.php. 因此如果你已经有了schema.php,
它将会创建 schema\_2.php等。你可以在任意时候存储这些schema文件 ::

    $ cake schema update -s 2

2 是你想要运行的快照的数字，schema shell将会提示你确认你要的动作，并显示
``ALTER`` 语句表示已有的数据库和当前执行的Schema文件的不同之处。

你也可以在命令中加上 ``--dry``  选项预演一下。

工作流例子
=================

创建一个模式并提交
------------------------

一旦一个项目使用了版本控制，cake scheme的使用将会遵循如下步骤 :

1. 创建和编辑你的数据库表格
2. 执行你的cake schema来导出一个你的数据库的全部描述。
3. 提交创建的或者更新的schema.php文件 ::

    $ # once your database has been updated
    $ Console/cake schema generate
    $ git commit -a
    

.. note::

    如果项目没有被版本化，管理schema将会通过快照来完成（见上一节）。
   

获取最近一次的改动
------------------------

当你从你的仓库中拉取最新的改动是，探索数据库中结构的改动（可能会出现 'missing a table'
的错误）:

1. 执行 cake schema 更新你的数据库 ::

    $ git pull
    $ Console/cake schema create
    $ Console/cake schema update

这些操作都可以在预演模式中运行。

回滚
------------

如果你在更新你的数据库之前，需要回到以前的状态，你会被提示这样做cake schema是不
支持的。更具体的说，一旦你的表创建了你就不能自动删除了。反之，使用 ``update`` 将会
删除任何与schema文件中不同的地方 ::

    $ git revert HEAD
    $ Console/cake schema update

选择提示  ::

    The following statements will run.
    ALTER TABLE `roles`
    DROP `position`;
    Are you sure you want to alter the tables? (y/n)
    [n] >

.. meta::
    :title lang=zh_CN: Schema management and migrations
    :keywords lang=zh_CN: schema files,schema management,schema objects,database schema,table statements,database changes,migrations,versioning,snapshots,sql,snapshot,shell,config,functionality,choices,models,php files,php file,directory,running
