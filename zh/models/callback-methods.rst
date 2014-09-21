回调方法

如果你需要在完成模型操作之前或之后要做一些处理逻辑，使用模型的回调函数吧。
这些函数定义在模型类中(包括AppModel)，注意这些特殊函数的预期返回值。

当使用回调函数应该记住行为(behavior)的回调函数比模型的回调函数**之前**执行。

beforeFind
==========

``beforeFind(array $queryData)``

该回调函数在任意的查询相关的操作前被调用。参数 ``$queryData`` 包含当前查询
的信息比如 : 条件，列，等。

Called before any find-related operation. The ``$queryData`` passed
to this callback contains information about the current query:
conditions, fields, etc.

如果不希望查询操作被执行(可能基于相关 ``$queryData`` 选项而做出的决定)，
返回*false*。否则返回可能修改过的 ``$queryData`` ，或者任何你想传递给查询的信息

If you do not wish the find operation to begin (possibly based on a
decision relating to the ``$queryData`` options), return *false*.
Otherwise, return the possibly modified ``$queryData``, or anything
you want to get passed to find and its counterparts.

可以使用该回调方法基于用户的权限限制其查询操作，或者根据当前负载
决定是否采用缓存。。

You might use this callback to restrict find operations based on a
user’s role, or make caching decisions based on the current load.

afterFind
=========

``afterFind(array $results, boolean $primary = false)``

使用此回调函数可以修改已经查询出来的结果。或者执行任何其他的post-find逻辑。
$results参数接收包含模型查询操作的结果，等. 比如::

    $results = array(
        0 => array(
            'ModelName' => array(
                'field1' => 'value1',
                'field2' => 'value2',
            ),
        ),
    );

这个回调函数的返回值应该是(可能修改后的)由于查询操作触发的这个
回调。

The return value for this callback should be the (possibly
modified) results for the find operation that triggered this
callback.

``$primary`` 参数表示当前的模型是否是被关联查询，如果是关联查询，``$results``
的内容跟普通的查询操作结果格式不一样，可能会是如下的内容::

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

    将 ``$primary`` 设为true，在递归查找中可能会遇到 "Cannot
    use string offset as an array" 这个来自PHP的致命错误。

    Code expecting ``$primary`` to be true will probably get a "Cannot
    use string offset as an array" fatal error from PHP if a recursive
    find is used.

下面是个用afterfind将查出的日期进行格式化的例子::

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

使用此回调函数可以在验证之前修改数据，如果需要也可以修改验证规则。
这个函数必须返回*true*，否则当前的save()执行会被中断。

Use this callback to modify model data before it is validated, or
to modify validation rules if required. This function must also
return *true*, otherwise the current save() execution will abort.

beforeSave
==========

``beforeSave(array $options = array())``

可以在此回调函数内放任何预保存逻辑。这个函数会在验证数据成功之后及数据保存之前执行，
如果想要保存操作成功，此函数应该返回true。

Place any pre-save logic in this function. This function executes
immediately after model data has been successfully validated, but
just before the data is saved. This function should also return
true if you want the save operation to continue.

此函数适用于对数据保存前进行处理。如果需要存储特定的数据格式，可以直接修改$this->data。

This callback is especially handy for any data-massaging logic that
needs to happen before your data is stored. If your storage engine
needs dates in a specific format, access it at $this->data and
modify it.

下面是个用beforeSave进行数据转换的例子。
保存在数据库中的begindate日期字段格式的为YYYY-MM-DD，而在项目中显示的格式要求为DD-MM-YYYY。
我们可以使用下面的代码完成这个需求。

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

    请确保beforeSave()返回true，否则会保存失败。

afterSave
=========

``afterSave(boolean $created)``

如果需要每个保存操作后执行一些逻辑，可以将这些逻辑放到afterSave回调方法中。

If you have logic you need to be executed just after every save
operation, place it in this callback method.

如果是插入新记录(而不是更新记录)，请将 ``$created`` 值设为true。

The value of ``$created`` will be true if a new record was created
(rather than an update).

beforeDelete
============

``beforeDelete(boolean $cascade = true)``

在此函数内放置任何预删除逻辑。若要删除操作成功，此函数应该返回true，
为false则会终止删除。

Place any pre-deletion logic in this function. This function should
return true if you want the deletion to continue, and false if you
want to abort.

当 ``$cascade`` 为真，会进行级联删除操作。

The value of ``$cascade`` will be ``true`` if records that depend
on this record will also be deleted.

.. tip::

    请确保beforeDelete()返回true，否则会删除失败。

::

    // 使用 app/Model/ProductCategory.php
    // 在下面的例子中，如果一个产品目录下面包含产品，则不删除此目录。
    // 在ProductsController.php中我们设置$this->id，并执行$this->Product->delete($id)
    // 假设ProductCategory对应很多个Product，我们可以在模型中使用$this->Product。

    // In the following example, do not let a product category be deleted if it still contains products.
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

在这个回调函数里放置每次删除操作完成后执行的逻辑。

Place any logic that you want to be executed after every deletion
in this callback method.

onError
=======

``onError()``

遇到任何问题发生时被调用。

Called if any problems occur.


.. meta::
    :title lang=zh_CN: Callback Methods
    :keywords lang=zh_CN: querydata,query conditions,model classes,callback methods,special functions,return values,counterparts,array,logic,decisions