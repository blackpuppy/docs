虚字段
##############

虚字段可以把SQL表达式当作模型中的字段来使用，这些字段不能保存数据，但是和其他字段一样可以进行读操作。
他们会被索引在model的主键，位于其他字段旁边。(They will be indexed under the model's key alongside other model
fields.)


创建虚字段
=======================

创建虚拟字段很简单。在每个模型中你可以设置``$virtualFields``属性，该属性是一个数组，
形式如 字段名 => 表达式。下面是一个虚字段定义的例子::

    public $virtualFields = array(
        'name' => 'CONCAT(User.first_name, " ", User.last_name)'
    );

PostgreSQL中的SQL语法::

    public $virtualFields = array(
        'name' => 'User.first_name || \' \' || User.last_name'
    );

在使用Model的find的操作后，User的查询结果中会多出键名为``name``的内容，虚字段不要与数据库中已存在的字段名相同。
否则会导致错误。

有时可以不带模型名，(译注：最好带上)，如果你不遵循规范，（比如和其他表有多个关联）可能会出现错误。这种情况下，应该不带模型名，结果就是``first_name || \' \' || last_name``。

使用虚字段
====================

操作虚拟字段有多种方法。

Model::hasField()
-----------------

如果模型中存在第一个参数指定的实际存在的字段，将返回true。
将第二个参数设为true，虚拟字段也会被检查。使用上面的代码来举例::

    $this->User->hasField('name'); // 返回false，因为不存在名为name的实际字段
    $this->User->hasField('name', true); // 放回true，因为存在名为name的虚字段

Model::isVirtualField()
-----------------------

检测一个字段/列是虚字段还是实际字段。如果是虚拟字段将返回true::

    $this->User->isVirtualField('name'); //true
    $this->User->isVirtualField('first_name'); //false

Model::getVirtualField()
------------------------

该方法用来取得虚字段对应的SQL表达式，如果没有参数，会返回该模型所有的虚字段::

    $this->User->getVirtualField('name'); //将返回 'CONCAT(User.first_name, ' ', User.last_name)'

模型的find()方法和虚字段
--------------------------------

如前所述，Model::find()像处理其他字段一样处理虚字段。虚字段的值会包括在模型的结果中::

    $results = $this->User->find('first');

    // 输出的结果
    array(
        'User' => array(
            'first_name' => 'Mark',
            'last_name' => 'Story',
            'name' => 'Mark Story',
            //更多的字段...
        )
    );

分页和虚字段
-----------------------------

由于查询时虚字段与一般字段的行为一样，所以也可以用``Controller::paginate()``来排序。

虚字段和模型别名(model aliases)
================================

当你使用虚字段和带别名的模型，可能会遇到虚字段的模型不会更新映射到新的模型别名中去。
如果你使用的虚字段所在的模型中有多个别名，最好在模型的构造函数中来定义虚字段。
When you are using virtualFields and models with aliases that are
not the same as their name, you can run into problems as
virtualFields do not update to reflect the bound alias. If you are
using virtualFields in models that have more than one alias it is
best to define the virtualFields in your model's constructor::

    public function __construct($id = false, $table = null, $ds = null) {
        parent::__construct($id, $table, $ds);
        $this->virtualFields['name'] = sprintf('CONCAT(%s.first_name, " ", %s.last_name)', $this->alias, $this->alias);
    }

这将使虚字段在给定模型的所有别名中都有效。

SQL查询中的虚字段
=============================

使用query函数直接进行SQL查询，其返回的数据并不和模型的数据一样。比如::

    $this->Timelog->query("SELECT project_id, SUM(id) as TotalHours FROM timelogs AS Timelog GROUP BY project_id;");

返回如下格式的数据::
	
   Array
   (
       [0] => Array
           (
               [Timelog] => Array
                   (
                       [project_id] => 1234
                   )
                [0] => Array
                    (
                        [TotalHours] => 25.5
                    )
           )
    )

如果想把TotalHours放到Timelog数组中，我们需要为合计的列指定一个虚拟字段。
我们可以临时定义虚拟字段，比定义在模型中更有效果。我们设定默认值为0，免得其他查询使用这个虚拟字段。
如果那样，TotalHours会返回0::

    $this->Timelog->virtualFields['TotalHours'] = 0;

除了增加虚拟字段，我们还需要用``MyModel__MyField``的形式给列起别名。比如::

    $this->Timelog->query("SELECT project_id, SUM(id) as Timelog__TotalHours FROM timelogs AS Timelog GROUP BY project_id;");

在指定虚拟字段后再次查询，将会得到一个格式化好的的结果::

    Array
    (
        [0] => Array
            (
                [Timelog] => Array
                    (
                        [project_id] => 1234
                        [TotalHours] => 25.5
                    )
            )
    )
	
虚字段的局限
============================

使用虚字段会带来一些局限。首先，你不能在模型关联的条件(conditions)，排序(order)，字段(fields)数组中使用虚拟字段。如果那样做，会产生SQL错误。因为字段被没有被ORM替代(as the fields are not replaced by
the ORM)。很难去估算模型关联的深度。 This is because it difficult to estimate the depth at
which an associated model might be found.

常见的解决办法是在运行时将虚拟字段复制到其他模型::

    $this->virtualFields['name'] = $this->Author->virtualFields['name'];

or::

    $this->virtualFields += $this->Author->virtualFields;

.. meta::
    :title lang=en: Virtual fields
    :keywords lang=en: sql expressions,array name,model fields,sql errors,virtual field,concatenation,model name,first name last name
