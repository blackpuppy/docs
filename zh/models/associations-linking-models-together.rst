Associations: Linking Models Together
关联：将模型连接在一起
#####################################

CakePHP中的一个非常强劲的特性就是由模型提供关系映射，通过关联来管理多个模型间的连接。

One of the most powerful features of CakePHP is the ability to link
relational mapping provided by the model. In CakePHP, the links
between models are handled through associations.

在应用程序的不同对象间定义关联是一个自然过程。例如：在一个食谱数据库，
一个食谱可能有多个评论，每个评论有一个作者，而每个作者又可能有多个食谱。
定义这些关系的方式，使得你以一种直观且强大的方式访问你的数据。

Defining relations between different objects in your application
should be a natural process. For example: in a recipe database, a
recipe may have many reviews, reviews have a single author, and
authors may have many recipes. Defining the way these relations
work allows you to access your data in an intuitive and powerful
way.

本节的目的是展示如何在CakePHP中谋划、定义以及利用模型间的关系。

The purpose of this section is to show you how to plan for, define,
and utilize associations between models in CakePHP.

虽然数据可能有多种来源，但在web应用程序中最常见的则是存储在关系数据库中。 本节将覆盖这方面的大部分内容。

While data can come from a variety of sources, the most common form
of storage in web applications is a relational database. Most of
what this section covers will be in that context.

关于与插件模型一起的关联的信息，请参见插件模型 :ref:`plugin-models`。

For information on associations with Plugin models, see
:ref:`plugin-models`.


Relationship Types
关系类型
------------------

CakePHP 的关系类型有四种： hasOne、hasMany、belongsTo 和 hasAndBelongsToMany (HABTM)。

The four association types in CakePHP are: hasOne, hasMany,
belongsTo, and hasAndBelongsToMany (HABTM).

============= ===================== =======================================
Relationship  Association Type      Example
============= ===================== =======================================
one to one    hasOne                A user has one profile.
------------- --------------------- ---------------------------------------
one to many   hasMany               A user can have multiple recipes.
------------- --------------------- ---------------------------------------
many to one   belongsTo             Many recipes belong to a user.
------------- --------------------- ---------------------------------------
many to many  hasAndBelongsToMany   Recipes have, and belong to many ingredients.
============= ===================== =======================================

============= ===================== =======================================
关系 		  关联类型				例子
============= ===================== =======================================
一对一    	  hasOne                一个用户只有一份个人资料
------------- --------------------- ---------------------------------------
一对多        hasMany               一个用户有多份食谱
------------- --------------------- ---------------------------------------
多对一        belongsTo             多份食谱属于同一个用户
------------- --------------------- ---------------------------------------
多对多        hasAndBelongsToMany   多份食谱有且属于多种成分
============= ===================== =======================================

关联是通过创建一个以关联命名的变量来定义的。 此变量有时候可能是简单的字符串，但也可能是用于定义关联细节的复杂的多维数组。

Associations are defined by creating a class variable named after
the association you are defining. The class variable can sometimes
be as simple as a string, but can be as complete as a
multidimensional array used to define association specifics.

::

    class User extends AppModel {
        public $hasOne = 'Profile';
        public $hasMany = array(
            'Recipe' => array(
                'className'  => 'Recipe',
                'conditions' => array('Recipe.approved' => '1'),
                'order'      => 'Recipe.created DESC'
            )
        );
    }

在上面的例子中，第一个实例的单词'Recipe'是别名。它是关系的唯一标识，可以是你选择的任何东西。
通常选择与要引用的类相同的名字。然而，**每个模型的别名在应用程序中必须唯一**。下面有一些正确的例子：

In the above example, the first instance of the word 'Recipe' is
what is termed an 'Alias'. This is an identifier for the
relationship and can be anything you choose. Usually, you will
choose the same name as the class that it references. However,
**aliases for each model must be unique app wide**. For example it is
appropriate to have::

    class User extends AppModel {
        public $hasMany = array(
            'MyRecipe' => array(
                'className' => 'Recipe',
            )
        );
        public $hasAndBelongsToMany = array(
            'MemberOf' => array(
                'className' => 'Group',
            )
        );
    }

    class Group extends AppModel {
        public $hasMany = array(
            'MyRecipe' => array(
                'className'  => 'Recipe',
            )
        );
        public $hasAndBelongsToMany = array(
            'Member' => array(
                'className' => 'User',
            )
        );
    }

但是下面的写法在任何环境下都不工作::
but the following will not work well in all circumstances::

    class User extends AppModel {
        public $hasMany = array(
            'MyRecipe' => array(
                'className' => 'Recipe',
            )
        );
        public $hasAndBelongsToMany = array(
            'Member' => array(
                'className' => 'Group',
            )
        );
    }

    class Group extends AppModel {
        public $hasMany = array(
            'MyRecipe' => array(
                'className'  => 'Recipe',
            )
        );
        public $hasAndBelongsToMany = array(
            'Member' => array(
                'className' => 'User',
            )
        );
    }

这是因为在HABTM关联中，别名'Member'同时指向了User模型(在Group模型中)和Group 模型(在User模型中)。
在不同的模型为某个模型起不唯一的别名，可能会带来未知的后果。

because here we have the alias 'Member' referring to both the User
(in Group) and the Group (in User) model in the HABTM associations.
Choosing non-unique names for model aliases across models can cause
unexpected behavior.

Cake会自动在关联模型对象间建立连接。所以可以在User模型中以如下方式访问Recipe模型::

Cake will automatically create links between associated model
objects. So for example in your ``User`` model you can access the
``Recipe`` model as::

    $this->Recipe->someFunction();

同样的，也能在控制器中循着模型关系访问关联模型：

Similarly in your controller you can access an associated model
simply by following your model associations::

    $this->User->Recipe->someFunction();

.. note::

	记住，关系定义是'单向的'。如果定义了User hasMany Recipe，对Recipe模型是没有影响的。
	需要定义 Recipe belongsTo User才能从Recipe模型访问User模型。

    Remember that associations are defined 'one way'. If you define
    User hasMany Recipe that has no effect on the Recipe Model. You
    need to define Recipe belongsTo User to be able to access the User
    model from your Recipe model

hasOne
------

让我们设置User模型以hasOne类型关联到Profile模型。

Let’s set up a User model with a hasOne relationship to a Profile
model.

首先，数据库表需要有正确的主键。对于hasOne关系，一个表必须包含指向另一个表的外键。
在本例中，profiles表将包含一个叫做user_id的字段。基本模式是:

First, your database tables need to be keyed correctly. For a
hasOne relationship to work, one table has to contain a foreign key
that points to a record in the other. In this case the profiles
table will contain a field called user\_id. The basic pattern is:

**hasOne:** *另一个* 模型包含外键。

**hasOne:** the *other* model contains the foreign key.

==================== ==================
Relation 关系        Schema 结构
==================== ==================
Apple hasOne Banana  bananas.apple\_id
-------------------- ------------------
User hasOne Profile  profiles.user\_id
-------------------- ------------------
Doctor hasOne Mentor mentors.doctor\_id
==================== ==================

.. note::

	关于这一点，并没有强制要求遵循 CakePHP 约定，你能够很容易地在关联定义中使用任何外键来覆盖它。
	虽然如此，遵守规则将使你的代码更简捷，更易于阅读和维护。

    It is not mandatory to follow CakePHP conventions, you can easily override
    the use of any foreignKey in your associations definitions. Nevertheless sticking
    to conventions will make your code less repetitive, easier to read and to maintain.

User模型文件保存为/app/Model/User.php。为了定义‘User hasOne Profile’关联，需要在模型类中添加$hasOne属性。
记得要在/app/Model/Profile.php文件中放一个Profile模型，否则关联将不工作：

The User model file will be saved in /app/Model/User.php. To
define the ‘User hasOne Profile’ association, add the $hasOne
property to the model class. Remember to have a Profile model in
/app/Model/Profile.php, or the association won’t work::

    class User extends AppModel {
        public $hasOne = 'Profile';
    }

有两种途径在模型文件中描述此关系。最简单的方法是设置$hasOne属性为一个包含要关联的模型名的字符串，就像我们上面做的那样。

There are two ways to describe this relationship in your model
files. The simplest method is to set the $hasOne attribute to a
string containing the classname of the associated model, as we’ve
done above.

如果需要更全面的控制，可以使用数组语法定义关联。例如，你可能想要限制关联只包含某些记录。

If you need more control, you can define your associations using
array syntax. For example, you might want to limit the association
to include only certain records.

::

    class User extends AppModel {
        public $hasOne = array(
            'Profile' => array(
                'className'    => 'Profile',
                'conditions'   => array('Profile.published' => '1'),
                'dependent'    => true
            )
        );
    }

hasOne 关联数组包含的键有:

Possible keys for hasOne association arrays include:

-  **className**: 被关联到当前模型的模型类名。如果你定义了 ‘User hasOne Profile’关系，类名的键名将是 ‘Profile.’
-  **foreignKey**: 另一张表中的外键名。如果需要定义多个 hasOne 关系，这个键非常有用。其默认值为当前模型的单数模型名缀以 ‘_id’。
在上面的例子中，就默认为 ‘user_id’。
-  **conditions**: 一个 find() 兼容条件的数组或者类似 array(‘Profile.approved’ => true) 的SQL字符串.
-  **fields**: 需要在匹配的关联模型数据中获取的字段的列表。默认返回所有的字段。
-  **order**: 一个 find() 兼容排序子句或者类似 array(‘Profile.last_name’ => ‘ASC’) 的SQL字符串。
-  **dependent**: 当 dependent 键被设置为 true，并且模型的 delete() 方法调用时的参数cascade被设置为true，关联模型的记录同时被删除。
在本例中，我们将其设置为 true 将导致删除一个 User 时同时删除与其相关的 Profile。

-  **className**: the classname of the model being associated to
   the current model. If you’re defining a ‘User hasOne Profile’
   relationship, the className key should equal ‘Profile.’
-  **foreignKey**: the name of the foreign key found in the other
   model. This is especially handy if you need to define multiple
   hasOne relationships. The default value for this key is the
   underscored, singular name of the current model, suffixed with
   ‘\_id’. In the example above it would default to 'user\_id'.
-  **conditions**: an array of find() compatible conditions or SQL
   strings such as array('Profile.approved' => true)
-  **fields**: A list of fields to be retrieved when the associated
   model data is fetched. Returns all fields by default.
-  **order**: an array of find() compatible order clauses or SQL
   strings such as array('Profile.last_name' => 'ASC')
-  **dependent**: When the dependent key is set to true, and the
   model’s delete() method is called with the cascade parameter set to
   true, associated model records are also deleted. In this case we
   set it true so that deleting a User will also delete her associated
   Profile.

一旦定义了关系，执行User模型上的find操作将匹配存在关联的Profile记录::

Once this association has been defined, find operations on the User
model will also fetch a related Profile record if it exists::

    //Sample results from a $this->User->find() call.

    Array
    (
        [User] => Array
            (
                [id] => 121
                [name] => Gwoo the Kungwoo
                [created] => 2007-05-01 10:31:01
            )
        [Profile] => Array
            (
                [id] => 12
                [user_id] => 121
                [skill] => Baking Cakes
                [created] => 2007-05-01 10:31:01
            )
    )

belongsTo
属于
---------

现在我们有了通过访问 User 模型获取相关 Profile 数据的办法，让我们在 Profile 模型中定义 belongsTo 关联以获取相关的 User 数据。
belongsTo 关联是 hasOne 和 hasMany 关联的自然补充：它允许我们从其它途径查看数据。

Now that we have Profile data access from the User model, let’s
define a belongsTo association in the Profile model in order to get
access to related User data. The belongsTo association is a natural
complement to the hasOne and hasMany associations: it allows us to
see the data from the other direction.

在为 belongsTo 关系定义数据库表的键时，遵循如下约定：

When keying your database tables for a belongsTo relationship,
follow this convention:

**belongsTo:** *当前模型* 包含外键。
**belongsTo:** the *current* model contains the foreign key.

======================= ==================
Relation  关系          Schema  结构
======================= ==================
Banana belongsTo Apple  bananas.apple\_id
----------------------- ------------------
Profile belongsTo User  profiles.user\_id
----------------------- ------------------
Mentor belongsTo Doctor mentors.doctor\_id
======================= ==================

.. tip::

	如果一个模型(表)包含一个外键，它belongsTo另一个模型(表)。
    If a model(table) contains a foreign key, it belongsTo the other
    model(table).

我们可以使用如下字符串语法，在/app/Model/Profile.php 文件中的Profile模型中定义belongsTo关联::

We can define the belongsTo association in our Profile model at
/app/Model/Profile.php using the string syntax as follows::

    class Profile extends AppModel {
        public $belongsTo = 'User';
    }


我们还能使用数组语法定义特定的关系::

We can also define a more specific relationship using array
syntax::

    class Profile extends AppModel {
        public $belongsTo = array(
            'User' => array(
                'className'    => 'User',
                'foreignKey'   => 'user_id'
            )
        );
    }

belongsTo 关联数组包含的键有:

Possible keys for belongsTo association arrays include:

-  **className**: 被关联到当前模型的模型类名。如果你定义了 ‘Profile belongsTo User’关系，类名的键名将为 ‘User.’。
-  **foreignKey**: 当前模型中需要的外键。用于需要定义多个 belongsTo 关系。其默认值为另一模型的单数模型名缀以 ‘_id’。
-  **conditions**: 一个 find() 兼容条件的数组或者类似 array('User.active' => true) 的 SQL 字符串。
-  **type**: SQL 查询的 join 类型，默认为 Left，这不可能在所有情况下都符合你的需求，
在你想要从主模型和关联模型获取全部内容或者什么都不要时很有用！(仅在某些条件下有效)。
**(注：类型值必须是小写，例如：left, inner)**
   **(NB: type value is in lower case - i.e. left, inner)**
-  **fields**: 需要在匹配的关联模型数据中获取的字段的列表。默认返回所有的字段。
-  **order**: 一个 find() 兼容排序子句或者类似 array('User.username' => 'ASC') 的 SQL 字符串。
-  **counterCache**: 如果此键的值设置为 true，当你在做 ``save()`` 或者``delete()`` 操作时关联模型将自动递增或递减外键关联的表的“[singular\_model\_name]\_count”列的值。
如果它是一个字符串，则其将是计数用的列名。计数列的值表示关联行的数量。
也可以通过使用数组指定多个计数缓存，键为列名，值为条件，参见:ref:`multiple-counterCache`
-  **counterScope**: 用于更新计数缓存列的可选条件数组。

-  **className**: the classname of the model being associated to
   the current model. If you’re defining a ‘Profile belongsTo User’
   relationship, the className key should equal ‘User.’
-  **foreignKey**: the name of the foreign key found in the current
   model. This is especially handy if you need to define multiple
   belongsTo relationships. The default value for this key is the
   underscored, singular name of the other model, suffixed with
   ``_id``.
-  **conditions**: an array of find() compatible conditions or SQL
   strings such as ``array('User.active' => true)``
-  **type**: the type of the join to use in the SQL query, default
   is LEFT which may not fit your needs in all situations, INNER may
   be helpful when you want everything from your main and associated
   models or nothing at all! (effective when used with some conditions
   of course).
   **(NB: type value is in lower case - i.e. left, inner)**
-  **fields**: A list of fields to be retrieved when the associated
   model data is fetched. Returns all fields by default.
-  **order**: an array of find() compatible order clauses or SQL
   strings such as ``array('User.username' => 'ASC')``
-  **counterCache**: If set to true the associated Model will
   automatically increase or decrease the
   “[singular\_model\_name]\_count” field in the foreign table
   whenever you do a ``save()`` or ``delete()``. If it's a string then it's the
   field name to use. The value in the counter field represents the
   number of related rows. You can also specify multiple counter caches
   by defining an array, see :ref:`multiple-counterCache`
-  **counterScope**: Optional conditions array to use for updating
   counter cache field.

一旦定义了关联，Profile模型上的find操作将同时获取相关的存在的User记录::

Once this association has been defined, find operations on the
Profile model will also fetch a related User record if it exists::

    //Sample results from a $this->Profile->find() call.

    Array
    (
       [Profile] => Array
            (
                [id] => 12
                [user_id] => 121
                [skill] => Baking Cakes
                [created] => 2007-05-01 10:31:01
            )
        [User] => Array
            (
                [id] => 121
                [name] => Gwoo the Kungwoo
                [created] => 2007-05-01 10:31:01
            )
    )

hasMany
一对多
-------

下一步：定义一个 “User hasMany Comment” 关联。一个 hasMany 关联将允许我们在获取 User 记录的同时获取用户的评论。

Next step: defining a “User hasMany Comment” association. A hasMany
association will allow us to fetch a user’s comments when we fetch
a User record.

在为 hasMany 关系定义数据库表的键时，遵循如下约定:

When keying your database tables for a hasMany relationship, follow
this convention:

**hasMany:** *其它* 模型包含外键

**hasMany:** the *other* model contains the foreign key.

======================= ==================
Relation   关系         Schema 结构
======================= ==================
User hasMany Comment    Comment.user\_id
----------------------- ------------------
Cake hasMany Virtue     Virtue.cake\_id
----------------------- ------------------
Product hasMany Option  Option.product\_id
======================= ==================

我们可以使用如下字符串语法，在 /app/Model/User.php 文件中的User模型中定义hasMnay关联::

We can define the hasMany association in our User model at
/app/Model/User.php using the string syntax as follows::

    class User extends AppModel {
        public $hasMany = 'Comment';
    }

我们还能使用数组语法定义特定的关系::

We can also define a more specific relationship using array
syntax::

    class User extends AppModel {
        public $hasMany = array(
            'Comment' => array(
                'className'     => 'Comment',
                'foreignKey'    => 'user_id',
                'conditions'    => array('Comment.status' => '1'),
                'order'         => 'Comment.created DESC',
                'limit'         => '5',
                'dependent'     => true
            )
        );
    }

hasMany 关联数组包含的键有:
Possible keys for hasMany association arrays include:

-  **className**: 被关联到当前模型的模型类名。如果你定义了 ‘User hasMany Comment’关系，类名键的值将为 ‘Comment.’。
-  **foreignKey**: 另一张表中的外键名。如果需要定义多个 hasMany 关系，这个键非常有用。其默认值为当前模型的单数模型名缀以 ‘\_id’。
-  **conditions**:  一个 find() 兼容条件的数组或者类似 array(‘Comment.visible’ => true) 的 SQL 字符串。
-  **order**:  一个 find() 兼容排序子句或者类似 array(‘Profile.last_name’ => ‘ASC’) 的 SQL 字符串。
-  **offset**: 获取和关联前要跳过的行数（根据提供的条件 - 多数用于分页时的当前页的偏移量）。
-  **dependent**: 如果 dependent 设置为 true，就有可能进行模型的递归删除。在本例中，当 User 记录被删除后，关联的 Comment 记录将被删除。
-  **exclusive**:  当 exclusive 设置为 true，将用 deleteAll() 代替分别删除每个实体来来完成递归模型删除。
这大大提高了性能，但可能不是所有情况下的理想选择。
-  **finderQuery**:  CakePHP 中用于获取关联模型的记录的完整 SQL 查询。用在包含许多自定义结果的场合。
如果你建立的一个查询包含关联模型 ID 的引用，在查询中使用 ``{$__cakeID__$}`` 标记它。
例如，如果你的 Apple 模型 hasMany Orange，
此查询看上去有点像这样： ``SELECT Orange.* from oranges as Orange WHERE Orange.apple_id = {$__cakeID__$};``;

-  **className**: the classname of the model being associated to
   the current model. If you’re defining a ‘User hasMany Comment’
   relationship, the className key should equal ‘Comment.’
-  **foreignKey**: the name of the foreign key found in the other
   model. This is especially handy if you need to define multiple
   hasMany relationships. The default value for this key is the
   underscored, singular name of the actual model, suffixed with
   ‘\_id’.
-  **conditions**: an array of find() compatible conditions or SQL
   strings such as array('Comment.visible' => true)
-  **order**:  an array of find() compatible order clauses or SQL
   strings such as array('Profile.last_name' => 'ASC')
-  **limit**: The maximum number of associated rows you want
   returned.
-  **offset**: The number of associated rows to skip over (given
   the current conditions and order) before fetching and associating.
-  **dependent**: When dependent is set to true, recursive model
   deletion is possible. In this example, Comment records will be
   deleted when their associated User record has been deleted.
-  **exclusive**: When exclusive is set to true, recursive model
   deletion does the delete with a deleteAll() call, instead of
   deleting each entity separately. This greatly improves performance,
   but may not be ideal for all circumstances.
-  **finderQuery**: A complete SQL query CakePHP can use to fetch
   associated model records. This should be used in situations that
   require very custom results.
   If a query you're building requires a reference to the associated
   model ID, use the special ``{$__cakeID__$}`` marker in the query.
   For example, if your Apple model hasMany Orange, the query should
   look something like this:
   ``SELECT Orange.* from oranges as Orange WHERE Orange.apple_id = {$__cakeID__$};``

一旦关联被建立，User 模型上的 find 操作也将获取相关的 Comment 数据（如果它存在的话）：

Once this association has been defined, find operations on the User
model will also fetch related Comment records if they exist::

    //Sample results from a $this->User->find() call.

    Array
    (
        [User] => Array
            (
                [id] => 121
                [name] => Gwoo the Kungwoo
                [created] => 2007-05-01 10:31:01
            )
        [Comment] => Array
            (
                [0] => Array
                    (
                        [id] => 123
                        [user_id] => 121
                        [title] => On Gwoo the Kungwoo
                        [body] => The Kungwooness is not so Gwooish
                        [created] => 2006-05-01 10:31:01
                    )
                [1] => Array
                    (
                        [id] => 124
                        [user_id] => 121
                        [title] => More on Gwoo
                        [body] => But what of the ‘Nut?
                        [created] => 2006-05-01 10:41:01
                    )
            )
    )

有件事需要记住：你还需要定义 Comment belongsTo User 关联，用于从两个方向获取数据。
我们在这一节概述了能够使你从 User 模型获取 Comment 数据的方法。
在 Comment 模型中添加 Comment belongsTo User 关系将使你能够从 Comment 模型中获取 User 数据 -
这样的链接关系才是完整的且允许从两个模型的角度获取信息流。

One thing to remember is that you’ll need a complimentary Comment
belongsTo User association in order to get the data from both
directions. What we’ve outlined in this section empowers you to get
Comment data from the User. Adding the Comment belongsTo User
association in the Comment model empowers you to get User data from
the Comment model - completing the connection and allowing the flow
of information from either model’s perspective.

counterCache - Cache your count()
counterCache - 缓存你的 count()
---------------------------------

这个功能帮助你缓存相关数据的计数。模型通过自己追踪指向关联 ``$hasMany`` 模型的所有的添加/删除并递增/递减父模型表的专用整数列，
替代手工调用 ``find('count')`` 计算记录的计数。

This function helps you cache the count of related data. Instead of
counting the records manually via ``find('count')``, the model
itself tracks any addition/deleting towards the associated
``$hasMany`` model and increases/decreases a dedicated integer
field within the parent model table.

这个列的名称由列的单数名后缀以下划线和单词"count"构成：

The name of the field consists of the singular model name followed
by a underscore and the word "count"::

    my_model_count

如果你有一个叫 ``ImageComment`` 的模型和一个叫 ``Image`` 的模型，你需要添加一个指向 ``images`` 表的新的整数列并命名为``image_comment_count``。

Let's say you have a model called ``ImageComment`` and a model
called ``Image``, you would add a new INT-field to the ``images``
table and name it ``image_comment_count``.

下面是更多的示例:
Here are some more examples:

========== ======================= =========================================
Model      Associated Model        Example
========== ======================= =========================================
User       Image                   users.image\_count
---------- ----------------------- -----------------------------------------
Image      ImageComment            images.image\_comment\_count
---------- ----------------------- -----------------------------------------
BlogEntry  BlogEntryComment        blog\_entries.blog\_entry\_comment\_count
========== ======================= =========================================

一旦你添加了计数列，就可以使用它了。通过在你的关联中添加 counterCache 键并将其值设置为 ``true``，可以激活 counter-cache::

Once you have added the counter field you are good to go. Activate
counter-cache in your association by adding a ``counterCache`` key
and set the value to ``true``::

    class ImageComment extends AppModel {
        public $belongsTo = array(
            'Image' => array(
                'counterCache' => true,
            )
        );
    }

自此，你每次添加或删除一个关联到``Image``的``ImageComment``，``image_comment_count``字段的数字都会自动调整。

From now on, every time you add or remove a ``ImageComment`` associated to
``Image``, the number within ``image_comment_count`` is adjusted
automatically.

counterScope
============

你还可以指定 ``counterScope``.。它允许你指定一个简单的条件，通知模型什么时候更新（不更新）计数值，这依赖于你如何查看。

You can also specify ``counterScope``. It allows you to specify a
simple condition which tells the model when to update (or when not
to, depending on how you look at it) the counter value.

在我们的 Image 模型示例中，我们可以象下面这样指定::

Using our Image model example, we can specify it like so::

    class ImageComment extends AppModel {
        public $belongsTo = array(
            'Image' => array(
                'counterCache' => true,
                'counterScope' => array('Image.active' => 1) // only count if "Image" is active = 1
            )
        );
    }

.. _multiple-counterCache:

Multiple counterCache
多个counterCache
=====================

CakePHP从2.0起在单一模型关联中支持多个``counterCache``。同样地可能需要为每个``counterCache``定义
``counterScope``。假设有一个``User``模型和``Message``模型，如果想统计每个用户已阅读信息和未阅读信息量。

Since 2.0 CakePHP supports having multiple ``counterCache`` in a single model
relation. It is also possible to define a ``counterScope`` for each ``counterCache``.
Assuming you have a ``User`` model and a ``Message`` model and you want to be able
to count the amount of read and unread messages for each user.

========= ====================== ===========================================
Model     Field                  Description
========= ====================== ===========================================
User      users.messages\_read   Count read ``Message``
--------- ---------------------- -------------------------------------------
User      users.messages\_unread Count unread ``Message``
--------- ---------------------- -------------------------------------------
Message   messages.is\_read      Determines if a ``Message`` is read or not.
========= ====================== ===========================================

像这样设置``belongsTo``::
With this setup your ``belongsTo`` would look like this::

    class Message extends AppModel {
        public $belongsTo = array(
            'User' => array(
                'counterCache' => array(
                    'messages_read' => array('Message.is_read' => 1),
                    'messages_unread' => array('Message.is_read' => 0)
                )
            )
        );
    }

hasAndBelongsToMany (HABTM)
---------------------------

现在，你已经是 CakePHP 模型关联的专家了。你已经深谙对象关系中的三种关联。

Alright. At this point, you can already call yourself a CakePHP
model associations professional. You're already well versed in the
three associations that take up the bulk of object relations.

现在我们来解决最后一种关系类型： hasAndBelongsToMany，也称为 HABTM。
这种关联用于两个模型需要多次重复以不同方式连接的场合。

Let's tackle the final relationship type: hasAndBelongsToMany, or
HABTM. This association is used when you have two models that need
to be joined up, repeatedly, many times, in many different ways.

hasMany 与 HABTM 主要不同点是 HABTM 中对象间的连接不是唯一的。
例如，以 HABTM 方式连接 Recipe 模型和 Ingredient 模型。
西红柿不只可以作为我奶奶意大利面（Recipe）的成分（Ingredient），我也可以用它做色拉（Recipe）。

The main difference between hasMany and HABTM is that a link
between models in HABTM is not exclusive. For example, we're about
to join up our Recipe model with an Ingredient model using HABTM.
Using tomatoes as an Ingredient for my grandma's spaghetti recipe
doesn't "use up" the ingredient. I can also use it for a salad Recipe.

hasMany 关联对象间的连接是唯一的。如果我们的 User hasMnay Comments，一个评论仅连接到一个特定的用户。它不能被再利用。

Links between hasMany associated objects are exclusive. If my User
hasMany Comments, a comment is only linked to a specific user. It's
no longer up for grabs.

继续前进。我们需要在数据库中设置一个额外的表，用来处理 HABTM 关联。
这个新连接表的名字需要包含两个相关模型的名字，按字母顺序并且用下划线( \_ )间隔。
表的内容有两个列，每个外键（整数类型）都指向相关模型的主键。为避免出现问题 - 不要为这个两个列定义复合主键，
如果应用程序包含复合主键，你可以定义一个唯一的索引（作为外键指向的键）。
如果你计划在这个表中加入任何额外的信息，或者使用 ‘with’ 模型，你需要添加一个附加主键列(约定为 ‘id’)

Moving on. We'll need to set up an extra table in the database to
handle HABTM associations. This new join table's name needs to
include the names of both models involved, in alphabetical order,
and separated with an underscore ( \_ ). The contents of the table
should be two fields, each foreign keys (which should be integers)
pointing to both of the primary keys of the involved models. To
avoid any issues - don't define a combined primary key for these
two fields, if your application requires it you can define a unique
index. If you plan to add any extra information to this table, or use
a 'with' model, you should add an additional primary key field (by convention
'id').

**HABTM** 包含一个单独的连接表，其表名包含两个 模型 的名字。
**HABTM** requires a separate join table that includes both *model*
names.

========================= ================================================================
Relationship              HABTM Table Fields
========================= ================================================================
Recipe HABTM Ingredient   **ingredients_recipes**.id, **ingredients_recipes**.ingredient_id, **ingredients_recipes**.recipe_id
------------------------- ----------------------------------------------------------------
Cake HABTM Fan            **cakes_fans**.id, **cakes_fans**.cake_id, **cakes_fans**.fan_id
------------------------- ----------------------------------------------------------------
Foo HABTM Bar             **bars_foos**.id, **bars_foos**.foo_id, **bars_foos**.bar_id
========================= ================================================================


.. note::

	按照约定，表名是按字母顺序组成的。在关联定义中自定义表名是可能的。
    Table names are by convention in alphabetical order. It is
    possible to define a custom table name in association definition

确保表 **cakes** 和 **recipes** 遵循了约定，由表中的 id 列担当主键。
如果它们与假定的不同，模型的 主键 必须被改变。参见:ref:`model-primaryKey`

Make sure primary keys in tables **cakes** and **recipes** have
"id" fields as assumed by convention. If they're different than
assumed, it has to be changed in model's :ref:`model-primaryKey`

一旦这个新表被建立，我们就可以在模型文件中建立 HABTM 关联了。这次我们将直接跳到数组语法：

Once this new table has been created, we can define the HABTM
association in the model files. We're gonna skip straight to the
array syntax this time::

    class Recipe extends AppModel {
        public $hasAndBelongsToMany = array(
            'Ingredient' =>
                array(
                    'className'              => 'Ingredient',
                    'joinTable'              => 'ingredients_recipes',
                    'foreignKey'             => 'recipe_id',
                    'associationForeignKey'  => 'ingredient_id',
                    'unique'                 => true,
                    'conditions'             => '',
                    'fields'                 => '',
                    'order'                  => '',
                    'limit'                  => '',
                    'offset'                 => '',
                    'finderQuery'            => '',
                    'deleteQuery'            => '',
                    'insertQuery'            => ''
                )
        );
    }

HABTM 关联数组可能包含的键有：

Possible keys for HABTM association arrays include:

.. _ref-habtm-arrays:

-  **className**: 关联到当前模型的模型类名。如果你定义了 ‘Recipe HABTM Ingredient’ 关系，这个类名将是 ‘Ingredient.’
-  **joinTable**: 在本关联中使用的连接表的名字（如果当前表没有按照 HABTM 连接表的约定命名的话）。
-  **with**: 为连接表定义模型名。默认的情况下，CakePHP 将自动为你建立一个模型。上例中，它被称为 IngredientsRecipe。
可以使用这个键来覆盖默认的名字。连接表模型能够像所有的 “常规” 模型那样用来直接访问连接表。
通过建立带有相同类名和文件名的模型类，可以向连接表搜索中加入任何自定义行为，例如向其加入更多的信息/列。
-  **foreignKey**: 当前模型中需要的外键。用于需要定义多个 HABTM 关系。其默认值为当前模型的单数模型名缀以 ‘_id’。
-  **associationForeignKey**: 另一张表中的外键名。用于需要定义多个 HABTM 关系。其默认值为另一模型的单数模型名缀以 ‘_id’。
-  **unique**: 布尔值或者字符串``keepExisting``。
    - 如果为 true （默认值），Cake 将在插入新行前删除外键表中存在的相关记录。现有的关系在更新时需要再次传递。
    - 如果为 false，Cake 将插入相关记录，并且在保存过程中不删除连接记录。
    - 如果设置为 keepExisting，其行为与`true`相同，但现有关联不被删除。
-  **conditions**: 一个find()兼容条件的数组或者SQL字符串。如果在关联表上设置了条件，需要使用 ‘with’ 模型，并且在其上定义必要的belongsTo关联。
-  **fields**: 需要在匹配的关联模型数据中获取的字段的列表。默认返回所有的字段。
-  **order**: 一个 find() 兼容排序子句或者 SQL 字符串。
-  **limit**: 想返回的关联行的最大行数。
-  **offset**: 获取和关联前要跳过的行数(根据提供的条件 - 多数用于分页时的当前页的偏移量)
-  **finderQuery, deleteQuery, insertQuery**: CakePHP 能用来获取、删除或者建立新的关联模型记录的完整 SQL 查询语句。用在包含很多自定义结果的场合。

-  **className**: the classname of the model being associated to
   the current model. If you're defining a ‘Recipe HABTM Ingredient'
   relationship, the className key should equal ‘Ingredient.'
-  **joinTable**: The name of the join table used in this
   association (if the current table doesn't adhere to the naming
   convention for HABTM join tables).
-  **with**: Defines the name of the model for the join table. By
   default CakePHP will auto-create a model for you. Using the example
   above it would be called IngredientsRecipe. By using this key you can
   override this default name. The join table model can be used just
   like any "regular" model to access the join table directly. By creating
   a model class with such name and filename you can add any custom behavior
   to the join table searches, such as adding more information/columns to it
-  **foreignKey**: the name of the foreign key found in the current
   model. This is especially handy if you need to define multiple
   HABTM relationships. The default value for this key is the
   underscored, singular name of the current model, suffixed with
   ‘\_id'.
-  **associationForeignKey**: the name of the foreign key found in
   the other model. This is especially handy if you need to define
   multiple HABTM relationships. The default value for this key is the
   underscored, singular name of the other model, suffixed with
   ‘\_id'.
-  **unique**: boolean or string ``keepExisting``.
    - If true (default value) cake will first delete existing relationship
      records in the foreign keys table before inserting new ones.
      Existing associations need to be passed again when updating.
    - When false, cake will insert the relationship record, and that
      no join records are deleted during a save operation.
    - When set to ``keepExisting``, the behavior is similar to `true`,
      but existing associations are not deleted.
-  **conditions**: an array of find() compatible conditions or SQL
   string.  If you have conditions on an associated table, you should use a
   'with' model, and define the necessary belongsTo associations on it.
-  **fields**: A list of fields to be retrieved when the associated
   model data is fetched. Returns all fields by default.
-  **order**: an array of find() compatible order clauses or SQL
   strings
-  **limit**: The maximum number of associated rows you want
   returned.
-  **offset**: The number of associated rows to skip over (given
   the current conditions and order) before fetching and associating.
-  **finderQuery, deleteQuery, insertQuery**: A complete SQL query
   CakePHP can use to fetch, delete, or create new associated model
   records. This should be used in situations that require very custom
   results.

一旦关联被创建，Recipe 模型上的 find 操作将可同时获取到存在的相关的 Tag 记录::

Once this association has been defined, find operations on the
Recipe model will also fetch related Tag records if they exist::

    // Sample results from a $this->Recipe->find() call.

    Array
    (
        [Recipe] => Array
            (
                [id] => 2745
                [name] => Chocolate Frosted Sugar Bombs
                [created] => 2007-05-01 10:31:01
                [user_id] => 2346
            )
        [Ingredient] => Array
            (
                [0] => Array
                    (
                        [id] => 123
                        [name] => Chocolate
                    )
               [1] => Array
                    (
                        [id] => 124
                        [name] => Sugar
                    )
               [2] => Array
                    (
                        [id] => 125
                        [name] => Bombs
                    )
            )
    )

如果在使用 Ingredient 模型时想获取 Recipe 数据，记得在 Ingredient 模型中定义 HABTM 关联。

Remember to define a HABTM association in the Ingredient model if you'd
like to fetch Recipe data when using the Ingredient model.

.. note::

   HABTM 数据被视为完整的数据集。每次一个新的关联数据被加入，数据库中的关联行的完整数据集被删除并重新建立。
   所以总是需要为保存操作传递整个数据集。使用 HABTM 的另一方法参见:ref:`hasMany-through`

   HABTM data is treated like a complete set, each time a new data association is added
   the complete set of associated rows in database is dropped and created again so you
   will always need to pass the whole data set for saving. For an alternative to using
   HABTM see :ref:`hasMany-through`

.. tip::

	关于保存 HABTM 对象的更多信息请参见:ref:`saving-habtm`
    For more information on saving HABTM objects see :ref:`saving-habtm`


.. _hasMany-through:

hasMany through (The Join Model)
hasMany 贯穿(连接模型)
--------------------------------

有时候需要存储带有多对多关系的附加数据。考虑以下情况：

It is sometimes desirable to store additional data with a many to
many association. Consider the following

`Student hasAndBelongsToMany Course`

`Course hasAndBelongsToMany Student`

换句话说，一个Student可以有很多Courses，而一个Course也能被多个Student选择。 这个简单的多对多关联需要一个类似于如下结构的表::
    id | student_id | course_id

In other words, a Student can take many Courses and a Course can be
taken by many Students. This is a simple many to many association
demanding a table such as this::

    id | student_id | course_id

现在，如果我们要存储学生在课程上出席的天数及他们的最终级别，这张表将变成::
    id | student_id | course_id | days_attended | grade

问题是，hasAndBelongsToMany 不支持这类情况，因为 hasAandBelongsToMany 关联被存储时，先要删除这个关联。列中的额外数据会丢失，且放到新插入的数据中。

Now what if we want to store the number of days that were attended
by the student on the course and their final grade? The table we'd
want would be::

    id | student_id | course_id | days_attended | grade

The trouble is, hasAndBelongsToMany will not support this type of
scenario because when hasAndBelongsToMany associations are saved,
the association is deleted first. You would lose the extra data in
the columns as it is not replaced in the new insert.

    .. versionchanged:: 2.1

	你可以将 unique 设置为 keepExisting 防止在保存过程丢失额外的数据。
	参阅:ref:`HABTM association arrays <ref-habtm-arrays>`。

    You can set ``unique`` setting to ``keepExisting`` circumvent
    losing extra data during the save operation.  See ``unique``
    key in :ref:`HABTM association arrays <ref-habtm-arrays>`.

实现我们的要求的方法是使用一个**连接模型**，或者也称为**hasMany through**关联。
具体作法是模型与自身关联。现在我们建立一个新的模型 CourseMembership。下面是此模型的定义。

The way to implement our requirement is to use a **join model**,
otherwise known as a **hasMany through** association.
That is, the association is a model itself. So, we can create a new
model CourseMembership. Take a look at the following models.::

            // Student.php
            class Student extends AppModel {
                public $hasMany = array(
                    'CourseMembership'
                );
            }

            // Course.php

            class Course extends AppModel {
                public $hasMany = array(
                    'CourseMembership'
                );
            }

            // CourseMembership.php

            class CourseMembership extends AppModel {
                public $belongsTo = array(
                    'Student', 'Course'
                );
            }

CourseMembership 连接模型唯一标识了一个给定的学生额外参与的课程，存入扩展元信息中。

The CourseMembership join model uniquely identifies a given
Student's participation on a Course in addition to extra
meta-information.

连接表非常有用，Cake使其非常容易地与内置的hasMany和belongsTo关联及saveAll特性一同使用。

Join models are pretty useful things to be able to use and Cake
makes it easy to do so with its built-in hasMany and belongsTo
associations and saveAll feature.

.. _dynamic-associations:

Creating and Destroying Associations on the Fly
动态创建和销毁关联
-----------------------------------------------

有时候需要在运行时动态建立和销毁模型关联。比如以下几种情况:
Sometimes it becomes necessary to create and destroy model
associations on the fly. This may be for any number of reasons:

-  想减少获取的关联数据的量，但是所有的关联都是循环的第一级。
-  想要改变定义关联的方法以便排序或者过滤关联数据。

这种关联的建立与销毁由 CakePHP 模型 bindModel() 和 unbindModel() 方法完成。
(还有一个非常有用的行为叫 "Containable"，更多信息请参阅手册中 内置行为 一节)。
我们来设置几个模型，看看 bindModel() 和 unbindModel() 如何工作。
我们从两个模型开始::

This association creation and destruction is done using the CakePHP
model bindModel() and unbindModel() methods. (There is also a very
helpful behavior called "Containable", please refer to manual
section about Built-in behaviors for more information). Let's set
up a few models so we can see how bindModel() and unbindModel()
work. We'll start with two models::

    class Leader extends AppModel {
        public $hasMany = array(
            'Follower' => array(
                'className' => 'Follower',
                'order'     => 'Follower.rank'
            )
        );
    }

    class Follower extends AppModel {
        public $name = 'Follower';
    }

现在，在LeaderController控制器中，我们能够使用Leader模型的find()方法获取一个Leader和它的追随者(followers) 。
就像你上面看到的那样，Leader 模型的关联关系数组定义了"Leader hasMany Followers"关系。
为了演示一下实际效果，我们使用 unbindModel() 删除控制器动作中的关联::

Now, in the LeadersController, we can use the find() method in the
Leader model to fetch a Leader and its associated followers. As you
can see above, the association array in the Leader model defines a
"Leader hasMany Followers" relationship. For demonstration
purposes, let's use unbindModel() to remove that association in a
controller action::

    public function some_action() {
    	// 获取 Leaders 及其相关的 Followers
        // This fetches Leaders, and their associated Followers
        $this->Leader->find('all');

		// 删除 hasMany...
        // Let's remove the hasMany...
        $this->Leader->unbindModel(
            array('hasMany' => array('Follower'))
        );

		// 现在使用 find 函数将只返回 Leaders，没有 Followers
        // Now using a find function will return
        // Leaders, with no Followers
        $this->Leader->find('all');

		// NOTE: unbindModel 只影响紧随其后的 find 函数。再往后的 find 调用仍将使用预配置的关联信息。
        // NOTE: unbindModel only affects the very next
        // find function. An additional find call will use
        // the configured association information.

		// 所以此处在unbindModel()后面再次使用find('all')，又会获取 Leaders 及与其相关的 Followers ...
        // We've already used find('all') after unbindModel(),
        // so this will fetch Leaders with associated
        // Followers once again...
        $this->Leader->find('all');
    }

.. note::

	使用 bindModel() 和 unbindModel() 来添加和删除关联，仅在*紧随其后* 的 find 操作中有效，除非第二个参数设置为*false*。
	如果第二个参数被设置为 false，请求的剩余位置仍将保持 bind 行为。

    Removing or adding associations using bind- and unbindModel() only
    works for the *next* find operation only unless the second
    parameter has been set to false. If the second parameter has been
    set to *false*, the bind remains in place for the remainder of the
    request.

以下是 unbindModel() 的基本用法模板::
Here’s the basic usage pattern for unbindModel()::

    $this->Model->unbindModel(
        array('associationType' => array('associatedModelClassName'))
    );

现在我们成功地在运行过程中删除了一个关联。 让我们来添加一个。
我们要为没有Principle的Leader模型来一些Principle关联。
我们的Principle模型文件除了public $name声明语句之外，什么都没有。
我们在运行中给我们的Leader关联一些 Principles(谨记它仅在紧随其后的 find 操作中有效)。
在 LeadersController 中的函数如下::

Now that we've successfully removed an association on the fly,
let's add one. Our as-of-yet unprincipled Leader needs some
associated Principles. The model file for our Principle model is
bare, except for the public $name statement. Let's associate some
Principles to our Leader on the fly (but remember–only for just the
following find operation). This function appears in the
LeadersController::

    public function another_action() {
     	// 在 leader.php 文件中没有 Leader hasMany Principles 关联，所以这里的 find 只获取了 Leaders。
        // There is no Leader hasMany Principles in
        // the leader.php model file, so a find here,
        // only fetches Leaders.
        $this->Leader->find('all');

		// 我们来用 bindModel() 为 Leader 模型添加一个新的关联：
        // Let's use bindModel() to add a new association
        // to the Leader model:
        $this->Leader->bindModel(
            array('hasMany' => array(
                    'Principle' => array(
                        'className' => 'Principle'
                    )
                )
            )
        );

		// 现在我们已经正确的设置了关联，我们可以使用单个的 find 函数来获取带有相关 principles 的 Leader：
        // Now that we're associated correctly,
        // we can use a single find function to fetch
        // Leaders with their associated principles:
        $this->Leader->find('all');
    }

就是这样。bindModel() 的基本用法是封装在以你尝试建立的关联类型命名的数组中的常规数组::

    $this->Model->bindModel(
        array('associationName' => array(
                'associatedModelClassName' => array(
                    // normal association keys go here...
                )
            )
        )
    );

即使不需要通过绑定模型对模型文件中的关联定义做任何排序，仍然需要为使新关联正常工作设置正确的排序键

Even though the newly bound model doesn't need any sort of
association definition in its model file, it will still need to be
correctly keyed in order for the new association to work properly.

Multiple relations to the same model
同一模型上的多个关系
------------------------------------

有时一个模型有多个与其它模型的关联。例如，你可能需要有一个关联两个User模型的Message模型。
一个是要向其发送消息的用户，一个是从其接收消息的用户。
消息表有一个user\_id字段，还有一个 recipient\_id字段。这样的话消息模型看起来就像下面这样::

There are cases where a Model has more than one relation to another
Model. For example you might have a Message model that has two
relations to the User model. One relation to the user that sends a
message, and a second to the user that receives the message. The
messages table will have a field user\_id, but also a field
recipient\_id. Now your Message model can look something like::

    class Message extends AppModel {
        public $belongsTo = array(
            'Sender' => array(
                'className' => 'User',
                'foreignKey' => 'user_id'
            ),
            'Recipient' => array(
                'className' => 'User',
                'foreignKey' => 'recipient_id'
            )
        );
    }

Recipient 是 User 模型的别名。来瞧瞧 User 模型是什么样的：

Recipient is an alias for the User model. Now let's see what the
User model would look like::

    class User extends AppModel {
        public $hasMany = array(
            'MessageSent' => array(
                'className' => 'Message',
                'foreignKey' => 'user_id'
            ),
            'MessageReceived' => array(
                'className' => 'Message',
                'foreignKey' => 'recipient_id'
            )
        );
    }

它也可以建立如下的自关联::

It is also possible to create self associations as shown below::

    class Post extends AppModel {

        public $belongsTo = array(
            'Parent' => array(
                'className' => 'Post',
                'foreignKey' => 'parent_id'
            )
        );

        public $hasMany = array(
            'Children' => array(
                'className' => 'Post',
                'foreignKey' => 'parent_id'
            )
        );
    }

**获取关联记录的嵌套数组:**
**Fetching a nested array of associated records:**

如果表里有 parent_id 可以使用:ref:`model-find-threaded`来获取单个查询记录的嵌套数组而不用再设置任何关联设置。

If your table has ``parent_id`` field you can also use :ref:`model-find-threaded`
to fetch nested array of records using a single query without
setting up any associations.

.. _joining-tables:

Joining tables
连接表
--------------

在SQL中你可以使用JOIN子句绑定相关表。这允许你运行跨越多个表的复杂查询(例如：按给定的几个 tag 搜索帖子)。

In SQL you can combine related tables using the JOIN statement.
This allows you to perform complex searches across multiples tables
(i.e: search posts given several tags).

在 CakePHP 中一些关联（belongsTo 和 hasOne）自动执行 join 以检索数据，所以能根据相关数据检索模型的查询。

In CakePHP some associations (belongsTo and hasOne) performs
automatic joins to retrieve data, so you can issue queries to
retrieve models based on data in the related one.

但是这不适用于 hasMany 和 hasAndBelongsToMany 关联。这些地方需要强制向循环中添加 join。
你必须定义与要联合的表的必要连接（join），使你的查询获得期望的结果。

But this is not the case with hasMany and hasAndBelongsToMany
associations. Here is where forcing joins comes to the rescue. You
only have to define the necessary joins to combine tables and get
the desired results for your query.

.. note::

	谨记，你需要将 recursion 设置为 -1，以使其正常工作。例如： $this->Channel->recursive = -1;
    Remember you need to set the recursion to -1 for this to work. I.e:
    $this->Channel->recursive = -1;

在表间强制添加 join 时，你需要在调用 Model::find() 时使用 "modern"语法，在 $options 数组中添加'joins'键。例如::
To force a join between tables you need to use the "modern" syntax
for Model::find(), adding a 'joins' key to the $options array. For
example::

    $options['joins'] = array(
        array('table' => 'channels',
            'alias' => 'Channel',
            'type' => 'LEFT',
            'conditions' => array(
                'Channel.id = Item.channel_id',
            )
        )
    );

    $Item->find('all', $options);

.. note::

	注意'join'数组不是一个键。
    Note that the 'join' arrays are not keyed.

在上面的例子中，叫做 Item 的模型 left join 到 channels 表。可以用模型名为表起别名，以使检索到的数组完全符合 CakePHP 的数据结构。
In the above example, a model called Item is left joined to the
channels table. You can alias the table with the Model name, so the
retrieved data complies with the CakePHP data structure.

定义 join 所用的键如下:
The keys that define the join are the following:

-  **table**: 要连接的表。
-  **alias**: 表的别名。最好使用关联模型名。
   associated with the table is the best bet.
-  **type**: 连接类型： inner， left 或者 right。
-  **conditions**: 执行 join 的条件。

-  **table**: The table for the join.
-  **alias**: An alias to the table. The name of the model
   associated with the table is the best bet.
-  **type**: The type of join: inner, left or right.
-  **conditions**: The conditions to perform the join.

对于 joins 选项，可以添加基于关系模型字段的条件：

With joins, you could add conditions based on Related model
fields::

    $options['joins'] = array(
        array('table' => 'channels',
            'alias' => 'Channel',
            'type' => 'LEFT',
            'conditions' => array(
                'Channel.id = Item.channel_id',
            )
        )
    );

    $options['conditions'] = array(
        'Channel.private' => 1
    );

    $privateItems = $Item->find('all', $options);

可以在 hasAndBelongsToMany 中运行几个需要的 joins:
You could perform several joins as needed in hasAndBelongsToMany:

Suppose a Book hasAndBelongsToMany Tag association. This relation
uses a books\_tags table as join table, so you need to join the
books table to the books\_tags table, and this with the tags
table::

    $options['joins'] = array(
        array('table' => 'books_tags',
            'alias' => 'BooksTag',
            'type' => 'inner',
            'conditions' => array(
                'Books.id = BooksTag.books_id'
            )
        ),
        array('table' => 'tags',
            'alias' => 'Tag',
            'type' => 'inner',
            'conditions' => array(
                'BooksTag.tag_id = Tag.id'
            )
        )
    );

    $options['conditions'] = array(
        'Tag.tag' => 'Novel'
    );

    $books = $Book->find('all', $options);

使用 joins 允许你以极为灵活的方式处理 CakePHP 的关系并获取数据，但是在很多情况下，你能使用其它工具达到同样的目的，
例如正确地定义关联，运行时绑定模型或者使用 Containable 行为。
使用这种特性要很小心，因为它在某些情况下可能会带来模式不规范的SQL查询。

Using joins allows you to have a maximum flexibility in how CakePHP handles associations
and fetch the data, however in most cases you can use other tools to achieve the same results
such as correctly defining associations, binding models on the fly and using the Containable
behavior. This feature should be used with care because it could lead, in a few cases, into bad formed
SQL queries if combined with any of the former techniques described for associating models.


.. meta::
    :title lang=en: Associations: Linking Models Together
    :keywords lang=en: relationship types,relational mapping,recipe database,relational database,this section covers,web applications,recipes,models,cakephp,storage
