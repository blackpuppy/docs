脚手架 Scaffolding
###########

应用程序脚手架是一种允许开发者定义并且创建具有建立、查询、更新和删除的基本应用程序的技术。
CakePHP的脚手架还允许开发者定义如何与其它对象交互，建立或断开它们的连接。

Application scaffolding is a technique that allows a developer to
define and create a basic application that can create, retrieve,
update and delete objects. Scaffolding in CakePHP also allows
developers to define how objects are related to each other, and to
create and break those links.

脚手架用于建立一个模型和它的控制器。一旦你在控制器中设置了 $scaffold 变量，就可以运行了。

All that’s needed to create a scaffold is a model and its
controller. Once you set the $scaffold variable in the controller,
you’re up and running.

CakePHP 的脚手架非常酷。它可以使你在几分种内就完成一个基本的 CRUD 应用程序。
它甚至酷到你想在产品应用中使用它。是的，我们也认为它很酷，但是请记住它仅仅是脚手架。
脚手架是快速开始项目的随时可以被拿来使用的一种松散结构。 
但并不意味着它完整灵活，只是开始进行一个项目中的临时方案。
如果你发现你确实要自定义逻辑或视图，那就放弃使用脚手架，开始写自己的代码。
CakePHP 的 Bake 控制台（见下一节）是下一步的好选择：它生成了与当前脚手架结果（或更多功能的）相同的代码。

CakePHP’s scaffolding is pretty cool. It allows you to get a basic
CRUD application up and going in minutes. It's so cool that you'll want
to use it in production apps. Now, we think it's cool too, but
please realize that scaffolding is... well... just scaffolding.
It's a loose structure you throw up real quick during the beginning
of a project in order to get started. It isn't meant to be
completely flexible, it’s meant as a temporary way to get up and
going. If you find yourself really wanting to customize your logic
and your views, it's time to pull your scaffolding down in order to
write some code. CakePHP’s Bake console, covered in the next
section, is a great next step: it generates all the code that would
produce the same result as the most current scaffold.

脚手架是开始编写一个 web 应用程序的早期代码的好方法。
早期的数据库结构随时会变更，这在设计过程的初期是完全正常的。
其负面影响是：web 程序员痛恨编写一个看起来永远用不到的表单。
为了减少程序员的这种无谓的劳动，CakePHP 中加入了脚手架。 
脚手架分析数据库表，并且建立标准的带有添加、删除和编辑按钮的列表；
标准的编辑表单； 与数据库的单个成员交互的标准视图。

Scaffolding is a great way of getting the early parts of developing
a web application started. Early database schemas are subject to
change, which is perfectly normal in the early part of the design
process. This has a downside: a web developer hates creating forms
that never will see real use. To reduce the strain on the
developer, scaffolding has been included in CakePHP. Scaffolding
analyzes your database tables and creates standard lists with add,
delete and edit buttons, standard forms for editing and standard
views for inspecting a single item in the database.

要将脚手架添加到应用程序中，只要在控制器中加入 $scaffold 变量：

To add scaffolding to your application, in the controller, add the
$scaffold variable::

    class CategoriesController extends AppController {
        public $scaffold;
    }

假设你已经建立了更多基本 Category 模型文件（在 /app/Model/Category.php），
访问http://example.com/categories 去查看你的新脚手架。

Assuming you’ve created even the most basic Category model class
file (in /app/Model/Category.php), you’re ready to go. Visit
http://example.com/categories to see your new scaffold.

.. note::

用脚手架构造的控制器中新建方法可能带来非预期的结果。
例如，如果你在脚手架控制器中建立了index()方法，你的index方法将在脚手架功能渲染之前优先被渲染。

    Creating methods in controllers that are scaffolded can cause
    unwanted results. For example, if you create an index() method in a
    scaffolded controller, your index method will be rendered rather
    than the scaffolding functionality.

脚手架支持使用模型关联，所以如果你的 Category 模型(属于) belongsTo 一个 User 模型，
你将会在 Category 列表中看到关联的 User ID。虽然脚手架 “知道” 模型间的关系，
你还是无法在脚手架视图中看到任何关联的记录，直到你在模型中手动添加关联代码。
例如，如果(组包含很多用户) Group hasMany User，并且(用户也属于组) User blongsTo Group，
你必须在 User 和 Group 模型中手动添加如下代码。
在你添加这些代码之前，视图将在 New User 表单中显示空的 Group 下拉列表框。
在你加入这些代码之后，视图将在 New User 表单中显示来自 Group 表的 ID 或者名字构成的下拉列表：

Scaffolding is knowledgeable about model associations, so if your
Category model belongsTo a User, you’ll see related User IDs in the
Category listings. While scaffolding "knows" about model
associations, you will not see any related records in the scaffold
views until you manually add the association code to the model. For
example, if Group hasMany User and User belongsTo Group, you have
to manually add the following code in your User and Group models.
Before you add the following code, the view displays an empty
select input for Group in the New User form. After you add the
following code, the view displays a select input populated with IDs
or names from the Group table in the New User form::

    // In Group.php
    public $hasMany = 'User';
    // In User.php
    public $belongsTo = 'Group';

如果你想在一个ID 内看到更多东西（例如用户的姓），你可以在模型中设置 $displayField 变量。
让我们在User 类中设置 $displayField 变量，以便在脚手架中显示关联到 categories 的 用户的姓名，而不是ID。
这个特点使脚手架在许多实例中可读性更强::

If you’d rather see something besides an ID (like the user’s first
name), you can set the $displayField variable in the model. Let’s
set the $displayField variable in our User class so that users
related to categories will be shown by first name rather than just
an ID in scaffolding. This feature makes scaffolding more readable
in many instances::

    class User extends AppModel {
        public $displayField = 'first_name';
    }

使用脚手架建立一个简单的管理界面
Creating a simple admin interface with scaffolding
==================================================

如果你已经在 app/Config/core.php 中设置了允许 admin 的路由，
就可以使用带有``Configure::write('Routing.prefixes', array('admin'));``的脚手架生成一个管理界面。

一旦你允许了 admin 路由，只要将 admin 前缀赋给脚手架变量::

If you have enabled admin routing in your app/Config/core.php, with
``Configure::write('Routing.prefixes', array('admin'));`` you can
use scaffolding to generate an admin interface.

Once you have enabled admin routing assign your admin prefix to the
scaffolding variable::

    public $scaffold = 'admin';

可以访问 admin 的脚手架动作::

You will now be able to access admin scaffolded actions::

    http://example.com/admin/controller/index
    http://example.com/admin/controller/view
    http://example.com/admin/controller/edit
    http://example.com/admin/controller/add
    http://example.com/admin/controller/delete

这种方法能够很快的建立一个简单的后台界面。 
切记不能在脚手架中同时使用 admin 和 (非admin) non-admin 两类方法。 
在正常脚手架中，你可以用自己的方法覆盖或者替换个别方法::

This is an easy way to create a simple backend interface quickly.
Keep in mind that you cannot have both admin and non-admin methods
scaffolded at the same time. As with normal scaffolding you can
override individual methods and replace them with your own::

    public function admin_view($id = null) {
      // custom code here
    }

一旦你替换了脚手架的动作，你还需要建立这个动作的视图文件。

Once you have replaced a scaffolded action you will need to create
a view file for the action as well.

自定义脚手架视图 Customizing Scaffold Views
==========================

如果你想在你的脚手架视图中使用一些不一样的东西，可以建立一个模板。
我们虽然不推荐使用这种技术构建应用程序，但是在原型迭代阶段这种自定义功能还是有用的。

If you're looking for something a little different in your
scaffolded views, you can create templates. We still don't
recommend using this technique for production applications, but
such a customization may be useful during prototyping iterations.

为指定的控制器使用自定义脚手架视图（例如 PostsController），文件位置和命名类似于::

Custom scaffolding views for a specific controller
(PostsController in this example) should be placed like so::

    /app/View/Posts/scaffold.index.ctp
    /app/View/Posts/scaffold.form.ctp
    /app/View/Posts/scaffold.view.ctp

为所有的控制器中自定义脚手架视图，文件位置和命名类似于::

Custom scaffolding views for all controllers should be placed like so::

    /app/View/Scaffolds/index.ctp
    /app/View/Scaffolds/form.ctp
    /app/View/Scaffolds/view.ctp


.. meta::
    :title lang=zh: Scaffolding
    :keywords lang=zh: database schemas,loose structure,scaffolding,scaffold,php class,database tables,web developer,downside,web application,logic,developers,cakephp,running,current,delete,database application
