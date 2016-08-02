Containable
###########

.. php:class:: ContainableBehavior()

``ContainableBehavior``是CakePHP 1.2中新添加的。
这个模型行为可以过滤和限制模型查询操作。使用Containable
帮助削减不必要的数据损耗。提高速度和应用程序的整体性能。
同样能够通过干净一致的方式为你的客户提供查询和过滤数据的功能。

A new addition to the CakePHP 1.2 core is the
``ContainableBehavior``. This model behavior allows you to filter
and limit model find operations. Using Containable will help you
cut down on needless wear and tear on your database, increasing the
speed and overall performance of your application. The class will
also help you search and filter your data for your users in a clean
and consistent way.

Containable使得模型绑定更加合理和简化操作。它通过临时或永久
的改变模型关联。通过提供的containments生成一系列``bindModel``和
``unbindModel``调用。由于Containable只修改存在的模型关联，
并不允许你限制通过远程关联的结果。应该使用:ref:`joining-tables`。

Containable allows you to streamline and simplify operations on
your model bindings. It works by temporarily or permanently
altering the associations of your models. It does this by using
supplied the containments to generate a series of ``bindModel`` and
``unbindModel`` calls. Since Containable only modifies existing relationships it
will not allow you to restrict results by distant associations. Instead
you should refer to :ref:`joining-tables`.

为了使用此新的行为，要在模型中添加$actsAs属性。

To use the new behavior, you can add it to the $actsAs property of
your model::

    class Post extends AppModel {
        public $actsAs = array('Containable');
    }

可以动态使用此行为
You can also attach the behavior on the fly::

    $this->Post->Behaviors->load('Containable');

.. _using-containable:

使用Containable
Using Containable
~~~~~~~~~~~~~~~~~

为了搞清Containable是如何工作的。先看几个例子。首先，我们在一个名为
Post的模型上使用find()查询操作，Post 包含很多条(hasMany)评论(Comment)，并且Posts属于多个
(hasAndBelongsToMany) 标签(Tag)。被抓取的数据量比正常情况下被扩展很多。

To see how Containable works, let's look at a few examples. First,
we'll start off with a find() call on a model named Post. Let's say
that Post hasMany Comment, and Post hasAndBelongsToMany Tag. The
amount of data fetched in a normal find() call is rather
extensive::

    debug($this->Post->find('all'));

    [0] => Array
            (
                [Post] => Array
                    (
                        [id] => 1
                        [title] => First article
                        [content] => aaa
                        [created] => 2008-05-18 00:00:00
                    )
                [Comment] => Array
                    (
                        [0] => Array
                            (
                                [id] => 1
                                [post_id] => 1
                                [author] => Daniel
                                [email] => dan@example.com
                                [website] => http://example.com
                                [comment] => First comment
                                [created] => 2008-05-18 00:00:00
                            )
                        [1] => Array
                            (
                                [id] => 2
                                [post_id] => 1
                                [author] => Sam
                                [email] => sam@example.net
                                [website] => http://example.net
                                [comment] => Second comment
                                [created] => 2008-05-18 00:00:00
                            )
                    )
                [Tag] => Array
                    (
                        [0] => Array
                            (
                                [id] => 1
                                [name] => Awesome
                            )
                        [1] => Array
                            (
                                [id] => 2
                                [name] => Baking
                            )
                    )
            )
    [1] => Array
            (
                [Post] => Array
                    (...

在你的应用成员中的一些接口，可能并不需要从Post模型中获取那么
多信息。``ContainableBehavior``要做的就是帮助你削减find()返回的内容。

For some interfaces in your application, you may not need that much
information from the Post model. One thing the
``ContainableBehavior`` does is help you cut down on what find()
returns.

举例。只获取与post关联的信息。
For example, to get only the post-related information, you can do
the following::

    $this->Post->contain();
    $this->Post->find('all');

可以在find()方法内部调用contain。

You can also invoke Containable's magic from inside the find()
call::

    $this->Post->find('all', array('contain' => false));

经过这么处理，结果会简洁许多
Having done that, you end up with something a lot more concise::

    [0] => Array
            (
                [Post] => Array
                    (
                        [id] => 1
                        [title] => First article
                        [content] => aaa
                        [created] => 2008-05-18 00:00:00
                    )
            )
    [1] => Array
            (
                [Post] => Array
                    (
                        [id] => 2
                        [title] => Second article
                        [content] => bbb
                        [created] => 2008-05-19 00:00:00
                    )
            )

这种情况并不新颖，实际上，也可以不使用``ContainableBehavior``。

This sort of help isn't new: in fact, you can do that without the
``ContainableBehavior`` doing something like this::

    $this->Post->recursive = -1;
    $this->Post->find('all');

Containable在处理同层内容复杂关联时很有用，当要削减多层内容时，
模型的``$recursive``属性会更有效。若要想保持层级结构并且每层都
挑选所需的内容，我们来瞧瞧使用``contain()``方法是怎么处理的。

Containable really shines when you have complex associations, and
you want to pare down things that sit at the same level. The
model's ``$recursive`` property is helpful if you want to hack off
an entire level of recursion, but not when you want to pick and
choose what to keep at each level. Let's see how it works by using
the ``contain()`` method.

contain方法的第一个参数接收模型名或多个模型名的数组。
如果要抓取所有的post和与他们关联的tags(不要任何comment信息)，
我们可以这么做::

The contain method's first argument accepts the name, or an array
of names, of the models to keep in the find operation. If we wanted
to fetch all posts and their related tags (without any comment
information), we'd try something like this::

    $this->Post->contain('Tag');
    $this->Post->find('all');

同样，可以在find()内使用contain键名。
Again, we can use the contain key inside a find() call::

    $this->Post->find('all', array('contain' => 'Tag'));

不用Containable，可能要使用多次``unbindModel()``方法来解绑多个模型，
Containable则创建了一种更简洁的方法来完成同样的工作。

Without Containable, you'd end up needing to use the
``unbindModel()`` method of the model, multiple times if you're
paring off multiple models. Containable creates a cleaner way to
accomplish this same task.

包含更深的关联
Containing deeper associations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Containable可以更深一步：可以过滤被关联的*associated*模型的数据。
瞧一下调用find()返回的结果，注意到有Comment模型中的author字段。
若需要保留此字段。可以这么做。

Containable also goes a step deeper: you can filter the data of the
*associated* models. If you look at the results of the original
find() call, notice the author field in the Comment model. If you
are interested in the posts and the names of the comment authors —
and nothing else — you could do something like the following::

    $this->Post->contain('Comment.author');
    $this->Post->find('all');

    // 或者
    // or..

    $this->Post->find('all', array('contain' => 'Comment.author'));

这里，我们告诉Containable提供给我们post的信息，并且仅需要
关联的Comment模型中的author字段。输出的结果类似这样::

Here, we've told Containable to give us our post information, and
just the author field of the associated Comment model. The output
of the find call might look something like this::

    [0] => Array
            (
                [Post] => Array
                    (
                        [id] => 1
                        [title] => First article
                        [content] => aaa
                        [created] => 2008-05-18 00:00:00
                    )
                [Comment] => Array
                    (
                        [0] => Array
                            (
                                [author] => Daniel
                                [post_id] => 1
                            )
                        [1] => Array
                            (
                                [author] => Sam
                                [post_id] => 1
                            )
                    )
            )
    [1] => Array
            (...

若你所见，Comment数组仅包含author字段(加上post\_id，CakePHP需要它来映射结果)。
As you can see, the Comment arrays only contain the author field
(plus the post\_id which is needed by CakePHP to map the results).

同样可以指定条件来过滤关联的Comment数据。
You can also filter the associated Comment data by specifying a
condition::

    $this->Post->contain('Comment.author = "Daniel"');
    $this->Post->find('all');

    //或者...
    //or...

    $this->Post->find('all', array('contain' => 'Comment.author = "Daniel"'));

获取评论的作者是Daniel的所有posts。
This gives us a result that gives us posts with comments authored
by Daniel::

    [0] => Array
            (
                [Post] => Array
                    (
                        [id] => 1
                        [title] => First article
                        [content] => aaa
                        [created] => 2008-05-18 00:00:00
                    )
                [Comment] => Array
                    (
                        [0] => Array
                            (
                                [id] => 1
                                [post_id] => 1
                                [author] => Daniel
                                [email] => dan@example.com
                                [website] => http://example.com
                                [comment] => First comment
                                [created] => 2008-05-18 00:00:00
                            )
                    )
            )

额外的过滤可以参见:ref:`model-find` options::
Additional filtering can be performed by supplying the standard :ref:`model-find` options::

    $this->Post->find('all', array('contain' => array(
        'Comment' => array(
            'conditions' => array('Comment.author =' => "Daniel"),
            'order' => 'Comment.created DESC'
        )
    )));

下面是个使用``ContainableBehavior``获取深层和复杂的模型关联例子。

Here's an example of using the ``ContainableBehavior`` when you've
got deep and complex model relationships.

让我们考虑下面的模型关联。
Let's consider the following model associations::

    User->Profile
    User->Account->AccountSummary
    User->Post->PostAttachment->PostAttachmentHistory->HistoryNotes
    User->Post->Tag

使用Containable检索上面的关联::
This is how we retrieve the above associations with Containable::

    $this->User->find('all', array(
        'contain' => array(
            'Profile',
            'Account' => array(
                'AccountSummary'
            ),
            'Post' => array(
                'PostAttachment' => array(
                    'fields' => array('id', 'name'),
                    'PostAttachmentHistory' => array(
                        'HistoryNotes' => array(
                            'fields' => array('id', 'note')
                        )
                    )
                ),
                'Tag' => array(
                    'conditions' => array('Tag.name LIKE' => '%happy%')
                )
            )
        )
    ));

切记``contain``作为键名在主模型中只能使用一次。不要在关联的模型中多次使用。
Keep in mind that ``contain`` key is only used once in the main
model, you don't need to use 'contain' again for related models

.. note::

    当使用 'fields' 和 'contain'选项，切记要包含所有的外键。无论是
    直接或间接查询。同时要注意，因为Containable必须依附于所有的模型，
    也可以在AppModel中使用。

    When using 'fields' and 'contain' options - be careful to include
    all foreign keys that your query directly or indirectly requires.
    Please also note that because Containable must to be attached to
    all models used in containment, you may consider attaching it to
    your AppModel.

ContainableBehavior 选项
ContainableBehavior options
~~~~~~~~~~~~~~~~~~~~~~~~~~~

当``ContainableBehavior``依附于一个模型，有很多选项可用。
使用这些设置可以对Containable行为进行微调与其他行为一起工作时
更加简单。

The ``ContainableBehavior`` has a number of options that can be set
when the Behavior is attached to a model. The settings allow you to
fine tune the behavior of Containable and work with other behaviors
more easily.

-  **recursive** (布尔型, 可选) 设为真时允许containable自动决定指定模型要抓取数据的递归层次，
   设置为false禁用这个特性，默认为``true``。
-  **notices** (布尔型, 可选) 当绑定一个无效的引用时触发警告。默认值``true``。
-  **autoFields**: (布尔型, 可选) 当抓取被请求的绑定时自动添加所需要的字段，默认值``true``.

-  **recursive** (boolean, optional) set to true to allow
   containable to automatically determine the recursiveness level
   needed to fetch specified models, and set the model recursiveness
   to this level. setting it to false disables this feature. The
   default value is ``true``.
-  **notices** (boolean, optional) issues E\_NOTICES for bindings
   referenced in a containable call that are not valid. The default
   value is ``true``.
-  **autoFields**: (boolean, optional) auto-add needed fields to
   fetch requested bindings. The default value is ``true``.

可以在运行时改变ContainableBehavior的设置。

:doc:`/models/behaviors`
You can change ContainableBehavior settings at run time by
reattaching the behavior as seen in
:doc:`/models/behaviors` (Using Behaviors).

ContainableBehavior有时会和其他行为导致问题或使用聚合函数and/or GROUP BY语句
的时候。如果因为掺杂聚合和非聚合字段得到了无效的SQL语句的错误，尝试禁用
``autoFields``设置。

ContainableBehavior can sometimes cause issues with other behaviors
or queries that use aggregate functions and/or GROUP BY statements.
If you get invalid SQL errors due to mixing of aggregate and
non-aggregate fields, try disabling the ``autoFields`` setting.::

    $this->Post->Behaviors->load('Containable', array('autoFields' => false));

分页时使用Containable
Using Containable with pagination
=================================

可以在``$paginate``分页属性中包含 'contain'参数，在find('count')和find('all') 同样适用。
By including the 'contain' parameter in the ``$paginate`` property
it will apply to both the find('count') and the find('all') done on
the model.

参见 :ref:`using-containable` 章节获得更多细节。
See the section :ref:`using-containable` for further details.

下面是一个分页时使用contain关联的例子::
Here's an example of how to contain associations when paginating::

    $this->paginate['User'] = array(
        'contain' => array('Profile', 'Account'),
        'order' => 'User.username'
    );

    $users = $this->paginate('User');


.. meta::
    :title lang=zh: Containable
    :keywords lang=zh: model behavior,author daniel,article content,new addition,wear and tear,array,aaa,email,fly,models
