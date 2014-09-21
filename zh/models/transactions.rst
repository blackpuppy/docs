事务处理
############


要执行事务，模型所对应的表必须支持事务。

所有的事务处理方法必须通过模型的数据源对象来执行。在模型中获得模型的数据源的方式如下::

    $dataSource = $this->getDataSource();

接着你可以使用数据源来开始、提交或者回滚事务。

::

    $dataSource->begin();

    // 执行一些任务

    if (/*all's well*/) {
        $dataSource->commit();
    } else {
        $dataSource->rollback();
    }

嵌套事务 Nested Transactions
-------------------

可以多次使用`Datasource::begin()`方法来开始事务。只有当提交事务或回滚事务的次数与开始事务的次数一致时，事务才会结束::

    $dataSource->begin();
    // 执行一些任务
    $dataSource->begin();
    // 再执行几个任务
    if (/*最新的任务执行成功*/) {
        $dataSource->commit();
    } else {
        $dataSource->rollback();
        // 在主任务中改变一些东西
    }
    $dataSource->commit();

如果数据库支持嵌套事务并且在数据源中开启，嵌套事务会被执行。如果不支持嵌套事务或者没有开启，方法将会总是返回true。

如果你想多次开始事务但不使用数据库的嵌套事务，用``$dataSource->useNestedTransactions = false;``来关闭嵌套事务。这将会仅使用全局事务。

实际的嵌套事务默认设为false。使用``$dataSource->useNestedTransactions = true;``来开启它。

.. meta::
    :title lang=zh_CN: Transactions
    :keywords lang=zh_CN: transaction methods,datasource,rollback,data source,begin,commit,nested transaction
