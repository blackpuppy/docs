缓存助件
###########

.. php:class:: CacheHelper(View $view, array $settings = array())

缓存助件帮助缓存整个布局和视图，节省重复读取数据的时间。 Cake 的视图缓存暂时把解
释后的布局和视图存为简单的 PHP + HTML 文件。应当注意缓存助件和其它助件的工作方式
颇不相同。它没有被直接调用的方法。而是，视图被标以缓存标签，说明内容中的哪个代码
块不需要被缓存。然后 CacheHelper 助件使用助件的回调方法来处理文件，并输出生成缓存
文件。

当一个 URL 被请求时，CakePHP 检查该请求字符串是否已经被缓存了。如果是，则其余的网
址调度过程就会被省略。任何不缓存的代码块会正常处理，然后视图会被发送。这为每一个
对缓存了的 URL 的请求节省了大量的处理时间，因为只有最少的代码被执行。如果 Cake 没
有找到缓存的视图，或者缓存对于请求的 URL 已经过期，它就会照常继续处理请求。

使用助件
================

在你能够使用 CacheHelper 助件之前，你必须采取两个步骤。首先，在
``APP/Config/core.php``中，去掉对``Cache.check``的 Configure write 调用的注释。这
会告诉 CakePHP 在处理请求时，检查并生成视图缓存。

去掉对``Cache.check``行的注释之后，你要把助件添加到你的控制器的``$helpers``数组中::

    class PostsController extends AppController {
        public $helpers = array('Cache');
    }

你还要在你的 bootstrap 中把 CacheDispatcher 添加到你的调度过滤器中::

    Configure::write('Dispatcher.filters', array(
        'CacheDispatcher'
    ));

.. versionadded:: 2.3
  如果你的设置有多个域或语言，你可以用
  `Configure::write('Cache.viewPrefix', 'YOURPREFIX');`来为保存的视图缓存文件增加
  前缀。

其它配置选项
--------------------------------

CacheHelper 助件还有其它一些配置选项，可以用来调整它的行为。这通过控制器中的
``$cacheAction``变量来完成。``$cacheAction``应当被赋值为数组，包含你要缓存的动作，
以及你要这些视图缓存的以秒计算的时间长度。时间可以用``strtotime()``格式(例如
"1 hour"，或者"3 minutes")来表示。

用一个 ArticlesController 控制器的例子，它会收到很多(请求的)通讯，需要被缓存::

    public $cacheAction = array(
        'view' => 36000,
        'index'  => 48000
    );

这样就会缓存 view 动作10个小时，index 动作12个小时(译注：原文是13个小时，当为笔误
)。把``$cacheAction``设置为一个与``strtotime()``兼容的值，你可以缓存控制器中的每
一个动作::

    public $cacheAction = "1 hour";

你也可以针对用``CacheHelper``助件创建的缓存视图启用控制器/组件的回调。为此，你必
须使用 ``$cacheAction``的数组形式，创造一个下面这样的数组::

    public $cacheAction = array(
        'view' => array('callbacks' => true, 'duration' => 21600),
        'add' => array('callbacks' => true, 'duration' => 36000),
        'index' => array('callbacks' => true, 'duration' => 48000)
    );

通过设置``callbacks => true``，你告诉 CacheHelper 助件，你要在生成的文件中为控制
器创建组件和模型。并且，触发组件的 initialize 、控制器的 beforeFilter 和组件的 
startup 这些回调。

.. note::

    设置``callbacks => true``部分地否定了缓存的目的。这也是为什么缺省情况下这没有
    启用的原因。

标记视图中不要缓存的内容
===================================

有些时候，你不想让*整个*视图都被缓存。例如，在一个用户登录的时候，或者作为游客浏
览你的网站，页面某些部分会呈现出不同的(内容)。

要让代码块的内容*不*要被缓存，把这些(部分)象这样包括在
``<!--nocache--> <!--/nocache-->``之中:

.. code-block:: php

    <!--nocache-->
    <?php if ($this->Session->check('User.name')): ?>
        Welcome, <?php echo h($this->Session->read('User.name')); ?>.
    <?php else: ?>
        <?php echo $this->Html->link('Login', 'users/login'); ?>
    <?php endif; ?>
    <!--/nocache-->

.. note::

    你不能在元素中使用``nocache``标签。因为元素没有回调，所以它们不能被缓存。

应当注意，一旦一个动作被缓存了，该动作的控制器方法就不会被调用。当一个缓存文件被
创建时，请求对象和视图变量会用 PHP 的``serialize()``方法序列化。

.. warning::

    如果你的视图变量含有不可序列化的内容，比如 SimpleXML 对象、资源句柄(resource 
    handle)、或闭包(closure)，你就可能无法使用视图缓存了。

清除缓存
==================

重要的是要记住，如果缓存的视图所使用的模型发生了变化，CakePHP 就会清除缓存了的视
图。例如，如果一个缓存的视图使用 Post 模型的数据，且发生了一次对 Post 的 INSERT，
UPDATE 或 DELETE 查询，则该视图的缓存会被清除，下一次请求时就会生成新的内容。

.. note::

    这种自动的缓存清除要求控制器/模型名称必须是 URL 的一部分。如果你用路由改变了
    网址，这项特性就不会起作用。

如果你需要手动清除缓存，你可以调用 Cache::clear()。这会清除**所有**缓存的数据，除
了缓存的视图文件。如果你要清除缓存的视图文件，请使用``clearCache()``。


.. meta::
    :title lang=zh_CN: CacheHelper
    :description lang=zh_CN: The Cache helper assists in caching entire layouts and views, saving time repetitively retrieving data.
    :keywords lang=zh_CN: cache helper,view caching,cache action,cakephp cache,nocache,clear cache