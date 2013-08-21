模型
Models
######

模型在应用程序中是作为业务逻辑层而存在的。这就意味着, 模型应当负责管理几乎所有涉及数据的事情, 其有效性, 相互作用, 以及在你的工作领域中(?)信息工作流程的演化。
Models are the classes that sit as the business layer in your application.
This means that they should be responsible for managing almost everything
that happens regarding your data, its validity, interactions and evolution
of the information workflow in your domain of work.

通常模型类用来表示数据, 并且在CakePHP应用程序中用来数据访问, 具体说, 就是数据库中的表, 但不限于此, 也可以访问任何数据, 比如文件, 外部网络服务, iCal日程, 或者CSV文件中的行。
Usually model classes represent data and are used in CakePHP applications
for data access, more specifically they represent a database table but they are
not limited to this, but can be used to access anything that manipulates data
such as files, external web services, iCal events, or rows in a CSV file.

一个模型可以联系到其他模型。例如, 一份菜谱可以和菜谱的作者关联, 也可以和菜谱的原料相关联。
A model can be associated with other models. For example, a Recipe
may be associated with the Author of the recipe as well as the
Ingredient in the recipe.

本小节中我们将解释模型的哪些特性可以自动化, 如何改变这些特性的自动化, 以及模型有哪些方法和属性。我们会解释关联数据的各种方式。我们还将描述如何检索, 保存和删除数据。最后, 我们来看一下数据源(*Datasource*)。
This section will explain what features of the model can be
automated, how to override those features, and what methods and
properties a model can have. It'll explain the different ways to
associate your data. It'll describe how to find, save, and delete
data. Finally, it'll look at Datasources.

理解模型
Understanding Models
====================

模型代表你的数据模型。在面向对象编程中数据模型是表示一件"事物"的对象, 比如, 一辆汽车, 一个人, 或者一所房子。例如, 一个博客可以有多篇文章, 
每篇文章又可以有多条评论。博客, 文章和评论就是彼此关联的模型的例子。
A Model represents your data model. In object-oriented programming
a data model is an object that represents a "thing", like a car, a
person, or a house. A blog, for example, may have many blog posts
and each blog post may have many comments. The Blog, Post, and
Comment are all examples of models, each associated with another.

这里有一个CakePHP模型定义的简单例子::
Here is a simple example of a model definition in CakePHP::

    App::uses('AppModel', 'Model');
    class Ingredient extends AppModel {
        public $name = 'Ingredient';
    }

仅需这样简单的声明, Ingredient模型就具备了所有用来生成查询以及保存和删除数据的功能。这些魔术般的方法来自CakePHP的Model类, 得益于继承的魔法。Ingredient模型扩展了应用程序模型AppModel, 而AppModel又扩展了CakePHP内部的Model类。就是这个核心的Model类赋予你的Ingredient类这些功能的。``App::uses('AppModel', 'Model')``保证模型在每次调用时都延迟加载了。
With just this simple declaration, the Ingredient model is bestowed
with all the functionality you need to create queries along with
saving and deleting data. These magic methods come from CakePHP's
Model class by the magic of inheritance. The Ingredient model
extends the application model, AppModel, which extends CakePHP's
internal Model class. It is this core Model class that bestows the
functionality onto your Ingredient model. ``App::uses('AppModel', 'Model')``
ensures that the model is lazy loaded in every instance of its usage.

这个中间的类AppModel是空的。如果你没有自己创建, 则会从CakePHP内核文件夹取得。重载AppModel, 你就可以定义你的应用程序中所有的模型都具有的功能。为此, 你需要在Model文件夹中创建自己的``AppModel.php``, 就象你的应用程序中其他所有的模型一样。使用:doc:`Bake <console-and-shells/code-generation-with-bake>`创建项目, 就会为你自动生成这个文件。
This intermediate class, AppModel, is empty and if you haven't
created your own, is taken from within the CakePHP core folder. Overriding
the AppModel allows you to define functionality that should be made
available to all models within your application. To do so, you need
to create your own ``AppModel.php`` file that resides in the Model folder,
as all other models in your application. Creating a project using
:doc:`Bake <console-and-shells/code-generation-with-bake>` will automatically
generate this file for you.

关于如何在多个模型使用相似的逻辑的更多信息, 请参看:doc:`Behaviors <models/behaviors>`。
See also :doc:`Behaviors <models/behaviors>` for more information on
how to apply similar logic to multiple models.

回到我们的Ingredient模型, 在``/app/Model/``目录中创建一个PHP文件。按照惯例, 文件名应该和类名一样; 在本例中就是``Ingredient.php``。
Back to our Ingredient model, in order to work on it, create the PHP file in the
``/app/Model/`` directory. By convention it should have the same name as the class;
for this example ``Ingredient.php``.

.. note::

    如果CakePHP在/app/Model目录中无法找到对应的文件, 它就会为你动态创建一个模型对象。这也意味着, 如果你的模型文件命名不正确(比如ingredient.php或者Ingredients.php), CakePHP就会使用AppModel的实例, 而不是你的找不到的(从CakePHP的角度来看)模型文件。如果你试图调用在你的模型中定义的方法, 或者你的模型上附加的行为, 然而你得到的却是关于你调用的方法的SQL错误 - 这明显是因为CakePHP无法找到你的模型, 那么你要检查你的文件名, 应用程序缓存, 或者两者都要检查。
    CakePHP will dynamically create a model object for you if it cannot
    find a corresponding file in /app/Model. This also means that if
    your model file isn't named correctly (i.e. ingredient.php or
    Ingredients.php) CakePHP will use an instance of AppModel rather
    than your missing (from CakePHP's perspective) model file. If
    you're trying to use a method you've defined in your model, or a
    behavior attached to your model and you're getting SQL errors that
    are the name of the method you're calling - it's a sure sign
    CakePHP can't find your model and you either need to check the file
    names, your application cache, or both.

.. note::

    某些类名是无法作为模型名称的。例如, "File"无法使用, 因为"File"是CakePHP内核中已经存在的一个类了。
    Some class names are not usable for model names. For instance
    "File" cannot be used as "File" is a class already existing in the
    CakePHP core.


模型定义了之后, 就可以在:doc:`控制器 <controllers>`中使用了。如果模型名称与控制器名称匹配, CakePHP就会自动使该模型可以访问。例如, 一个叫IngredientsController的控制器会自动初始化Ingredient模型, 并把它附加在控制器上, 为``$this->Ingredient``::
With your model defined, it can be accessed from within your
:doc:`Controller <controllers>`. CakePHP will automatically
make the model available for access when its name matches that of
the controller. For example, a controller named
IngredientsController will automatically initialize the Ingredient
model and attach it to the controller at ``$this->Ingredient``::

    class IngredientsController extends AppController {
        public function index() {
            //获得所有原料并把它传给视图:
            //grab all ingredients and pass it to the view:
            $ingredients = $this->Ingredient->find('all');
            $this->set('ingredients', $ingredients);
        }
    }

关联的模型可以从主模型访问到。在下例中, Recipe与Ingredient有关联::
Associated models are available through the main model. In the
following example, Recipe has an association with the Ingredient
model::

    class Recipe extends AppModel {

        public function steakRecipes() {
            $ingredient = $this->Ingredient->findByName('Steak');
            return $this->findAllByMainIngredient($ingredient['Ingredient']['id']);
        }
    }

这里展示了如何使用关联在一起的模型。要明白关联是如何定义的, 请看:doc:`模型的关联一节 <models/associations-linking-models-together>`。
This shows how to use models that are already linked. To understand how associations are
defined take a look at the :doc:`Associations section <models/associations-linking-models-together>`

更多关于模型
More on models
==============

.. toctree::

    models/associations-linking-models-together
    models/retrieving-your-data
    models/saving-your-data
    models/deleting-data
    models/data-validation
    models/callback-methods
    models/behaviors
    models/datasources
    models/model-attributes
    models/additional-methods-and-properties
    models/virtual-fields
    models/transactions


.. meta::
    :title lang=en: Models
    :keywords lang=en: information workflow,csv file,object oriented programming,model class,model classes,model definition,internal model,core model,simple declaration,application model,php class,database table,data model,data access,external web,inheritance,different ways,validity,functionality,queries