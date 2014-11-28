访问控制列表组件
####################

.. php:class:: AclComponent(ComponentCollection $collection, array $settings = array())

CakePHP 的访问控制列表是最常被讨论的功能之一，最有可能是因为这是最迫切
需要的，但也可能是因为它是最令人费解的。如果你在寻找通常开始使用访问控制列表
(ACL)的好方式，请继续读下去。

勇敢面对，坚持始终，即使过程并非一帆风顺。一旦你掌握了其中的诀窍，这就会成为你
手中极为强大的开发工具。

理解 ACL 如何工作
===========================

强大的事物需要权限控制。访问控制列表是一种管理应用程序权限的方式，具有细小颗粒
度，并且易于维护和管理。

访问控制列表，或者 ACL，主要管理两种东西: 要求东西的，和被要求的东西。用 ACL 
的术语来说，要使用东西的(多数情况下是用户)被称为访问请求对象(*access request 
object*)，或者 ARO。系统中被要求的东西(多数情况下是动作或数据)被称为访问控制对象
(*access control object*)，或者 ACO。实体被称为“对象”是因为有时请求对象不是人——有时你也许要
限制某个 Cake 控制器启动应用程序其它部分逻辑的权限。ACO 可以是任何你想控制的
东西，从控制器行为，到网络服务(web service)，到你奶奶网络日记的某一行。

回顾一下:

-  ACO —— 访问控制对象(*Access Control Object*) —— 被要求的东西
-  ARO —— 访问请求对象(*Access Request Object*) —— 要求东西的东西

基本上，ACL 就是用来决定何时一个 ARO 能够访问一个 ACO。

为了帮助你理解所有的东西在一起如何工作，让我们使用一个半真半假的例子。花一点儿
时间，想象一下，魔幻小说*指环王*中的那群熟悉的探险人物们使用的计算机系统。队
伍的领导者，甘道夫，想要管理团队的资产，同时保持团队其他成员足够的隐私和安全。
他要做的第一件事就是建立一份涉及的 ARO 的名单:


-  甘道夫(Gandalf)
-  阿拉贡(Aragorn)
-  毕尔博(Bilbo)
-  弗拉多(Frodo)
-  咕噜姆(Gollum)
-  拉格拉斯(Legolas)
-  吉穆利(Gimli)
-  皮平(Pippin)
-  梅里(Merry)

.. note::

    必须认识到，访问控制列表(ACL)与验证(*authentication*)*不*同。
    访问控制列表(ACL)是在一个用户被验证之后的事情。尽管两者通常联合使用，认识
    到它们的区别很重要，一个是知道某人是谁(验证)，一个是知道他能做什么(ACL)。

甘道夫要做的下一件事就是建立一份系统要管理的物品或访问控制对象(ACO)的初始清单。
他的清单大概会是这样:


-  武器(Weapons)
-  魔戒(The One Ring)
-  腌肉(Salted Pork)
-  通关文牒(Diplomacy)
-  麦芽酒(Ale)

通常的做法是，系统的管理会使用一种矩阵，显示一组用户和与物品关联的权限。如果这
些信息保存在一个表格中，也许会是象下面的表格这样:

================= ============= ============== ================= =================== ===========
x                 武器(Weapons) 魔戒(The Ring) 腌肉(Salted Pork) 通关文牒(Diplomacy) 麦芽酒(Ale)
================= ============= ============== ================= =================== ===========
甘道夫(Gandalf)                                允许              允许                允许       
----------------- ------------- -------------- ----------------- ------------------- -----------
阿拉贡(Aragorn)   允许                         允许              允许                允许     
----------------- ------------- -------------- ----------------- ------------------- -----------
毕尔博(Bilbo)                                                                        允许     
----------------- ------------- -------------- ----------------- ------------------- -----------
弗拉多(Frodo)                   允许                                                 允许     
----------------- ------------- -------------- ----------------- ------------------- -----------
咕噜姆(Gollum)                                 允许                                             
----------------- ------------- -------------- ----------------- ------------------- -----------
拉格拉斯(Legolas) 允许                         允许              允许                允许     
----------------- ------------- -------------- ----------------- ------------------- -----------
吉穆利(Gimli)     允许                         允许                                             
----------------- ------------- -------------- ----------------- ------------------- -----------
皮平(Pippin)                                                     允许                允许     
----------------- ------------- -------------- ----------------- ------------------- -----------
梅里(Merry)                                                      允许                允许     
================= ============= ============== ================= =================== ===========

乍一看，这样似乎不错。通过赋值可以保护安全(只有弗拉多可以触摸魔戒)，又可以防
止事故(不让霍比特人碰到腌肉和武器)。看起来有足够细小的颗粒度，又容易阅读，不
是吗？

对于象这样小的系统，也许矩阵的设置就可以了。但对一个逐渐扩展的系统，或一个有大
量资源(ACO)和用户(ARO)的系统，一个表格很快就会变得难以管理。想象一下试图去控制
上百个作战营地的访问权限，并以单个营地来管理。矩阵的另一个缺陷是，你无法逻辑地
把用户分组，或者基于这样的逻辑分组来对成组的用户做层叠式的权限改动。例如，如果
在战斗结束后能自动允许霍比特人使用麦芽酒和腌肉，那当然好: 但逐个人地设置权限很
繁琐，且容易出错。层叠式地修改所有“霍比特人”的权限就容易多了。

访问控制列表(ACL)最通常以树形结构来实现。通常有一棵访问请求对象(ARO)树和一棵访
问控制对象(ACO)树。把你的对象组织成树形，权限仍然可以以细微的颗粒处理，同时又
保持大范围的控制。作为一个英明的领导者，甘道夫在新系统中选择使用访问控制列表
(ACL)，并按照下面的方式来组织他的对象:


-  魔戒团队(Fellowship of the Ring™)

   -  战士(Warriors)

      -  阿拉贡(Aragorn)
      -  拉格拉斯(Legolas)
      -  吉穆利(Gimli)

   -  术士(Wizards)

      -  甘道夫(Gandalf)

   -  霍比特人(Hobbits)

      -  弗拉多(Frodo)
      -  毕尔博(Bilbo)
      -  梅里(Merry)
      -  皮平(Pippin)

   -  来访者(Visitors)

      -  咕噜姆(Gollum)



对访问请求对象(ARO)使用树形结构允许甘道夫一次性为整群用户定义权限。所以，用我
们的访问请求对象(ARO)树，甘道夫可以确定一些群组的权限:


-  魔戒团队(Fellowship of the Ring™)
   (**禁止**: 一切)

   -  战士(Warriors)
      (**允许**: 武器, 麦芽酒, 精灵食品(Elven Rations), 腌肉)

      -  阿拉贡(Aragorn)
      -  拉格拉斯(Legolas)
      -  吉穆利(Gimli)

   -  术士(Wizards)
      (**允许**: 腌肉, 通关文牒, 麦芽酒)

      -  甘道夫(Gandalf)

   -  霍比特人(Hobbits)
      (**允许**: 麦芽酒)

      -  弗拉多(Frodo)
      -  毕尔博(Bilbo)
      -  梅里(Merry)
      -  皮平(Pippin)

   -  来访者(Visitors)
      (**允许**: 腌肉)

      -  咕噜姆(Gollum)



如果我们要使用访问控制列表(ACL)来查看皮平(Pippin)是否被允许喝麦芽酒，我们需要先
获得他在树中的路径，即 Fellowship->Hobbits->Pippin。然后我们检查在每个节点上的
不同权限，再使用与皮平(Pippin)和麦芽酒最相关的权限。

================================ ================ =======================
ARO 节点                         权限信息         结果
================================ ================ =======================
魔戒团队(Fellowship of the Ring) 禁止一切         禁止喝麦芽酒。
-------------------------------- ---------------- -----------------------
霍比特人(Hobbits)                允许麦芽酒       允许喝麦芽酒！
-------------------------------- ---------------- -----------------------
皮平(Pippin)                     --               还是允许喝麦芽酒！
================================ ================ =======================

.. note::

    由于访问控制列表(ACL)树中的 'Pippin' 节点没有明确禁止对麦芽酒访问控制对象
    (ACO)的访问，最后的结果是我们允许对该访问控制对象(ACO)的访问。

树形结构也允许我们为更小颗粒的控制做跟细微的调整——而同时又能保持对成群的访问
请求对象(ARO)做大范围修改的能力:


-  魔戒团队(Fellowship of the Ring™)
   (**禁止**: 一切)

   -  战士(Warriors)
      (**允许**: Weapons, 麦芽酒, 精灵食品(Elven Rations), 腌肉)

      -  阿拉贡(Aragorn)
         (Allow: Diplomacy)
      -  拉格拉斯(Legolas)
      -  吉穆利(Gimli)

   -  术士(Wizards)
      (**允许**: 腌肉, 通关文牒, 麦芽酒)

      -  甘道夫(Gandalf)

   -  霍比特人(Hobbits)
      (**允许**: 麦芽酒)

      -  弗拉多(Frodo)
         (Allow: Ring)
      -  毕尔博(Bilbo)
      -  梅里(Merry)
         (Deny: 麦芽酒)
      -  皮平(Pippin)
         (Allow: 通关文牒)

   -  来访者(Visitors)
      (**允许**: 腌肉)

      -  咕噜姆(Gollum)



这种方法允许我们既可以做大范围的权限修改，又可以进行细微的调整。这让我们可以说，
所有霍比特人都可以喝麦芽酒，只有一个例外——梅里(Merry)。要查看梅里(Merry)是否可以
喝麦芽酒，我们要找出他在树中的路径: Fellowship->Hobbits->Merry，再延路径而下，注
意与麦芽酒相关的权限:

================================ ================ =======================
ARO 节点                         权限信息         结果
================================ ================ =======================
魔戒团队(Fellowship of the Ring) 禁止一切         禁止喝麦芽酒。
-------------------------------- ---------------- -----------------------
霍比特人(Hobbits)                允许麦芽酒       允许喝麦芽酒！
-------------------------------- ---------------- -----------------------
梅里(Merry)                      禁止麦芽酒       禁止喝麦芽酒！
================================ ================ =======================

定义权限: Cake 基于 INI 的访问控制列表(ACL)
===========================================

Cake 的第一个访问控制列表(ACL)实现是基于保存在 Cake 安装目录下的 INI 文件。尽管
这可用且稳定，我们仍建议你使用基于数据库的 ACL 解决方案，主要因为它能够及时(on 
the fly)创建新的访问控制列表(ACO)和访问请求对象(ARO)。我们是指简单应用程序中的
使用——而且尤其是那些出于某些原因而可能不使用数据库的情况。

缺省情况下，CakePHP 的访问控制列表(ACL)是数据库驱动的。要启用基于 INI 的访问控
制列表(ACL)，你需要告诉CakePHP 你使用什么系统，改变 app/Config/core.php 中的下
面这几行。

::

    // 改变这几行:
    Configure::write('Acl.classname', 'DbAcl');
    Configure::write('Acl.database', 'default');

    // 改成这样:
    Configure::write('Acl.classname', 'IniAcl');
    //Configure::write('Acl.database', 'default');

访问请求对象(ARO)/访问控制对象(ACO)权限在**/app/Config/acl.ini.php**中指定。基
本上访问请求对象(ARO)在一个 INI 段落中，有三个属性: groups，allow，和 deny。


-  groups: 当前访问请求对象(ARO)所属的访问请求对象(ARO)组的名称。
-  allow: 当前访问请求对象(ARO)能够访问的访问控制对象(ACO)的名称
-  deny: 当前访问请求对象(ARO)应当被拒绝访问的访问控制对象(ACO)的名称

访问控制对象(ACO)在 INI 段落中只有 allow 和 deny 属性。

作为一个例子，让我们来看看我们一直在精心打造的魔戒团队访问请求对象(ARO)的结构，
在 INI 语法中会是什么样子:

::

    ;-------------------------------------
    ; AROs
    ;-------------------------------------
    [aragorn]
    groups = warriors
    allow = diplomacy

    [legolas]
    groups = warriors

    [gimli]
    groups = warriors

    [gandalf]
    groups = wizards

    [frodo]
    groups = hobbits
    allow = ring

    [bilbo]
    groups = hobbits

    [merry]
    groups = hobbits
    deny = ale

    [pippin]
    groups = hobbits

    [gollum]
    groups = visitors

    ;-------------------------------------
    ; ARO Groups
    ;-------------------------------------
    [warriors]
    allow = weapons, ale, salted_pork

    [wizards]
    allow = salted_pork, diplomacy, ale

    [hobbits]
    allow = ale

    [visitors]
    allow = salted_pork

现在定义了权限，你可以直接跳到使用访问控制列表(ACL)组件来 
:ref:`检查权限一节 <checking-permissions>`。

定义权限: Cake 基于数据库的访问控制列表(ACL)
============================================

至此我们介绍了基于 INI 的访问控制列表(ACL)权限，让我们继续介绍(更常用的)基于数
据库的访问控制列表(ACL)。

起步
---------------

缺省的访问控制列表(ACL)权限实现是数据库驱动的。Cake 的数据库访问控制列表(ACL)
包括一组核心模型，以及 Cake 安装自带的一个命令行应用程序。模型是 Cake 用来与
数据库交互从而保存和读取树形格式的节点。命令行应用程序用来初始化你的数据库以及
与访问控制对象(ACO)和访问请求对象(ARO)进行交互。

首先，你要确保``/app/Config/database.php``存在并且正确配置。关于数据库配置的详
细信息见4.1小节。

一旦完成，就可以用 CakePHP 的命令行程序来创建访问控制列表(ACL)数据库表:

::

    $ cake schema create DbAcl

运行该命令会删除(*drop*)并重建以树形格式保存访问控制对象(ACO)和访问请求对象
(ARO)信息必需的表。命令行应用程序的输出应该象这样:

::

    ---------------------------------------------------------------
    Cake Schema Shell
    ---------------------------------------------------------------

    The following tables will be dropped.
    acos
    aros
    aros_acos

    Are you sure you want to drop the tables? (y/n)
    [n] > y
    Dropping tables.
    acos updated.
    aros updated.
    aros_acos updated.

    The following tables will be created.
    acos
    aros
    aros_acos

    Are you sure you want to create the tables? (y/n)
    [y] > y
    Creating tables.
    acos updated.
    aros updated.
    aros_acos updated.
    End create.

.. note::

    这代替了之前的已废弃的命令"initdb"。

你也可以使用 SQL 文件``app/Config/Schema/db_acl.sql``，不过那样一点儿也不好玩儿。

当这完成之后，你的系统中就应该有三个新的数据库表: acos，aros 和 aros\_acos (关
联表，用来创建两个树之间的权限信息)。

.. note::

    如果你好奇于 Cake 如何在这些表中保存树的数据，请继续往下阅读数据库中树的遍
    历。访问控制列表(ACL)组件用 CakePHP 的:doc:`/core-libraries/behaviors/tree`
    来管理树的继承。访问控制列表(ACL)的模型类文件可在``lib/Cake/Model/``目录中
    找到。

现在我们全部设置好了，让我们来着手创建一些访问请求对象(ARO)和访问控制对象(ACO)
树吧。

创建访问请求对象(ARO)和访问控制对象(ACO)
------------------------------------------------------------------------

在创建新的访问控制列表(ACL)对象(访问控制对象(ACO)和访问请求对象(ARO))时，请注
意有两种主要的方法命名和访问节点。*第一种*方法是给出模型名称和外键值来直接把
一个访问控制列表(ACL)对象和一条数据库记录联系起来。*第二种*方法可用于当对象与
数据库中的记录没有直接联系的情况——你可以为对象提供一个文字性的别名。

.. note::

    通常，当你创建一个组或者高级别的对象时，请使用别名。如果你管理数据库中某
    一项或某一条记录的权限，请使用模型/外键的方法。

你应当用核心的 CakePHP 访问控制列表(ACL)模型来创建新的访问控制列表(ACL)对象。
这时，有一些字段你应当用于保存数据: ``model``，``foreign_key``，``alias``和
``parent_id``。

访问控制列表(ACL)对象的``model``和``foreign_key``字段让你可以把(ACL)对象和相
应的模型记录(如果有的话)联系起来。例如，许多访问请求对象(ARO)会在数据库中有
相应的用户(User)记录。把访问请求对象(ARO)的``foreign_key``设置为用户(User)的 
ID，让你可以用一个用户(User)模型的 find() 调用就把访问请求对象(ARO)和用户
(User)信息联系在一起，如果你设置了正确的模型关联的话。反过来，如果你要管理某
个博客帖子或菜谱列表的编辑操作，你可以把访问控制列表(ACO)对象和该模型记录联
系起来。

访问控制列表(ACL)对象的``alias``字段只是一个人类可读的标签，让你可以用来标识
一个与模型记录没有直接关联的访问控制列表(ACL)对象。别名(*Alias*)通常用于命名
用户组或者访问控制对象(ACO)集合。

访问控制列表(ACL)对象的``parent_id``字段让你可以填充树形结构。提供在树中父节
点的 ID，来创建一个新的子节点。

在我们能够创建新的访问控制列表(ACL)对象之前，我们需要加载它们相应的类。最容
易的办法是在你控制器的 $components 数组中包括 Cake 的 访问控制列表(ACL)组件:

::

    public $components = array('Acl');

做完这件事之后，让我们来看看一些创建这些对象的例子。下面的代码可以放在控制器动
作里面的某个地方:

.. note::

    尽管这里的例子专注于访问请求对象(ARO)的创建，同样的技术也可用于创建访问控
    制对象(ACO)树。

继续我们魔戒团队的建设，让我们先建立访问请求对象(ARO)组。因为这些组不会真有相
应的(数据库)记录，我们会用别名来创建这些访问控制列表(ACL)对象。我们这里做的是
出于控制器动作的角度，但也可以在其它地方进行。我们这里介绍的有点儿不够真实，
不过运用这些技术来及时创建访问请求对象(ARO)和访问控制对象(ACO)对象，应该对你
完全不是问题。

这应该不是完全陌生的——我们只不过象我们一直在做的，用模型来保存数据而已:

::

    public function any_action() {
        $aro = $this->Acl->Aro;

        // 下面是所有组的信息，放在数组里就可以遍历
        $groups = array(
            0 => array(
                'alias' => 'warriors'
            ),
            1 => array(
                'alias' => 'wizards'
            ),
            2 => array(
                'alias' => 'hobbits'
            ),
            3 => array(
                'alias' => 'visitors'
            ),
        );

        // 遍历并创建访问请求对象(ARO)组
        foreach ($groups as $data) {
            // 记得在循环中保存时要调用 create()...
            $aro->create();

            // 保存数据
            $aro->save($data);
        }

        // 其它动作逻辑在下面...
    }

一旦把它们保存好了，就可以用访问控制列表(ACL)命令行程序来验证树的结构。

::

    $ cake acl view aro

    Aro tree:
    ---------------------------------------------------------------
      [1]warriors

      [2]wizards

      [3]hobbits

      [4]visitors

    ---------------------------------------------------------------

我想现在这还不象是一棵树，但起码我们证实我们有了四个顶层的节点。让我们为这些访问
请求对象(ARO)节点加一些子节点，在这些组下面加入用户 访问请求对象(ARO)吧。每个中
土的良民在我们的新系统中都有一个账号，所以我们会把这些访问请求对象(ARO)记录与我
们数据库中的模型记录挂钩。

.. note::

    在向树中增加子节点时，确保使用访问控制列表(ACL)节点的 ID，而不是 foreign\_key 
    的值。

::

    public function any_action() {
        $aro = new Aro();

        // 这里是用户记录，可与新的 ARO 记录挂钩。
        // 该数据可来自模型并被修改，不过我们在这里出于演示的目的使用静态数组。

        $users = array(
            0 => array(
                'alias' => 'Aragorn',
                'parent_id' => 1,
                'model' => 'User',
                'foreign_key' => 2356,
            ),
            1 => array(
                'alias' => 'Legolas',
                'parent_id' => 1,
                'model' => 'User',
                'foreign_key' => 6342,
            ),
            2 => array(
                'alias' => 'Gimli',
                'parent_id' => 1,
                'model' => 'User',
                'foreign_key' => 1564,
            ),
            3 => array(
                'alias' => 'Gandalf',
                'parent_id' => 2,
                'model' => 'User',
                'foreign_key' => 7419,
            ),
            4 => array(
                'alias' => 'Frodo',
                'parent_id' => 3,
                'model' => 'User',
                'foreign_key' => 7451,
            ),
            5 => array(
                'alias' => 'Bilbo',
                'parent_id' => 3,
                'model' => 'User',
                'foreign_key' => 5126,
            ),
            6 => array(
                'alias' => 'Merry',
                'parent_id' => 3,
                'model' => 'User',
                'foreign_key' => 5144,
            ),
            7 => array(
                'alias' => 'Pippin',
                'parent_id' => 3,
                'model' => 'User',
                'foreign_key' => 1211,
            ),
            8 => array(
                'alias' => 'Gollum',
                'parent_id' => 4,
                'model' => 'User',
                'foreign_key' => 1337,
            ),
        );

        // 遍历并创建 ARO 对象(作为子节点)
        foreach ($users as $data) {
            // 在循环中保存，记得调用 create()...
            $aro->create();

            // 保存数据 Save data
            $aro->save($data);
        }

        // 其它动作逻辑...
    }

.. note::

    通常你不会既提供别名(alias)又提供模型/外键(foreign\_key)，不过我们在这里出
    于演示的目的两者都使用，从而使树的结构更易读。

现在那个命令行应用程序命令的输出更加有趣了。让我们来试一下:

::

    $ cake acl view aro

    Aro tree:
    ---------------------------------------------------------------
      [1]warriors

        [5]Aragorn

        [6]Legolas

        [7]Gimli

      [2]wizards

        [8]Gandalf

      [3]hobbits

        [9]Frodo

        [10]Bilbo

        [11]Merry

        [12]Pippin

      [4]visitors

        [13]Gollum

    ---------------------------------------------------------------

至此我们正确建立了访问请求对象(ARO)树，让我们来讨论一下构建访问控制对象(ACO)树
的一种可能的方法。尽管我们能够建立访问控制对象(ACO)的更加抽象的表示方法，(但是)
经常更加实际的做法是根据 Cake 的控制器/动作的设置来建立访问控制对象(ACO)树的模
型。在这个魔戒团队的场景中我们要处理五个主要的对象，这在 Cake 应用程序中自然的
设置是一组模型，而最终是操控它们的控制器。控制器后面，我们想要控制这些控制器的
特定动作的访问。

基于这样的想法，让我们仿照 Cake 应用程序的设置，来建立访问控制对象(ACO)树。由
于我们有五种访问控制对象(ACO)对象，我们要创建的访问控制对象(ACO)树最终看起来
会象下面这样:


-  武器(Weapons)
-  魔戒(Rings)
-  肉食(PorkChops)
-  外交文件(DiplomaticEfforts)
-  麦芽酒(Ales)


Cake 访问控制列表(ACL)设置的一个好处是，每个访问控制对象(ACO)对象自动带有与 
CRUD 动作(创建，读取，更新和删除)相关的四个属性。你可以在五个主要访问控制对象
(ACO)之下创建子节点，但使用 Cake 内置的动作管理涵盖了对一个给定对象的基本 CRUD 
操作。记住这一点会使你的访问控制对象(ACO)树更小、更易于维护。以后到我们讨论如
何分配权限时，就可以看到这些如何使用了。

既然你现在已经精通于添加访问请求对象(ARO)对象，那就用同样的技术来创建这个访问
控制对象(ACO)树吧。使用核心的 Aco 模型来创建这些上层的组。

分配权限
---------------------

创建了访问控制对象(ACO)和访问请求对象(ARO)对象之后，我们终于可以在这两个组之间
分配权限了。这要使用 Cake 的核心 Acl 组件。让我们继续我们之前的例子。

下面我们会在一个控制器动作之内进行，这是因为权限是用 Acl 组件管理的。

::

    class SomethingsController extends AppController {
        // 你也许会想把它放在 AppController 中，但放在这里也很好。

        public $components = array('Acl');

    }

让我们在这个控制器的一个动作中用 AclComponent 来建立一些基本的权限。

::

    public function index() {
        // 给战士(warriors)对武器(weapons)完全的权限
        // 这两个例子都使用别名的语法
        $this->Acl->allow('warriors', 'Weapons');

        // 然而国王也许不想给每个人不受控制的权限
        $this->Acl->deny('warriors/Legolas', 'Weapons', 'delete');
        $this->Acl->deny('warriors/Gimli',   'Weapons', 'delete');

        die(print_r('done', 1));
    }

我们对 AclComponent 组件的第一次调用，允许 'warriors' 访问请求对象(ARO)组里面
的任何用户，对 'Weapons' 访问控制对象(ACO)组里面的任何东西，有完全的权限。这
里我们只是用别名来界定访问控制对象(ACO)和访问请求对象(ARO)对象。

注意到第三个参数的用法了吗？我们就是这样使用所有 Cake 访问控制对象(ACO)对象内
置的顺手的动作的。这个参数缺省的选项是``create``，``read``，``update``和
``delete``，但是你可以在数据库表``aros_acos``中增加一列(前缀用\_——例如
``_admin``)，然后把它和缺省值一起使用。

第二组调用试图设置更细微颗粒的权限。我们要保持阿拉贡(Aragorn)完全的权限，但防
止该组里的其他战士(warriors)删除武器(Weapon)记录。以上我们使用别名的语法来界
定访问请求对象(ARO)对象，但你也许想要使用模型/外键的语法。我们上面所写的等同
于这样:

::

    // 6342 = Legolas
    // 1564 = Gimli

    $this->Acl->deny(array('model' => 'User', 'foreign_key' => 6342), 'Weapons', 'delete');
    $this->Acl->deny(array('model' => 'User', 'foreign_key' => 1564), 'Weapons', 'delete');

.. note::

    用别名的语法来界定一个节点使用斜线分隔的字符串(
    '/users/employees/developers')。使用模型/外键的语法来界定节点使用带有两个
    参数的数组: ``array('model' => 'User', 'foreign_key' => 8282)``。

下一节会帮助我们验证我们所做的设置，使用 AclComponent 组件来验证我们刚刚建立
的权限。

.. _checking-permissions:

检查权限: ACL 组件
---------------------------------------

让我们用 AclComponent 组件来确保矮人(dwarves)和精灵(elves)无法从武器库中去掉任
何东西。现在我们可以用 AclComponent 组件来检查一下我们创建的访问控制对象(ACO)
和访问请求对象(ARO)对象了。检查权限的基本语法是:

::

    $this->Acl->check($aro, $aco, $action = '*');

让我们在控制器动作里面试一下:

::

    public function index() {
        // 这些都返回 true:
        $this->Acl->check('warriors/Aragorn', 'Weapons');
        $this->Acl->check('warriors/Aragorn', 'Weapons', 'create');
        $this->Acl->check('warriors/Aragorn', 'Weapons', 'read');
        $this->Acl->check('warriors/Aragorn', 'Weapons', 'update');
        $this->Acl->check('warriors/Aragorn', 'Weapons', 'delete');

        // 记得我们可以对我们的用户 ARO 对象使用模型/id 语法
        $this->Acl->check(array('User' => array('id' => 2356)), 'Weapons');

        // 这些也返回 true:
        $result = $this->Acl->check('warriors/Legolas', 'Weapons', 'create');
        $result = $this->Acl->check('warriors/Gimli', 'Weapons', 'read');

        // 但这些返回 false:
        $result = $this->Acl->check('warriors/Legolas', 'Weapons', 'delete');
        $result = $this->Acl->check('warriors/Gimli', 'Weapons', 'delete');
    }

这里的用法只是演示性的，不过希望你能明白这样的检查可以用来决定是否允许某事发生、
显示错误信息、或者使用户跳转到登录页面。


.. meta::
    :title lang=zh_CN: Access Control Lists
    :keywords lang=zh_CN: fantasy novel,access control list,request objects,online diary,request object,acls,adventurers,gandalf,lingo,web service,computer system,grandma,lord of the rings,entities,assets,logic,cakephp,stuff,control objects,control object