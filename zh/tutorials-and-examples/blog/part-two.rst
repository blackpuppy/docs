Blog �̳� - ���һ����
******************************

����һ�� Post ģ��
===================

ģ������ CakePHP Ӧ�õĻ���. ͨ������һ�� CakePHP ģ�ͽ�����ϵ�����ݿ�,
Ϊ�˽���ȥ����ͼ����ӡ��༭��ɾ���������������Ȱ�һЩ�����������㡣

CakePHP ��ģ�����ļ���  ``/app/Model`` , ���Ǵ������ļ�������
Ϊ  ``/app/Model/Post.php`` .���ļ�����ӦΪ::

    class Post extends AppModel {
    }

�� CakePHP �У�����Լ������Ҫ. ͨ���������ǵ�ģ��Ϊ
Post, CakePHP ���Զ����ø�ģ�ͱ�PostsControllerʹ�ã������󶨵����ݿ�����Ϊ "posts" �ı�

.. ע��::

    ���CakePHP������ /app/Model �ҵ���ص��ļ��������Զ�Ϊ�㴴��һ��ģ�Ͷ���. 
	�����Ļ��������û����ȷ��������ļ�(��������Ϊ post.php ��
    posts.php)��CakePHP�������������ò�ʹ��Ĭ�ϵ����á�


����ģ�͵ĸ�����Ϣ, �����ǰ׺, �ص�, ��֤,��鿴�ֲ��е��ĵ� :doc:`/Models` �½�.


����һ��Posts�Ŀ�����
=========================

������, Ϊ���ǵ�posts����һ��������. �����������е�post���
�������߼� .��˵, ���Ǻ�ģ��һ��post��صĹ�����ɵĵط���
�Ѹ��ļ�����Ϊ ``PostsController.php`` ������  ``/app/Controller`` Ŀ¼�¡�
���ǿ������Ļ�������::

    class PostsController extends AppController {
        public $helpers = array('Html', 'Form');
    }

����, ���һ������. ����һ�����Ӧ����һ�������ĺ������߽ӿڡ����磬
���û����� www.example.com/posts/index (ͬ www.example.com/posts/ ),
���ǽ�����������posts���б���������Ĵ����������::

    class PostsController extends AppController {
        public $helpers = array('Html', 'Form');

        public function index() {
            $this->set('posts', $this->Post->find('all'));
        }
    }

�����������¸ö���.ͨ�������ǵ� PostsController���庯��  ``index()``
, �û������ڿ���ͨ���������www.example.com/posts/index
�����ʸ��߼�.ͬ����, �������һ������ ``foobar()`` , �û�������ͨ������ www.example.com/posts/foobar ������.

.. ����::

	�㽫�ᱻ�յ�ȥ�����������Ͷ�������ȷ�ķ�ʽȥ��ȡһ����ȷ��URL��
	��ѭCakePHP�������淶�������׶������Ķ������֣������ʹ�á�routes����URLӳ�䵽
	��Ĵ����У����������ᵽ��

�ڶ�����ʹ�� ``set()`` ��������Ĳ������ӿ������д������ݵ���ͼ�С�
��ͼ�е�'posts'�����ȼ���Post ģ���� ``find('all')`` �ķ���ֵ�����ǵ�
``$this->Post`` ��Post ģ���п�������Ϊ������ѭ��Cake�������淶��

��:doc:`/controllers` �½��˽����Ĺ���Cake�Ŀ���������Ϣ.

���� Post ��ͼ
===================

�������ǵ�ģ���Ѿ���������,Ӧ���߼��Լ��������ж���Ĺ�����, 
���������Ǵ���һ��index��������ͼ��

Cake ����ͼ��������Ӧ�õĲ�����չʾ��ʽ��Ƭ�Ρ��Դ����Ӧ�ã�������
HTML �� PHP ��ϵ�, ���������տ����� XML, CSV, �����Ƕ���������.

������������ͼ��װ�Ĵ��룬���Ա������ת���ģ������ڣ���������ʹ��Ĭ�ϵĲ��֡�

���ǵ���һ����������ʹ��  ``set()`` �������� 'posts'  ������ֵ��
�ǽ���ֵ���ݵ���ͼ��,��������::

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

Cake����ͼ������ ``/app/View`` Ŀ¼�У���Ӧ��Ӧ�Ŀ�����
 (�ڱ�����������Ҫ����Ϊ 'Posts'  ).��post��������ʾ�ڱ���У�
��ͼ�Ĵ����������

.. code-block:: php

    <!-- File: /app/View/Posts/index.ctp -->

    <h1>Blog posts</h1>
    <table>
        <tr>
            <th>Id</th>
            <th>Title</th>
            <th>Created</th>
        </tr>

        <!-- ���� $posts ����, ����post����Ϣ -->

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

ϣ�������ῴ������Щ.

��Ҳ���Ѿ�ע�⵽�� ``$this->Html`` �������,���� CakePHP :php:class:`HtmlHelper`  ��
��һ��ʾ��. CakePHP�ṩ��һЩhelpers��ʹ���ӣ���������JavaScript �� Ajax ���.
����������￴�����ʹ������  :doc:`/views/helpers` , ��ֵ��ע����� ``link()`` ������
�����һ�� HTML���Ӻͱ���(��һ������)���Լ�URL (�ڶ�������).

����Cake��ָ��URLʱ, �Ƽ�ʹ�������ʽ. ��Routes�½������ǻὲ����Щϸ��.
ʹ�����ݸ�ʽ����ʾURL����������CakePHP�ķ���·�ɹ��ܣ���Ҳ���Զ������Ӧ�õ����·����
��/controller/action/param1/param2����

���ڣ�����Դ�������������ַ http://www.example.com/posts/index . 
��Ӧ�ÿ��Կ��������ͼ������ͱ����posts���б�����ȷ�ĸ�ʽ��

������ڵ���������������ͼ�д��������ӣ�ָ��URL /posts/view/some\_id 
��post�ı�������ӣ���CakePHP�����֪�㻹û�ж�����������������û�б�
֪ͨ���Ǿ���ʲô�ط������˻�����ʵ�����Ѿ�͵͵�����ˣ��ðɣ��������������
�����ɡ���PostsController::

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

 ``set()`` �Ѿ�����Ϥ�˰ɣ� ע�⵽����ʹ�� ``findById()`` 
 ������ ``find('all')`` ����Ϊ����ֵ��Ҫһ��post����Ϣ��

ע�⵽���ǵ���ͼ������Ҫһ��������post��ID�����������ͨ��
�����URL�����ݵģ����һ���û����� ``/posts/view/3`` ,��ôֵ
'3' �ͻḳֵ�� ``$id`` .

����Ҳ����Щ��������ȷ���û�ȷʵ��Ҫ����һ����¼�����һ���û�
���� ``/posts/view`` , ���Ǿ��׳�һ�� ``NotFoundException``  �쳣��
�� CakePHP ErrorHandler ����. ����Ҳ������һ��ͬ���ļ������֤�û�
���ʵļ�¼�Ǵ��ڵġ�

���������ǽ��������ͼ���������� ``/app/View/Posts/view.ctp``

.. code-block:: php

    <!-- File: /app/View/Posts/view.ctp -->

    <h1><?php echo h($post['Post']['title']); ?></h1>

    <p><small>Created: <?php echo $post['Post']['created']; ?></small></p>

    <p><?php echo h($post['Post']['body']); ?></p>

��֤�����������ǿ��Թ����ģ������������ ``/posts/index``  �����ֶ�����鿴һ��post������ ``/posts/view/1`` .

��� Posts
============

�����ݿ��ж�������ʾposts��һ���õĿ�ʼ��������ʾ������һ���µ�posts��

���ȣ����ڿ�����PostsController�д������� ``add()``  ��ʼ::

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

.. ע��::

    ����Ҫ���� SessionComponent - �Լ� SessionHelper - �����õ��Ŀ�������. 
	�����Ҫ�Ļ������뵽���AppController.

���� ``add()`` ����������: ������ HTTP ����ķ����� POST, ��ʹ�� Post ģ�ͽ����ݱ���.
�����Ϊ����ԭ��û�б��棬������ͼ����Ⱦ������������л�����û���ʾ��֤��Ĵ������������ȡ�

�κ� CakePHP �������һ�� ``CakeRequest`` ����������ͨ�� ``$this->request`` ������. 
����������������յ�����������ò����ܹ��������������Ӧ�õ������ڱ�����,����ʹ��  
 :php:meth:`CakeRequest::is()` �����������������Ƿ���һ�� HTTP POST ����.

��һ���û������Ӧ����ʹ��һ���� POST ����, ����Ϣ������ ``$this->request->data`` . 
�����ʹ�� :php:func:`pr()`  �� :php:func:`debug()` ������ӡ������Ϣ��

����ʹ�� SessionComponent's :php:meth:`SessionComponent::setFlash()`
����������һ����Ϣ��ҳ���ض��������ʾ�Ự����������������������� 
 :php:func:`SessionHelper::flash` ��ʾ��Ϣ�������صĻỰ�������������� :php:meth:`Controller::redirect` �����ض���ҳ�浽������ URL.���� ``array('action' => 'index')``
����URL ��/posts �� posts ��������index����.
�����ϸ�� :php:func:`Router::url()`  ������ `API <http://api20.cakephp.org>` �еĶ���URL��ʽ��

���� ``save()`` ���������������֤�����κ�����ʱȡ�����档����
�����ڽ�������С������������δ�����Щ����

������֤
===============

Cake�����ܴ��Ŭ�������ѱ��������֤�ĵ�����ÿһ���˶��ޱ��������ı������ǵ�
��֤���֣�CakePHP����Щ�����򵥺Ϳ��١�

������֤���ܣ��㽫��Ҫ����ͼ��ʹ��Cake�� FormHelper ����� :php:class:`FormHelper`  Ĭ����������ͼ�ж�����ͨ�� ``$this->Form`` ����.

�������ǵ����post����ͼ:

.. code-block:: php

    <!-- File: /app/View/Posts/add.ctp -->

    <h1>Add Post</h1>
    <?php
    echo $this->Form->create('Post');
    echo $this->Form->input('title');
    echo $this->Form->input('body', array('rows' => '3'));
    echo $this->Form->end('Save Post');
    ?>

�������ʹ�� FormHelper ����̬����һ�� HTML��. 
������ ``$this->Form->create()`` ������:

.. code-block:: html

    <form id="PostAddForm" method="post" action="/posts/add">

��� ``create()`` ��������, ���ٶ���Ҫ����һ���ύ��ǰ��������
``add()`` ���� (���� ``edit()`` ���� ���� ``id`` ��ֵʱ), ͨ�� POST ����.

��� ``$this->Form->input()`` ��������������ͬ���ı�Ԫ�� .
��һ���������� CakePHP �������Ǹ��ֶ�,�ڶ����������㶨��һϵ��ѡ������
���Ƕ����ı������������㽫ע�⵽ :``input()``  ���������ͬ�ı�Ԫ�أ�����ݵ���ģ���и��ֶεĶ���.

``$this->Form->end()``  ����һ���ύ��ť��������. 
 ``end()`` �ĵ�һ�������������������ύ��ť�ϵ�����. 
�������и���helper����Ϣ :doc:`/views/helpers` .

���������ǻ�ȥ���������ǵ� ``/app/View/Posts/index.ctp`` ��ͼ��
��� "Add Post" ����. ��  ``<table>`` ǰ������´��� ::

    <?php echo $this->Html->link(
        'Add Post',
        array('controller' => 'posts', 'action' => 'add')
    ); ?>

�������Щ�ɻ���ô����CakePHP�ҵ���֤Ҫ���أ���֤�Ĺ�������ģ���ж���ġ�
 �����Ǽ��һ��Post ģ�Ͳ���һЩ����::

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

``$validate`` ������� CakePHP �� ``save()`` ����������ʱ���ȥ��֤������ݣ�
����Ҷ�����body�ͱ�����ֶβ���Ϊ�գ�CakePHP����֤�����ǿ��
������ڽ�����֤�������ÿ��������ʼ����ȣ������������������Լ�����֤����
������Ϣ���Ʋ� :doc:`/Models/data-validation`.


�������Ѿ��������֤���򲿷֣�ʹ�ñ�Ӧ�����������һ��post���ڱ������body����
���տ�����֤������������õġ���Ϊ�����Ѿ�ʹ����FormHelper��
 :php:meth:`FormHelper::input()`  ���� ���������ǵı�Ԫ�أ�����
����֤������Ϣ�����Զ���ʾ��

�༭Posts
=============

Post�༭:��ʼ��. �������Ѿ��Ǹ�CakePHPרҵ��ʿ��, �����������Ѿ�ѡ����һ��ģʽ.
����������Ȼ������ͼ��������PostsController�еĶ��� ``edit()`` ��������::

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

�����������ȷ���û��Ѿ����ʵ���һ���Ѵ�ļ�¼���������û�д��� ``$id``  ��ֵ����post
û���ҵ������׳� ``NotFoundException`` �쳣�� CakePHP ErrorHandler ������.

���ţ������������Ƿ���һ��POST��������ǣ�Ȼ������ʹ��POST�е�������
����Post��¼��������˻ز�����֤�Ĵ�����ʾ���û���

��� ``$this->request->data`` ��û�����ݼ������Ǽ򵥵�����Ϊǰһ����õ�post��


�༭post����ͼ��������:

.. code-block:: php

    <!-- File: /app/View/Posts/edit.ctp -->

    <h1>Edit Post</h1>
    <?php
        echo $this->Form->create('Post');
        echo $this->Form->input('title');
        echo $this->Form->input('body', array('rows' => '3'));
        echo $this->Form->input('id', array('type' => 'hidden'));
        echo $this->Form->end('Save Post');

�����ͼ����༭���������һЩֵ�����Լ�һЩ��֤��Ҫ�Ĵ�����Ϣ��

������������Ҫע����ǣ������ 'id'��CakePHP ���������ڱ༭һ��ģ��.
���û�� 'id' , ������ ``save()``  ʱ��Cake �����������ڲ���һ���µ�ģ��.

�����ڿ��Ը������index��ͼ�ˣ����posts�ı༭���ӡ�:

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

ɾ��Posts
==============

������, ����ɾ��posts����. ��PostsController����� ``delete()`` ����::

    public function delete($id) {
        if ($this->request->is('get')) {
            throw new MethodNotAllowedException();
        }

        if ($this->Post->delete($id)) {
            $this->Session->setFlash('The post with id: ' . $id . ' has been deleted.');
            $this->redirect(array('action' => 'index'));
        }
    }

����߼�ɾ��ָ�� `$id` ��posts�������ض��� ``/posts`` ��ʹ�� ``$this->Session->setFlash()`` 
 ��ʾ���û�ȷ����Ϣ������û�����ͨ��GET����ɾ��postʱ�������׳��쳣��
δ����ȡ���쳣����CakePHP���쳣�����ȡ����ҳ������ʾһ��������Ϣ��
��������ڽ����쳣 :doc:`/development/exceptions`  ���������Ӧ����ʹ�������ɶ���HTTP�Ĵ���

��Ϊ���ǽ�����ִ��һЩ�߼����ض�����Щ����û����ͼ��ֻ����index��ͼ��
���ɾ�������������û�ɾ��posts:

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

ʹ�� :php:meth:`~FormHelper::postLink()`  ������һ������ʹ��Javascrip������һ��ɾ������post��POST��������.
ʹ��GET������ɾ��������Σ�յ�,��Ϊweb���潫�л���ɾ�������е�����.

.. ע��::

	�����ͼ����Ҳʹ����FormHelper�����û���ͼɾ��һ��postʱ��
	������û�һ��JavaScript��ȷ�϶Ի�����ʾ��

·��
======

һ������, CakePHPĬ�ϵ�·���Ѿ����Ĺ���. ���û��Ѻ���
��ͨ������������������еĿ����߽�������CakePHP��URL
ӳ���������Ĺ���. ���ԣ�������̳������ǽ�������һ�����ٵĶ�·�ɵĸĶ���

������ :ref:`routes-configuration`  �и���ĸ߼�·�ɼ��ɵ���Ϣ��

Ĭ������£� CakePHP ʹ��PagesController��Ӧ���վ���Ŀ¼��
����(���� http://www.example.com) , ��Ⱦ "home" ��ͼ���������ǽ�ͨ��
�޸�routes���򣬽����滻Ϊ���ǵ�PostsController .

Cake's ��·�������� ``/app/Config/routes.php``  �ļ�. �����ע�͵�����ɾ����
Ĭ�ϵ�·��root����. �������::

    Router::connect('/', array('controller' => 'pages', 'action' => 'display', 'home'));

��һ�ж����� '/' �� CakePHPĬ�ϵ���ҳ.
������Ҫ�����嵽���ǵ�Posts, �����޸Ĵ���Ϊ::

    Router::connect('/', array('controller' => 'posts', 'action' => 'index'));

�����Ͱ� '/' �� index() ����ָ�����ǵ� PostsController.

.. ע��::

    CakePHPͬ��֧�� '���� ·��' - ���������·���������Ϊ
    ``array('controller' => 'posts', 'action' => 'index')``, URL ������ '/'.
	��˺õ���������ʹ���������������·���е�URLȷ������ָ��Ψһ��

����
==========

�����ַ���������Ӧ�û�Ϊ��Ӯ��ƽ��������������Ǯ��������������Ļ��롣
�򵥰�? ����̷̳ǳ�����. CakePHP �ṩ�˷ǳ��ǳ���Ĺ�����ɫ, 
�����Ƿǳ����ģ�������Ͳ�һһ��д�ˡ�ʹ�ø��ֲ����µĲ�����Ϊ����������ɫ��Ӧ�õ�ָ���ɡ�

�������Ѿ�������һ��������CakeӦ�ò������Ѿ����Կ�ʼ�����������ˡ�
��ʼ���Լ��Ĺ����Ǹ����Ķ����µ� :doc:`Cookbook </index>`  ��  `API <http://api20.cakephp.org>`_.

�����Ҫ������������ #cakephp. ��ӭʹ�� CakePHP!

���������Ķ�����
---------------------------

����ѧϰCakePHP�����ǽ�������ȥ����:

1. :ref:`view-layouts`: �Զ��������վ����
2. :ref:`view-elements` �����������ͼƬ��
3. :doc:`/controllers/scaffolding`: ��д����ǰ������ԭ�͡�
4. :doc:`/console-and-shells/code-generation-with-bake` �Զ����� CRUD ����
5. :doc:`/tutorials-and-examples/blog-auth-example/auth`: �û������֤����Ȩ�̳�


.. meta::
    :title lang=en: Blog �̳� ���һ����
    :keywords lang=en: doc ģ��,validation check,controller actions,postģ�� ,php class,ģ����,ģ�� object,business logic,database table,naming convention,bread and butter,callbacks,prefixes,nutshell,interaction,array,cakephp,interface,applications,delete
