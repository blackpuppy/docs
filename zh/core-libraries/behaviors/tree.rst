树行为
######

.. php:class:: TreeBehavior()

把层次结构的数据保存在数据库表中，这是相当常见的需求。这样的例子有有无限子类的分类，多级菜单系统的数据，或者层级的文字表示，比如在访问控制列表中用于保存访问控制对象。

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

修改数据，和添加数据一样，是透明的。如果你改了一些东西，但是没有改 parent\_id 字段——数据的结构就会保持不变。例如::
Modifying data is as transparent as adding new data. If you modify
something, but do not change the parent\_id field - the structure
of your data will remain unchanged. For example::

    // 控制器伪代码 pseudo controller code
    $this->Category->id = 5; // id of Extreme knitting
    $this->Category->save(array('name' => 'Extreme fishing'));

上面的代码没有改变 parent\_id 字段——就算 parent\_id 字段也包括在传给 save 方法的数组中，只要值不变，结构也不会变化。所以数据树现在应该是这样:
The above code did not affect the parent\_id field - even if the
parent\_id is included in the data that is passed to save if the
value doesn't change, neither does the data structure. Therefore
the tree of data would now look like:


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

在树中移动数据也是一件简单的事情。比如说， Extreme fishing 不属于 Sport 类别，而是应该在 Other People's Categories 之下。用下面的代码::
Moving data around in your tree is also a simple affair. Let's say
that Extreme fishing does not belong under Sport, but instead
should be located under Other People's Categories. With the
following code::

    // 控制器伪代码 pseudo controller code
    $this->Category->id = 5; // id of Extreme fishing
    $newParentId = $this->Category->field('id', array('name' => 'Other People\'s Categories'));
    $this->Category->save(array('parent_id' => $newParentId));

结构就会如愿变为:
As would be expected the structure would be modified to:


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
Deleting data
-------------

树行为提供了若干种方法来删除数据。从最简单的例子开始；比如说 reports 不需要了。要删除它*以及它所包含的任何子节点*，只需象任何模型一样调用 delete 方法。例如用下面的代码::
The tree behavior provides a number of ways to manage deleting
data. To start with the simplest example; let's say that the
reports category is no longer useful. To remove it
*and any children it may have* just call delete as you would for
any model. For example with the following code::

    // 控制器伪代码 pseudo controller code
    $this->Category->id = 10;
    $this->Category->delete();

类别树会变成下面这样:
The category tree would be modified as follows:


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
Querying and using your data
----------------------------

使用和操作层次化的数据，可能是一件棘手的事。除了核心的 find 方法，树行为带来一些与树有关的方法，供你使用。
Using and manipulating hierarchical data can be a tricky business.
In addition to the core find methods, with the tree behavior there
are a few more tree-orientated permutations at your disposal.

.. note::

    大部分树行为的方法返回并依赖于以``lft``字段排序的数据。如果你调用``find()``却没有用``lft``字段排序，或者调用树行为的方法并传入排列顺序，你可能会得到意想不到的结果。
    Most tree behavior methods return and rely on data being sorted by
    the ``lft`` field. If you call ``find()`` and do not order by
    ``lft``, or call a tree behavior method and pass a sort order, you
    may get undesirable results.


.. php:class:: TreeBehavior

    .. php:method:: children($id = null, $direct = false, $fields = null, $order = null, $limit = null, $page = 1, $recursive = null)

    :param $id: 要查找的记录的 ID 标识 The ID of the record to look up
    :param $direct: 设置为 true，返回直接的字节点 Set to true to return only the direct descendants
    :param $fields: 单个字段名字符串，或者字段名数组，指明返回值中要包括的字段 Single string field name or array of fields to include in the return
    :param $order: ORDER BY 条件的 SQL 字符串 SQL string of ORDER BY conditions
    :param $limit: SQL LIMIT 语句 SQL LIMIT statement
    :param $page: 获得分页结果 for accessing paged results
    :param $recursive: 关联模型要关联的深度 Number of levels deep for recursive associated Models

    ``children``方法接受一条记录行的主键值(id)并返回子节点记录，缺省情况下以它们在树中出现的次序排序。第二个可选参数决定是否只返回直接的子节点。用前面例子中的数据::
    The ``children`` method takes the primary key value (the id) of a
    row and returns the children, by default in the order they appear
    in the tree. The second optional parameter defines whether or not
    only direct children should be returned. Using the example data
    from the previous section::

        $allChildren = $this->Category->children(1); // 含有11项的一维数组 a flat array with 11 items
        // -- 或者 or --
        $this->Category->id = 1;
        $allChildren = $this->Category->children(); // 含有11项的一维数组 a flat array with 11 items

        // 只返回直接的子节点 Only return direct children
        $directChildren = $this->Category->children(1, true); // 含有2项的一维数组 a flat array with 2 items

    .. note::

        如果你要一个嵌套的数组，请用 ``find('threaded')``
        If you want a recursive array use ``find('threaded')``

    .. php:method:: childCount($id = null, $direct = false)

    和``children``方法一样，``childCount``方法接受一行的主键值(id)，返回它的子记录数目。
    第二个可选参数决定是否只对直接的子记录计数。使用前面例子中的数据::
    As with the method ``children``, ``childCount`` takes the primary
    key value (the id) of a row and returns how many children it has.
    The second optional parameter defines whether or not only direct
    children are counted. Using the example data from the previous
    section::

        $totalChildren = $this->Category->childCount(1); // 会输出11 will output 11
        // -- 或者 or --
        $this->Category->id = 1;
        $directChildren = $this->Category->childCount(); // 会输出11 will output 11

        // 只对这个类别直接的子类进行计数 Only counts the direct descendants of this category
        $numChildren = $this->Category->childCount(1, true); // 会输出2 will output 2

    .. php:method:: generateTreeList ($conditions=null, $keyPath=null, $valuePath=null, $spacer= '_', $recursive=null)

    :param $conditions: 使用与同样的选项。 Uses the same conditional options as find().
    :param $keyPath: 用作键(key)的字段的路径。 Path to the field to use for the key.
    :param $valuePath: 用作标签(label)的字段的路径。 Path to the field to use for the label.
    :param $spacer: 在每一项之前用来标明路径的字符串。The string to use in front of each item to indicate depth.
    :param $recursive: 读取关联记录的深度的层数。The number of levels deep to fetch associated records

    这个返回的数据与方法:ref:`model-find-list`类似，有一个缩进的前缀来标明数据的结构。下面的例子中你能可以看到这个方法返回怎样的结果::
    This method will return data similar to
    :ref:`model-find-list`, with an indented prefix
    to show the structure of your data. Below is an example of what you
    can expect this method to return::

      $treelist = $this->Category->generateTreeList();

    输出:: Output::

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

    这个提供方便的方法，正如名字所说，返回任何节点的父节点，或者如果节点没有父节点(如果是)就返回*false*。例如::
    This convenience function will, as the name suggests, return the
    parent node for any node, or *false* if the node has no parent (it's
    the root node). For example::

        $parent = $this->Category->getParentNode(2); //<- fun 的 id id for fun
        // $parent 含有 All categories $parent contains All categories

    .. php:method:: getPath( $id = null, $fields = null, $recursive = null )

    在涉及层次性的数据时，'path'是指从你当前的位置到达顶点的路径。所以类别 "International"的路径是:
    The 'path' when referring to hierarchal data is how you get from
    where you are to the top. So for example the path from the category
    "International" is:


    -  My Categories

     -  ...
     -  Work

        -  Trips

           -  ...
           -  International




    使用"International"的id，getPath 方法会依次返回每一个父节点(从最上面开始)。::
    Using the id of "International" getPath will return each of the
    parents in turn (starting from the top).::

        $parents = $this->Category->getPath(15);

    ::

      // $parents 的内容 contents of $parents
      array(
          [0] =>  array('Category' => array('id' => 1, 'name' => 'My Categories', ..)),
          [1] =>  array('Category' => array('id' => 9, 'name' => 'Work', ..)),
          [2] =>  array('Category' => array('id' => 13, 'name' => 'Trips', ..)),
          [3] =>  array('Category' => array('id' => 15, 'name' => 'International', ..)),
      )


高级用法
Advanced Usage
==============

    树行为并非只在后台起作用，有些在这个行为中定义的方法，照顾到了你对层次性数据的所有需求，以及可能在此过程中发生的意料之外的问题。
    The tree behavior doesn't only work in the background, there are a
    number of specific methods defined in the behavior to cater for all
    your hierarchical data needs, and any unexpected problems that
    might arise in the process.

    .. php:method:: moveDown()

    把一个节点在树中向下移动。你需要提供要移动的节点的 ID，以及移动多少个位置的正数。给定节点的所有子节点也会一起移动。
    Used to move a single node down the tree. You need to provide the
    ID of the element to be moved and a positive number of how many
    positions the node should be moved down. All child nodes for the
    specified node will also be moved.

    下面是一个控制器动作的例子(在 Categories 控制器中)，在树中向下移动指定节点::
    Here is an example of a controller action (in a controller named
    Categories) that moves a specified node down the tree::

        public function movedown($id = null, $delta = null) {
            $this->Category->id = $id;
            if (!$this->Category->exists()) {
               throw new NotFoundException(__('Invalid category'));
            }

            if ($delta > 0) {
                $this->Category->moveDown($this->Category->id, abs($delta));
            } else {
                $this->Session->setFlash('请提供该节点要下移位置的数目。Please provide the number of positions the field should be moved down.');
            }

            $this->redirect(array('action' => 'index'), null, true);
        }

    例如，如果你要把类别"Sport"(id 为3)向下移动一个位置，你应当请求: /categories/movedown/3/1。
    For example, if you'd like to move the "Sport" ( id of 3 ) category one
    position down, you would request: /categories/movedown/3/1.

    .. php:method:: moveUp()

    把一个节点在树中向上移动。你需要提供要移动的节点的 ID，以及移动多少个位置的正数。给定节点的所有子节点也会一起移动。
    Used to move a single node up the tree. You need to provide the ID
    of the element to be moved and a positive number of how many
    positions the node should be moved up. All child nodes will also be
    moved.

    下面是控制器动作的一个例子(在 Categories 控制器中)，在树中向上移动一个节点::
    Here's an example of a controller action (in a controller named
    Categories) that moves a node up the tree::

        public function moveup($id = null, $delta = null) {
            $this->Category->id = $id;
            if (!$this->Category->exists()) {
               throw new NotFoundException(__('Invalid category'));
            }

            if ($delta > 0) {
                $this->Category->moveUp($this->Category->id, abs($delta));
            } else {
                $this->Session->setFlash('Please provide a number of positions the category should be moved up.');
            }

            $this->redirect(array('action' => 'index'), null, true);
        }

    例如，如果你要把类别"Gwendolyn"(id 为8)向上移动一个位置，你应当请求 /categories/moveup/8/1。现在朋友(Friends)的顺序为 Gwendolyn，Gerald。
    For example, if you would like to move the category "Gwendolyn" ( id of 8 ) up
    one position you would request /categories/moveup/8/1. Now
    the order of Friends will be Gwendolyn, Gerald.

    .. php:method:: removeFromTree($id = null, $delete = false)

    使用这个方法，会删除或者移动一个节点，但是会保留其子树，并把子树重新定位到上一级节点之下。这个方法比:ref:`model-delete`方法提供了更多的控制，后者对于使用树行为的模型会把指定的节点和所有的子节点都删除。
    Using this method will either delete or move a node but retain its
    sub-tree, which will be reparented one level higher. It offers more
    control than :ref:`model-delete`, which for a model
    using the tree behavior will remove the specified node and all of
    its children.

    以下面的树作为其实状态:
    Taking the following tree as a starting point:


    -  My Categories

       -  Fun

          -  Sport

             -  Surfing
             -  Extreme knitting
             -  Skating




    用'Sport'的 id 来允许下面的代码::
    Running the following code with the id for 'Sport'::

        $this->Node->removeFromTree($id);

    Sport 节点就会变成一个顶层节点:
    The Sport node will be become a top level node:


    -  My Categories

       -  Fun

          -  Surfing
          -  Extreme knitting
          -  Skating


    -  Sport **Moved**

    这展示了``removeFromTree``方法的缺省行为，移动节点到没有父节点的位置，并把所有子节点重新定位。
    This demonstrates the default behavior of ``removeFromTree`` of
    moving the node to have no parent, and re-parenting all children.

    不过，如果用'Sport'的 id 来允许下面的代码::
    If however the following code snippet was used with the id for
    'Sport'::

        $this->Node->removeFromTree($id, true);

    The tree would become


    -  My Categories

       -  Fun

          -  Surfing
          -  Extreme knitting
          -  Skating



    这说明了``removeFromTree``方法的另一种用法，子节点被重新定位，而'Sport'被删除了。
    This demonstrates the alternate use for ``removeFromTree``, the
    children have been reparented and 'Sport' has been deleted.

    .. php:method:: reorder(array('id' => null, 'field' => $Model->displayField, 'order' => 'ASC', 'verify' => true))

    根据参数中指定的字段和方向把树的重新排序。节点(及子节点)。这个方法不会改变任何节点的父节点。:
    Reorders the nodes (and child nodes) of the tree according to the
    field and direction specified in the parameters. This method does
    not change the parent of any node.::

        $model->reorder(array(
            'id' => ,    // 作为重新排序的顶层节点的记录的id，缺省值: $Model->id id of record to use as top node for reordering, default: $Model->id
            'field' => , // 哪个字段用于重新排序，缺省值: $Model->displayField which field to use in reordering, default: $Model->displayField
            'order' => , // 排序的方向，缺省值: 'ASC' direction to order, default: 'ASC'
            'verify' =>  // 在重新排序前是否验证树，缺省值: true whether or not to verify the tree before reorder, default: true
        ));

    .. note::

        如果你保存了数据或者在模型上做了其它操作，你也许想要在调用重新排序前设置``$model->id = null``。否则只有当前节点和它的子节点会被重新排序。
        If you have saved your data or made other operations on the model,
        you might want to set ``$model->id = null`` before calling
        ``reorder``. Otherwise only the current node and it's children will
        be reordered.

数据一致性
Data Integrity
==============

    鉴于象树和链表这样复杂的自引用数据结构的性质，它们偶尔会由于一个不经心的调用而受损。别担心，一切都没有丢失。树行为有几个之前没有在文档中说明的特性，设计用来从这种情况下恢复。
    Due to the nature of complex self referential data structures such
    as trees and linked lists, they can occasionally become broken by a
    careless call. Take heart, for all is not lost! The Tree Behavior
    contains several previously undocumented features designed to
    recover from such situations.

    .. php:method:: recover($mode = 'parent', $missingParentAction = null)

    ``mode``参数用来指明正确/合法信息的来源。基于信息来源，相反的数据源会被填充。例如，如果 MPTT 字段受损或为空，在``$mode 'parent'``时，``parent_id``字段的值
会被用来填充左和右字段。``missingParentAction``参数只适用于 mode 为"parent"时，决定在 parent 字段含有不存在的 id 时该如何处理。
    The ``mode`` parameter is used to specify the source of info that
    is valid/correct. The opposite source of data will be populated
    based upon that source of info. E.g. if the MPTT fields are corrupt
    or empty, with the ``$mode 'parent'`` the values of the
    ``parent_id`` field will be used to populate the left and right
    fields. The ``missingParentAction`` parameter only applies to
    "parent" mode and determines what to do if the parent field
    contains an id that is not present.

    ``$mode``参数允许的值为:
    Available ``$mode`` options:

    -  ``'parent'`` - 用现存的 ``parent_id`` 来更新 ``lft`` 和 ``rght`` 字段 use the existing ``parent_id``'s to update the
       ``lft`` and ``rght`` fields
    -  ``'tree'`` - 用现存的 ``lft`` 和 ``rght`` 字段来更新 ``parent_id`` use the existing ``lft`` and ``rght`` fields to
       update ``parent_id``

    当``mode='parent'``时，参数``missingParentActions``允许的值为:
    Available ``missingParentActions`` options when using
    ``mode='parent'``:

    -  ``null`` - 不做任何事情，继续 do nothing and carry on
    -  ``'return'`` - 不做任何事情，返回 do nothing and return
    -  ``'delete'`` - 删除该节点 delete the node
    -  ``int`` - 设置 parent\_id 为这个 id set the parent\_id to this id

    例如:: Example::

        // 基于 parent_id 重建左和右字段 Rebuild all the left and right fields based on the parent_id
        $this->Category->recover();
        // 或者 or
        $this->Category->recover('parent');

        // 基于 lft 和 rght 字段重建 parent_id Rebuild all the parent_id's based on the lft and rght fields
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
    Returns ``true`` if the tree is valid otherwise an array of errors,
    with fields for type, incorrect index and message.

    输出数组的没条记录是形式为(type, id, message)的数组
    Each record in the output array is an array of the form (type, id,
    message)

    -  ``type``为``'index'``或者 ``'node'``
       ``type`` is either ``'index'`` or ``'node'``
    -  ``'id'``是错误节点的id
       ``'id'`` is the id of the erroneous node.
    -  ``'message'``取决于错误
       ``'message'`` depends on the error

    使用的例子:: Example Use::

        $this->Category->verify();

    输出的例子::
    Example output::

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