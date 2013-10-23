回调方法
################

如果你想恰好在 CakePHP 模型操作之前或之后插入一些逻辑，请使用模型的回调方法。这些函数可以定义在模型类(包括你的 AppModel 类)中。一定要注意这些特殊函数各自返回值的不同含义。

当使用回调方法时，应当记住，行为的回调方法在模型的回调方法**之前**触发。

beforeFind
==========

``beforeFind(array $queryData)``

在任何与 find 相关的操作之前调用。传入这个回调方法的 ``$queryData`` 含有与当前查询相关的信息: conditions，fields，等等。

如果你不希望 find 操作开始(可以基于与 ``$queryData`` 所含信息相关的判断)，就返回 *false*。不然，可以返回更改了的 ``$queryData``，或者任何你想传给 find 及其它查询方法的数据。

你可以用这个回调方法根据用户的角色来限制 find 操作，或者根据当前的负载来确定缓存的策略。

afterFind
=========

``afterFind(array $results, boolean $primary = false)``

用这个回调方法来改变从 find 操作返回的结果，或者执行任何其他 find 之后的逻辑。传入这个回调方法的 $results 参数包含从模型的 find 操作返回的结果，象这样::

    $results = array(
        0 => array(
            '模型名称' => array(
                '字段_1' => '值1',
                '字段_2' => '值2',
            ),
        ),
    );

这个回调方法的返回值应当是给触发这个回调的 find 操作的(可能被改动过的)结果。

``$primary`` 参数说明当模型是查询起始的模型，还是作为关联模型查询到的。如果模型是作为关联模型查询的，``$results`` 的格式会有所不同; 与通常从 find 操作获得的结果不同，你可能会得到::

    $results = array(
        '字段_1' => '值1',
        '字段_2' => '值2'
    );

.. warning::

    期待 ``$primary`` 为 true 的代码，如果使用递归查询(*recursive find*) ，可能会从PHP得到 "Cannot
    use string offset as an array" 的严重错误。

下面的例子说明如何用 afterfind 来格式化日期::

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

这个回调可以用来在验证之前改变模型数据，或者在需要时改变验证规则。,这个函数也必须返回 *true*，否则当前 save() 的执行就会中断。

beforeSave
==========

``beforeSave(array $options = array())``

把任何 save 之前的逻辑放在这个函数里。这个函数紧跟在模型数据成功验证后，但在数据即将保存之前，执行。如果你要 save 操作继续执行，这个函数也要返回 true。

对于在数据保存之前要进行的任何修正数据的逻辑，这个回调是尤其方便的。如果你的存储引擎需要某种格式的日期，可以在 $this->data 得到日期字段并进行修改。

下面是一个如何使用 beforeSave 来转换日期的例子。例子中的应用程序代码，把 begindate 在数据库中格式化成 YYYY-MM-DD，而在应用程序中显示成 DD-MM-YYYY。当然这很容易改变。在相应的模型中使用下面的代码。

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

    确保 beforeSave() 返回 true，否则保存就会失败。

afterSave
=========

``afterSave(boolean $created)``

如果你有每次保存操作之后都要执行的逻辑，就把它放在这个回调方法中。

如果创建一条新记录(而非更新)，``$created`` 的值就会是 true。

beforeDelete
============

``beforeDelete(boolean $cascade = true)``

任何删除之前的逻辑，请放在这个函数中。 如果你要继续删除，此函数应当返回 true，如果想放弃删除就返回 false。

如果依赖于当前这条记录的其他记录也要删除的话,``$cascade``的值将会是``true``。

.. tip::

    确保 beforeDelete() 返回 true，否则删除就会失败。

::

    // using app/Model/ProductCategory.php
    // 在下面的例子中，如果一个产品类别还有产品，则不允许删除 。
    // 对 ProductsController.php 中的 $this->Product->delete($id) 的调用设置了 $this->id。
    // 假设 'ProductCategory 有很多(*hasMany*) Product'，我们可以在模型中访问 $this->Product。
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

onError
=======

``onError()``

任何问题发生都会调用。


.. meta::
    :title lang=en: Callback Methods
    :keywords lang=en: querydata,query conditions,model classes,callback methods,special functions,return values,counterparts,array,logic,decisions