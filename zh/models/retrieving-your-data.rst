检索数据
####################

如前所述，模型层扮演的是从不同的存储中获取数据的角色。 
CakePHP的模型类拥有很多功能，具有搜索数据，排序，分页并且进行过滤。
最常用的功能是find()方法。 :php:meth:`Model::find()`

.. _model-find:

find
====

``find(string $type = 'first', array $params = array())``

find是所有检索数据方法中使用最普遍。 
``$type``参数值可以是 ``'all'``, ``'first'``, ``'count'``, ``'list'``,
``'neighbors'`` 或 ``'threaded'`` 或者任何自定义查询类型。
切记 ``$type``是大小写敏感的。使用大写字母
(如 ``All``) 将得不到期望的结果。

``$params`` 用于向find方法传递各种查询参数，其默认有如下的键值 - 每一个都是可选的。 ::

    array(
        'conditions' => array('Model.field' => $thisValue), //包含查询条件的数组
        'recursive' => 1, //int整型
        'fields' => array('Model.field1', 'DISTINCT Model.field2'), //包含字段名的数组
        'order' => array('Model.created', 'Model.field3 DESC'), //字符串或数组
        'group' => array('Model.field'), //将字段GROUP BY
        'limit' => n, //int整型
        'page' => n, //int整型
        'offset' => n, //int整型
        'callbacks' => true /其他值可以是 false, 'before', 'after'
    )

也可以添加和使用其它的参数，如查找类型、行为或自己定义的模型方法。


.. _model-find-first:

find('first')
=============

``find('first', $params)`` 只返回一条记录。以下是几个简单的（控制器代码）实例。
::

    public function some_function() {
        // ...
        $semiRandomArticle = $this->Article->find('first');
        $lastCreated = $this->Article->find('first', array(
            'order' => array('Article.created' => 'desc')
        ));
        $specificallyThisOne = $this->Article->find('first', array(
            'conditions' => array('Article.id' => 1)
        ));
        // ...
    }

在第一个示例中，没有向 find 传递任何参数 - 所以没有任何条件和排序。
这种形式的 ``find('first')`` 调用返回的格式如下。 ::

    Array
    (
        [ModelName] => Array
            (
                [id] => 83
                [field1] => value1
                [field2] => value2
                [field3] => value3
            )

        [AssociatedModelName] => Array
            (
                [id] => 1
                [field1] => value1
                [field2] => value2
                [field3] => value3
            )
    )

.. _model-find-count:

find('count')
=============

``find('count', $params)`` 返回一个整数值。以下是几个简单的（控制器代码）实例。 ::

    public function some_function() {
        // ...
        $total = $this->Article->find('count');
        $pending = $this->Article->find('count', array(
            'conditions' => array('Article.status' => 'pending')
        ));
        $authors = $this->Article->User->find('count');
        $publishedAuthors = $this->Article->find('count', array(
           'fields' => 'DISTINCT Article.user_id',
           'conditions' => array('Article.status !=' => 'pending')
        ));
        // ...
    }

.. note::

    不要向 ``find('count')`` 传递 ``fields`` 数组. 只需为DISTINCT count 指定一个字段(其它情况下，计数结果总是相同的 - 仅取决于条件).

.. _model-find-all:

find('all')
===========

``find('all', $params)`` 返回一个(可能是多维)数组。
实际上它是所有的``find()``方法的变体，包括``paginate``分页，下面是一些简单的示例。 ::

    public function some_function() {
        // ...
        $allArticles = $this->Article->find('all');
        $pending = $this->Article->find('all', array(
            'conditions' => array('Article.status' => 'pending')
        ));
        $allAuthors = $this->Article->User->find('all');
        $allPublishedAuthors = $this->Article->User->find('all', array(
            'conditions' => array('Article.status !=' => 'pending')
        ));
        // ...
    }

.. note::

    上面的例子中，``$allAuthors``包含user表的中的每个用户信息。因为没有任何条件,所以将查询所有用户。

``find('all')`` 返回的结果格式如下。 ::

    Array
    (
        [0] => Array
            (
                [ModelName] => Array
                    (
                        [id] => 83
                        [field1] => value1
                        [field2] => value2
                        [field3] => value3
                    )

                [AssociatedModelName] => Array
                    (
                        [id] => 1
                        [field1] => value1
                        [field2] => value2
                        [field3] => value3
                    )

            )
    )

.. _model-find-list:

find('list')
============

``find('list', $params)`` 返回一个索引数组, 在生成类似HTML输入表单中的 select元素的列表时很有用。下面是一些简单的示例。 ::

    public function some_function() {
        // ...
        $allArticles = $this->Article->find('list');
        $pending = $this->Article->find('list', array(
            'conditions' => array('Article.status' => 'pending')
        ));
        $allAuthors = $this->Article->User->find('list');
        $allPublishedAuthors = $this->Article->find('list', array(
            'fields' => array('User.id', 'User.name'),
            'conditions' => array('Article.status !=' => 'pending'),
            'recursive' => 0
        ));
        // ...
    }

.. note::

    同上 ``$allAuthors`` 将包含users表的所有用户

调用 ``find('list')`` 的结果格式如下::

    Array
    (
        //[id] => 'displayValue',
        [1] => 'displayValue1',
        [2] => 'displayValue2',
        [4] => 'displayValue4',
        [5] => 'displayValue5',
        [6] => 'displayValue6',
        [3] => 'displayValue3',
    )

当调用``find('list')``时，传给``fields``的参数用于决定数组的键名和键值以及(可选的)结果的分组。 默认情况下，模型的主键被当作键，显示列当作值（可以在模型的displayField属性中配置 :ref:`model-displayField`）见下面的示例。 ::

    public function some_function() {
        // ...
        $justusernames = $this->Article->User->find('list', array(
            'fields' => array('User.username')
        ));
        $usernameMap = $this->Article->User->find('list', array(
            'fields' => array('User.username', 'User.first_name')
        ));
        $usernameGroups = $this->Article->User->find('list', array(
            'fields' => array('User.username', 'User.first_name', 'User.group')
        ));
        // ...
    }

在上面的例子中，结果变量类似下面这样。 ::


    $justusernames = Array
    (
        //[id] => 'username',
        [213] => 'AD7six',
        [25] => '_psychic_',
        [1] => 'PHPNut',
        [2] => 'gwoo',
        [400] => 'jperras',
    )

    $usernameMap = Array
    (
        //[username] => 'firstname',
        ['AD7six'] => 'Andy',
        ['_psychic_'] => 'John',
        ['PHPNut'] => 'Larry',
        ['gwoo'] => 'Gwoo',
        ['jperras'] => 'Joël',
    )

    $usernameGroups = Array
    (
        ['User'] => Array
        (
            ['PHPNut'] => 'Larry',
            ['gwoo'] => 'Gwoo',
        )

        ['Admin'] => Array
        (
            ['_psychic_'] => 'John',
            ['AD7six'] => 'Andy',
            ['jperras'] => 'Joël',
        )

    )

.. _model-find-threaded:

find('threaded')
================

``find('threaded', $params)`` 返回一个嵌套数组，可以使用模型的``parent_id``字段建立相应的嵌套结果。下面是几个简单的（控制器代码）示例::

    public function some_function() {
        // ...
        $allCategories = $this->Category->find('threaded');
        $comments = $this->Comment->find('threaded', array(
            'conditions' => array('article_id' => 50)
        ));
        // ...
    }

.. tip::

    处理嵌套数据的更好的方法是使用`树` :doc:`/core-libraries/behaviors/tree`
    行为

在上面的例子中，``$allCategories`` 将包含一个呈现整个分类结构的嵌套数组。调用 ``find('threaded')`` 的结果格式如下。 ::

    Array
    (
        [0] => Array
        (
            [ModelName] => Array
            (
                [id] => 83
                [parent_id] => null
                [field1] => value1
                [field2] => value2
                [field3] => value3
            )

            [AssociatedModelName] => Array
            (
                [id] => 1
                [field1] => value1
                [field2] => value2
                [field3] => value3
            )

            [children] => Array
            (
                [0] => Array
                (
                    [ModelName] => Array
                    (
                        [id] => 42
                        [parent_id] => 83
                        [field1] => value1
                        [field2] => value2
                        [field3] => value3
                    )

                    [AssociatedModelName] => Array
                    (
                        [id] => 2
                        [field1] => value1
                        [field2] => value2
                        [field3] => value3
                    )

                    [children] => Array
                    (
                    )
                )
                ...
            )
        )
    )

结果中的顺序是可以改变的，因为它受order的影响。
如果将 ``'order' => 'name ASC'`` 作为参数传递给 ``find('threaded')``，结果将按name排序。
类似于此的所有order都能被使用，此方法没有内置的首次返回的顶层结果的顺序。

.. warn::

    如果指定了 ``fields``, 就必须包含parent_id (或者它的当前别名)::

        public function some_function() {
            $categories = $this->Category->find('threaded', array(
                'fields' => array('id', 'name', 'parent_id')
            ));
        }

    否则，上面例子中返回的数组将不是预期的嵌套结构。

.. _model-find-neighbors:

find('neighbors')
=================

``find('neighbors', $params)`` 与'first'类似, 但返回查询记录的前一条和后一条记录。 下面是一个简单的（控制器代码）示例：

::

    public function some_function() {
       $neighbors = $this->Article->find('neighbors', array('field' => 'id', 'value' => 3));
    }

``$params`` 数组包含两个元素: field 和 value。其它元素仍然可用 (Ex: If your model acts as
containable, then you can specify 'contain' in ``$params``). 调用 ``find('neighbors')`` 返回的结果格式如下:

::

    Array
    (
        [prev] => Array
        (
            [ModelName] => Array
            (
                [id] => 2
                [field1] => value1
                [field2] => value2
                ...
            )
            [AssociatedModelName] => Array
            (
                [id] => 151
                [field1] => value1
                [field2] => value2
                ...
            )
        )
        [next] => Array
        (
            [ModelName] => Array
            (
                [id] => 4
                [field1] => value1
                [field2] => value2
                ...
            )
            [AssociatedModelName] => Array
            (
                [id] => 122
                [field1] => value1
                [field2] => value2
                ...
            )
        )
    )

.. note::

    注意，结果总是只包含两个根元素： prev和next。
    此功能不兑现模型默认的递归变量。递归设置必须以参数形式传递给每个需要的调用。
    This function does not honor a model's default recursive
    var. The recursive setting must be passed in the parameters on each call.

.. _model-custom-find:

创建自定义查询类型
==========================

``find`` 方法很灵活，能够接收我们自定义的查找类型, 这是通过在模型中定义自己的类型变量并在模型中实现特定的函数来完成的。

模型的find类型是find选项的简写。例如，如下两种写法是等价的：

::

    $this->User->find('first');
    $this->User->find('all', array('limit' => 1));

以下是预定义的核心find类型：:

* ``first``
* ``all``
* ``count``
* ``list``
* ``threaded``
* ``neighbors``

那么其它的类型呢？已在数据库中查找所有的文章为例。首先要做的是把我们的自定义类型添加到模型的:php:attr:`Model::$findMethods`变量中。

::

    class Article extends AppModel {
        public $findMethods = array('available' =>  true);
    }

上面会告诉CakePHP接受值 ``available`` 作为``find` 函数的第一个参数。接下来要去实现 ``_findAvailable`` 函数。
要符合驼峰法命名的规则, 如果想实现一个叫做 ``myFancySearch`` 的查找函数，就需要命名为 ``_findMyFancySearch``。

::

    class Article extends AppModel {
        public $findMethods = array('available' =>  true);

        protected function _findAvailable($state, $query, $results = array()) {
            if ($state === 'before') {
                $query['conditions']['Article.published'] = true;
                return $query;
            }
            return $results;
        }
    }

下面是完整的示例（控制器代码）:

::

    class ArticlesController extends AppController {

        // 查询所有发布的文章并按照created列排序
        public function index() {
            $articles = $this->Article->find('available', array(
                'order' => array('created' => 'desc')
            ));
        }

    }

这个特殊的方法 ``_find[Type]`` 接收三个参数。第一个参数指执行查询的状态，可以是 ``before`` 或 ``after``。这样处理是因为此函数是一种回调函数，可以在查询结束前修改查询，或者在获取结果后对结果进行修改。 

通常执行该自定义查询方法的第一件事是检查查询状态。``before``状态可以修改查询、绑定新的关联、应用更多的行为，
，and interpret any special key that is passed in the second argument of ``find``. This
state requires you to return the $query argument (modified or not).

``after`` 状态可以检测查询结果，注入新的数据并以另外一种格式返回，或者在查询结果上做任何爱做的事情。此状态需要你返回$results数组(修改或者不修改)。

可以创建任意多你喜欢的自定义查找，这也是在应用程序中跨越模型复用代码的好办法。

还可以通过如下自定义的类型对结果进行分页：

::

    class ArticlesController extends AppController {

        // Will paginate all published articles
        public function index() {
            $this->paginate = array('available');
            $articles = $this->paginate();
            $this->set(compact('articles'));
        }

    }

Setting the ``$this->paginate`` property as above on the controller will result in the ``type``
of the find becoming ``available``, and will also allow you to continue to modify the find results.

If your pagination page count is becoming corrupt, it may be necessary to add the following code to
your ``AppModel``, which should fix pagination count:

::

    class AppModel extends Model {

    /**
     * Removes 'fields' key from count query on custom finds when it is an array,
     * as it will completely break the Model::_findCount() call
     *
     * @param string $state Either "before" or "after"
     * @param array $query
     * @param array $results
     * @return int The number of records found, or false
     * @access protected
     * @see Model::find()
     */
        protected function _findCount($state, $query, $results = array()) {
            if ($state === 'before') {
                if (isset($query['type']) && isset($this->findMethods[$query['type']])) {
                    $query = $this->{'_find' . ucfirst($query['type'])}('before', $query);
                    if (!empty($query['fields']) && is_array($query['fields'])) {
                        if (!preg_match('/^count/i', current($query['fields']))) {
                            unset($query['fields']);
                        }
                    }
                }
            }
            return parent::_findCount($state, $query, $results);
        }

    }
    ?>


.. versionchanged:: 2.2

You no longer need to override _findCount for fixing incorrect count results.
The ``'before'`` state of your custom finder will now be called again with
$query['operation'] = 'count'. The returned $query will be used in ``_findCount()``
If needed you can distinguish by checking for ``'operation'`` key
and return a different ``$query``::

    protected function _findAvailable($state, $query, $results = array()) {
        if ($state === 'before') {
            $query['conditions']['Article.published'] = true;
            if (!empty($query['operation']) && $query['operation'] === 'count') {
                return $query;
            }
            $query['joins'] = array(
                //array of required joins
            );
            return $query;
        }
        return $results;
    }

魔法查找类型
================

魔法函数可以作为搜寻表中特定列的快捷操作，只要在函数末尾添加字段名(驼峰命名格式)，
并且提供列的条件作为第一个参数。
These magic functions can be used as a shortcut to search your
tables by a certain field. Just add the name of the field (in
CamelCase format) to the end of these functions, and supply the
criteria for that field as the first parameter.

findAllBy() 函数返回类似于``find('all')``的返回格式的结果， 而findBy返回的格式与``find('first')`` 相同。
findAllBy() functions will return results in a format like ``find('all')``,
while findBy() return in the same format as ``find('first')``

findAllBy
---------

``findAllBy<字段名>(string $value, array $fields, array $order, int $limit, int $page, int $recursive)``

+------------------------------------------------------------------------------------------+------------------------------------------------------------+
| findAllBy<x> 示例                                                                     | 对应的SQL片段                                 |
+==========================================================================================+============================================================+
| ``$this->Product->findAllByOrderStatus('3');``                                           | ``Product.order_status = 3``                               |
+------------------------------------------------------------------------------------------+------------------------------------------------------------+
| ``$this->Recipe->findAllByType('Cookie');``                                              | ``Recipe.type = 'Cookie'``                                 |
+------------------------------------------------------------------------------------------+------------------------------------------------------------+
| ``$this->User->findAllByLastName('Anderson');``                                          | ``User.last_name = 'Anderson'``                            |
+------------------------------------------------------------------------------------------+------------------------------------------------------------+
| ``$this->Cake->findAllById(7);``                                                         | ``Cake.id = 7``                                            |
+------------------------------------------------------------------------------------------+------------------------------------------------------------+
| ``$this->User->findAllByEmailOrUsername('jhon', 'jhon');``                               | ``User.email = 'jhon' OR User.username = 'jhon';``         |
+------------------------------------------------------------------------------------------+------------------------------------------------------------+
| ``$this->User->findAllByUsernameAndPassword('jhon', '123');``                            | ``User.username = 'jhon' AND User.password = '123';``      |
+------------------------------------------------------------------------------------------+------------------------------------------------------------+
| ``$this->User->findAllByLastName('psychic', array(), array('User.user_name => 'asc'));`` | ``User.last_name = 'psychic' ORDER BY User.user_name ASC`` |
+------------------------------------------------------------------------------------------+------------------------------------------------------------+

返回结果数组的格式类似于``find('all')``的返回值格式。

findBy
------

``findBy<字段名>(string $value);``

findBy魔法函数同样接受一些可选参数:

``findBy<字段名>(string $value[, mixed $fields[, mixed $order]]);``


+------------------------------------------------------------+-------------------------------------------------------+
| findBy<x> 示例                                          | 对应的SQL片段                            |
+============================================================+=======================================================+
| ``$this->Product->findByOrderStatus('3');``                | ``Product.order_status = 3``                          |
+------------------------------------------------------------+-------------------------------------------------------+
| ``$this->Recipe->findByType('Cookie');``                   | ``Recipe.type = 'Cookie'``                            |
+------------------------------------------------------------+-------------------------------------------------------+
| ``$this->User->findByLastName('Anderson');``               | ``User.last_name = 'Anderson';``                      |
+------------------------------------------------------------+-------------------------------------------------------+
| ``$this->User->findByEmailOrUsername('jhon', 'jhon');``    | ``User.email = 'jhon' OR User.username = 'jhon';``    |
+------------------------------------------------------------+-------------------------------------------------------+
| ``$this->User->findByUsernameAndPassword('jhon', '123');`` | ``User.username = 'jhon' AND User.password = '123';`` |
+------------------------------------------------------------+-------------------------------------------------------+
| ``$this->Cake->findById(7);``                              | ``Cake.id = 7``                                       |
+------------------------------------------------------------+-------------------------------------------------------+

findBy() 函数返回的结果类似于``find('first')``

.. _model-query:

:php:meth:`Model::query()`
==========================

``query(string $query)``

虽然很少有必要，但如果你不能或不想通过其它方法调用 SQL，就可以直接使用模型的``query()``方法。


如果你真想在应用程序中使用这种方法，请确保你已经阅读过CakePHP的:doc:`/core-utility-libraries/sanitize` 这有助于清理用户提供的数据，以防止注入和跨站点脚本攻击。

.. note::

    ``query()`` 不理会 $Model->cacheQueries 因为其功能本质上与调用的模型不相关。为避免缓存调用查询，需要将第二个参数设置为 false，例如: ``query($query, $cachequeries = false)``

``query()`` 在查询中使用表名作为返回数据的数组的键名，而不是模型名。例如::

    $this->Picture->query("SELECT * FROM pictures LIMIT 2;");

可能返回如下数组::

    Array
    (
        [0] => Array
        (
            [pictures] => Array
            (
                [id] => 1304
                [user_id] => 759
            )
        )

        [1] => Array
        (
            [pictures] => Array
            (
                [id] => 1305
                [user_id] => 759
            )
        )
    )

要使用模型名作为数组键，以与 find 方法的返回结果一致，可以将查询写成。 ::

    $this->Picture->query("SELECT * FROM pictures AS Picture LIMIT 2;");

将返回::

    Array
    (
        [0] => Array
        (
            [Picture] => Array
            (
                [id] => 1304
                [user_id] => 759
            )
        )

        [1] => Array
        (
            [Picture] => Array
            (
                [id] => 1305
                [user_id] => 759
            )
        )
    )

.. note::

    此语法及关联数组结构仅在 MySQL 中有效。在手动运行查询时，Cake 不提供任何抽象数据，所以其结果在不同的数据库中有所不同。

:php:meth:`Model::field()`
==========================

``field(string $name, array $conditions = null, string $order = null)``

、返回以``$name``命名列的第一条记录的值,以$conditions为条件按照$order排序。如果没有传递条件并且模型设置了id, 将返回当前模型结果的列的值。如果没有匹配的记录，查找将返回 false。

::

    $this->Post->id = 22;
    echo $this->Post->field('name'); // echo the name for row id 22

    echo $this->Post->field('name', array('created <' => date('Y-m-d H:i:s')), 'created DESC');
    // echo the name of the last created instance 
    // 显示最后创建的实例的 'name' 列

:php:meth:`Model::read()`
=========================

``read($fields, $id)``

``read()`` 是一个设置当前模型数据的方法(``Model::$data``)
(``Model::$data``)--例如在编辑过程中--但是也可以在其他情况下从数据库中获取单条记录。

``$fields`` 传递单个字段名，可以是字符串或包含字段的数组；如果为空，则获取所有字段。

``$id`` 指定要读取的记录ID，默认由``Model::$id``指定，传递不同的值给``$id``就会搜索所选的记录。

``read()`` 总是返回一个数组(即使仅包含一个字段名)。使用``field``来获取单个字段的值。

.. warning::

    由于``read``方法覆盖任何存储在模型的``data``和``id`` 属性中的任何信息，通常使用此功能是要非常小心，尤其在类似 ``beforeValidate``和``beforeSave``等模型回调函数中。
    通常``find``方法比``read``方法提供了更强大和易用的API。

复杂的查找条件 Complex Find Conditions
=======================

大多数模型的find调用会牵涉到很多查询条件，使用CakePHP可以把这些条件放在数组里。
这种写法的好处是整洁且易读。还能够避免SQL注入。

基于数组的最基础的查询类似于::

    $conditions = array("Post.title" => "This is a post", "Post.author_id" => 1);
    // 带有模型的示例:
    $this->Post->find('first', array('conditions' => $conditions));

此结构非常简单：它将查找标题等于 “This is a post” 的帖子。
注意，我们可以使用 “title” 作为列的名字，但是在构建查询时，最好总是指定模型名，因为它提高了代码的清晰度，有助于在你选择改变架构时避免冲突。

其它的匹配类型呢？同样简单。假设你要查找所有的 title 不是 This is a post 的帖子::

    array("Post.title !=" => "This is a post")

注意，'!=' 跟在列的名称之后。
CakePHP 能解析任何有效的 SQL 比较操作符，包括使用 LIKE、BETWEEN、REGEX 的匹配表达式，只要你用空格分隔开列名和操作符。IN(...) 风格的匹配例外。
假设你想查找title列包含在给定的值集合之内的帖子::

    array(
        "Post.title" => array("First post", "Second post", "Third post")
    )

要执行 NOT IN(...) 匹配查找 title 不在给定的值集之内的帖子：::

    array(
        "NOT" => array("Post.title" => array("First post", "Second post", "Third post"))
    )

为条件添加附加的过滤就像给数组添加附加的键/值对一样简单::

    array (
        "Post.title" => array("First post", "Second post", "Third post"),
        "Post.created >" => date('Y-m-d', strtotime("-2 weeks"))
    )

还可以创建对比数据库中两个列的查找::
You can also create finds that compare two fields in the database::

    array("Post.created = Post.modified")

上面的例子将返回创建时间和编辑时间相同的帖子 (就是指那些从来没被编辑过的帖子)。

记住，如果你发现不能在此方法中生成 WHERE 子句（例如 逻辑运算），你可以用字符串来指定它::

    array(
        'Model.field & 8 = 1',
        // 其它常用条件
    )

默认情况下，CakePHP 使用逻辑 AND 连接多个条件；
也就是说，上面的代码片段仅匹配两星期前创建的并且标题与给定的结果的某一个匹配的帖子。
但是我们也能很容易的找到符合任一条件的帖子::

    array("OR" => array(
        "Post.title" => array("First post", "Second post", "Third post"),
        "Post.created >" => date('Y-m-d', strtotime("-2 weeks"))
    ))

CakePHP 接受所有有效的 SQL 逻辑运算，包括AND, OR,
NOT, XOR, 等等，而且不区分大小写, 这些条件还能无限制嵌套。
假设 Posts 和 Authors 表之间有 belongsTo 关系. 我们要搜寻所有包含特定关键词（”magic”）或者两星期前建立的，但仅限于由用户 Bob 发布的帖子::

    array(
        "Author.name" => "Bob",
        "OR" => array(
            "Post.title LIKE" => "%magic%",
            "Post.created >" => date('Y-m-d', strtotime("-2 weeks"))
        )
    )

如果需要在同一个列上设置多个条件，比如想要执行一个带有多个 LIKE 的搜索，可以使用类似如下的条件::

    array('OR' => array(
        array('Post.title LIKE' => '%one%'),
        array('Post.title LIKE' => '%two%')
    ))

Cake 还能检查 null 列。在本例中，查询将返回所有 title 不为 null 的记录::

    array("NOT" => array(
            "Post.title" => null
        )
    )

要处理 BETWEEN 查询，可以使用如下::

    array('Post.read_count BETWEEN ? AND ?' => array(1,10))

.. note::

    是否为数字值加上引号将取决于数据库中列的类型
    CakePHP will quote the numeric values depending on the field
    type in your DB.

GROUP BY?::

    array(
        'fields' => array(
            'Product.type',
            'MIN(Product.price) as price'
        ),
        'group' => 'Product.type'
    )

所返回的值格式如下::

    Array
    (
        [0] => Array
        (
            [Product] => Array
            (
                [type] => Clothing
            )
            [0] => Array
            (
                [price] => 32
            )
        )
        [1] => Array
        ...

下面是执行 DISTINCT 查询的简单示例。可以按类似格式使用其它操作符，例如
MIN(), MAX(), 等等::

    array(
        'fields' => array('DISTINCT (User.name) AS my_column_name'),
        'order' = >array('User.id DESC')
    )

通过嵌套多个条件数组，可以构建非常复杂的条件::

    array(
        'OR' => array(
            array('Company.name' => 'Future Holdings'),
            array('Company.city' => 'CA')
        ),
        'AND' => array(
            array(
                'OR' => array(
                    array('Company.status' => 'active'),
                    'NOT' => array(
                        array('Company.status' => array('inactive', 'suspended'))
                    )
                )
            )
        )
    )

其对应的 SQL 查询为::

    SELECT `Company`.`id`, `Company`.`name`,
    `Company`.`description`, `Company`.`location`,
    `Company`.`created`, `Company`.`status`, `Company`.`size`

    FROM
       `companies` AS `Company`
    WHERE
       ((`Company`.`name` = 'Future Holdings')
       OR
       (`Company`.`name` = 'Steel Mega Works'))
    AND
       ((`Company`.`status` = 'active')
       OR (NOT (`Company`.`status` IN ('inactive', 'suspended'))))

子查询
-----------

下面的示例假定我们有一个带有"id", "name" 和 "status"的"users" 表 。
status 可以是  "A", "B" 或者 "C"。
现在我们想使用子查询获取所有 status 不同于"B" 的用户。

为了达到此目的，我们将获取模型数据源，向其发出请求以建立查询，就像我们正在调用 find 方法，只不过返回的是一条 SQL 语句。然后，我们生成一个表达式并将其添加到条件数组中::

    $conditionsSubQuery['"User2"."status"'] = 'B';

    $db = $this->User->getDataSource();
    $subQuery = $db->buildStatement(
        array(
            'fields'     => array('"User2"."id"'),
            'table'      => $db->fullTableName($this->User),
            'alias'      => 'User2',
            'limit'      => null,
            'offset'     => null,
            'joins'      => array(),
            'conditions' => $conditionsSubQuery,
            'order'      => null,
            'group'      => null
        ),
        $this->User
    );
    $subQuery = ' "User"."id" NOT IN (' . $subQuery . ') ';
    $subQueryExpression = $db->expression($subQuery);

    $conditions[] = $subQueryExpression;

    $this->User->find('all', compact('conditions'));

生成的 SQL 查询为::

    SELECT
        "User"."id" AS "User__id",
        "User"."name" AS "User__name",
        "User"."status" AS "User__status"
    FROM
        "users" AS "User"
    WHERE
        "User"."id" NOT IN (
            SELECT
                "User2"."id"
            FROM
                "users" AS "User2"
            WHERE
                "User2"."status" = 'B'
        )

另外，如果你需要传递上面的原始 SQL 查询的一部分，带有原始 SQL 的数据源**表达式**的查询在任意部分都管用。

Also, if you need to pass just part of your query as raw SQL as the
above, datasource **expressions** with raw SQL work for any part of
the find query.


预处理语句
-------------------

如果需要对查询有更多控制，可以使用预处理语句。
它允许你直接与数据库驱动对话，并且传递任何你需要的自定义查询

Should you need even more control over your queries, you can make use of prepared
statements. This allows you to talk directly to the database driver and send any
custom query you like::

    $db = $this->getDataSource();
    $db->fetchAll(
        'SELECT * from users where username = ? AND password = ?',
        array('jhon', '12345')
    );
    $db->fetchAll(
        'SELECT * from users where username = :username AND password = :password',
        array('username' => 'jhon','password' => '12345')
    );



.. meta::
    :title lang=en: Retrieving Your Data
    :keywords lang=en: upper case character,array model,order array,controller code,retrieval functions,model layer,model methods,model class,model data,data retrieval,field names,workhorse,desc,neighbors,parameters,storage,models
