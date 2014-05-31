Blog 教程 - 添加一个层
******************************

创建一个 Post 模型
===================

模型类是 CakePHP 应用的基础. 通过创建一个 CakePHP 模型将会联系到数据库,
为了将来去做视图、添加、编辑和删除操作，让我们先把一些基础工作做足。

CakePHP 的模型类文件在  ``/app/Model`` , 我们创建的文件将保存
为  ``/app/Model/Post.php`` .该文件内容应为::

    class Post extends AppModel {
    }

在 CakePHP 中，命名约定很重要. 通过命名我们的模型为
Post, CakePHP 能自动将让该模型被PostsController使用，并被绑定到数据库中名为 "posts" 的表。

.. 注意::

    如果CakePHP不能在 /app/Model 找到相关的文件，它将自动为你创建一个模型对象. 
	这样的话，如果你没有正确命名你的文件(比如命名为 post.php 或
    posts.php)，CakePHP将会忽略你的配置并使用默认的配置。


关于模型的更多信息, 比如表前缀, 回调, 验证,请查看手册中的文档 :doc:`/Models` 章节.


创建一个Posts的控制器
=========================

接下来, 为我们的posts创建一个控制器. 控制器是所有的post相关
的事物逻辑 .简单说, 它是和模型一起将post相关的工作完成的地方。
把该文件保存为 ``PostsController.php`` ，放在  ``/app/Controller`` 目录下。
这是控制器的基本内容::

    class PostsController extends AppController {
        public $helpers = array('Html', 'Form');
    }

现在, 添加一个动作. 动作一般代表应用中一个单独的函数或者接口。例如，
当用户请求 www.example.com/posts/index (同 www.example.com/posts/ ),
他们将会期望看到posts的列表，这个动作的代码会是这样::

    class PostsController extends AppController {
        public $helpers = array('Html', 'Form');

        public function index() {
            $this->set('posts', $this->Post->find('all'));
        }
    }

让我来解释下该动作.通过在我们的 PostsController定义函数  ``index()``
, 用户名现在可以通过请求访问www.example.com/posts/index
来访问该逻辑.同样的, 如果定义一个函数 ``foobar()`` , 用户将可以通过请求 www.example.com/posts/foobar 来访问.

.. 警告::

	你将会被诱导去命名控制器和动作的正确的方式去获取一个正确的URL。
	遵循CakePHP的命名规范，创建易读易理解的动作名字，你可以使用“routes”将URL映射到
	你的代码中，这个后面会提到。

在动作中使用 ``set()`` 这个单独的操作来从控制器中传递数据到视图中。
视图中的'posts'变量等价于Post 模型中 ``find('all')`` 的返回值。我们的
``$this->Post`` 在Post 模型中可用是因为我们遵循的Cake的命名规范。

在:doc:`/controllers` 章节了解更多的关于Cake的控制器的信息.

创建 Post 视图
===================

根据我们的模型已经有了数据,应用逻辑以及控制器中定义的工作流, 
现在让我们创建一个index动作的视图。

Cake 的视图仅仅是在应用的布局中展示样式的片段。对大多数应用，他们是
HTML 和 PHP 混合的, 但它们最终可能是 XML, CSV, 甚至是二进制数据.

布局是描述视图包装的代码，可以被定义和转换的，但现在，让我们先使用默认的布局。

还记得上一节中我们是使用  ``set()`` 方法来对 'posts'  变量赋值吗？
那将把值传递到视图中,代码如下::

    // print_r($posts) output:

    Array
    (
        [0] => Array
            (
                [Post] => Array
                    (
                        [id] => 1
                        [title] => The title
                        [body] => This is the post body.
                        [created] => 2008-02-13 18:34:55
                        [modified] =>
                    )
            )
        [1] => Array
            (
                [Post] => Array
                    (
                        [id] => 2
                        [title] => A title once again
                        [body] => And the post body follows.
                        [created] => 2008-02-13 18:34:56
                        [modified] =>
                    )
            )
        [2] => Array
            (
                [Post] => Array
                    (
                        [id] => 3
                        [title] => Title strikes back
                        [body] => This is really exciting! Not.
                        [created] => 2008-02-13 18:34:57
                        [modified] =>
                    )
            )
    )

Cake的视图保存在 ``/app/View`` 目录中，对应相应的控制器
 (在本例中我们需要命名为 'Posts'  ).将post的数据显示在表格中，
视图的代码会是这样

.. code-block:: php

    <!-- File: /app/View/Posts/index.ctp -->

    <h1>Blog posts</h1>
    <table>
        <tr>
            <th>Id</th>
            <th>Title</th>
            <th>Created</th>
        </tr>

        <!-- 遍历 $posts 数组, 输入post的信息 -->

        <?php foreach ($posts as $post): ?>
        <tr>
            <td><?php echo $post['Post']['id']; ?></td>
            <td>
                <?php echo $this->Html->link($post['Post']['title'],
    array('controller' => 'posts', 'action' => 'view', $post['Post']['id'])); ?>
            </td>
            <td><?php echo $post['Post']['created']; ?></td>
        </tr>
        <?php endforeach; ?>
        <?php unset($post); ?>
    </table>

希望这样会看起来简单些.

你也许已经注意到了 ``$this->Html`` 这个对象,这是 CakePHP :php:class:`HtmlHelper`  类
的一个示例. CakePHP提供了一些helpers来使链接，表格输出，JavaScript 和 Ajax 简便.
你可以在这里看到如何使用它们  :doc:`/views/helpers` , 但值得注意的是 ``link()`` 方法将
会产生一个 HTML链接和标题(第一个变量)，以及URL (第二个变量).

当在Cake中指定URL时, 推荐使用数组格式. 在Routes章节中我们会讲到这些细节.
使用数据格式来表示URL允许你利用CakePHP的反向路由功能，你也可以定义基于应用的相对路径，
像/controller/action/param1/param2这样

现在，你可以打开浏览器，输入地址 http://www.example.com/posts/index . 
你应该可以看到你的视图，标题和表格中posts的列表都是正确的格式。

如果你在点击了我们在这个视图中创建的链接（指向URL /posts/view/some\_id 
的post的标题的链接），CakePHP将会告知你还没有定义这个动作，如果你没有被
通知，那就是什么地方出错了或者你实际上已经偷偷定义了，好吧，我们来创建这个
动作吧。在PostsController::

    class PostsController extends AppController {
        public $helpers = array('Html', 'Form');

        public function index() {
             $this->set('posts', $this->Post->find('all'));
        }

        public function view($id = null) {
            if (!$id) {
                throw new NotFoundException(__('Invalid post'));
            }

            $post = $this->Post->findById($id);
            if (!$post) {
                throw new NotFoundException(__('Invalid post'));
            }
            $this->set('post', $post);
        }
    }

 ``set()`` 已经很熟悉了吧？ 注意到我们使用 ``findById()`` 
 而不是 ``find('all')`` ，因为我们值想要一个post的信息。

注意到我们的视图动作需要一个参数，post的ID。这个参数是通过
请求的URL来传递的，如果一个用户请求 ``/posts/view/3`` ,那么值
'3' 就会赋值给 ``$id`` .

我们也做了些错误检查来确保用户确实是要访问一个记录，如果一个用户
请求 ``/posts/view`` , 我们就抛出一个 ``NotFoundException``  异常来
让 CakePHP ErrorHandler 处理. 我们也加入了一个同样的检查来保证用户
访问的记录是存在的。

现在让我们建立这个视图并将它放在 ``/app/View/Posts/view.ctp``

.. code-block:: php

    <!-- File: /app/View/Posts/view.ctp -->

    <h1><?php echo h($post['Post']['title']); ?></h1>

    <p><small>Created: <?php echo $post['Post']['created']; ?></small></p>

    <p><?php echo h($post['Post']['body']); ?></p>

验证我们所做的是可以工作的，打开浏览器访问 ``/posts/index``  或者手动输入查看一个post的请求 ``/posts/view/1`` .

添加 Posts
============

从数据库中读出并显示posts是一个好的开始，现在演示如何添加一个新的posts。

首先，从在控制器PostsController中创建动作 ``add()``  开始::

    class PostsController extends AppController {
        public $helpers = array('Html', 'Form', 'Session');
        public $components = array('Session');

        public function index() {
            $this->set('posts', $this->Post->find('all'));
        }

        public function view($id) {
            if (!$id) {
                throw new NotFoundException(__('Invalid post'));
            }

            $post = $this->Post->findById($id);
            if (!$post) {
                throw new NotFoundException(__('Invalid post'));
            }
            $this->set('post', $post);
        }

        public function add() {
            if ($this->request->is('post')) {
                $this->Post->create();
                if ($this->Post->save($this->request->data)) {
                    $this->Session->setFlash('Your post has been saved.');
                    $this->redirect(array('action' => 'index'));
                } else {
                    $this->Session->setFlash('Unable to add your post.');
                }
            }
        }
    }

.. 注意::

    你需要导入 SessionComponent - 以及 SessionHelper - 到你用到的控制器中. 
	如果需要的话，导入到你的AppController.

这是 ``add()`` 动作所做的: 如果这个 HTTP 请求的方法是 POST, 将使用 Post 模型将数据保存.
如果因为其他原因没有保存，就在视图中渲染，这个让我们有机会给用户显示验证后的错误或其他警告等。

任何 CakePHP 请求包括一个 ``CakeRequest`` 对象，它可以通过 ``$this->request`` 来访问. 
这个请求对象包含了收到的请求的有用并且能够被用来控制你的应用的流向。在本例中,我们使用  
 :php:meth:`CakeRequest::is()` 方法来检查这个请求是否是一个 HTTP POST 请求.

当一个用户在你的应用中使用一个表单 POST 数据, 其信息保存在 ``$this->request->data`` . 
你可以使用 :php:func:`pr()`  或 :php:func:`debug()` 函数打印出其信息。

我们使用 SessionComponent's :php:meth:`SessionComponent::setFlash()`
方法来设置一个信息在页面重定向后来显示会话变量，在这个布局中我们用 
 :php:func:`SessionHelper::flash` 显示信息并清空相关的会话变量。控制器的 :php:meth:`Controller::redirect` 函数重定向页面到其他的 URL.参数 ``array('action' => 'index')``
翻译URL 到/posts 即 posts 控制器的index动作.
你可以细查 :php:func:`Router::url()`  函数在 `API <http://api20.cakephp.org>` 中的多种URL格式。

调用 ``save()`` 方法将会检查错误验证和有任何问题时取消保存。我们
将会在接下来的小节里面讨论如何处理这些错误。

数据验证
===============

Cake付出很大的努力来摆脱表单输入的验证的单调，每一个人都恨编码无数的表格和他们的
验证部分，CakePHP让这些工作简单和快速。

利用验证功能，你将需要在视图中使用Cake的 FormHelper 。这个 :php:class:`FormHelper`  默认在所有视图中都可以通过 ``$this->Form`` 访问.

这是我们的添加post的视图:

.. code-block:: php

    <!-- File: /app/View/Posts/add.ctp -->

    <h1>Add Post</h1>
    <?php
    echo $this->Form->create('Post');
    echo $this->Form->input('title');
    echo $this->Form->input('body', array('rows' => '3'));
    echo $this->Form->end('Save Post');
    ?>

这里，我们使用 FormHelper 来动态生成一个 HTML表单. 
这里用 ``$this->Form->create()`` 来生成:

.. code-block:: html

    <form id="PostAddForm" method="post" action="/posts/add">

如果 ``create()`` 不带参量, 它假定你要建立一个提交当前控制器的
``add()`` 动作 (或者 ``edit()`` 动作 ，当 ``id`` 有值时), 通过 POST 方法.

这个 ``$this->Form->input()`` 方法被用来创建同名的表单元素 .
第一个参数告诉 CakePHP 关联到那个字段,第二个参数让你定义一系列选项。在这里，
我们定义文本区的行数。你将注意到 :``input()``  将会输出不同的表单元素，其根据的是模型中该字段的定义.

``$this->Form->end()``  生成一个提交按钮并结束表单. 
 ``end()`` 的第一个参数可以用来定义提交按钮上的文字. 
在这里有更多helper的信息 :doc:`/views/helpers` .

现在让我们回去并更新我们的 ``/app/View/Posts/index.ctp`` 视图，
添加 "Add Post" 链接. 在  ``<table>`` 前添加如下代码 ::

    <?php echo $this->Html->link(
        'Add Post',
        array('controller' => 'posts', 'action' => 'add')
    ); ?>

你可能有些疑惑：怎么告诉CakePHP我的验证要求呢？验证的规则是在模型中定义的。
 让我们检查一下Post 模型并做一些调整::

    class Post extends AppModel {
        public $validate = array(
            'title' => array(
                'rule' => 'notEmpty'
            ),
            'body' => array(
                'rule' => 'notEmpty'
            )
        );
    }

``$validate`` 数组告诉 CakePHP 当 ``save()`` 方法被调用时如何去验证你的数据，
这里，我定义了body和标题的字段不能为空，CakePHP的验证引擎很强大
有许多内建的验证规则（信用卡、电子邮件，等）并且灵活便于你增加自己的验证规则。
更多信息请移步 :doc:`/Models/data-validation`.


现在你已经完成了验证规则部分，使用本应用来尝试添加一个post，在标题或者body部分
留空看看验证部分如何起作用的。因为我们已经使用了FormHelper的
 :php:meth:`FormHelper::input()`  方法 来创建我们的表单元素，我们
的验证错误信息将会自动显示。

编辑Posts
=============

Post编辑:开始吧. 你现在已经是个CakePHP专业人士啦, 所以你现在已经选择了一个模式.
建立动作，然后是视图。控制器PostsController中的动作 ``edit()`` 会是这样::

    public function edit($id = null) {
        if (!$id) {
            throw new NotFoundException(__('Invalid post'));
        }

        $post = $this->Post->findById($id);
        if (!$post) {
            throw new NotFoundException(__('Invalid post'));
        }

        if ($this->request->is('post') || $this->request->is('put')) {
            $this->Post->id = $id;
            if ($this->Post->save($this->request->data)) {
                $this->Session->setFlash('Your post has been updated.');
                $this->redirect(array('action' => 'index'));
            } else {
                $this->Session->setFlash('Unable to update your post.');
            }
        }

        if (!$this->request->data) {
            $this->request->data = $post;
        }
    }

这个动作首先确保用户已经访问到了一个已存的记录。如果他们没有传入 ``$id``  的值或者post
没有找到，就抛出 ``NotFoundException`` 异常让 CakePHP ErrorHandler 来处理.

接着，检查这个请求是否是一个POST请求，如果是，然后我们使用POST中的数据来
更新Post记录，否则就退回并将验证的错误显示给用户。

如果 ``$this->request->data`` 中没有数据集，我们简单的设置为前一个获得的post。


编辑post的视图会是这样:

.. code-block:: php

    <!-- File: /app/View/Posts/edit.ctp -->

    <h1>Edit Post</h1>
    <?php
        echo $this->Form->create('Post');
        echo $this->Form->input('title');
        echo $this->Form->input('body', array('rows' => '3'));
        echo $this->Form->input('id', array('type' => 'hidden'));
        echo $this->Form->end('Save Post');

这个视图输出编辑表格（填入了一些值），以及一些验证需要的错误信息。

我们在这里需要注意的是：如果有 'id'，CakePHP 将假设你在编辑一个模型.
如果没有 'id' , 当调用 ``save()``  时，Cake 将假设你正在插入一个新的模型.

你现在可以更新你的index视图了，添加posts的编辑链接。:

.. code-block:: php

    <!-- File: /app/View/Posts/index.ctp  (edit links added) -->

    <h1>Blog posts</h1>
    <p><?php echo $this->Html->link("Add Post", array('action' => 'add')); ?></p>
    <table>
        <tr>
            <th>Id</th>
            <th>Title</th>
                    <th>Action</th>
            <th>Created</th>
        </tr>

    <!-- Here's where we loop through our $posts array, printing out post info -->

    <?php foreach ($posts as $post): ?>
        <tr>
            <td><?php echo $post['Post']['id']; ?></td>
            <td>
                <?php echo $this->Html->link($post['Post']['title'], array('action' => 'view', $post['Post']['id'])); ?>
            </td>
            <td>
                <?php echo $this->Html->link('Edit', array('action' => 'edit', $post['Post']['id'])); ?>
            </td>
            <td>
                <?php echo $post['Post']['created']; ?>
            </td>
        </tr>
    <?php endforeach; ?>

    </table>

删除Posts
==============

接下来, 增加删除posts功能. 在PostsController中添加 ``delete()`` 动作::

    public function delete($id) {
        if ($this->request->is('get')) {
            throw new MethodNotAllowedException();
        }

        if ($this->Post->delete($id)) {
            $this->Session->setFlash('The post with id: ' . $id . ' has been deleted.');
            $this->redirect(array('action' => 'index'));
        }
    }

这个逻辑删除指定 `$id` 的posts，并在重定向到 ``/posts`` 后使用 ``$this->Session->setFlash()`` 
 显示给用户确认信息。如果用户尝试通过GET请求删除post时，我们抛出异常。
未被获取的异常将被CakePHP的异常处理截取并在页面上显示一个错误信息。
这有许多内建的异常 :doc:`/development/exceptions`  可以在你的应用中使用来生成多种HTTP的错误。

因为我们仅仅是执行一些逻辑和重定向，这些动作没有视图，只需在index视图中
添加删除链接来允许用户删除posts:

.. code-block:: php

    <!-- File: /app/View/Posts/index.ctp -->

    <h1>Blog posts</h1>
    <p><?php echo $this->Html->link('Add Post', array('action' => 'add')); ?></p>
    <table>
        <tr>
            <th>Id</th>
            <th>Title</th>
            <th>Actions</th>
            <th>Created</th>
        </tr>

    <!-- Here's where we loop through our $posts array, printing out post info -->

        <?php foreach ($posts as $post): ?>
        <tr>
            <td><?php echo $post['Post']['id']; ?></td>
            <td>
                <?php echo $this->Html->link($post['Post']['title'], array('action' => 'view', $post['Post']['id'])); ?>
            </td>
            <td>
                <?php echo $this->Form->postLink(
                    'Delete',
                    array('action' => 'delete', $post['Post']['id']),
                    array('confirm' => 'Are you sure?'));
                ?>
                <?php echo $this->Html->link('Edit', array('action' => 'edit', $post['Post']['id'])); ?>
            </td>
            <td>
                <?php echo $post['Post']['created']; ?>
            </td>
        </tr>
        <?php endforeach; ?>

    </table>

使用 :php:meth:`~FormHelper::postLink()`  将创建一个链接使用Javascrip来创建一个删除我们post的POST类型请求.
使用GET请求来删除内容是危险的,因为web爬虫将有机会删除你所有的内容.

.. 注意::

	这个视图代码也使用了FormHelper，当用户视图删除一个post时，
	将会给用户一个JavaScript的确认对话框提示。

路由
======

一般来讲, CakePHP默认的路由已经做的够好. 对用户友好性
和通用搜索引擎兼容性敏感的开发者将会欣赏CakePHP在URL
映射上所做的工作. 所以，在这个教程中我们将仅仅做一个快速的对路由的改动。

在这里 :ref:`routes-configuration`  有更多的高级路由技巧的信息。

默认情况下， CakePHP 使用PagesController响应相对站点根目录的
请求(例如 http://www.example.com) , 渲染 "home" 视图。这里我们将通过
修改routes规则，将其替换为我们的PostsController .

Cake's 的路由设置在 ``/app/Config/routes.php``  文件. 你可以注释掉或者删除掉
默认的路由root设置. 如代码中::

    Router::connect('/', array('controller' => 'pages', 'action' => 'display', 'home'));

这一行定义了 '/' ， CakePHP默认的首页.
我们想要到定义到我们的Posts, 所以修改代码为::

    Router::connect('/', array('controller' => 'posts', 'action' => 'index'));

这样就把 '/' 的 index() 动作指向我们的 PostsController.

.. 注意::

    CakePHP同样支持 '反向 路由' - 比如上面的路由如果定义为
    ``array('controller' => 'posts', 'action' => 'index')``, URL 将会是 '/'.
	因此好的做法是总使用数组来定义你的路由中的URL确保它的指向唯一。

结论
==========

用这种方法来创建应用会为你赢得平静，荣誉，爱，钱甚至超出你最疯狂的幻想。
简单吧? 这个教程非常基本. CakePHP 提供了非常非常多的功能特色, 
并且是非常灵活的，在这里就不一一叙写了。使用该手册余下的部分作为创建更具特色的应用的指导吧。

现在你已经创建了一个基本的Cake应用并且你已经可以开始真正的做事了。
开始你自己的工程那个，阅读余下的 :doc:`Cookbook </index>`  和  `API <http://api20.cakephp.org>`_.

如果需要帮助，来这里 #cakephp. 欢迎使用 CakePHP!

接下来的阅读建议
---------------------------

这是学习CakePHP的人们接下来常去看的:

1. :ref:`view-layouts`: 自定义你的网站布局
2. :ref:`view-elements` 导入和重用视图片段
3. :doc:`/controllers/scaffolding`: 在写代码前，快速原型。
4. :doc:`/console-and-shells/code-generation-with-bake` 自动生成 CRUD 代码
5. :doc:`/tutorials-and-examples/blog-auth-example/auth`: 用户身份验证和授权教程


.. meta::
    :title lang=en: Blog Tutorial - Adding a layer
    :keywords lang=en: doc 模型,validation check,controller actions,post模型 ,php class,模型类,模型 object,business logic,database table,naming convention,bread and butter,callbacks,prefixes,nutshell,interaction,array,cakephp,interface,applications,delete
