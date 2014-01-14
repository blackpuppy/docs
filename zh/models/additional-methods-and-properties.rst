额外的方法和属性
#################################

虽然CakePHP的模型函数会在你需要的地方才用到，但不要忘了他的本质: 类
你可以在模型类中定义自己的方法和属性。

处理任何保存或获取数据的操作最好都写在模型中。这个概念通常被称为fat model。
::

    class Example extends AppModel {
        public function getRecent() {
            $conditions = array(
                'created BETWEEN (curdate() - interval 7 day) and (curdate() - interval 0 day))'
            );
            return $this->find('all', compact('conditions'));
        }
    }

这个 ``getRecent()`` 方法现在可以被运用在控制器中。

::

    $recent = $this->Example->getRecent();

:php:meth:`Model::associations()`
=================================

获得关联信息::

    $result = $this->Example->associations();
    // $result 等于 array('belongsTo', 'hasOne', 'hasMany', 'hasAndBelongsToMany')

:php:meth:`Model::buildQuery(string $type = 'first', array $query = array())`

=============================================================================

构建查询数组，用于数据源生成查询来获取数据。

:php:meth:`Model::deconstruct(string $field, mixed $data)`
==========================================================

把复杂的数据类型(数组或对象)拆分成单个字段值。
Deconstructs a complex data type (array or object) into a single field value.

:php:meth:`Model::escapeField(string $field = null, string $alias = null)`
==========================================================================

转义列名并前缀上模型名，是按照当前数据库驱动的规则进行转义
Escapes the field name and prepends the model name. Escaping is done according
to the current database driver's rules.

:php:meth:`Model::exists($id)`
==============================

如果存在特定ID记录，返回true。
Returns true if a record with the particular ID exists.

若没有提供ID，会调用 :php:meth:`Model::getID()` 方法获得当前的记录ID。然后执行 ``Model::find('count')``
以确认在当前的配置数据源中是否在持久存储中存在该记录。

If ID is not provided it calls :php:meth:`Model::getID()` to obtain the current record ID to verify, and
then performs a ``Model::find('count')`` on the currently configured datasource to
ascertain the existence of the record in persistent storage.

.. note ::

    $id参数是2.1中新增的。在此之前它不带任何参数。
    Parameter $id was added in 2.1. Prior to that it does not take any parameter.

::

    $this->Example->id = 9;
    if ($this->Example->exists()) {
        // ...
    }

    $exists = $this->Foo->exists(2);

:php:meth:`Model::getAffectedRows()`
====================================

返回上次查询的影响行的数量
Returns the number of rows affected by the last query.

:php:meth:`Model::getAssociated(string $type = null)`
=====================================================

获取关联此模型的所有模型。
Gets all the models with which this model is associated.

:php:meth:`Model::getColumnType(string $column)`
================================================

返回模型中指定列的列类型。

:php:meth:`Model::getColumnTypes()`
===================================

返回模型中所有的列名和列类型的关联数组。

:php:meth:`Model::getID(integer $list = 0)`
===========================================

返回当前记录的ID.

:php:meth:`Model::getInsertID()`
================================

返回上一条插入记录的ID.

:php:meth:`Model::getLastInsertID()`
====================================

``getInsertID()``的别名.

.. meta::
    :title lang=en: Additional Methods and Properties
    :keywords lang=en: model classes,model functions,model class,interval,array
