保存数据
################

CakePHP 中用模型保存数据非常方便。只需将保存的数据以数组格式传递给模型的 ``save()`` 方法。::

    Array
    (
        [ModelName] => Array
        (
            [fieldname1] => 'value'
            [fieldname2] => 'value'
        )
    )

多数时候你无需担心这种格式:
CakePHP的:php:class:`FormHelper`和模型的find 方法都会将数据处理成这种格式。
如果使用其它的助手，数据也能方便地以 ``$this->request->data`` 形式使用。

下面是使用 CakePHP 模型向数据库表存入数据的控制器动作的示例::

    public function edit($id) {
        // 是否有通过POST方法过来的数据？
        if ($this->request->is('post')) {
            // 如果表单数据能够通过校验并保存成功......
            if ($this->Recipe->save($this->request->data)) {
                // 设置 session 信息并跳转
                $this->Session->setFlash('Recipe Saved!');
                $this->redirect('/recipes');
            }
        }

        // 如果没有表单数据，查找recipe表中记录使其可以被编辑
        // 并将其赋值给视图
        $this->set('recipe', $this->Recipe->findById($id));
    }

当调用 save 方法，在第一个参数中传递给它的数据会经过CakePHP的校验机制校验数据(参见章节 :doc:`/models/data-validation` 以获取更多信息)。如果因为某些原因，数据没有被保存，检查一下是不是没有符合某些校验规则。
可以通过输出 :php:attr:`Model::$validationErrors` 来进行调试。 ::

    if ($this->Recipe->save($this->request->data)) {
        // "保存" 成功后的处理逻辑。
    }
    debug($this->Recipe->validationErrors);

其它一些与保存相关的有用的模型方法:

:php:meth:`Model::set($one, $two = null)`
=========================================

``Model::set()`` 能够用于将数据的一个或多个字段放入模型的 data 数组。当使用带有 ActiveRecord特性的模型时很有用。 ::

    $this->Post->read(null, 1);
    $this->Post->set('title', 'New title for the article');
    $this->Post->save();

此例展示了如何使用 ActiveRecord 的 ``set()`` 方法更新和保存单个列。还可以使用 set() 给多个字段赋新值。 ::

    $this->Post->read(null, 1);
    $this->Post->set(array(
        'title' => 'New title',
        'published' => false
    ));
    $this->Post->save();

上例将更新thitle和published字段并保存到数据库中。

:php:meth:`Model::save(array $data = null, boolean $validate = true, array $fieldList = array())`
=================================================================================================

这个方法保存数组格式的数据。第二个参数允许跳过校验，第三个参数允许提供要保存字段的列表。为了提高安全性，可以使用 ``$fieldList`` 限制要保存的字段。

.. note::

    如果不提供``$fieldList``，恶意的用户能够向表单数据中添加附加的字段（在你没有使用 :php:class:`SecurityComponent`的情况下），并通过这种方法来改变原本不希望被改变的字段。

save 方法还有一个替代语法。 ::

    save(array $data = null, array $params = array())

``$params`` 数组可以用如下选项作为其键:

* ``validate`` 可为 true/false 是否开启校验。
* ``fieldList`` 由允许保存的字段构成的数组。
* ``callbacks`` false将禁止回调。使用 'before' 或 'after' 将仅允许指定的回调。

关于模型回调的更多信息请参见 :doc:`here <callback-methods>`

.. tip::

    如果你不想保存数据时自动更新``modified``列，在 $data 数组中添加 'updated' => false。

一旦保存完成，可以使用模型对象的 ``$id`` 属性获得对象的 ID - 在创建新对象时可能会非常方便。

::

    $this->Ingredient->save($newData);
    $newIngredientId = $this->Ingredient->id;

创建或更新是通过模型的 ``id`` 列来控制的。如果设置了 $Model->id，带有这个主键的记录将被更新。 其它情况下，一条新记录被创建::

    // 建新记录：id 没有设置或为 null
    $this->Recipe->create();
    $this->Recipe->save($this->request->data);

    // 更新记录： id 被设置为一个数值
    $this->Recipe->id = 2;
    $this->Recipe->save($this->request->data);

.. tip::

    在循环中调用 save 时，不要忘记调用``create()``。

如果想更新一个值，而不是创建一条新记录，请确保向数据数组传递了主键列::

    $data = array('id' => 10, 'title' => 'My new title');
    // 将更新 id 为 10 的 Recipe 记录
    $this->Recipe->save($data);

:php:meth:`Model::create(array $data = array())`
================================================

这个方法为保存新信息重置模型的状态。 
实际上它并不向数据库中创建新记录，而是清除预先设置的 Model::$id，并在 Model::$data 中设置基于数据库列默认的默认值。如果没有定义数据库字段的默认值，Model::$data会被设置一个空数组。

如果传递了 ``$data`` 参数（使用上面描述的数组格式），模型实例将准备保存这些数据(使用 ``$this->data``)。

如果用 ``false`` 或 ``null`` 传递给 ``$data`` 参数，Model::data会被设置为一个空数组。

.. tip::

    如果要插入一新行而不是更新已存在的一行，必须先调用 create()。这样能够避免与其它位置中曾调用过的 save 发生冲突。



:php:meth:`Model::saveField(string $fieldName, string $fieldValue, $validate = false)`
======================================================================================

用于保存单个列的值。在使用 saveField() 之前要先设置模型的 ID (``$this->ModelName->id = $id``)。
在使用这个方法时，``$fieldName`` 仅需要包含列名，不需要模型名和列。

例如，更新一条博客的标题，可以用如下方式在控制器中调用 ``saveField``::

    $this->Post->saveField('title', 'A New Title for a New Day');

.. 警告::

    在使用这个方法更新时不能停止 ``modified`` 列，你需要使用 save() 方法。

saveField 方法也有一个替代语法：::

    saveField(string $fieldName, string $fieldValue, array $params = array())

``$params`` 数组可以用如下选项作为其键:

* ``validate`` 可为 true/false 是否开启校验。
* ``callbacks`` 设置为 false 将禁止回调。使用 'before' 或 'after' 将仅允许指定的回调。

:php:meth:`Model::updateAll(array $fields, array $conditions)`
==============================================================

一次调用更新一条或多条记录。通过``$conditions`` 数组标识被更新的记录，$fields 参数指定被更新的列。

例如，批准所有超过一年的bakers成为会员，调用如下的更新语句。 ::


    $this_year = date('Y-m-d h:i:s', strtotime('-1 year'));

    $this->Baker->updateAll(
        array('Baker.approved' => true),
        array('Baker.created <=' => $this_year)
    );

.. tip::

    $fields 数组可接受 SQL 表达式。字面值使用 Sanitize::escape() 手动引用。

    The $fields array accepts SQL expressions. Literal values should be
    quoted manually using :php:meth:`Sanitize::escape()`.

.. note::

    即使列中存在 modified列要被更新，它也不会通过 ORM 自动更新。必须手动将其加入到你想更新的数组中。

例如，关闭所有属于一个特定客户的门票::

    $this->Ticket->updateAll(
        array('Ticket.status' => "'closed'"),
        array('Ticket.customer_id' => 453)
    );

默认情况下，updateAll() 将自动连接支持 join 的数据库的 belongsTo 关联。通过临时绑定关联能够防止这种连接。

:php:meth:`Model::saveMany(array $data = null, array $options = array())`
=========================================================================

此方法用于同时保存同一模型的多行。可以带有如下选项:


* ``validate``: 设置为 false 将禁止校验，设置为 true 将在保存前校验每条记录，设置为'first'将在任意一条被保存前检查  *all* 记录(默认值)

* ``atomic``: 如果为 true(默认值)，将在single transaction中保存所有记录，如果 数据库/表 不支持transactions需要设置为 false。

*  ``fieldList``: 与 Model::save() 方法的 $fieldList 参数相同。

*  ``deep``: (自 2.1 版开始) 如果设置为 true，关联数据也被保存，参见 saveAssociated。

为单个模型保存多条记录，$data需要是数字索引的记录数组。 ::

    $data = array(
        array('title' => 'title 1'),
        array('title' => 'title 2'),
    );

.. note::

    我们传递了数字索引代替了通常情况下 $data 包含的 Article 键。在保存同一模型的多条记录时，记录数组需要使用数字索引，而不是模型的键。

    Note that we are passing numerical indices instead of usual
    ``$data`` containing the Article key. When saving multiple records
    of same model the records arrays should be just numerically indexed
    without the model key.

它也可以接受如下格式的数据：

    $data = array(
        array('Article' => array('title' => 'title 1')),
        array('Article' => array('title' => 'title 2')),
    );

如果还要保存关联数据，还要带上 $options['deep'] = true (2.1 版本起)，上面的两个例子将类似于下面的代码::
To save also associated data with ``$options['deep'] = true`` (since 2.1), the two above examples would look like::

    $data = array(
        array('title' => 'title 1', 'Assoc' => array('field' => 'value')),
        array('title' => 'title 2'),
    );
    $data = array(
        array('Article' => array('title' => 'title 1'), 'Assoc' => array('field' => 'value')),
        array('Article' => array('title' => 'title 2')),
    );
    $Model->saveMany($data, array('deep' => true));

切记，如果只想更新记录而不是创建新记录，需要向数据行添加主键索引::

    $data = array(
        array('Article' => array('title' => 'New article')), // This creates a new row
        array('Article' => array('id' => 2, 'title' => 'title 2')), // This updates an existing row
    );


:php:meth:`Model::saveAssociated(array $data = null, array $options = array())`
===============================================================================

此方法用于一次保存多个模型关联。可以带有如下选项：

Method used to save multiple model associations at once. The following
options may be used:

* ``validate``: 设置为 false 将禁止校验，设置为 true 将在保存前校验每条记录，设置为'first'将在任意一条被保存前检查  *all* 记录(默认值)
* ``atomic``: 如果为 true(默认值)，将在single transaction中保存所有记录，如果 数据库/表 不支持transactions需要设置为 false。

*  ``fieldList``: 与 Model::save() 方法的 $fieldList 参数相同。

*  ``deep``: (自 2.1 版开始) 如果设置为 true，关联数据也被保存，默认为false 参见 saveAssociated。
* ``deep``: (since 2.1) If set to true, not only directly associated data is saved,
  but deeper nested associated data as well. Defaults to false.

为了保存记录的同时保存与其有着 hasOne 或者 belongsTo 关联的记录，data 数组格式可以如下::

For saving a record along with its related record having a hasOne
or belongsTo association, the data array should be like this::

    $data = array(
        'User' => array('username' => 'billy'),
        'Profile' => array('sex' => 'Male', 'occupation' => 'Programmer'),
    );

为了保存记录的同时，保存与其有着 hasMany 关联的记录，data 数组格式可以如下::

For saving a record along with its related records having hasMany
association, the data array should be like this::

    $data = array(
        'Article' => array('title' => 'My first article'),
        'Comment' => array(
            array('body' => 'Comment 1', 'user_id' => 1),
            array('body' => 'Comment 2', 'user_id' => 12),
            array('body' => 'Comment 3', 'user_id' => 40),
        ),
    );

为了保存记录的同时保存与其有着超过两层深度的 hasMany 关联的记录，data 数组格式可以如下::

And for saving a record along with its related records having hasMany with more than two
levels deep associations, the data array should be as follow::

    $data = array(
        'User' => array('email' => 'john-doe@cakephp.org'),
        'Cart' => array(
            array(
                'payment_status_id' => 2,
                'total_cost' => 250,
                'CartItem' => array(
                    array(
                        'cart_product_id' => 3,
                        'quantity' => 1,
                        'cost' => 100,
                    ),
                    array(
                        'cart_product_id' => 5,
                        'quantity' => 1,
                        'cost' => 150,
                    )
                )
            )
        )
    );

.. note::

    如果保存成功，主模型的外键将被存储在相关模型的id字段中，例如 $this->RelatedModel->id

    If successful, the foreign key of the main model will be stored in
    the related models' id field, i.e. ``$this->RelatedModel->id``.

.. warning::

    在调用 atomic 选项设置为 false 的 saveAssociated 方法时要小心的进行检查，它返回的是一个数组，而不是布尔值

    Be careful when checking saveAssociated calls with atomic option set to
    false. It returns an array instead of boolean.

.. versionchanged:: 2.1

    现在你可以保存深层关联的数据(用 $options['deep'] = true 设置)

    You can now save deeper associated data as well with setting ``$options['deep'] = true;``

为了保存记录的同时，保存与其有 hasMany 关联的相关记录及深层关联的 Comment belongsTo User 数据，data 数组格式可以如下::

For saving a record along with its related records having hasMany
association and deeper associated Comment belongsTo User data as well,
the data array should be like this::

    $data = array(
        'Article' => array('title' => 'My first article'),
        'Comment' => array(
            array('body' => 'Comment 1', 'user_id' => 1),
            array('body' => 'Save a new user as well', 'User' => array('first' => 'mad', 'last' => 'coder')),
        ),
    );

并用如下语句进行保存::

And save this data with::

    $Article->saveAssociated($data, array('deep' => true));

.. versionchanged:: 2.1

    ``Model::saveAll()`` 和类似方法现在支持为多个模型传递`fieldList`选项

    ``Model::saveAll()`` and friends now support passing the `fieldList` for multiple models.

为多个模型传递 ``fieldList`` 的例子::

Example of using ``fieldList`` with multiple models::

    $this->SomeModel->saveAll($data, array(
        'fieldList' => array(
            'SomeModel' => array('field_1'),
            'AssociatedModel' => array('field_2', 'field_3')
        )
    ));

fieldList 是一个以模型别名为键，以列构成的数组作为值的数组。 模型名如同在被保存的数据中那样，不能嵌套。

The fieldList will be an array of model aliases as keys and arrays with fields as values.
The model names are not nested like in the data to be saved.

:php:meth:`Model::saveAll(array $data = null, array $options = array())`
========================================================================

``saveAll``函数只是 ``saveMany`` 和 ``saveAssociated``方法的包装器。它检查数据并且决定执行哪种数据保存类型。它查看数据并决定执行哪种类型的保存。
如果数据是数字索引数组，``saveMany`` 被调用，否则 saveAssociated 被调用。

The ``saveAll`` function is just a wrapper around the ``saveMany`` and ``saveAssociated``
methods. it will inspect the data and determine what type of save it should perform. If
data is formatted in a numerical indexed array, ``saveMany`` will be called, otherwise
``saveAssociated`` is used.

此函数的选项与前面的两个函数相同，并向后兼容。推荐根据实际情况使用 ``saveMany`` 或 ``saveAssociated``。

This function receives the same options as the former two, and is generally a backwards
compatible function. It is recommended using either ``saveMany`` or ``saveAssociated``
depending on the case.


保存相关模型的数据（hasOne, hasMany, belongsTo）  
Saving Related Model Data (hasOne, hasMany, belongsTo)
======================================================

在与关联模型一起工作时，When working with associated models, 
一定要意识到模型数据的保存总是由相应有 CakePHP 模型来完成。
如果保存一条新的 Post 和它关联的 Comment，就需要在保存操作的过程中同时使用 Post 和 Comment 模型。

如果系统中还不存在关联模型记录（例如，想要保存新的 User，同时保存相关的 Profile 记录），
需要先保存主模型或者父模型。

为了了解这是如何工作的，想像一下我们在处理保存新用 User 和相关 Profile 的控制器中有一个动作。
下面的示例动作假设已经为创建单个 User 和单个 Profile，POST 了足够的数据（使用 FormHelper）：

When working with associated models, it is important to realize
that saving model data should always be done by the corresponding
CakePHP model. If you are saving a new Post and its associated
Comments, then you would use both Post and Comment models during
the save operation.

If neither of the associated model records exists in the system yet
(for example, you want to save a new User and their related Profile
records at the same time), you'll need to first save the primary,
or parent model.

To get an idea of how this works, let's imagine that we have an
action in our UsersController that handles the saving of a new User
and a related Profile. The example action shown below will assume
that you've POSTed enough data (using the FormHelper) to create a
single User and a single Profile::

    public function add() {
        if (!empty($this->request->data)) {
            // 我们能保存 User 数据：
            // 它放在 $this->request->data['User'] 中
            // We can save the User data:
            // it should be in $this->request->data['User']

            $user = $this->User->save($this->request->data);

            // 如果用户被保存，添加这条信息到数据并保存 Profile。
            // If the user was saved, Now we add this information to the data
            // and save the Profile.

            if (!empty($user)) {
                // 新创建的 User ID 已经被赋值给 $this->User->id.
                // The ID of the newly created user has been set
                // as $this->User->id.
                $this->request->data['Profile']['user_id'] = $this->User->id;

                // 由于 User hasOne Profile，因此可以通过 User 模型访问 Profile 模型：
                // Because our User hasOne Profile, we can access
                // the Profile model through the User model:
                $this->User->Profile->save($this->request->data);
            }
        }
    }

作为一条规则，当带有 hasOne、hasMany、belongsTo 关联时，全部与键有关。基本思路是从一个模型中获取键，并将其放入另一个模型的外键列中。
有时需要涉及使用``save()``后的模型类的``$id`` 属性，
但是其它情况下只涉及从 POST 给控制器动作的表单的隐藏域（hidden input）中得到的 ID。

作为上述基本方法的补充，CakePHP 还提供了一个非常有用的方法 ``saveAssociated()``，它允许你用一个简短的方式校验和保存多个模型。另外，``saveAssociated()`` 还提供了事务支持以确保数据库中的数据的完整（例如，一个模型保存失败，另一个模型也就不保存了）。

As a rule, when working with hasOne, hasMany, and belongsTo
associations, it's all about keying. The basic idea is to get the
key from one model and place it in the foreign key field on the
other. Sometimes this might involve using the ``$id`` attribute of
the model class after a ``save()``, but other times it might just
involve gathering the ID from a hidden input on a form that’s just
been POSTed to a controller action.

To supplement the basic approach used above, CakePHP also offers a
very handy method ``saveAssociated()``, which allows you to validate and
save multiple models in one shot. In addition, ``saveAssociated()``
provides transactional support to ensure data integrity in your
database (i.e. if one model fails to save, the other models will
not be saved either).

.. note::

    为使事务工作在 MySQL 中正常工作，表必须使用 InnoDB 引擎。记住，MyISAM 表不支持事务。
    For transactions to work correctly in MySQL your tables must use
    InnoDB engine. Remember that MyISAM tables do not support
    transactions.

来看看如何使用 ``saveAssociated()`` 同时保存 Company 和 Account 模型吧。
Let's see how we can use ``saveAssociated()`` to save Company and Account
models at the same time。

首先，需要同时为 Company 和 Account 创建表单(假设 Company hasMany Account)::
First, you need to build your form for both Company and Account
models (we'll assume that Company hasMany Account)::

    echo $this->Form->create('Company', array('action' => 'add'));
    echo $this->Form->input('Company.name', array('label' => 'Company name'));
    echo $this->Form->input('Company.description');
    echo $this->Form->input('Company.location');

    echo $this->Form->input('Account.0.name', array('label' => 'Account name'));
    echo $this->Form->input('Account.0.username');
    echo $this->Form->input('Account.0.email');

    echo $this->Form->end('Add');

看看为 Acount 模型命名表单列的方法。如果 Company 是主模型，``saveAssociated()``期望相关模型（Account）数据以指定的格式放进数组。并且拥有我们需要的 Account.0.fieldName。

Take a look at the way we named the form fields for the Account
model. If Company is our main model, ``saveAssociated()`` will expect the
related model's (Account) data to arrive in a specific format. And
having ``Account.0.fieldName`` is exactly what we need.

.. note::

    上面的列命名对于 hasMany 关联是必须的。如果关联是 hasOne，你就得为关联模型使用 ModelName.fieldName 了。

    The above field naming is required for a hasMany association. If
    the association between the models is hasOne, you have to use
    ModelName.fieldName notation for the associated model.

现在，可以在 CompaniesController 中创建``add()``动作了::

Now, in our CompaniesController we can create an ``add()``
action::

    public function add() {
        if (!empty($this->request->data)) {
            // Use the following to avoid validation errors:
            unset($this->Company->Account->validate['company_id']);
            $this->Company->saveAssociated($this->request->data);
        }
    }

这就是全部的步骤了。现在 Company 和 Account 模型将同时被校验和保存。默认情况下，``saveAssociated`` 将检验传递过来的全部值，然后尝试执行每一个保存。

That's all there is to it. Now our Company and Account models will
be validated and saved all at the same time. By default ``saveAssociated``
will validate all values passed and then try to perform a save for each.

通过数据保存 hasMany  Saving hasMany through data
===========================

让我们来看看存在在 join 表里的两个模型的数据是如何保存的。就像 :ref:`hasMany-through` 一节展示的那样，
join 表是用 `hasMany` 类型的关系关联到每个模型的。 我们的例子包括 Cake 学校的负责人要求我们写一个程序允许它记录一个学生在某门课上出勤的天数和等级。下面是示例代码.::

Let's see how data stored in a join table for two models is saved. As shown in the :ref:`hasMany-through`
section, the join table is associated to each model using a `hasMany` type of relationship.
Our example involves the Head of Cake School asking us to write an application that allows
him to log a student's attendance on a course with days attended and grade. Take
a look at the following code.::

   // Controller/CourseMembershipController.php
   class CourseMembershipsController extends AppController {
       public $uses = array('CourseMembership');

       public function index() {
           $this->set('courseMembershipsList', $this->CourseMembership->find('all'));
       }

       public function add() {
           if ($this->request->is('post')) {
               if ($this->CourseMembership->saveAssociated($this->request->data)) {
                   $this->redirect(array('action' => 'index'));
               }
           }
       }
   }

   // View/CourseMemberships/add.ctp

   <?php echo $this->Form->create('CourseMembership'); ?>
       <?php echo $this->Form->input('Student.first_name'); ?>
       <?php echo $this->Form->input('Student.last_name'); ?>
       <?php echo $this->Form->input('Course.name'); ?>
       <?php echo $this->Form->input('CourseMembership.days_attended'); ?>
       <?php echo $this->Form->input('CourseMembership.grade'); ?>
       <button type="submit">Save</button>
   <?php echo  $this->Form->end(); ?>

提交的数据数组如下.::
The data array will look like this when submitted.::

    Array
    (
        [Student] => Array
        (
            [first_name] => Joe
            [last_name] => Bloggs
        )

        [Course] => Array
        (
            [name] => Cake
        )

        [CourseMembership] => Array
        (
            [days_attended] => 5
            [grade] => A
        )

    )

Cake 会很乐意使用一个带有这种数据结构的 `saveAssociated` 调用就能同时保存很多，
并将 Student 和 Course 的外键赋予 CouseMembership。
如果我们运行 CourseMembershipsController 上的 index 动作，从 find(‘all’) 中获取的数据结构如下::

Cake will happily be able to save the lot together and assign
the foreign keys of the Student and Course into CourseMembership
with a `saveAssociated` call with this data structure. If we run the index
action of our CourseMembershipsController the data structure
received now from a find('all') is::

    Array
    (
        [0] => Array
        (
            [CourseMembership] => Array
            (
                [id] => 1
                [student_id] => 1
                [course_id] => 1
                [days_attended] => 5
                [grade] => A
            )

            [Student] => Array
            (
                [id] => 1
                [first_name] => Joe
                [last_name] => Bloggs
            )

            [Course] => Array
            (
                [id] => 1
                [name] => Cake
            )
        )
    )

当然，还有很多带有连接模型的工作的方法。上面的版本假定你想要立刻保存每样东西。 
还有这样的情况：你想独立地创建 Student 和 Course，稍后再指定两者与 CourseMembership 的关联。 因此你可能有一个允许利用列表或ID选择存在的学生和课程及两个 CourseMembership 元列的表单，例如.::

There are of course many ways to work with a join model. The
version above assumes you want to save everything at-once. There
will be cases where you want to create the Student and Course
independently and at a later point associate the two together with
a CourseMembership. So you might have a form that allows selection
of existing students and courses from pick lists or ID entry and
then the two meta-fields for the CourseMembership, e.g.::

        // View/CourseMemberships/add.ctp

        <?php echo $this->Form->create('CourseMembership'); ?>
            <?php echo $this->Form->input('Student.id', array('type' => 'text', 'label' => 'Student ID', 'default' => 1)); ?>
            <?php echo $this->Form->input('Course.id', array('type' => 'text', 'label' => 'Course ID', 'default' => 1)); ?>
            <?php echo $this->Form->input('CourseMembership.days_attended'); ?>
            <?php echo $this->Form->input('CourseMembership.grade'); ?>
            <button type="submit">Save</button>
        <?php echo $this->Form->end(); ?>

所得到的 POST 数据::
And the resultant POST::

    Array
    (
        [Student] => Array
        (
            [id] => 1
        )

        [Course] => Array
        (
            [id] => 1
        )

        [CourseMembership] => Array
        (
            [days_attended] => 10
            [grade] => 5
        )
    )

Cake 利用 saveAssociated 将 Student id 和 Course id 推入 CourseMembership。

Again Cake is good to us and pulls the Student id and Course id
into the CourseMembership with the `saveAssociated`.

.. _saving-habtm:

保存相关模型数据 (HABTM)  Saving Related Model Data (HABTM)
---------------------------------

通过 hasOne、belongsTo、hasMany 保存有关联的模型是非常简单的： 只需要将关联模型的 ID 填入外键列。 填完之后，只要调用模型上的 ``save()`` 方法，一切就都被正确的串连起来了。 
下面是准备传递给 Tag 模型的 ``save()`` 方法的数据数组格式的示例：

Saving models that are associated by hasOne, belongsTo, and hasMany
is pretty simple: you just populate the foreign key field with the
ID of the associated model. Once that's done, you just call the
``save()`` method on the model, and everything gets linked up
correctly. An example of the required format for the data array
passed to ``save()`` for the Tag model is shown below::

    Array
    (
        [Recipe] => Array
            (
                [id] => 42
            )
        [Tag] => Array
            (
                [name] => Italian
            )
    )

也可以在 ``saveAll()`` 中使用这种格式保存多条记录和与它们有 HABTM 关联的的模型，格式如下：

You can also use this format to save several records and their
HABTM associations with ``saveAll()``, using an array like the
following::

    Array
    (
        [0] => Array
            (
                [Recipe] => Array
                    (
                        [id] => 42
                    )
                [Tag] => Array
                    (
                        [name] => Italian
                    )
            )
        [1] => Array
            (
                [Recipe] => Array
                    (
                        [id] => 42
                    )
                [Tag] => Array
                    (
                        [name] => Pasta
                    )
            )
        [2] => Array
            (
                [Recipe] => Array
                    (
                        [id] => 51
                    )
                [Tag] => Array
                    (
                        [name] => Mexican
                    )
            )
        [3] => Array
            (
                [Recipe] => Array
                    (
                        [id] => 17
                    )
                [Tag] => Array
                    (
                        [name] => American (new)
                    )
            )
    )

将上面的数组传递给 ``saveAll()`` 将创建所包含的 tag ，每个都与它们各自的 recipe 关联。

Passing the above array to ``saveAll()`` will create the contained tags,
each associated with their respective recipes.

作为示例，我们建立了创建新 tag 和运行期间生成与 recipe 关联的正确数据数组的表单。

As an example, we'll build a form that creates a new tag and
generates the proper data array to associate it on the fly with
some recipe.

这个简单的表单如下：(我们假定 ``$recipe_id`` 已经设置了)::

The simplest form might look something like this (we'll assume that
``$recipe_id`` is already set to something)::

    <?php echo $this->Form->create('Tag'); ?>
        <?php echo $this->Form->input(
            'Recipe.id',
            array('type' => 'hidden', 'value' => $recipe_id)
        ); ?>
        <?php echo $this->Form->input('Tag.name'); ?>
    <?php echo $this->Form->end('Add Tag'); ?>

在这个例子中，你能看到``Recipe.id``隐藏域，其值被设置为我们的 tag 想要连接的recipe的ID。

In this example, you can see the ``Recipe.id`` hidden field whose
value is set to the ID of the recipe we want to link the tag to.

当在控制器中调用 ``save()`` 方法，它将自动将 HABTM 数据保存到数据库::

When the ``save()`` method is invoked within the controller, it'll
automatically save the HABTM data to the database::

    public function add() {
        // Save the association
        if ($this->Tag->save($this->request->data)) {
            // do something on success
        }
    }

这段代码将创建一个新的 Tag 并与 Recipe 相关联，其 ID 由 ``$this->request->data['Recipe']['id']``设置。

With the preceding code, our new Tag is created and associated with
a Recipe, whose ID was set in ``$this->request->data['Recipe']['id']``.

某些情况下，我们可能希望呈现的关联数据能够包含下拉 select 列表。数据可能使用 ``find('list')`` 从模型中取出并且赋给用模型名命名的视图变量。 同名的 input 将自动把数据放进 ``<select>``::

Other ways we might want to present our associated data can include
a select drop down list. The data can be pulled from the model
using the ``find('list')`` method and assigned to a view variable
of the model name. An input with the same name will automatically
pull in this data into a ``<select>``::

    // 控制器代码:
    $this->set('tags', $this->Recipe->Tag->find('list'));

    // 视图代码:
    $this->Form->input('tags');

更可能的情形是一个 HABTM 关系包含一个允许多选的 ``<select>``。例如，一个 Recipe 可能被赋了多个 Tag。在这种情况下，数据以相同的方式从模型中取出，但是表单 input 定义稍有不同。tag 的命名使用 ``ModelName`` 约定

A more likely scenario with a HABTM relationship would include a
``<select>`` set to allow multiple selections. For example, a
Recipe can have multiple Tags assigned to it. In this case, the
data is pulled out of the model the same way, but the form input is
declared slightly different. The tag name is defined using the
``ModelName`` convention::

    // 控制器代码:
    $this->set('tags', $this->Recipe->Tag->find('list'));

    // 视图代码:
    $this->Form->input('Tag');

使用上面这段代码，将建立可多选的下拉列表（select），允许多选自动被保存到已添加或已保存到数据库中的 Recipe。

Using the preceding code, a multiple select drop down is created,
allowing for multiple choices to automatically be saved to the
existing Recipe being added or saved to the database.

Self HABTM
~~~~~~~~~~

Normally HABTM is used to bring 2 models together but it can also
be used with only 1 model, though it requires some extra attention.

The key is in the model setup the ``className``. Simply adding a
``Project`` HABTM ``Project`` relation causes issues saving data.
By setting the ``className`` to the models name and use the alias as
key we avoid those issues.::

    class Project extends AppModel {
        public $hasAndBelongsToMany = array(
            'RelatedProject' => array(
                'className'              => 'Project',
                'foreignKey'             => 'projects_a_id',
                'associationForeignKey'  => 'projects_b_id',
            ),
        );
    }

Creating form elements and saving the data works the same as before but you use the alias instead. This::

    $this->set('projects', $this->Project->find('list'));
    $this->Form->input('Project');

Becomes this::

    $this->set('relatedProjects', $this->Project->find('list'));
    $this->Form->input('RelatedProject');

当 HABTM 变得复杂时怎么办？
What to do when HABTM becomes complicated?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

默认情况下，当保存 HasAndBelongsToMany 关系时，在保存新记录之前Cake会先删除join表中的所有行。 
例如，有一个拥有10个 Children 关联的 Club表。
带着2个 children 更新 Club。Club 将只有2个 Children，而不是12个。

By default when saving a HasAndBelongsToMany relationship, Cake
will delete all rows on the join table before saving new ones. For
example if you have a Club that has 10 Children associated. You
then update the Club with 2 children. The Club will only have 2
Children, not 12.

要注意，如果想要向带有 HABTM 的连接表添加更多的列（建立时间或者元数据）是可能的，
重要的是要明白你有一个简单的选项。

Also note that if you want to add more fields to the join (when it
was created or meta information) this is possible with HABTM join
tables, but it is important to understand that you have an easy
option.

两个模型间的 HasAndBelongsToMany 关联实际上是同时拥有 hasMany 和 belongsTo 关联的三个模型关系的简写。

HasAndBelongsToMany between two models is in reality shorthand for
three models associated through both a hasMany and a belongsTo
association.

考虑下面的例子::
Consider this example::

    Child hasAndBelongsToMany Club

另一个方法是添加一个 Membership 模型::
Another way to look at this is adding a Membership model::

    Child hasMany Membership
    Membership belongsTo Child, Club
    Club hasMany Membership.

这两个例子几乎是相同的。
它们在数据库中使用了命名相同的 amount 列，模型中的 amount 也是相同的。
最重要的不同是 "join" 表命名不同，并且其行为更具可预知性

These two examples are almost the exact same. They use the same
amount of named fields in the database and the same amount of
models. The important differences are that the "join" model is
named differently and its behavior is more predictable.

.. tip::

    当连接表包含外键以外的扩展列时，通过将数组的 ``'unique'`` 设置为 ``'keepExisting'``，能够防止丢失扩展列的值。同样，可以认为设置 'unique' => true，在保存操作过程中不会丢失扩展列的数据。
    参见 HABTM association arrays。

    When your join table contains extra fields besides two foreign
    keys, you can prevent losing the extra field values by setting
    ``'unique'`` array key to ``'keepExisting'``. You could think of
    this similar to 'unique' => true, but without losing data from
    the extra fields during save operation. See: :ref:`HABTM
    association arrays <ref-habtm-arrays>`.

不过，更多情况下，为连接表建立一个模型，并像上面的例子那样设置 hasMany、belongsTo 关联，代替使用 HABTM 关联，会更简单

However, in most cases it's easier to make a model for the join table
and setup hasMany, belongsTo associations as shown in example above
instead of using HABTM association.

数据表 Datatables
==========

虽然 CakePHP 可以有非数据库驱动的数据源，但多数时候，都是有数据库驱动的。
CakePHP 被设计成可以与 MySQL、MSSQL、Oracle、PostgreSQL 和其它数据库一起工作。
你可以创建你平时所用的数据库系统的表。在创建模型类时，模型将自动映射到已经建立的表上。表名被转换为复数小写，多个单词的表名的单词用下划线间隔。例如，名为 Ingredient 的模型对应的表名为 ingredients。名为 EventRegistration 的模型对应的表名为 event_registrations。CakePHP 将检查表来决定每个列的数据类型，并使用这些信息自动化各种特性，比如视图中输出的表单域。列名被转换为小写并用下划线间隔。

While CakePHP can have datasources that aren't database driven, most of the
time, they are. CakePHP is designed to be agnostic and will work with MySQL,
MSSQL, PostgreSQL and others. You can create your database tables as you
normally would. When you create your Model classes, they'll automatically map to the tables that you've created. Table names are by convention lowercase and
pluralized with multi-word table names separated by underscores. For example, a
Model name of Ingredient expects the table name ingredients. A Model name of
EventRegistration would expect a table name of event_registrations. CakePHP will inspect your tables to determine the data type of each field and uses this
information to automate various features such as outputting form fields in the
view. Field names are by convention lowercase and separated by underscores.

使用 created 和 modified 列
Using created and modified
--------------------------

如果我们在数据库表中定义 ``created`` 和/或 ``modified`` 字段作为 datetime 列，CakePHP 能够识别这些域并自动在其中填入记录在数据库中创建的时间和保存的时间（除非被保存的数据中已经包含了这些域的值）。

By defining a ``created`` and/or ``modified`` field in your database table as datetime
fields (default null), CakePHP will recognize those fields and populate them automatically
whenever a record is created or saved to the database (unless the data being
saved already contains a value for these fields).

在记录首次添加时，``created`` 和 ``modified``列将被设置为当前日期时间。当已经存在的记录被保存时，modified 列将被更新为当前日期时间。

The ``created`` and ``modified`` fields will be set to the current date and time when
the record is initially added. The modified field will be updated with the
current date and time whenever the existing record is saved.

如果在 Model::save() 之前 ，$this->data 中包含了 updated、created、modified 数据（例如 Model::read 或者 Model::set），那么这些值将从 $this->data 中获取，并且不自动更新。 
如果不希望发生可以用 ``unset($this->data['Model']['modified'])`` 等方法。
或者可以覆盖 Model::save() 方法来做这件事::

If you have ``created`` or ``modified`` data in your $this->data (e.g. from a
Model::read or Model::set) before a Model::save() then the values will be taken
from $this->data and not automagically updated. If you don't want that you can use
``unset($this->data['Model']['modified'])``, etc. Alternatively you can override
the Model::save() to always do it for you::

    class AppModel extends Model {

        public function save($data = null, $validate = true, $fieldList = array()) {
            // 在每个保存操作前清除 modified 字段值：
            // Clear modified field value before each save
            $this->set($data);
            if (isset($this->data[$this->alias]['modified'])) {
                unset($this->data[$this->alias]['modified']);
            }
            return parent::save($this->data, $validate, $fieldList);
        }

    }

.. meta::
    :title lang=zh: Saving Your Data
    :keywords lang=zh: doc models,validation rules,data validation,flash message,null model,table php,request data,php class,model data,database table,array,recipes,success,reason,snap,data model

