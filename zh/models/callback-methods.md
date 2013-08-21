回调方法
Callback Methods
################

如果你想触及恰好在CakePHP模型操作之前或之后的逻辑, 请使用模型的回调方法。这些函数可以定义在模型类(包括你的AppModel)中。一定要注意这些特殊函数各自预期的返回值。
If you want to sneak in some logic just before or after a CakePHP
model operation, use model callbacks. These functions can be
defined in model classes (including your AppModel) class. Be sure
to note the expected return values for each of these special
functions.

当使用回调方法时, 应当记住, 行为的回调方法在模型的回调方法**之前**触发。
When using callback methods you should remember that behavior callbacks are
fired **before** model callbacks are.

beforeFind
==========

``beforeFind(array $queryData)``

在任何与find相关的操作之前调用。传入这个回调方法的``$queryData``包括当前查询相关的信息: conditions, fields, 等等。
Called before any find-related operation. The ``$queryData`` passed
to this callback contains information about the current query:
conditions, fields, etc.

如果你不希望find操作开始(可以基于与``$queryData``所含信息相关的判断), 就返回*false*。不然, 可以返回更改了的``$queryData``, 或者任何你想传给find及其它查询方法。
If you do not wish the find operation to begin (possibly based on a
decision relating to the ``$queryData`` options), return *false*.
Otherwise, return the possibly modified ``$queryData``, or anything
you want to get passed to find and its counterparts.

你可以用这个回调方法根据用户的角色来限制find操作, 或者根据当前的负载来确定缓存的策略。
You might use this callback to restrict find operations based on a
user’s role, or make caching decisions based on the current load.

afterFind
=========

``afterFind(array $results, boolean $primary = false)``

用这个回调方法来改变从find操作返回的结果, 或者执行任何其他find之后的逻辑。传入这个回调方法的$results参数包含从模型的find操作返回的结果, 象这样::
Use this callback to modify results that have been returned from a
find operation, or to perform any other post-find logic. The
$results parameter passed to this callback contains the returned
results from the model's find operation, i.e. something like::

    $results = array(
        0 => array(
            '模型名称ModelName' => array(
                '字段field1' => 'value1',
                '字段field2' => 'value2',
            ),
        ),
    );

这个回调方法的返回值应当是给触发这个回调的find操作的(可能被改动的)结果。
The return value for this callback should be the (possibly
modified) results for the find operation that triggered this
callback.

``$primary``参数说明当模型是查询起始的模型, 还是作为相关模型查询到的。如果模型是作为相关模型查询的, ``$results``的格式会有所不同; 与通常从find操作获得的结果不同, 你可能会得到::
The ``$primary`` parameter indicates whether or not the current
model was the model that the query originated on or whether or not
this model was queried as an association. If a model is queried as
an association the format of ``$results`` can differ; instead of the
result you would normally get from a find operation, you may get
this::

    $results = array(
        'field_1' => 'value1',
        'field_2' => 'value2'
    );

.. warning::

    期待``$primary``为true的代码, 如果使用叠代查询(*recursive find*) , 可能会从PHP得到"Cannot
    use string offset as an array"的严重错误。
    Code expecting ``$primary`` to be true will probably get a "Cannot
    use string offset as an array" fatal error from PHP if a recursive
    find is used.

下面的例子说明如何用afterfind来格式化日期::
Below is an example of how afterfind can be used for date
formatting::

    public function afterFind($results, $primary = false) {
        foreach ($results as $key => $val) {
            if (isset($val['Event']['begindate'])) {
                $results[$key]['Event']['begindate'] = $this->dateFormatAfterFind($val['Event']['begindate']);
            }
        }
        return $results;
    }
    
    public function dateFormatAfterFind($dateString) {
        return date('d-m-Y', strtotime($dateString));
    }

beforeValidate
==============

``beforeValidate(array $options = array())``

这个回调可以用来在验证之前改变模型数据, 或者在需要时改变验证规则。,这个函数也必须返回*true*, 否则当前save()操作就会中断。
Use this callback to modify model data before it is validated, or
to modify validation rules if required. This function must also
return *true*, otherwise the current save() execution will abort.

beforeSave
==========

``beforeSave(array $options = array())``

把任何save之前的逻辑放在这个函数里。这个函数在模型数据成功验证后, 但在数据保存之前, 立即执行。如果你要save操作继续执行, 这个函数也要返回true。
Place any pre-save logic in this function. This function executes
immediately after model data has been successfully validated, but
just before the data is saved. This function should also return
true if you want the save operation to continue.

对于在数据保存之前要进行的任何修正数据的逻辑, 这个回调是尤其顺手的。如果你的存储引擎需要某种格式的日期, 可以在$this->data得到日期并进行修改。
This callback is especially handy for any data-massaging logic that
needs to happen before your data is stored. If your storage engine
needs dates in a specific format, access it at $this->data and
modify it.

下面是一个如何使用beforeSave来转换日期的例子。例子中的应用程序代码, 把begindate在数据库中格式化成YYYY-MM-DD, 而在应用程序中显示成DD-MM-YYYY。当然这很容易改变。在相应的模型中用下面的代码。
Below is an example of how beforeSave can be used for date
conversion. The code in the example is used for an application with
a begindate formatted like YYYY-MM-DD in the database and is
displayed like DD-MM-YYYY in the application. Of course this can be
changed very easily. Use the code below in the appropriate model.

::

    public function beforeSave($options = array()) {
        if (!empty($this->data['Event']['begindate']) && !empty($this->data['Event']['enddate'])) {
            $this->data['Event']['begindate'] = $this->dateFormatBeforeSave($this->data['Event']['begindate']);
            $this->data['Event']['enddate'] = $this->dateFormatBeforeSave($this->data['Event']['enddate']);
        }
        return true;
    }

    public function dateFormatBeforeSave($dateString) {
        return date('Y-m-d', strtotime($dateString));
    }

.. tip::

    确保beforeSave()返回true, 否则保存就会失败。
    Be sure that beforeSave() returns true, or your save is going to
    fail.

afterSave
=========

``afterSave(boolean $created)``

如果你你有每次保操作之后都要执行的逻辑, 就把它放在这个回调方法中。
If you have logic you need to be executed just after every save
operation, place it in this callback method.

如果创建一条新记录(而非更新), ``$created``的值就会是true。
The value of ``$created`` will be true if a new record was created
(rather than an update).

beforeDelete
============

``beforeDelete(boolean $cascade = true)``

任何删除之前的逻辑, 请放在这个函数中。此函数应当返回true, 如果你要继续删除, 如果想放弃就返回false。
 Place any pre-deletion logic in this function. This function should
return true if you want the deletion to continue, and false if you
want to abort.
如果依赖于当前这条记录的其他记录也要删除时的话,``$cascade``的值将会是``true``。
The value of ``$cascade`` will be ``true`` if records that depend
on this record will also be deleted.

.. tip::

    确保beforeDelete()返回true, 否则删除就会失败。
    Be sure that beforeDelete() returns true, or your delete is going
    to fail.

::

    // using app/Model/ProductCategory.php
    // 在下面的例子中, 如果一个产品类别还有产品, 则不允许删除 。In the following example, do not let a product category be deleted if it still contains products.
    // A call of $this->Product->delete($id) from ProductsController.php has set $this->id .
    // Assuming 'ProductCategory hasMany Product', we can access $this->Product in the model.
    public function beforeDelete($cascade = true) {
        $count = $this->Product->find("count", array(
            "conditions" => array("product_category_id" => $this->id)
        ));
        if ($count == 0) {
            return true;
        } else {
            return false;
        }
    }

afterDelete
===========

``afterDelete()``

在此回调方法中放入每次删除之后都要执行的任何逻辑。
Place any logic that you want to be executed after every deletion
in this callback method.

onError
=======

``onError()``

任何问题发生都会调用。
Called if any problems occur.


.. meta::
    :title lang=en: Callback Methods
    :keywords lang=en: querydata,query conditions,model classes,callback methods,special functions,return values,counterparts,array,logic,decisions