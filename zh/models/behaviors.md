行为
Behaviors
#########

模型的行为是一种组织 CakePHP 中定义的功能的方法。这允许我们分离并重用构成一种行为的逻辑, 并且这不需要继承。例如创建树形结构。行为提供了一种简单但强大的方式来增强模型, 允许我们通过定义一个简单的类变量为模型附加功能。这样，行为就允许模型拜托不属于它们建模所依据的商业逻辑的多余负担, 或者是不同模型都需要且可以推断出来的(逻辑)。
Model behaviors are a way to organize some of the functionality
defined in CakePHP models. They allow us to separate and reuse logic that
creates a type of behavior, and they do this without requiring inheritance.  For
example creating tree structures. By providing a simple yet powerful way to
enhance models, behaviors allow us to attach functionality to models by defining
a simple class variable. That's how behaviors allow models to get rid of all the
extra weight that might not be part of the business contract they are modeling,
or that is also needed in different models and can then be extrapolated.

作为一个例子, 请考虑这样一个模型, 它让我们存取数据库中保存树形结构信息的一个表。删除, 添加, 和移动树的节点, 并不象删除, 插入和编辑表中的行那么简单。当把东西移来移去的时候, 很多记录要更新。与其为每个模型创建这些操作树的方法(对每个需要此功能的模型), 我们可以让我们的模型使用 :php:class:`TreeBehavior`, 或者用更正规的说法, 我们让模型具有树的行为。这就是把行为附加在模型上。就这么一行代码, 就可以让模型具有一整套新的方法, 可以和底层的(数据)结构交互。
As an example, consider a model that gives us access to a database table which
stores structural information about a tree. Removing, adding, and migrating
nodes in the tree is not as simple as deleting, inserting, and editing rows in
the table. Many records may need to be updated as things move around. Rather
than creating those tree-manipulation methods on a per model basis (for every
model that needs that functionality), we could simply tell our model to use the
:php:class:`TreeBehavior`, or in more formal terms, we tell our model to behave
as a Tree.  This is known as attaching a behavior to a model. With just one line
of code, our CakePHP model takes on a whole new set of methods that allow it to
interact with the underlying structure.

CakePHP 已有的行为包括树结构, 翻译内容, 权限控制列表的交互, 还有在 CakePHP Bakery (`http://bakery.cakephp.org
<http://bakery.cakephp.org>`_) 上社区贡献的行为。本节将介绍为模型添加行为的基本使用模式, 如何使用 CakePHP 自带的行为, 以及如何创建你自己的行为。
CakePHP already includes behaviors for tree structures, translated content,
access control list interaction, not to mention the community-contributed
behaviors already available in the CakePHP Bakery (`http://bakery.cakephp.org
<http://bakery.cakephp.org>`_).  In this section, we'll cover the basic usage
pattern for adding behaviors to models, how to use CakePHP's built-in behaviors,
and how to create our own.

基本上, 行为是带有回调的 `Mixins <http://en.wikipedia.org/wiki/Mixin>`_。
In essence, Behaviors are
`Mixins <http://en.wikipedia.org/wiki/Mixin>`_ with callbacks.

使用行为
Using Behaviors
===============

行为通过模型类的变量 ``$actsAs`` 附加到模型上::
Behaviors are attached to models through the ``$actsAs`` model class
variable::

    class Category extends AppModel {
        public $actsAs = array('Tree');
    }

这个例子说明一个 Category 模型可以使用 TreeBehavior 在一个树形结构中处理。一旦指定了行为, 行为新添加的方法就可以象原来的模型中一直存在的部分来使用::
This example shows how a Category model could be managed in a tree
structure using the TreeBehavior. Once a behavior has been
specified, use the methods added by the behavior as if they always
existed as part of the original model::

    // Set ID
    $this->Category->id = 42;

    // Use behavior method, children():
    $kids = $this->Category->children();

在把行为附加到模型时, 某些行为要求或者允许定义一些设置。这里，我们告诉 TreeBehavior 底层数据库表中"左节点(*left*)"和"右节点(*right*)"字段的名称::
Some behaviors may require or allow settings to be defined when the
behavior is attached to the model. Here, we tell our TreeBehavior
the names of the "left" and "right" fields in the underlying
database table::

    class Category extends AppModel {
        public $actsAs = array('Tree' => array(
            'left'  => 'left_node',
            'right' => 'right_node'
        ));
    }

我们也可以为一个模型附加多个行为。例如, 没有理由我们的 Category 模型只能有树结构的行为, 它可能也需要国际化支持::
We can also attach several behaviors to a model. There's no reason
why, for example, our Category model should only behave as a tree,
it may also need internationalization support::

    class Category extends AppModel {
        public $actsAs = array(
            'Tree' => array(
              'left'  => 'left_node',
              'right' => 'right_node'
            ),
            'Translate'
        );
    }

至此我们始终使用模型的类变量来为模型添加行为。这意味着这些行为将在模型的整个生命周期中一直附加在模型上。然而, 我们也许需要在运行时将行为从模型上分离。比方说我们之前的 Category 模型, 具有 Tree 和 Translate 的行为, 出于某种原因, 我们要让它停止 Translate 的行为::
So far we have been adding behaviors to models using a model class
variable. That means that our behaviors will be attached to our
models throughout the model's lifetime. However, we may need to
"detach" behaviors from our models at runtime. Let's say that on
our previous Category model, which is acting as a Tree and a
Translate model, we need for some reason to force it to stop acting
as a Translate model::

    // 从模型分离行为:Detach a behavior from our model:
    $this->Category->Behaviors->unload('Translate');

这将使我们的 Category 模型从此停止 Translate 的行为。另外, 我们可能需要在模型的通常操作时取消 Translate 行为: 查找, 保存, 等等。实际上, 我们想要取消行为作用于 CakePHP 模型的回调函数。与其让行为脱离模型, 我们让模型停止将这些回调通知 Translate 行为::
That will make our Category model stop behaving as a Translate
model from thereon. We may need, instead, to just disable the
Translate behavior from acting upon our normal model operations:
our finds, our saves, etc. In fact, we are looking to disable the
behavior from acting upon our CakePHP model callbacks. Instead of
detaching the behavior, we then tell our model to stop informing of
these callbacks to the Translate behavior::

    // 停止让行为处理模型的回调Stop letting the behavior handle our model callbacks
    $this->Category->Behaviors->disable('Translate');

我们也有可能要知道行为是否在处理这些模型回调, 如果没有, 我们就恢复它对回调作出反应::
We may also need to find out if our behavior is handling those
model callbacks, and if not we then restore its ability to react to
them::

    // 如果行为没有处理模型的回调If our behavior is not handling model callbacks
    if (!$this->Category->Behaviors->enabled('Translate')) {
        // 告诉它开始处理Tell it to start doing so
        $this->Category->Behaviors->enable('Translate');
    }

就象我们能在运行时把行为从模型上完全分离, 我们也能附加新的行为。比如说, 我们熟悉的 Category 模型要有圣诞树的行为, 不过, 只是在圣诞节那天::
Just as we could completely detach a behavior from a model at
runtime, we can also attach new behaviors. Say that our familiar
Category model needs to start behaving as a Christmas model, but
only on Christmas day::

    // 如果今天是12月25日If today is Dec 25
    if (date('m/d') === '12/25') {
        // 我们的模型要有圣诞树的行为Our model needs to behave as a Christmas model
        $this->Category->Behaviors->load('Christmas');
    }

我们也可以用 load 方法重置行为的设置::
We can also use the load method to override behavior settings::

    // 改变已经附加的行为的一个设置We will change one setting from our already attached behavior
    $this->Category->Behaviors->load('Tree', array('left' => 'new_left_node'));

还有一个方法可以获得一个模型已附加的行为的列表。如果传入一个行为的名字, 它就会告诉我们那个行为是否已附加在模型上, 否则它就会给我们一个已附加行为的列表::
There's also a method to obtain the list of behaviors a model has
attached. If we pass the name of a behavior to the method, it will
tell us if that behavior is attached to the model, otherwise it
will give us the list of attached behaviors::

    // 如果 Translate 行为尚未附加上 If the Translate behavior is not attached
    if (!$this->Category->Behaviors->loaded('Translate')) {
        // 得到模型附加的所有行为的完整列表Get the list of all behaviors the model has attached
        $behaviors = $this->Category->Behaviors->loaded();
    }

创建行为
Creating Behaviors
==================

附加在模型上的行为的回调函数会被自动调用。这些回调函数和模型的回调函数类似: ``beforeFind``, ``afterFind``, ``beforeSave``, ``afterSave``, ``beforeDelete``,
``afterDelete`` and ``onError`` - 参见 :doc:`/models/callback-methods`。
Behaviors that are attached to Models get their callbacks called
automatically. The callbacks are similar to those found in Models:
``beforeFind``, ``afterFind``, ``beforeSave``, ``afterSave``, ``beforeDelete``,
``afterDelete`` and ``onError`` - see
:doc:`/models/callback-methods`.

你的行为应该放在 ``app/Model/Behavior`` 中。它们以 CamelCase 的方式命名, 末尾缀以 ``Behavior``, 比如 NameBehavior.php。当创建你自己的行为时, 用一个核心行为作为模板通常是有帮助的。核心行为可以在 ``lib/Cake/Model/Behavior/`` 中找到。
Your behaviors should be placed in ``app/Model/Behavior``.  They are named in CamelCase and
postfixed by ``Behavior``, ex. NameBehavior.php.
It's often helpful to use a core behavior as a template when creating
your own. Find them in ``lib/Cake/Model/Behavior/``.

行为的每个回调和方法把调用起始的模型作为第一个参数。
Every callback and behavior method takes a reference to the model it is being called
from as the first parameter.

除了实现回调, 你也可以为每个行为以及/或者每个模型附加的行为添加设置。给定设置的方法可以在核心行为及其配置的章节中找到。
Besides implementing the callbacks, you can add settings per behavior and/or
model behavior attachment. Information about specifying settings can be found in
the chapters about core behaviors and their configuration.

下面这个简单的例子说明行为的设置如何从模型传入到行为::
A quick example that illustrates how behavior settings can be
passed from the model to the behavior::

    class Post extends AppModel {
        public $actsAs = array(
            'YourBehavior' => array(
                'option1_key' => 'option1_value'
            )
        );
    }

既然行为被所有使用它的模型实例共享, 好的做法是基于使用行为的别名/模型名来保存设置。当被创建的行为的 ``setup()`` 方法被调用时::
Since behaviors are shared across all the model instances that use them, it's a
good practice to store the settings per alias/model name that is using the
behavior.  When created behaviors will have their ``setup()`` method called::

    public function setup(Model $Model, $settings = array()) {
        if (!isset($this->settings[$Model->alias])) {
            $this->settings[$Model->alias] = array(
                'option1_key' => 'option1_default_value',
                'option2_key' => 'option2_default_value',
                'option3_key' => 'option3_default_value',
            );
        }
        $this->settings[$Model->alias] = array_merge(
            $this->settings[$Model->alias], (array)$settings);
    }

创建行为方法
Creating behavior methods
=========================

具有行为的模型自动获得该行为的方法。例如, 如果你有::
Behavior methods are automatically available on any model acting as
the behavior. For example if you had::

    class Duck extends AppModel {
        public $actsAs = array('Flying');
    }

你可以调用 ``FlyingBehavior`` 的方法, 就象它们是 Duck 模型的方法一样。当创建行为方法时, 你自动得到调用模型作为第一个参数。所有其它参数都被右移一个位置。例如::
You would be able to call ``FlyingBehavior`` methods as if they were
methods on your Duck model. When creating behavior methods you
automatically get passed a reference of the calling model as the
first parameter. All other supplied parameters are shifted one
place to the right. For example::

    $this->Duck->fly('toronto', 'montreal');

Although this method takes two parameters, the method signature
should look like::

    public function fly(Model $Model, $from, $to) {
        // 飞行。Do some flying.
    }

切记在一个行为方法内部以 ``$this->doIt()`` 方式调用的方法无法自动得到附加的模型参数。
Keep in mind that methods called in a ``$this->doIt()`` fashion
from inside a behavior method will not get the $model parameter
automatically appended.

映射方法
Mapped methods
--------------

除了提供 'mixin' 方法, 行为还可以提供模式匹配方法。行为也可以定义映射方法。 映射方法使用模式匹配来调用方法。这允许你在行为上创建类似 ``Model::findAllByXXX`` 的方法。映射方法需要在行为的 ``$mapMethods`` 数组中声明。映射方法的签名与行为通常的 mixin 方法略有不同::
In addition to providing 'mixin' methods, behaviors can also provide pattern
matching methods. Behaviors can also define mapped methods.  Mapped methods use
pattern matching for method invocation. This allows you to create methods
similar to ``Model::findAllByXXX`` methods on your behaviors.  Mapped methods need
to be declared in your behaviors ``$mapMethods`` array.  The method signature for
a mapped method is slightly different than a normal behavior mixin method::

    class MyBehavior extends ModelBehavior {
        public $mapMethods = array('/do(\w+)/' => 'doSomething');

        public function doSomething(Model $model, $method, $arg1, $arg2) {
            debug(func_get_args());
            //do something
        }
    }

上面的代码会映射到每一个 ``doXXX()`` 方法的调用到此行为。正如你所看到的, 模型仍然是第一个参数, 但被调用的方法会是第二个参数。这允许你 munge方法名称以获得额外的信息, 很象 ``Model::findAllByXX``。如果上面的行为附加到一个模型, 就可能会象下面这样::
The above will map every ``doXXX()`` method call to the behavior.  As you can
see, the model is still the first parameter, but the called method name will be
the 2nd parameter.  This allows you to munge the method name for additional
information, much like ``Model::findAllByXX``.  If the above behavior was
attached to a model the following would happen::

    $model->doReleaseTheHounds('homer', 'lenny');

    // would output
    'ReleaseTheHounds', 'homer', 'lenny'

行为的回调
Behavior callbacks
==================

模型的行为可以定义一些回调函数, 在模型同名的回调之前触发。行为的回调让行为可以获取所附加的模型的事件, 并且改变参数, 或者加入额外的处理。
Model Behaviors can define a number of callbacks that are triggered
before the model callbacks of the same name. Behavior
callbacks allow your behaviors to capture events in attached models
and augment the parameters or splice in additional behavior.

所有行为的回调都在模型的回调**之前**触发:
All behavior callbacks are fired **before** the model/behavior callbacks are:

-  ``beforeValidate``
-  ``beforeFind``
-  ``afterFind``
-  ``beforeSave``
-  ``afterSave``
-  ``beforeDelete``
-  ``afterDelete``


创建行为的回调
Creating a behavior callback
----------------------------

.. php:class:: ModelBehavior

模型行为的回调定义为行为类中的普通方法。与通常的行为方法十分类似, 它们接受 ``$Model`` 作为第一个参数。这个参数就是调用行为方法的模型。
Model behavior callbacks are defined as simple methods in your
behavior class. Much like regular behavior methods, they receive a
``$Model`` parameter as the first argument. This parameter is the
model that the behavior method was invoked on.

.. php:method:: setup(Model $Model, array $settings = array())

    当一个行为附加到模型时调用。 settings 参数来自模型的 ``$actsAs`` 属性。
    Called when a behavior is attached to a model.  The settings come from the
    attached model's ``$actsAs`` property.

.. php:method:: cleanup(Model $Model)

    当一个行为从模型分离时调用。基类方法根据 ``$model->alias`` 来删除设置。你可以重载这个方法, 提供定制的清理功能。
    Called when a behavior is detached from a model.  The base method removes
    model settings based on ``$model->alias``. You can override this method and
    provide custom cleanup functionality.

.. php:method:: beforeFind(Model $Model, array $query)

    如果行为的 beforeFind 返回 false, find() 就会中断。返回一的数组就会用于增加用于 find 操作的查询参数。
    If a behavior's beforeFind return's false it will abort the find().
    Returning an array will augment the query parameters used for the
    find operation.

.. php:method:: afterFind(Model $Model, mixed $results, boolean $primary)

    你可以用 afterFind 来增加 find 操作的结果。返回值会作为结果，或者交给链条中的下一个行为, 或者交给模型的 afterFind。
    You can use the afterFind to augment the results of a find. The
    return value will be passed on as the results to either the next
    behavior in the chain or the model's afterFind.

.. php:method:: beforeDelete(Model $Model, boolean $cascade = true)

    你可以从行为的 beforeDelete 返回 false, 来中断删除操作。返回 true 就允许它继续。
    You can return false from a behavior's beforeDelete to abort the
    delete. Return true to allow it continue.

.. php:method:: afterDelete(Model $Model)

    你可以用 afterDelete 来执行与行为相关的清理操作。
    You can use afterDelete to perform clean up operations related to
    your behavior.

.. php:method:: beforeSave(Model $Model)

    你可以从行为的 beforeSave 返回 false, 来中断保存操作。返回 true 就允许它继续。
    You can return false from a behavior's beforeSave to abort the
    save. Return true to allow it continue.

.. php:method:: afterSave(Model $Model, boolean $created)

    你可以用 afterSave 来执行与行为相关的清理操作。 当创建一条记录时 $created 为 true, 当更新一条记录时则为 false。
    You can use afterSave to perform clean up operations related to
    your behavior. $created will be true when a record is created, and
    false when a record is updated.

.. php:method:: beforeValidate(Model $Model)

    你可以用 beforeValidate 来改变模型的验证数组或者处理任何其它在验证之前的逻辑。从 beforeValidate 回调方法返回 false 会中断验证并使验证失败。
    You can use beforeValidate to modify a model's validate array or
    handle any other pre-validation logic. Returning false from a
    beforeValidate callback will abort the validation and cause it to
    fail.



.. meta::
    :title lang=en: Behaviors
    :keywords lang=en: tree manipulation,manipulation methods,model behaviors,access control list,model class,tree structures,php class,business contract,class category,database table,bakery,inheritance,functionality,interaction,logic,cakephp,models,essence