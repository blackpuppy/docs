JSON 和 XML 视图
##################

在 CakePHP 2.1 中有两个新的视图类：  ``XmlView``  和  ``JsonView`` ，
可以让你更容易地创建 XML 和 JSON 响应，并且与 :php:class:`RequestHandlerComponent` 整合。

在应用中激活 ``RequestHandlerComponent`` 的同时激活对 ``xml`` 
和/或 ``json`` 扩展 , 你就可以自动利用新的视图了， ``XmlView`` 和 ``JsonView`` 将会像数据视图一样被引用。

这有两个方法来生成数据视图。第一种办法是使用 ``_serialize`` 键，
而第二种办法是创建普通的视图文件。

在你的应用中激活数据视图
=======================================

在使用数据视图类之前，需要进行如下设置 :

#. 激活 json 和 或 xml 扩展，这个是靠方法
   :php:meth:`Router::parseExtensions()`. 它将会让路由来处理多
   个扩展。
#. 添加 :php:class:`RequestHandlerComponent` 到你的组件的控制
   器里表里。这会让视图类能够自动的根据内容类型切换，你也可以使用 ``viewClassMap`` 来设置组件，映射为自定义的类或其他的数据类型。

.. 版本新增:: 2.3
    :php:meth:`RequestHandlerComponent::viewClassMap()` 方法被添加入viewClasses的映射类型。
    上一版本的viewClassMap 的设置将不再起作用。

在添加 ``Router::parseExtensions('json');`` 到你的路由文件后, 当一个请求是json类型时，CakePHP将会自动在视图类中切换。

通过 serialize 键 使用数据视图
=======================================

``_serialize`` 键是一个特殊的视图变量，它会在使用数据视图的时候
指出其他的视图变量应如何被序列化。这可以让你跳过为你的控制器中的
动作定义视图文件，直接把你的数据转化为 json/xml而不做任何自定义的格式化。

如果你需要在产生响应之前，对你的数据进行格式化或者操作的话，你
应该创建视图文件， ``_serialize`` 的值可以是一个字符串或者一个需要进行序列化
的视图变量的数组 ::

    class PostsController extends AppController {
        public function index() {
            $this->set('posts', $this->paginate());
            $this->set('_serialize', array('posts'));
        }
    }

你看也可以定义 ``_serialize`` 为多个视图变量的联合数组 ::

    class PostsController extends AppController {
        public function index() {
            // some code that created $posts and $comments
            $this->set(compact('posts', 'comments'));
            $this->set('_serialize', array('posts', 'comments'));
        }
    }

定义了 ``_serialize`` 作为数组可以在使用 :php:class:`XmlView` 时自动
添加一个顶层的 ``<response>`` 元素。如果你使用一个字符串来定义 
``_serialize`` 和 XmlView，确保你的视图变量有一个单独的顶层元素，
如果没有Xml就无法生成。

通过视图文件使用数据视图
=================================

如果你在创建最终的输出之前想要对你的视图内容进行操作的话，
你就需要创建视图文件，例如如果我们有一些posts，它们有一些
列含有生成的HTML，我们都会希望在JSON的响应中忽略掉。这个
时候就需要用到视图文件了 ::

    // Controller code
    class PostsController extends AppController {
        public function index() {
            $this->set(compact('posts', 'comments'));
        }
    }

    // 视图代码 - app/View/Posts/json/index.ctp
    foreach ($posts as &$post) {
        unset($post['Post']['generated_html']);
    }
    echo json_encode(compact('posts', 'comments'));

你可以做更多的复杂的操作，也可以使用helpers来格式化数据。

.. 注意::

    数据视图类不支持布局。他们假定视图文件不会输出序列化后的内容。

.. php:class:: XmlView

    一个视图类，用来生成Xml视图数据。上文说明了如何在你的应用中使用它。

    默认情况下，在使用 ``_serialize`` 时， XmlView 将会用一个
	``<response>`` 将你的序列化的视图变化包起来。你可以通过修改
	 ``_rootNode`` 视图变量的值来自定义个这个节点的名字。

    .. 新增:: 2.3
        新增``_rootNode`` 功能。

.. php:class:: JsonView

    一个视图类，用来生成Json视图数据。上文描述了如何在应用中使用它。
