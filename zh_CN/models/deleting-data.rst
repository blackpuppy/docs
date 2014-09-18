删除数据
#############

CakePHP的模型类提供了多种从数据库中删除记录的方法。

.. _model-delete:

delete方法 
======

``delete(int $id = null, boolean $cascade = true);``

删除指定$id的记录。默认情况下，会级联删除依赖于该记录的记录。

例如，当删除一个包含许多条食谱(Recipe)记录的用户(User)(用户绑定了 'hasMany' 或 'hasAndBelongsToMany' Recipes)。

-  如果$cascade设置为true,并且被关联的模型中dependent属性值为true,删除用户的同时，会删除关联该用户的食谱记录。
-  如果$cascade设置为false,删除该用户不会删除关联的食谱记录。

如果你使用的数据库支持外键和级联删除，会比cakephp自带的级联删除效率更高。
使用模型中的 ``Model::delete()`` 方法好处之一是允许你使用行为及回调函数。::

    $this->Comment->delete($this->request->data('Comment.id'));

在处理删除操作中，可以在自定义业务逻辑使用 ``beforeDelete`` 和 ``afterDelete`` 方法。
这些方法存在于模型和行为中。更多信息参见 :doc:`/models/callback-methods`。

.. _model-deleteall:

deleteAll
=========

``deleteAll(mixed $conditions, $cascade = true, $callbacks = false)``

``deleteAll()`` 除了将删除匹配条件的所有记录外，与 ``delete()`` 类似。
``$conditions`` 条件可以是SQL语句片段或数组形式。 

* **conditions** 匹配的条件
* **cascade** 布尔型，设置true，会导致级联删除
* **callbacks** 布尔型, 执行回调函数

执行成功返回true，失败返回false。

Example::

    // 与 find() 方法类似，删除满足条件的记录
    $this->Comment->deleteAll(array('Comment.spam' => true), false);

如果删除操作的同时满足级联删除或回调函数，会导致执行多条SQL语句。

.. note::

    如果删除条件执行正确但没有找到匹配的记录，造成没有任何记录被删除，deleteAll() 也将返回true。

.. meta::
    :title lang=zh_CN: Deleting Data
    :keywords lang=zh_CN: doc models,custom logic,callback methods,model class,database model,callbacks,information model,request data,deleteall,fragment,leverage,array,cakephp,failure,recipes,benefit,delete,data model
