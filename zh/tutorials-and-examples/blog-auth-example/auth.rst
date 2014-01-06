简单的身份验证和授权应用
###################################################

接着我们的blog教程 :doc:`/tutorials-and-examples/blog/blog`  的例子，
如果我们想要建立一个根据登录的用户身份来决定其安全访问到正确的url地址。同时我们还有其他的需求，允许我们的blog有多个作者，
所以每一个作者都可以自由创作他们自己的文章(posts)，编辑和删除它们，而不允许对别人的文章做任何的改动。

创建所有用户的相关代码
================================

首先，让我们在数据库blog中新建一个表来保存用户的数据 ::

    CREATE TABLE users (
        id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50),
        password VARCHAR(50),
        role VARCHAR(20),
        created DATETIME DEFAULT NULL,
        modified DATETIME DEFAULT NULL
    );

我们坚持遵循 CakePHP 的命名约定，同时我们也利用了其他约定：比如在表user中使用username和password,CakePHP 将会自动配置好实现用户登录的大部分工作。

下一步是创建User模型，用来查询，保存和验证任何用户 ::

    // app/Model/User.php
    class User extends AppModel {
        public $validate = array(
            'username' => array(
                'required' => array(
                    'rule' => array('notEmpty'),
                    'message' => 'A username is required'
                )
            ),
            'password' => array(
                'required' => array(
                    'rule' => array('notEmpty'),
                    'message' => 'A password is required'
                )
            ),
            'role' => array(
                'valid' => array(
                    'rule' => array('inList', array('admin', 'author')),
                    'message' => 'Please enter a valid role',
                    'allowEmpty' => false
                )
            )
        );
    }

让我们也建立控制器 UsersController, 下面的内容是使用 CakePHP 捆绑的代码生成工具生成的基本的 UsersController 类 ::

    // app/Controller/UsersController.php
    class UsersController extends AppController {

        public function beforeFilter() {
            parent::beforeFilter();
            $this->Auth->allow('add');
        }

        public function index() {
            $this->User->recursive = 0;
            $this->set('users', $this->paginate());
        }

        public function view($id = null) {
            $this->User->id = $id;
            if (!$this->User->exists()) {
                throw new NotFoundException(__('Invalid user'));
            }
            $this->set('user', $this->User->read(null, $id));
        }

        public function add() {
            if ($this->request->is('post')) {
                $this->User->create();
                if ($this->User->save($this->request->data)) {
                    $this->Session->setFlash(__('The user has been saved'));
                    $this->redirect(array('action' => 'index'));
                } else {
                    $this->Session->setFlash(__('The user could not be saved. Please, try again.'));
                }
            }
        }

        public function edit($id = null) {
            $this->User->id = $id;
            if (!$this->User->exists()) {
                throw new NotFoundException(__('Invalid user'));
            }
            if ($this->request->is('post') || $this->request->is('put')) {
                if ($this->User->save($this->request->data)) {
                    $this->Session->setFlash(__('The user has been saved'));
                    $this->redirect(array('action' => 'index'));
                } else {
                    $this->Session->setFlash(__('The user could not be saved. Please, try again.'));
                }
            } else {
                $this->request->data = $this->User->read(null, $id);
                unset($this->request->data['User']['password']);
            }
        }

        public function delete($id = null) {
            if (!$this->request->is('post')) {
                throw new MethodNotAllowedException();
            }
            $this->User->id = $id;
            if (!$this->User->exists()) {
                throw new NotFoundException(__('Invalid user'));
            }
            if ($this->User->delete()) {
                $this->Session->setFlash(__('User deleted'));
                $this->redirect(array('action' => 'index'));
            }
            $this->Session->setFlash(__('User was not deleted'));
            $this->redirect(array('action' => 'index'));
        }
    }

同样的，我们使用代码生成工具，创建blog的posts的视图。因为是教学目的，这里仅展示视图add.ctp：

.. code-block:: php

    <!-- app/View/Users/add.ctp -->
    <div class="users form">
    <?php echo $this->Form->create('User'); ?>
        <fieldset>
            <legend><?php echo __('Add User'); ?></legend>
            <?php echo $this->Form->input('username');
            echo $this->Form->input('password');
            echo $this->Form->input('role', array(
                'options' => array('admin' => 'Admin', 'author' => 'Author')
            ));
        ?>
        </fieldset>
    <?php echo $this->Form->end(__('Submit')); ?>
    </div>

身份验证 (登录和登出)
=================================

我们现在已经准备好添加我们的认证层了，在 CakePHP 中，这个功能是由  :php:class:`AuthComponent` 完成的，这个组件会为特定动作要求用户登录，
处理用户登录和登出，并且检查用户是否有权限进行相应动作(即访问特定页面)。

添加这个组件到应用中，打开 ``app/Controller/AppController.php`` 文件，添加如下代码 ::

    // app/Controller/AppController.php
    class AppController extends Controller {
        //...

        public $components = array(
            'Session',
            'Auth' => array(
                'loginRedirect' => array('controller' => 'posts', 'action' => 'index'),
                'logoutRedirect' => array('controller' => 'pages', 'action' => 'display', 'home')
            )
        );

        public function beforeFilter() {
            $this->Auth->allow('index', 'view');
        }
        //...
    }

这里没有什么需要配置的，因为我们前面遵循了user表的命名约定，我们只设置了登录后和登出后页面转到的url地址，在我们的例子中，分别是 ``/posts/`` 和 ``/`` 。

我们在 `` beforeFilter`` 中所做的功能是告诉组件 AuthComponent，在控制器中的所有 ``index`` 和 ``view`` 行为都不需要登录。
我们希望我们的访问者能够读取并列出文章，而不需要注册网站。

现在，我们需要实现新用户的注册。保存它们的用户名和密码，而更重要的是，
在我们的数据库中保存用户的hash过的密码而不是用普通文本形式保存，让我们告诉 AuthComponent 组件让未验证的用户访问用户添加函数并实现登录和登出动作 ::

    // app/Controller/UsersController.php

    public function beforeFilter() {
        parent::beforeFilter();
        $this->Auth->allow('add'); // Letting users register themselves
    }

    public function login() {
        if ($this->request->is('post')) {
            if ($this->Auth->login()) {
                $this->redirect($this->Auth->redirect());
            } else {
                $this->Session->setFlash(__('Invalid username or password, try again'));
            }
        }
    }

    public function logout() {
        $this->redirect($this->Auth->logout());
    }

加密密码还没有做，打开User模型 ``app/Model/User.php`` 添加代码 ::

    // app/Model/User.php
    App::uses('AuthComponent', 'Controller/Component');
    class User extends AppModel {

    // ...

    public function beforeSave($options = array()) {
        if (isset($this->data[$this->alias]['password'])) {
            $this->data[$this->alias]['password'] = AuthComponent::password($this->data[$this->alias]['password']);
        }
        return true;
    }

    // ...

现在，每次用户密码保存的时候，都会使用 AuthComponent 组件提供的默认的类进行散列化。为登录创建模板视图：

.. code-block:: php

    <div class="users form">
    <?php echo $this->Session->flash('auth'); ?>
    <?php echo $this->Form->create('User'); ?>
        <fieldset>
            <legend><?php echo __('Please enter your username and password'); ?></legend>
            <?php echo $this->Form->input('username');
            echo $this->Form->input('password');
        ?>
        </fieldset>
    <?php echo $this->Form->end(__('Login')); ?>
    </div>

现在你可以访问 ``/users/add`` 地址来注册一个新的用户了。注册完成后访问  ``/users/login`` 地址登录，
试试访问其他地址比如像 ``/posts/add`` 这些没有明确允许的地址，你会看到应用会自动的转向到登录页面。

就是这！简单到不可思议。让我们返回去稍微解释下。 ``beforeFilter`` 函数告诉AuthComponent组件在UsersController中对 ``add`` 动作不需要登录，
并且在AppController中的 ``beforeFilter`` 也已经设置所有的控制器的``index`` 和 ``view`` 动作都是可以不登录的。


 ``login`` 动作执行AuthComponent中的 ``$this->Auth->login()`` 函数且不需要其他的设置的原因是我们遵循了之前提到的在数据库中的user表的命名约定，
并且使用表单提交用户的数据到控制器。这个函数返回登录成功还是失败，如果成功，就重定向到我们设置的登录成功的跳转页面。

登出函数只需要访问 ``/users/logout`` 并且重定向到先前配置的 logoutUrl。这个地址是 ``AuthComponent::logout()`` 函数返回登出成功后的跳转的页面。

权限(谁可以访问什么)
============================================

前面已经说了，我们要把这个blog应用改为可以多个用户创作的工具，为了做到这个，我们需要修改posts表，添加对User模型的引用 ::

    ALTER TABLE posts ADD COLUMN user_id INT(11);

同时，在PostsController中对新增的post做改动，添加当前登录的用户为作者 ::

    // app/Controller/PostsController.php
    public function add() {
        if ($this->request->is('post')) {
            $this->request->data['Post']['user_id'] = $this->Auth->user('id'); //Added this line
            if ($this->Post->save($this->request->data)) {
                $this->Session->setFlash('Your post has been saved.');
                $this->redirect(array('action' => 'index'));
            }
        }
    }

 ``user()`` 函数提供由组件提供，返回当前登录用户的所有列的数据.我们使用这个方法获得所需的用户信息。

让我们增强应用的安全性，避免用户编辑或删除其他用户的posts，基本的规则是管理用户可以访问任何的url地址，当前的用户（作者角色）只可以访问到允许的地址。打开 AppController 类，在 Auth 的配置中增加更多选项 ::

    // app/Controller/AppController.php

    public $components = array(
        'Session',
        'Auth' => array(
            'loginRedirect' => array('controller' => 'posts', 'action' => 'index'),
            'logoutRedirect' => array('controller' => 'pages', 'action' => 'display', 'home'),
            'authorize' => array('Controller') // Added this line
        )
    );

    public function isAuthorized($user) {
        // Admin can access every action
        if (isset($user['role']) && $user['role'] === 'admin') {
            return true;
        }

        // Default deny
        return false;
    }

我们只创建了一个非常简单的权限机制。在这个例子中用户登录后角色是``admin`` 的将可以访问任何地址，
而其余的（例如角色  ``author`` ) 同未登录的用户一样不能够做任何事。

这并不是我们所想要的，所以我们需要在我们的  ``isAuthorized()`` 方法中支持更多的规则。与其在 AppController中设置,
不如委托每个控制器提供这些额外的规则。我们要在PostsController中增加规则，允许作者创建posts并且防止其他作者对其post做改动。
打开  ``PostsController.php``  并添加如下内容 ::

    // app/Controller/PostsController.php

    public function isAuthorized($user) {
        // All registered users can add posts
        if ($this->action === 'add') {
            return true;
        }

        // The owner of a post can edit and delete it
        if (in_array($this->action, array('edit', 'delete'))) {
            $postId = $this->request->params['pass'][0];
            if ($this->Post->isOwnedBy($postId, $user['id'])) {
                return true;
            }
        }

        return parent::isAuthorized($user);
    }

我们现在重写了 AppController 的 ``isAuthorized()`` 方法并且在父类中已核准用户后再进行内部检查，如果他不是,只允许他访问add动作,
并有条件访问edit 和 delete动作。在 Post 模型中调用 ``isOwnedBy()`` 来告诉用户是否有权限来编辑post. 尽量把逻辑挪到模型中是个很好的实践。让我们实现它 ::

    // app/Model/Post.php

    public function isOwnedBy($post, $user) {
        return $this->field('id', array('id' => $post, 'user_id' => $user)) === $post;
    }

简单的身份验证和授权教程到这里就结束了。可以参考我们在PostsController中所做的用到UsersController中，
你应该也会更具创作性并可根据你自己的规则在 AppController 添加一般规则。

更多信息，参阅完整的Auth指导  :doc:`/core-libraries/components/authentication`  ，这里你可以找到更多组件配置，创建自主的权限类等。

接下来阅读的建议
---------------------------

1. :doc:`/console-and-shells/code-generation-with-bake` 自动生成 CRUD 代码
2. :doc:`/core-libraries/components/authentication`: 用户注册和登录


.. meta::
    :title lang=en: Simple Authentication and Authorization Application
    :keywords lang=en: auto increment,authorization application,model user,array,conventions,authentication,urls,cakephp,delete,doc,columns
