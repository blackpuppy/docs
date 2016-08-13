分页
##########

Pagination
##########

.. php:class:: PaginatorComponent(ComponentCollection $collection, array $settings = array())

创建灵活和对用户友好的网页应用程序，最主要的障碍之一就是设计直观的用户界面。很多应用程序的规模和复杂性会与日俱增，设计师们和程序员们发现他们无法处理成百上千条记录的显示。重构需要时间，而性能和用户满意度将受损。

One of the main obstacles of creating flexible and user-friendly
web applications is designing an intuitive user interface. Many applications
tend to grow in size and complexity quickly, and designers and
programmers alike find they are unable to cope with displaying
hundreds or thousands of records. Refactoring takes time, and
performance and user satisfaction can suffer.

每页显示合理数量的记录，一直都是每个应用程序的关键部分，历来导致开发人员的很多烦恼。CakePHP 通过提供快速而又简单的方式来分页显示数据，从而减轻了开发人员的负担。

Displaying a reasonable number of records per page has always been
a critical part of every application and used to cause many
headaches for developers. CakePHP eases the burden on the developer
by providing a quick, easy way to paginate data.

CakePHP 中的分页功能在控制器（*controller*）中是由组件（*component*）来提供的，使得构建分页的查询更容易。在视图（*view*）中则用 :php:class:`PaginatorHelper` 助件（*helper*）简化了分页链接和按键的生成。

Pagination in CakePHP is offered by a Component in the controller, to make
building paginated queries easier. In the View :php:class:`PaginatorHelper` is
used to make the generation of pagination links & buttons simple.

查询的设置
===========

Query Setup
===========

在控制器中，我们先着手在控制器变量 ``$paginate`` 中定义分页默认会使用的查询条件。这些条件，将作为分页查询的基础。它们会与排序、方向、（每页）最大记录数和页数这些从网址（*URL*）传入的参数相结合。这里需要指出，order 键必须用下面的数组结构定义::

In the controller, we start by defining the query conditions pagination will use
by default in the ``$paginate`` controller variable. These conditions, serve as
the basis of your pagination queries. They are augmented by the sort, direction
limit, and page parameters passed in from the URL. It is important to note
here that the order key must be defined in an array structure like below::

    class PostsController extends AppController {

        public $components = array('Paginator');

        public $paginate = array(
            'limit' => 25,
            'order' => array(
                'Post.title' => 'asc'
            )
        );
    }

也可以包含其他 :php:meth:`~Model::find()` 选项，比如 ``fields``::

You can also include other :php:meth:`~Model::find()` options, such as
``fields``::

    class PostsController extends AppController {

        public $components = array('Paginator');

        public $paginate = array(
            'fields' => array('Post.id', 'Post.created'),
            'limit' => 25,
            'order' => array(
                'Post.title' => 'asc'
            )
        );
    }

``$paginate`` 数组中可以包括的其他键与 ``Model->find('all')`` 方法的参数相似，即：``conditions``、 ``fields``、``order``、``limit``、``page``、``contain``、``joins`` 和 ``recursive``。前面提到的这些键，以及任何其他键都直接会传递给模型（*model*）的 find 方法。这样就很容易结合分页一起使用象 :php:class:`ContainableBehavior` 这样的行为（*behavior*）。

Other keys that can be included in the ``$paginate`` array are
similar to the parameters of the ``Model->find('all')`` method, that
is: ``conditions``, ``fields``, ``order``, ``limit``, ``page``, ``contain``,
``joins``, and ``recursive``. In addition to the aforementioned keys, any
additional keys will also be passed directly to the model find methods. This
makes it very simple to use behaviors like :php:class:`ContainableBehavior` with
pagination::


    class RecipesController extends AppController {

        public $components = array('Paginator');

        public $paginate = array(
            'limit' => 25,
            'contain' => array('Article')
        );
    }

除了可以定义通用的分页参数值，也可以在控制器中定义多组分页默认值，只需把要配置的模型名称作为数组的键::

In addition to defining general pagination values, you can define more than one
set of pagination defaults in the controller, you just name the keys of the
array after the model you wish to configure::

    class PostsController extends AppController {

        public $paginate = array(
            'Post' => array (...),
            'Author' => array (...)
        );
    }

键 ``Post`` 和 ``Author`` 对应的值可以包含不带模型/键的 ``$paginate`` 数组能够包含的所有属性。

The values of the ``Post`` and ``Author`` keys could contain all the properties
that a model/key less ``$paginate`` array could.

一旦定义了 ``$paginate`` 变量，就可以在控制器动作（*action*）中使用 :php:class:`PaginatorComponent` 组件的 ``paginate()`` 方法了。这会从模型返回 ``find()`` 结果。同时也设置一些额外的分页参数，并添加到请求（*request*）对象中。这些额外的信息设置在 ``$this->request->params['paging']`` 中，被 :php:class:`PaginatorHelper` 助件用于创建链接。:php:meth:`PaginatorComponent::paginate()` 方法同时也把 :php:class:`PaginatorHelper` 助件添加到控制器的助件列表中，如果还没有加入的话::

Once the ``$paginate`` variable has been defined, we can use the
:php:class:`PaginatorComponent`'s ``paginate()`` method from our controller
action. This will return ``find()`` results from the model. It also sets some
additional paging parameters, which are added to the request object. The
additional information is set to ``$this->request->params['paging']``, and is
used by :php:class:`PaginatorHelper` for creating links.
:php:meth:`PaginatorComponent::paginate()` also adds
:php:class:`PaginatorHelper` to the list of helpers in your controller, if it
has not been added already::

    public function list_recipes() {
        $this->Paginator->settings = $this->paginate;

        // 类似于 findAll()，但是读取分页的结果
        // similar to findAll(), but fetches paged results
        $data = $this->Paginator->paginate('Recipe');
        $this->set('data', $data);
    }

也可以把条件作为第二个参数传入 ``paginate()`` 方法，来过滤结果::

You can filter the records by passing conditions as second
parameter to the ``paginate()`` function::

    $data = $this->Paginator->paginate(
        'Recipe',
        array('Recipe.title LIKE' => 'a%')
    );

也可以在动作中设置 ``conditions`` 和其他分页设置数组::

Or you can also set ``conditions`` and other pagination settings array inside
your action::

    public function list_recipes() {
        $this->Paginator->settings = array(
            'conditions' => array('Recipe.title LIKE' => 'a%'),
            'limit' => 10
        );
        $data = $this->Paginator->paginate('Recipe');
        $this->set(compact('data'));
    }

自定义查询分页
=======================

Custom Query Pagination
=======================

如果你无法用标准的 find 选项来创建显示数据所需要的查询，还有一些其他办法。你可以使用 :ref:`自定义查询类型 <model-custom-find>`。你也可以在模型中实现 ``paginate()`` 和 ``paginateCount()`` 方法，或者把它们放在附加到模型的行为中。实现 ``paginate()`` 和/或 ``paginateCount()`` 方法的行为应当实现如下定义的方法签名，带有通常的额外的第一个参数 ``$model``::

If you're not able to use the standard find options to create the query you need
to display your data, there are a few options. You can use a
:ref:`custom find type <model-custom-find>`. You can also implement the
``paginate()`` and ``paginateCount()`` methods on your model, or include them in
a behavior attached to your model. Behaviors implementing ``paginate`` and/or
``paginateCount`` should implement the method signatures defined below with the
normal additional first parameter of ``$model``::

    // 在行为中实现的 paginate 和 paginateCount 方法。
    // paginate and paginateCount implemented on a behavior.
    public function paginate(Model $model, $conditions, $fields, $order, $limit,
        $page = 1, $recursive = null, $extra = array()) {
        // method content
        // 方法内容
    }

    public function paginateCount(Model $model, $conditions = null, $recursive = 0,
        $extra = array()) {
        // method body
        // 方法主体
    }

你极少需要实现 ``paginate()`` 和 ``paginateCount()`` 方法。你应当确保的确无法用核心的模型方法或自定义查询来达到目的。要用自定义 find 类型进行分页，在 2.3 版本，你应当设置第 ``0`` 个元素或者 ``findType``::

It's seldom you'll need to implement paginate() and paginateCount(). You should
make sure  you can't achieve your goal with the core model methods, or a custom
finder. To paginate with a custom find type, you should set the ``0``'th
element, or the ``findType`` key as of 2.3::

    public $paginate = array(
        'popular'
    );

由于第 0 个下标难于处理，在 2.3 版本中增加了 ``findType`` 选项::

Since the 0th index is difficult to manage, in 2.3 the ``findType`` option was
added::

    public $paginate = array(
        'findType' => 'popular'
    );

``paginate()`` 方法应当实现下面的方法签名。要使用你自己的方法/逻辑，在要用来获取数据的模型中重载它::

The ``paginate()`` method should implement the following method signature. To
use your own method/logic override it in the model you wish to get the data
from::

    /**
     * 重载 paginate 方法 - 按照 week、away_team_id 和 home_team_id 分组
     * Overridden paginate method - group by week, away_team_id and home_team_id
     */
    public function paginate($conditions, $fields, $order, $limit, $page = 1,
        $recursive = null, $extra = array()) {

        $recursive = -1;
        $group = $fields = array('week', 'away_team_id', 'home_team_id');
        return $this->find(
            'all',
            compact('conditions', 'fields', 'order', 'limit', 'page', 'recursive', 'group')
        );
    }

你还需要重载核心的 ``paginateCount()`` 方法，该方法的参数与 ``Model::find('count')`` 方法相同。下面的例子用了 PostgresSQL 特有的功能，所以请根据你使用的数据库做出相应调整::

You also need to override the core ``paginateCount()``, this method
expects the same arguments as ``Model::find('count')``. The example
below uses some PostgresSQL-specifc features, so please adjust
accordingly depending on what database you are using::

    /**
     * 重载 paginateCount 方法
     * Overridden paginateCount method
     */
    public function paginateCount($conditions = null, $recursive = 0,
                                    $extra = array()) {
        $sql = "SELECT
            DISTINCT ON(
                week, home_team_id, away_team_id
            )
                week, home_team_id, away_team_id
            FROM
                games";
        $this->recursive = $recursive;
        $results = $this->query($sql);
        return count($results);
    }

观察力好的读者应该已经注意到了，我们之前定义的分页方法实际上并不必要——你只需要在控制器的 ``$paginate`` 类变量中加入关键字就足够了::

The observant reader will have noticed that the paginate method
we've defined wasn't actually necessary - All you have to do is add
the keyword in controller's ``$paginate`` class variable::

    /**
     * 加上 GROUP BY 子句
     * Add GROUP BY clause
     */
    public $paginate = array(
        'MyModel' => array(
            'limit' => 20,
            'order' => array('week' => 'desc'),
            'group' => array('week', 'home_team_id', 'away_team_id')
        )
    );
    /**
     * 或者在动作中随时加入
     * Or on-the-fly from within the action
     */
    public function index() {
        $this->Paginator->settings = array(
            'MyModel' => array(
                'limit' => 20,
                'order' => array('week' => 'desc'),
                'group' => array('week', 'home_team_id', 'away_team_id')
            )
        );
    }

在 CakePHP 2.0 中，使用 GROUP BY 子句时不再需要实现 ``paginateCount()`` 方法。核心的 ``find('count')`` 方法会正确地计算出总行数。

In CakePHP 2.0, you no longer need to implement ``paginateCount()`` when using
group clauses. The core ``find('count')`` will correctly count the total number
of rows.

控制哪些字段用于排序
======================================

Control which fields used for ordering
======================================

默认情况下可以用模型的任何列进行排序。有时候这样也不好，因为这允许用户把没有索引的列、或者虚拟字段用于排序，而后者的计算更可能要耗费昂贵的资源。在这种情况下，你可以用 ``PaginatorComponent::paginate()`` 方法的第三个参数来限制能用于排序的列::

By default sorting can be done with any column on a model. This is sometimes
undesirable as it can allow users to sort on un-indexed columns, or virtual
fields that can be expensive to calculate. You can use the 3rd parameter of
``PaginatorComponent::paginate()`` to restrict the columns that sorting will be
done on::

    $this->Paginator->paginate('Post', array(), array('title', 'slug'));

这样就只允许用 title 和 slug 列进行排序。设置任何其他列进行排序都会被忽略。

This would allow sorting on the title and slug columns only. A user that sets
sort to any other value will be ignored.

限制可以读取的最大行数
====================================================

Limit the maximum number of rows that can be fetched
====================================================

读取的结果的行数以 ``limit`` 参数提供给用户。在分页结果中允许用户读取所有行，通常不好。默认情况下 CakePHP 限制可以读取的最大行数为 100。如果此默认值不适合你的应用程序，你可以把它作为分页选项的一部分进行调整::

The number of results that are fetched is exposed to the user as the
``limit`` parameter. It is generally undesirable to allow users to fetch all
rows in a paginated set. By default CakePHP limits the maximum number of rows
that can be fetched to 100. If this default is not appropriate for your
application, you can adjust it as part of the pagination options::

    public $paginate = array(
        // 这里还有其他键。
        // other keys here.
        'maxLimit' => 10
    );

如果请求的 limit 参数大于该值，就会被减小为 ``maxLimit`` 的值。

If the request's limit param is greater than this value, it will be reduced to
the ``maxLimit`` value.

.. _pagination-with-get:

用 GET 参数进行分页
==============================

Pagination with GET parameters
==============================

在之前版本的 CakePHP 中，只能用命名参数（*named parameter*）来生成分页链接。但是如果页面用 GET 参数进行请求，它们也同样有效。对 2.0 版本，我们决定使生成分页参数的方式更加可控和一致。你可以在组件中选择使用查询字符串（*querystring*）或命名参数。对收到的请求只会接受选中的类型，而且 :php:class:`PaginatorHelper` 助件只会生成带有选中类型的参数的链接::

In previous versions of CakePHP you could only generate pagination links using
named parameters. But if pages were requested with GET parameters they would
still work. For 2.0, we decided to make how you generate pagination parameters
more controlled and consistent. You can choose to use either querystring or
named parameters in the component. Incoming requests will accept only the chosen
type, and the :php:class:`PaginatorHelper` will generate links with the chosen type of
parameter::

    public $paginate = array(
        'paramType' => 'querystring'
    );

上面的代码会启用查询字符串参数的解析和生成。你也可以改变 PaginatorComponent 组件的 ``$settings`` 属性::

The above would enable querystring parameter parsing and generation. You can
also modify the ``$settings`` property on the PaginatorComponent::

    $this->Paginator->settings['paramType'] = 'querystring';

默认情况下，所有标准的分页参数都会转换成 GET 参数。

By default all of the typical paging parameters will be converted into GET
arguments.

.. note::

    你可能会遇到这样的情况，赋值给不存在的属性会抛出错误::

    You can run into a situation where assigning a value to a nonexistent property will throw errors::

        $this->paginate['limit'] = 10;

    这会抛出错误 "Notice: Indirect modification of overloaded property $paginate has no effect."。给该属性赋予初始值就解决了问题::

    will throw the error "Notice: Indirect modification of overloaded property $paginate has no effect."
    Assigning an initial value to the property solves the issue::

        $this->paginate = array();
        $this->paginate['limit'] = 10;
        //或者
        //or
        $this->paginate = array('limit' => 10);

    或者在控制器类中声明该属性::

    Or just declare the property in the controller class::

        class PostsController {
            public $paginate = array();
        }

    或者使用 ``$this->Paginator->settings = array('limit' => 10);``。

    Or use ``$this->Paginator->settings = array('limit' => 10);``

    如果要改变 PaginatorComponent 组件的 ``$settings`` 属性，确保 Paginator 组件已经加入到 $components 数组中。

    Make sure you have added the Paginator component to your $components array if
    you want to modify the ``$settings`` property of the PaginatorComponent.

    以上这两种方法都能够解决 notice 错误。

    Either of these approaches will solve the notice errors.

请求的页超出范围
==========================

Out of range page requests
==========================

从 2.3 版本开始，若试图访问不存在的页，即当请求的页数大于总页数时，PaginatorComponent 组件会抛出 `NotFoundException` 异常。

As of 2.3 the PaginatorComponent will throw a `NotFoundException` when trying to
access a non-existent page, i.e. page number requested is greater than total
page count.

那么，可以允许显示正常的错误页面，也可以使用 try catch 块，并在捕获 `NotFoundException` 异常时做出适当的处理。

So you could either let the normal error page be rendered or use a try catch
block and take appropriate action when a `NotFoundException` is caught::

    public function index() {
        try {
            $this->Paginator->paginate();
        } catch (NotFoundException $e) {
            //在这里进行处理，比如跳转到第一页或最后一页。
            //Do something here like redirecting to first or last page.
            //$this->request->params['paging'] will give you required info.
        }
    }

AJAX 分页
===============

AJAX Pagination
===============

在分页中加入 AJAX 功能是很容易的。使用 :php:class:`JsHelper` 助件和 :php:class:`RequestHandlerComponent` 组件就能够容易地给应用程序加上 AJAX 分页。欲知详情，请见 :ref:`ajax-pagination`。

It's very easy to incorporate AJAX functionality into pagination.
Using the :php:class:`JsHelper` and :php:class:`RequestHandlerComponent` you can
easily add AJAX pagination to your application. See :ref:`ajax-pagination` for
more information.

视图中的分页
======================

Pagination in the view
======================

关于如何创建分页导航的链接，请查看 :php:class:`PaginatorHelper` 助件的文档。

Check the :php:class:`PaginatorHelper` documentation for how to create links for
pagination navigation.


.. meta::
    :title lang=zh: Pagination
    :keywords lang=zh: order array,query conditions,php class,web applications,headaches,obstacles,complexity,programmers,parameters,paginate,designers,cakephp,satisfaction,developers
