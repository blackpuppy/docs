模型属性
################

模型属性用来重写默认的模型行为。

完整的模型属性列表及描述请查看CakePHP API
`http://api20.cakephp.org/class/model <http://api20.cakephp.org/class/model>`_.

useDbConfig
===========

``useDbConfig`` 属性为字符串，指定一个连接数据库的名称标识。其作用绑定模型和关联的数据表。
可以在数据库配置文件中设置，位置是/app/Config/database.php
``useDbConfig``属性的默认值是'default'
(译注：使用此属性就可以连接其他数据库了，多库查询)
使用示例:

::

    class Example extends AppModel {
        public $useDbConfig = 'alternate';
    }


useTable
========
``useTable`` 属性指定绑定数据表的表名。通常情况下，模型会自动绑定模型名的小写复数形式的表。
可以设定为其他表，当设为``false``此模型将不使用数据表
使用示例::

    class Example extends AppModel {
        public $useTable = false; // 此模型不会自动绑定数据表
    }

或者这样使用::

    class Example extends AppModel {
        public $useTable = 'exmp'; // 此模型将绑定表'exmp'
    }


tablePrefix
===========

使用表前缀。最初设置在/app/Config/database.php。默认不使用前缀，可以在模型中设置
tablePrefix属性覆盖它。

使用示例::

    class Example extends AppModel {
        public $tablePrefix = 'alternate_'; // 将和表'alternate_examples'绑定
    }

.. _model-primaryKey:

primaryKey
==========

每个表通常会有一个主键，一般叫``id``。我们可以指定一个字段为主键，通常用在一个已经存在的表。

使用示例::

    class Example extends AppModel {
        public $primaryKey = 'example_id'; // example_id是表的字段名
    }


.. _model-displayField:

displayField
============

``displayField``属性指定哪个字段用作字段标签，标签用在脚手架和调用find('list')函数时。默认模型会用name和title。
举个例子，使用``username``字段::

    class User extends AppModel {
        public $displayField = 'username';
    }

多字段名不能结合成一个显示字段。比如，你不能连接``array('first_name', 'last_name')``作为显示字段。但是可以利用模型的virtualField属性生成一个虚字段。

recursive
=========

recursive属性决定CakePHP中用``find()``和``read()``获取到的关联数据的深度。
假设你的应用程序的某些功能组属于一个域。，其中有很多用户，每个用户下面又有很多文章。可以基于数量量设置 $recursive 不同的值来通过 $this->Group->find()获取不同的结果。

Imagine your application features Groups which belong to a domain
and have many Users which in turn have many Articles. You can set
$recursive to different values based on the amount of data you want
back from a $this->Group->find() call:

* -1 只获取Group数据
* 0  获取Group数据和他的领域
* 1  获取Group数据和他的领域，领域关联的用户
* 2  获取Group数据和他的领域，领域关联的用户，用户关联的文章

* -1 Cake fetches Group data only, no joins.
* 0  Cake fetches Group data and its domain
* 1  Cake fetches a Group, its domain and its associated Users
* 2  Cake fetches a Group, its domain, its associated Users, and the
  Users' associated Articles

不要设置比需求更大的值。获取不需要的数据会不必要的减慢应用程序。注意recursive默认值是1。

Set it no higher than you need. Having CakePHP fetch data you
aren’t going to use slows your app unnecessarily. Also note that
the default recursive level is 1.

.. note::

如果想将$recursive与 ``fields``功能结合，必须手动把外键字段加入到 ``fields`` 数组。上面的例子中，需要加 ``domain_id``。

    If you want to combine $recursive with the ``fields``
    functionality, you will have to add the columns containing the
    required foreign keys to the ``fields`` array manually. In the
    example above, this could mean adding ``domain_id``.

.. tip::

recursive推荐值为-1。可以防止获取不需要的数据。最有可能发生在find()中。
只需要可控的情况下设置更大的值。

你可以把他添加到 AppModel::

    The recommended recursive level for your application should be -1.
    This avoids retrieving related data where that is unnecessary or even
    unwanted. This is most likely the case for most of your find() calls.
    Raise it only when needed or use Containable behavior.

    You can achieve that by adding it to the AppModel::

        public $recursive = -1;

order
=====

设置任何查询操作的默认排序。可用的值::

    $order = "field"
    $order = "Model.field";
    $order = "Model.field asc";
    $order = "Model.field ASC";
    $order = "Model.field DESC";
    $order = array("Model.field" => "asc", "Model.field2" => "DESC");

data
====

模型获取数据的容器。当模型返回的数据通常作为find()的返回数据时，你可以在模型的回调(callback)中取得保存在$data中的信息。

The container for the model’s fetched data. While data returned
from a model class is normally used as returned from a find() call,
you may need to access information stored in $data inside of model
callbacks.

\_schema
========

包含描述数据库字段的元数据。
每个字段被描述为如下形式:

-  name
-  type (integer, string, datetime, etc.)
-  null
-  default value
-  length

使用示例::

    public $_schema = array(
        'first_name' => array(
            'type' => 'string',
            'length' => 30
        ),
        'last_name' => array(
            'type' => 'string',
            'length' => 30
        ),
        'email' => array(
            'type' => 'string',
            'length' => 30
        ),
        'message' => array('type' => 'text')
    );

validate
========

设置此属性允许模型在保存数据前校验数据的规则。
以字段名命名的关键字保存正则表达式。

This attribute holds rules that allow the model to make data
validation decisions before saving. Keys named after fields hold
regex values allowing the model to try to make matches.

.. note::

    注意：没必要在save()前调用validate()。save()会在保存数据前自动校验数据。

有关验证的更多信息, 参见手册中的 :doc:`/models/data-validation`

virtualFields
=============

虚字段，类型是个数组。虚字段是SQL表达式的别名。
虚字段可以和其他字段一样查询但不能将数据插入虚字段中。

Array of virtual fields this model has. Virtual fields are aliased
SQL expressions. Fields added to this property will be read as
other fields in a model but will not be saveable.

MySQL下的使用例子::

    public $virtualFields = array(
        'name' => "CONCAT(User.first_name, ' ', User.last_name)"
    );

执行查询操作，User结果会包含一个 ``name``的字段。创建一个已经存在的字段作为虚字段是不可行的。
会导致SQL错误。

In subsequent find operations, your User results would contain a
``name`` key with the result of the concatenation. It is not
advisable to create virtual fields with the same names as columns
on the database, this can cause SQL errors.

有关 ``virtualFields`` 的更多信息用法等。参见 :doc:`/models/virtual-fields`。

For more information on the ``virtualFields`` property, its proper
usage, as well as limitations, see
:doc:`/models/virtual-fields`.

name
====

模型的名称。如果不指定会设为模型类的名称
If you do not specify it in your model file it will
be set to the class name by constructor.

使用示例::

    class Example extends AppModel {
        public $name = 'Example';
    }

cacheQueries
============

若设为true，单个请求获得的数据会被缓存，缓存保存在内存中，重复的请求会返回相同的数据

If set to true, data fetched by the model during a single request
is cached. This caching is in-memory only, and only lasts for the
duration of the request. Any duplicate requests for the same data
is handled by the cache.


.. meta::
    :title lang=en: Model Attributes
    :keywords lang=en: alternate table,default model,database configuration,model example,database table,default database,model class,model behavior,class model,plural form,database connections,database connection,attribute,attributes,complete list,config,cakephp,api,class example
