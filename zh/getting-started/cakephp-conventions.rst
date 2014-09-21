CakePHP命名约定
###################

我们是命名规则的拥护者。虽然需要花费一点时间来学习CakePHP的命名规则,但是遵循下面的约定，你能在开发上省下大把的时间。

CakePHP的命名约定汲取了许多开发者多年的经验和实践。这些规则也很容易被重写，即在修改旧系统时显得更为轻松。



控制器命名约定 Controller Conventions
======================

控制器的名字必须用复数，驼峰法表示。最后缀上 ``Controller`` 。``PeopleController`` 和 ``LatestArticlesController`` 都是符合约定的例子。

控制器的第一个方法应该是 ``index()`` 方法。当一个请求指定了控制器但没有指定方法时，CakePHP会默认执行那个控制器的
``index()`` 方法。例如, 请求地址http://www.example.com/apples/ 会被映射到 ``ApplesController`` 控制器的 ``index()`` 方法。
而 http://www.example.com/apples/view/ 会被映射到 ``ApplesController`` 的 ``view()`` 方法。

通过在控制器的方法名前加下划线可以改变该方法的可见性。如果一个方法名前面带一个下划线(_)，是无法通过web访问的，但是可以内部调用。
例如::

    class NewsController extends AppController {

        public function latest() {
            $this->_findNewArticles();
        }

        protected function _findNewArticles() {
            // Logic to find latest news articles
        }
    }


用户可以访问 http://www.example.com/news/latest/ 页面, 而访问
http://www.example.com/news/\_findNewArticles/ 会报错，
因为该方法名前带了下划线，你也可以使用PHP的访问修饰符来表明一个方法可否通过URL地址访问。非Public方法是不能直接访问。

有关控制器命名的注意事项
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

正如你所见，控制器名用单个单词命名很容易通过他的小写字母来访问。例如 ``ApplesController`` (对应的文件名为 'ApplesController.php' )
可通过 http://example.com/apples 访问。

多个单词命名的控制器，可通过以下的变换形式访问，他们都是等价的。
Multiple word controllers *can* be any 'inflected' form which
equals the controller name so:

- /redApples
- /RedApples
- /Red_apples
- /red_apples

以上都能访问到RedApples控制器的index方法，不管怎样, 按照命名规则的约定，你的url应该由小写字母和下划线组成,因此 /red_apples/go_pick 可以访问到
``RedApplesController::go_pick``。

有关CakePHP的URL和参数处理，参见 :ref:`路由配置 routes-configuration`

.. 文件和类名命名规则:
.. _file-and-classname-conventions:

文件和类名命名约定
==============================

通常，文件名和类名相匹配，使用驼峰命名法。举例来说，如果一个类名 **MyNiftyClass** 它的文件名会是MyNiftyClass.php。 以下是一些如何为各种类型类名命名的例子，
这些例子在CakePHP应用程序中大部分会用到：

-  控制器类 **KissesAndHugsController** 被命名为 **KissesAndHugsController.php**
-  组件类 **MyHandyComponent** 被命名为 **MyHandyComponent.php**
-  模型类 **OptionValue** 被命名为 **OptionValue.php**
-  行为类 **EspeciallyFunkableBehavior** 被命名为 **EspeciallyFunkableBehavior.php**
-  视图类 **SuperSimpleView** 被命名为 **SuperSimpleView.php**
-  助手类 **BestEverHelper** 被命名为 **BestEverHelper.php**


每个文件都会被放置于app目录下适当的子目录中。

模型和数据库命名约定
==============================

模型名称是单数驼峰形式。Person、BigPerson和ReallyBigPerson都是符合命名约定的例子。

模型对应的数据表名称是复数且以下划线分隔 ``people``, ``big_people``, 和 ``really_big_people``,
各自对应上面的模型。

你可以使用实用库中的 :php:class:`Inflector` 这个类中的方法去检测单词的单复数。参见
:doc:`/core-utility-libraries/inflector`。

字段名由多个单词包含的下划线组成，如first_name。

hasMany、belongsTo或hasOne关系模型中的外键名称会在相关模型在之后缀上_id。如果一个Baker表有许多Cake，cakes这个数据表会通过baker_id这个外键与bakers表关联。
复数单词的数据表名如category_types，她的外键应该为category_type_id。

连接多个数据表，使用hasAndBelongsToMany (HABTM)关系模型之间的命名方式必需依照字母先后次序(是apples_zebras而不是zebras_apples)。

所有数据表与CakePHP模型互动(除了join数据表)需要有一个主键使每一列单一识别。如果你希望使用无单一识别主键的数据表，
像是你的posts_tags结合数据表，CakePHP的命名规则就是加在数据表名称的单一主键。

All tables with which CakePHP models interact (with the exception
of join tables), require a singular primary key to uniquely
identify each row. If you wish to model a table which does not have
a single-field primary key, CakePHP's convention is that a
single-field primary key is added to the table. You have to add a
single-field primary key if you want to use that table's model.

CakePHP不支持复合主键。在这情况下你要直接操作你的连接数据表数据，你需要使用model中的query方法 :ref:`query <model-query>`
直接查询或是增加主键作为标准的模型。例如:


CakePHP does not support composite primary keys. If you want to
directly manipulate your join table data, use direct
:ref:`query <model-query>` calls or add a primary key to act on it
as a normal model. E.g.::

    CREATE TABLE posts_tags (
    id INT(10) NOT NULL AUTO_INCREMENT,
    post_id INT(10) NOT NULL,
    tag_id INT(10) NOT NULL,
    PRIMARY KEY(id));

除了用auto-increment字段来作主键外，也可以用char(36)字段。当你用Model::save方法来保存一条新记录，
Cake将会生成一个唯一的36位uuid(String::uuid)。

Rather than using an auto-increment key as the primary key, you may
also use char(36). Cake will then use a unique 36 character uuid
(String::uuid) whenever you save a new record using the Model::save
method.

视图命名约定
================

视图模版文件的名称以下划线分割的形式命名。例如：在PeopleController 中 getPeady() 方法将调用对应的视图文件 /app/View/People/get_ready.ctp。

基本模式是
/app/View/Controller/underscored\_function\_name.ctp.
/app/视图/控制器/带下划线的方法名.ctp.

通过使用CakePHP的这些规则来命名你的程序，可以减少麻烦，带来更好的可维护性。
下面是命名规则的最后一个例子。

-  数据库表名： "people"
-  模型： "Person", 放在 /app/Model/Person.php
-  控制器： "PeopleController"，放在 /app/Controller/PeopleController.php
-  视图模版, 放在 /app/View/People/index.ctp

使用这些约定，CakPHP就知道http://example.com/people/ 这个请求需要去调用PeopleController中的index()方法, 并自动加载Person模型 (即自动与数据库中的 ‘people’表关联), 并将其渲染到对应的视图文件。若没有配置关联，你可以自行创建。None of these relationships have
been configured by any means other than by creating classes and
files that you’d need to create anyway.

现在你已经了解到了CakePHP的基本原则, 你可以尝试运行
:doc:`/tutorials-and-examples/blog/blog` 理解它们是如何结合在一起的。


.. meta::
    :title lang=zh_CN: CakePHP Conventions
    :keywords lang=zh_CN: web development experience,maintenance nightmare,index method,legacy systems,method names,php class,uniform system,config files,tenets,apples,conventions,conventional controller,best practices,maps,visibility,news articles,functionality,logic,cakephp,developers
