Deleting Data
#############

CakePHP's Model class offers a few ways to delete records from your database.
CakePHP的模型类提供了很多种从数据库中删除记录的方法
.. _model-delete:

delete
======

``delete(int $id = null, boolean $cascade = true);``

Deletes the record identified by $id. By default, also deletes
records dependent on the record specified to be deleted.

删除指定id的记录

For example, when deleting a User record that is tied to many
Recipe records (User 'hasMany' or 'hasAndBelongsToMany' Recipes):

举例，当删除一个用户，每个用户可能包含很多条食谱记录(User 'hasMany' or 'hasAndBelongsToMany' Recipes)

-  if $cascade is set to true, the related Recipe records are also
   deleted if the model's dependent-value is set to true.
-  if $cascade is set to false, the Recipe records will remain
   after the User has been deleted.

-  如果$cascade为true,并且被关联的模型中dependent值为true,删除该用户会同时删除关联的食谱记录。
-  如果$cascade为false,删除该用户不会删除关联的食谱记录。

If your database supports foreign keys and cascading deletes, it's often more
efficient to rely on that feature than CakePHP's cascading. The one benefit to
using the cascade feature of ``Model::delete()`` is that it allows you to
leverage behaviors and model callbacks::

如果你使用的数据库支持外键和级联删除，会比cakephp自带的级联删除效率更高。使用模型中的delete方法好处之一是他允许你使用下面的回调函数

    $this->Comment->delete($this->request->data('Comment.id'));

You can hook custom logic into the delete process using the ``beforeDelete`` and
``afterDelete`` callbacks present in both Models and Behaviors.  See
:doc:`/models/callback-methods` for more information.

在删除操作中，你可以在beforeDelete()和afterDelete()方法中添加自己的业务逻辑
.. _model-deleteall:

deleteAll
=========

``deleteAll(mixed $conditions, $cascade = true, $callbacks = false)``

``deleteAll()`` is similar to ``delete()``, except that
``deleteAll()`` will delete all records that match the supplied
conditions. The ``$conditions`` array should be supplied as a SQL
fragment or array.

deleteAll()`与delete()类似，deleteAll()会删除所匹配条件，$conditions可以是SQL语句片段或数组


* **conditions** Conditions to match
* **cascade** Boolean, Set to true to delete records that depend on
  this record
* **callbacks** Boolean, Run callbacks

Return boolean True on success, false on failure.

Example::

    // Delete with array conditions similar to find()
    $this->Comment->deleteAll(array('Comment.spam' => true), false);

If you delete with either callbacks and/or cascade, rows will be found and then
deleted. This will often result in more queries being issued.

.. note::

    deleteAll() will return true even if no records are deleted, as the conditions
    for the delete query were successful and no matching records remain.

注意：如果查询条件执行成功但没有匹配的记录，造成没有任何记录被删除，deleteAll()也将返回真

.. meta::
    :title lang=en: Deleting Data
    :keywords lang=en: doc models,custom logic,callback methods,model class,database model,callbacks,information model,request data,deleteall,fragment,leverage,array,cakephp,failure,recipes,benefit,delete,data model
