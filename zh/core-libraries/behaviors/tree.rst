树行为
######

.. php:class:: TreeBehavior()

把层次结构的数据保存在数据库表中，这是相当常见的需求。这样的例子有含有无限子类的分类，多级菜单系统的数据，或者层级的文字表示，比如在访问控制列表中用于保存访问控制对象。

对于小的数据树，或者只有几层深度的数据，只需在你的数据库表中增加一个 parent\_id 字段，用来记录谁是谁的父节点。而和 cake 捆绑在一起的，是一个强大的行为，允许你使用`MPTT logic <http://www.sitepoint.com/hierarchical-data-database-2/>`_的好处，而不用操心该技术的细节——除非你想要这么做 ;)。

要求
============

要使用树行为，你的数据库表需要下面3个字段(都是 int 类型):

-  父节点 - 缺省字段名为 parent\_id，来保存父对象的 id。
-  左节点 - 缺省字段名为 lft，用来保存当前行的 lft 值。
-  右节点 - 缺省字段名为 rght，用来保存当前行的 rght 值。

如果你熟悉 MPTT 的逻辑，你可能会奇怪为什么要有一个 parent 字段——很简单，如果有直接的父节点连接保存在数据库中，一些事情就会容易一些——比如查找直属子节点。

.. note::

    ``parent``字段必须允许 NULL！如果你给顶层节点的 parent 字段赋值零，看起来好像可以，但是给树重新排序(可能还有其它操作)就不对了。

基本用法
===========

树行为有很多功能，不过让我们先从一个简单的例子开始——创建下面的数据库表，并放入一些数据::

    CREATE TABLE categories (
        id INTEGER(10) UNSIGNED NOT NULL AUTO_INCREMENT,
        parent_id INTEGER(10) DEFAULT NULL,
        lft INTEGER(10) DEFAULT NULL,
        rght INTEGER(10) DEFAULT NULL,
        name VARCHAR(255) DEFAULT '',
        PRIMARY KEY  (id)
    );

    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(1, 'My Categories', NULL, 1, 30);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(2, 'Fun', 1, 2, 15);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(3, 'Sport', 2, 3, 8);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(4, 'Surfing', 3, 4, 5);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(5, 'Extreme knitting', 3, 6, 7);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(6, 'Friends', 2, 9, 14);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(7, 'Gerald', 6, 10, 11);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(8, 'Gwendolyn', 6, 12, 13);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(9, 'Work', 1, 16, 29);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(10, 'Reports', 9, 17, 22);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(11, 'Annual', 10, 18, 19);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(12, 'Status', 10, 20, 21);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(13, 'Trips', 9, 23, 28);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(14, 'National', 13, 24, 25);
    INSERT INTO `categories` (`id`, `name`, `parent_id`, `lft`, `rght`) VALUES(15, 'International', 13, 26, 27);

为了检查这一切设置正确，我们可以添加一个测试方法，输出类别树的内容，就可以看到它什么样了。只需一个简单的控制器::

    class CategoriesController extends AppController {

        public function index() {
            $data = $this->Category->generateTreeList(null, null, null, '&nbsp;&nbsp;&nbsp;');
            debug($data); die;
        }
    }

以及更简单的模型定义::

    // app/Model/Category.php
    class Category extends AppModel {
        public $actsAs = array('Tree');
    }

我们访问 /categories，就可以看到我们的类别树数据什么样了。你应当看到类似下面这样的:


-  My Categories

   -  Fun

      -  Sport

         -  Surfing
         -  Extreme knitting

      -  Friends

         -  Gerald
         -  Gwendolyn


   -  Work

      -  Reports

         -  Annual
         -  Status

      -  Trips

         -  National
         -  International




添加数据
-----------

在上一节中，我们使用现存的数据，用``generateTreeList``方法看到这是层级的。然而，通常你要以同其它模型完全一样的方式添加数据。例如::

    // 控制器伪代码
    $data['Category']['parent_id'] = 3;
    $data['Category']['name'] = 'Skating';
    $this->Category->save($data);

使用树行为时，应当只需设置 parent\_id，而不必做更多的事情，而树行为会处理剩下的事情。如果你不设置 parent\_id，树行为就会把你新添加的(记录)作为一个新的顶层节点::

    // 控制器伪代码
    $data = array();
    $data['Category']['name'] = 'Other People\'s Categories';
    $this->Category->save($data);

运行上面两段代码，会把你的树改变成下面的样子:


-  My Categories

   -  Fun

      -  Sport

         -  Surfing
         -  Extreme knitting
         -  Skating **New**

      -  Friends

         -  Gerald
         -  Gwendolyn


   -  Work

      -  Reports

         -  Annual
         -  Status

      -  Trips

         -  National
         -  International



-  Other People's Categories **New**

修改数据
--------------

修改数据，和添加新数据一样，是透明的。如果你改了一些东西，但是没有改 parent\_id 字段——数据的结构就会保持不变。例如::

    // 控制器伪代码
    $this->Category->id = 5; // Extreme knitting 的 id
    $this->Category->save(array('name' => 'Extreme fishing'));

上面的代码没有改变 parent\_id 字段——就算 parent\_id 字段也包括在传给 save 方法的数组中，只要值不变，结构也不会变化。所以数据树现在应该是这样:


-  My Categories

-  Fun

 -  Sport

    -  Surfing
    -  Extreme fishing **Updated**
    -  Skating

 -  Friends

    -  Gerald
    -  Gwendolyn


-  Work

 -  Reports

    -  Annual
    -  Status

 -  Trips

    -  National
    -  International



-  Other People's Categories

在树中移动数据也是一件简单的事情。比如说， Extreme fishing 不属于 Sport 类别之下，而是应该在 Other People's Categories 之下。用下面的代码::

    // 控制器伪代码
    $this->Category->id = 5; // Extreme fishing 的 id
    $newParentId = $this->Category->field('id', array('name' => 'Other People\'s Categories'));
    $this->Category->save(array('parent_id' => $newParentId));

结构就会如愿变为:


-  My Categories

 -  Fun

    -  Sport

       -  Surfing
       -  Skating

    -  Friends

       -  Gerald
       -  Gwendolyn


 -  Work

    -  Reports

       -  Annual
       -  Status

    -  Trips

       -  National
       -  International



-  Other People's Categories

 -  Extreme fishing **Moved**


删除数据
-------------

树行为提供了若干种方法来删除数据。从最简单的例子开始；比如说 reports 类别没用了。要删除它*以及它所包含的任何子节点*，只需象任何模型一样调用 delete 方法。例如，用下面的代码::

    // 控制器伪代码
    $this->Category->id = 10;
    $this->Category->delete();

类别树会变成下面这样:


-  My Categories

 -  Fun

    -  Sport

       -  Surfing
       -  Skating

    -  Friends

       -  Gerald
       -  Gwendolyn


 -  Work

    -  Trips

       -  National
       -  International



-  Other People's Categories

 -  Extreme fishing


查询及使用你的数据
----------------------------

使用和操作层次结构的数据，可能是一件棘手的事。除了核心的 find 方法，树行为带来一些与树有关的方法，供你使用。

.. note::

    大部分树行为的方法返回并依赖于以``lft``字段排序的数据。如果你调用``find()``却没有用``lft``字段排序，或者调用树行为的方法并传入排列顺序，你可能会得到意想不到的结果。


.. php:class:: TreeBehavior

    .. php:method:: children($id = null, $direct = false, $fields = null, $order = null, $limit = null, $page = 1, $recursive = null)

    :param $id: 要查找的记录的 ID 标识
    :param $direct: 设置为 true，返回直接的子节点
    :param $fields: 单个字段名字符串，或者字段名数组，指明返回值中要包括的字段
    :param $order: ORDER BY 条件的 SQL 字符串
    :param $limit: SQL LIMIT 语句
    :param $page: 用于分页结果
    :param $recursive: 关联模型要关联的深度

    ``children``方法接受一条记录行的主键值(id)并返回子节点记录，缺省情况下以它们在树中出现的次序排序。第二个可选参数决定是否只返回直属的子节点。用前面例子中的数据::

        $allChildren = $this->Category->children(1); // 含有11项的一维数组
        // -- 或者 --
        $this->Category->id = 1;
        $allChildren = $this->Category->children(); // 含有11项的一维数组

        // 只返回直属的子节点
        $directChildren = $this->Category->children(1, true); // 含有2项的一维数组

    .. note::

        如果你要一个嵌套的数组，请用 ``find('threaded')``

    .. php:method:: childCount($id = null, $direct = false)

    和``children``方法一样，``childCount``方法接受一行记录的主键值(id)，返回它的子记录数目。
    第二个可选参数决定是否只对直属的子记录计数。使用前面例子中的数据::

        $totalChildren = $this->Category->childCount(1); // 会输出11
        // -- 或者 --
        $this->Category->id = 1;
        $directChildren = $this->Category->childCount(); // 会输出11

        // 只对这个类别直属的子类进行计数
        $numChildren = $this->Category->childCount(1, true); // 会输出2

    .. php:method:: generateTreeList ($conditions=null, $keyPath=null, $valuePath=null, $spacer= '_', $recursive=null)

    :param $conditions: 使用 find() 与同样的条件选项。
    :param $keyPath: 用作键(key)的字段的路径。
    :param $valuePath: 用作标签(label)的字段的路径。
    :param $spacer: 在每一项之前用来标明深度的字符串。
    :param $recursive: 读取关联记录深度的层数。

    这个返回的数据与方法:ref:`model-find-list`类似，有一个缩进的前缀来标明数据的结构。下面的例子就是这个方法预料要返回的结果::

      $treelist = $this->Category->generateTreeList();

    输出::

      array(
          [1] =>  "My Categories",
          [2] =>  "_Fun",
          [3] =>  "__Sport",
          [4] =>  "___Surfing",
          [16] => "___Skating",
          [6] =>  "__Friends",
          [7] =>  "___Gerald",
          [8] =>  "___Gwendolyn",
          [9] =>  "_Work",
          [13] => "__Trips",
          [14] => "___National",
          [15] => "___International",
          [17] => "Other People's Categories",
          [5] =>  "_Extreme fishing"
      )

    .. php:method:: getParentNode()

    这个提供方便的方法，正如名字所说，返回任何节点的父节点，或者如果节点没有父节点(就是根节点)就返回*false*。例如::

        $parent = $this->Category->getParentNode(2); //<- fun 的 id
        // $parent 含有 All categories

    .. php:method:: getPath( $id = null, $fields = null, $recursive = null )

    对于层次结构的数据来说，'path'是指从你当前的位置到达顶点的路径。所以类别 "International"的路径是:


    -  My Categories

     -  ...
     -  Work

        -  Trips

           -  ...
           -  International




    使用"International"的 id，getPath 方法会依次返回每一个父节点(从最上面开始)。::

        $parents = $this->Category->getPath(15);

    ::

      // $parents 的内容
      array(
          [0] =>  array('Category' => array('id' => 1, 'name' => 'My Categories', ..)),
          [1] =>  array('Category' => array('id' => 9, 'name' => 'Work', ..)),
          [2] =>  array('Category' => array('id' => 13, 'name' => 'Trips', ..)),
          [3] =>  array('Category' => array('id' => 15, 'name' => 'International', ..)),
      )


高级用法
==============

    树行为并非只在后台起作用，有些在这个行为中定义的方法，照顾到了你对层次结构数据的所有需求，以及可能在此过程中发生的意料之外的问题。

    .. php:method:: moveDown()

    把一个节点在树中向下移动。你需要提供要移动的节点的 ID，以及移动多少个位置的正数。给定节点的所有子节点也会一起移动。

    下面是一个控制器动作的例子(在 Categories 控制器中)，在树中向下移动指定节点::

        public function movedown($id = null, $delta = null) {
            $this->Category->id = $id;
            if (!$this->Category->exists()) {
               throw new NotFoundException(__('Invalid category'));
            }

            if ($delta > 0) {
                $this->Category->moveDown($this->Category->id, abs($delta));
            } else {
                $this->Session->setFlash('请提供该节点要下移位置的数目。');
            }

            $this->redirect(array('action' => 'index'), null, true);
        }

    例如，如果你要把类别"Sport"(id 为3)向下移动一个位置，你应当请求: /categories/movedown/3/1。

    .. php:method:: moveUp()

    把一个节点在树中向上移动。你需要提供要移动~的节点的 ID，以及移动多少个位置的正数。给定节点的所有子节点也会一起移动。

    下面是控制器动作的一个例子(在 Categories 控制器中)，在树中向上移动一个节点::

        public function moveup($id = null, $delta = null) {
            $this->Category->id = $id;
            if (!$this->Category->exists()) {
               throw new NotFoundException(__('Invalid category'));
            }

            if ($delta > 0) {
                $this->Category->moveUp($this->Category->id, abs($delta));
            } else {
                $this->Session->setFlash('请提供该节点要上移位置的数目。');
            }

            $this->redirect(array('action' => 'index'), null, true);
        }

    例如，如果你要把类别"Gwendolyn"(id 为8)向上移动一个位置，你应当请求 /categories/moveup/8/1。现在朋友(Friends)的顺序为 Gwendolyn，Gerald。

    .. php:method:: removeFromTree($id = null, $delete = false)

    使用这个方法，会删除或者移动一个节点，但是会保留其子树，并把子树重新定位到上一级节点之下。这个方法比:ref:`model-delete`方法提供了更多的控制，后者对于使用树行为的模型会把指定的节点和所有的子节点都删除。

    以下面的树作为起始状态:
    Taking the following tree as a starting point:


    -  My Categories

       -  Fun

          -  Sport

             -  Surfing
             -  Extreme knitting
             -  Skating




    用'Sport'的 id 来运行下面的代码::

        $this->Node->removeFromTree($id);

    Sport 节点就会变成一个顶层节点:


    -  My Categories

       -  Fun

          -  Surfing
          -  Extreme knitting
          -  Skating


    -  Sport **Moved**

    这展示了``removeFromTree``方法的缺省行为，移动节点到没有父节点的位置，并把所有子节点重新定位。

    不过，如果用'Sport'的 id 来运行下面的代码::

        $this->Node->removeFromTree($id, true);

    树就会变成


    -  My Categories

       -  Fun

          -  Surfing
          -  Extreme knitting
          -  Skating



    这说明了``removeFromTree``方法的另一种用法，子节点被重新定位，而'Sport'被删除了。

    .. php:method:: reorder(array('id' => null, 'field' => $Model->displayField, 'order' => 'ASC', 'verify' => true))

    根据参数中指定的字段和方向把树的节点重新排序。节点(及子节点)。这个方法不会改变任何节点的父节点。:

        $model->reorder(array(
            'id' => ,    // 作为重新排序的顶层节点记录的id，缺省值: $Model->id
            'field' => , // 哪个字段用于重新排序，缺省值: $Model->displayField
            'order' => , // 排序的方向，缺省值: 'ASC'
            'verify' =>  // 在重新排序前是否验证树，缺省值: true
        ));

    .. note::

        如果你保存了数据或者在模型上做了其它操作，你也许想要在调用 ``reorder`` 方法前设置``$model->id = null``。否则只有当前节点和它的子节点会被重新排序。

数据一致性
==============

    鉴于象树和链表这样复杂的自引用数据结构的性质，它们偶尔会由于一个不经心的调用而受损。别担心，一切都没有丢失！树行为有几个之前没有在文档中说明的特性，设计用来从这种情况下恢复。

    .. php:method:: recover($mode = 'parent', $missingParentAction = null)

    ``mode``参数用来指明正确/合法信息的来源。根据信息来源，相反的数据源会被填充。例如，如果 MPTT 字段受损或为空，在``$mode 'parent'``时，``parent_id``字段的值
会被用来填充左和右字段。``missingParentAction``参数只适用于 mode 为"parent"时，决定在 parent 字段含有不存在的 id 时该如何处理。

    ``$mode``参数允许的值为:

    -  ``'parent'`` - 用现有的 ``parent_id`` 来更新 ``lft`` 和 ``rght`` 字段
    -  ``'tree'`` - 用现有的 ``lft`` 和 ``rght`` 字段来更新 ``parent_id``

    当``mode='parent'``时，参数``missingParentActions``允许的值为:

    -  ``null`` - 不做任何事情，继续
    -  ``'return'`` - 不做任何事情，返回
    -  ``'delete'`` - 删除该节点
    -  ``int`` - 设置 parent\_id 为这个 id

    例如::

        // 基于 parent_id 重建所有左和右字段
        $this->Category->recover();
        // 或者
        $this->Category->recover('parent');

        // 基于 lft 和 rght 字段重建所有 parent_id
        $this->Category->recover('tree');


    .. php:method:: reorder($options = array())

    
    Reorders the nodes (and child nodes) of the tree according to the
    field and direction specified in the parameters. This method does
    not change the parent of any node.

    Reordering affects all nodes in the tree by default, however the
    following options can affect the process:

    -  ``'id'`` - only reorder nodes below this node.
    -  ``'field``' - field to use for sorting, default is the
       ``displayField`` for the model.
    -  ``'order'`` - ``'ASC'`` for ascending, ``'DESC'`` for descending
       sort.
    -  ``'verify'`` - whether or not to verify the tree prior to
       resorting.

    ``$options`` is used to pass all extra parameters, and has the
    following possible keys by default, all of which are optional::

        array(
            'id' => null,
            'field' => $model->displayField,
            'order' => 'ASC',
            'verify' => true
        )


    .. php:method:: verify()

    如果树是正确的就返回``true``，否则就返回一个错误数组，数组的字段为类型(type)，错误的索引和消息。

    输出数组的每条记录是格式为(type, id, message)的数组

    -  ``type``为``'index'``或者 ``'node'``
    -  ``'id'``是错误节点的id。
    -  ``'message'``取决于错误

    使用的例子::

        $this->Category->verify();

    输出的例子::

        Array
        (
            [0] => Array
                (
                    [0] => node
                    [1] => 3
                    [2] => left and right values identical
                )
            [1] => Array
                (
                    [0] => node
                    [1] => 2
                    [2] => The parent node 999 doesn't exist
                )
            [10] => Array
                (
                    [0] => index
                    [1] => 123
                    [2] => missing
                )
            [99] => Array
                (
                    [0] => node
                    [1] => 163
                    [2] => left greater than right
                )

        )



.. meta::
    :title lang=en: Tree
    :keywords lang=en: auto increment,literal representation,parent id,table categories,database table,hierarchical data,null value,menu system,intricacies,access control,hierarchy,logic,elements,trees