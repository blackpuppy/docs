FormHelper 助件
################

.. php:class:: FormHelper(View $view, array $settings = array())

FormHelper 助件在表单的创建中做了大部分繁重的工作。FormHelper 助件意在快速创建表
单，且以能够使验证、重新填充和布局得以简化的方式。FormHelper 助件也是灵活的——它
几乎做任何事情都使用约定，或者你也可以用特定的方法只得到你需要的。

创建表单
==============

为了利用 FormHelper 助件你要使用的第一个方法是``create()``方法。这个特殊的方法输
出一个开始的 form 标签。

.. php:method:: create(string $model = null, array $options = array())

    所有的参数都是可选的。如果``create()``方法调用时没有参数，就会认为构建的表单
    是通过当前的 URL 提交给当前的控制器。缺省的提交表单的方法是 POST。返回的
    form 元素带有一个 DOM ID。这个 ID 是用模型的名字、控制器动作的名字，按照驼峰
    命名方式(CamelCased)生成的。如果在 UsersController 的视图中调用``create()``方
    法，在渲染得到的视图中会看到下面的输出:

    .. code-block:: html

        <form id="UserAddForm" method="post" action="/users/add">

    .. note::

        你也可以给``$model``参数传入``false``。这样就会把表单数据放进数组:
        ``$this->request->data``中(而不是次级数组
        ``$this->request->data['Model']``中)。这对于不代表任何数据库中
        的东西的简短表单，是很方便的。

    其实，``create()``方法允许我们用参数对表单做很多定制。首先，你可以指定模型名
    字。为表单指定模型，就是创建了表单的*上下文(context)*。所有的字段都属于该模型
    (除非另行说明)，所有引用的模型都与之关联。如果你不指定模型，就认为是使用当前
    控制器的缺省模型::

        // 如果你在 /recipes/add 页面
        echo $this->Form->create('Recipe');

    输出:

    .. code-block:: php

        <form id="RecipeAddForm" method="post" action="/recipes/add">

    这会把表单数据以 POST 方式提交给 RecipesController 控制器的``add()``动作。当
    然，你也可以用同样的逻辑创建编辑(edit)表单。FormHelper 助件用
    ``$this->request->data``属性来自动探知是否创建新增(add)或编辑(edit)表单。如果
    ``$this->request->data``包含一个以表单的模型命名的数组元素，而且该数组包含模
    型主键的非空值，FormHelper 助件就会为该记录创建一个编辑表单。例如，如果我们浏
    览 http://site.com/recipes/edit/5 页面，我们会得到下面这些::

        // Controller/RecipesController.php:
        public function edit($id = null) {
            if (empty($this->request->data)) {
                $this->request->data = $this->Recipe->findById($id);
            } else {
                // Save logic goes here
            }
        }

        // View/Recipes/edit.ctp:
        // 因为 $this->request->data['Recipe']['id'] = 5，我们会得到编辑表单
        <?php echo $this->Form->create('Recipe'); ?>

    输出:

    .. code-block:: html

        <form id="RecipeEditForm" method="post" action="/recipes/edit/5">
        <input type="hidden" name="_method" value="PUT" />

    .. note::

        因为这是一个编辑表单，生成了一个隐藏输入字段来覆盖缺省的 HTTP 方法。

    当为插件中的模型创建表单时，你应当总是使用:term:`plugin syntax`来创建表单。这
    会确保表单生成正确::

        echo $this->Form->create('ContactManager.Contact');

    绝大部分对表单的配置是通过``$options``数组进行的。这个特殊的数组可以包含一系
    列各种键-值对，影响表单标签的生成。

    .. versionchanged:: 2.0
        所有表单的缺省网址，现在是当前的网址，包括传入(passed)、命名(named)和查询
        字符串(query string)参数。你可以通过给``$this->Form->create()``方法的第二
        个参数提供``$options['url']``来覆盖这个缺省值。

create() 方法的选项
--------------------

create() 方法有一些选项:

* ``$options['type']`` 这个键用来指明要创建的表单的类型。合法的值包括'post'，
'get'，'file'，'put'和'delete'。

  提供'post'或者'get'会相应地改变表单提交的方法::

      echo $this->Form->create('User', array('type' => 'get'));

  输出:

  .. code-block:: html

     <form id="UserAddForm" method="get" action="/users/add">

  指定'file'会把表单提交方法改为'post'，并且在表单标签中包括一个为
  "multipart/form-data"的 enctype 属性。如果表单中有任何 file 元素，这(个属性)就
  要使用。如果没有正确的 enctype 属性，文件上传就无法工作::

      echo $this->Form->create('User', array('type' => 'file'));

  输出:

  .. code-block:: html

     <form id="UserAddForm" enctype="multipart/form-data" method="post" action="/users/add">

  当使用'put'或者'delete'时，表单功能上等同于'post'表单，但在提交时，HTTP 请求方法
  会被相应地改变为'PUT'或'DELETE'。这让 CakePHP 可以在网络浏览器中模拟正确的
  REST 支持。

* ``$options['action']`` action 键让你可以把表单指向当前控制器中的一个特定动作。
例如，如果你要把表单指向当前控制器的 login()动作，你可以提供下面这样的 $options 
数组::

    echo $this->Form->create('User', array('action' => 'login'));

  输出:

  .. code-block:: html

     <form id="UserLoginForm" method="post" action="/users/login">

* ``$options['url']`` 如果想要的表单动作不在当前控制器中，你可以用 $options 数组
的‘url’键来为表单动作指定一个 URL。提供的 URL 可以是相对于你的 CakePHP 应用程序::

    echo $this->Form->create(null, array('url' => '/recipes/add'));
    // 或者
    echo $this->Form->create(null, array(
        'url' => array('controller' => 'recipes', 'action' => 'add')
    ));

  输出:

  .. code-block:: html

     <form method="post" action="/recipes/add">

  或者也可以指向外部域名::

    echo $this->Form->create(null, array(
        'url' => 'http://www.google.com/search',
        'type' => 'get'
    ));

  输出:

  .. code-block:: html

    <form method="get" action="http://www.google.com/search">

  也请查看:php:meth:`HtmlHelper::url()`，以了解更多不同类型的网址的例子。

* ``$options['default']`` 如果'default'被设为布尔值 false，表单的提交动作就会改成按动提交按键时不会提交表单。如果表单要通过 AJAX 提交，设置'default'为 false 阻止了表单缺省的行为，你就可以抓取数据并通过 AJAX 提交。

* ``$options['inputDefaults']`` 你可以用``inputDefaults``键为``input()``方法设置一组缺省选项，来定制缺省的输入项(input)创建。

    echo $this->Form->create('User', array(
        'inputDefaults' => array(
            'label' => false,
            'div' => false
        )
    ));

  之后所有创建的 input 标签就会继承 inputDefaults 中指定的选项。你可以在对 input()的调用中声明选项来覆盖 defaultOptions::

    echo $this->Form->input('password'); // 没有 div，没有 label
    echo $this->Form->input('username', array('label' => 'Username')); // 有一个 label 元素

结束表单
================

.. php:method:: end($options = null)

    FormHelper 助件有一个``end()``方法，用来完成表单。``end()``经常只输出一个结束表单标签，但使用``end()``方法也可以让 FormHelper 助件插入:php:class:`SecurityComponent`组件要求的隐藏表单元素:

    .. code-block:: php

        <?php echo $this->Form->create(); ?>

        <!-- Form elements go here -->

        <?php echo $this->Form->end(); ?>

    如果提供一个字符串作为``end()``方法的第一个参数，FormHelper 助件就会在和结束表单标签一起，输出一个相应(以输入参数)命名的提交按键。

        <?php echo $this->Form->end('Finish'); ?>

    就会输出:

    .. code-block:: html

        <div class="submit">
            <input type="submit" value="Finish" />
        </div>
        </form>

    你可以传入一个数组给``end()``方法来指定详细设置::

        $options = array(
            'label' => 'Update',
            'div' => array(
                'class' => 'glass-pill',
            )
        );
        echo $this->Form->end($options);

    就会输出:

    .. code-block:: html

        <div class="glass-pill"><input type="submit" value="Update" name="Update"></div>

    更多细节请参看<http://api20.cakephp.org>`_。

    .. note::

        如果你在应用程序中使用:php:class:`SecurityComponent`组件，你应当总是用``end()``方法结束表单。

.. _automagic-form-elements:

创建表单元素
======================

使用 FormHelper 助件，有多种方法可以创建表单输入元素。我们从``input()``方法开始说起。这个方法会自动检查提供给它的模型字段，从而为那个字段创建适当的输入项元素。在内部``input()``方法调用 FormHelper 助件的其它方法。

.. php:method:: input(string $fieldName, array $options = array())

    根据给定的``Model.field``创建下列元素:

    * 包裹的 div 元素。
    * Label 元素
    * (一个或多个) Input 元素
    * 如果适用，带有消息的错误元素

    创建的 input 元素的类型取决于列的数据类型:

    列的类型
        获得的表单输入字段
    string (char, varchar, etc.)
        text
    boolean, tinyint(1)
        checkbox
    text
        textarea
    以 password、passwd 或 psword 命名的 text
        password
    以 email 命名的 text
        email
    以 tel、telephone 或 phone 命名的 text
        tel
    date
        日、月和年的 select 输入项
    datetime, timestamp
        日、月、年、小时、分钟和上下午的 select 输入项
    time
        小时、分钟和上下午的 select 输入项

    ``$options``参数让你定制``input()``方法如何工作，并微调生成的内容。

    如果模型字段的验证规则没有指定``allowEmpty =>
    true``，包裹的 div 元素就会带有``required``的(样式)类名。这种行为的一个局限是，字段所在的模型在当前请求(的处理过程)中必须已经加载，或者直接与提供给:php:meth:`~FormHelper::create()`方法的模型相关联。

    .. versionadded:: 2.3

    .. _html5-required:

    自2.3版本起，HTML5 的``required``属性也会根据验证规则被添加到 input 标签上。你可以对字段在 options 数组中显式地设置``required``键，来覆盖这一点。要对整个表单省略浏览器验证的触发，你可以对使用:php:meth:`FormHelper::submit()`方法生成的 input 按键设置选项``'formnovalidate' => true``，或者在:php:meth:`FormHelper::create()`的选项中设置``'novalidate' => true``。

    例如，假设 User 模型包括 username (varchar)，password (varchar)，approved (datetime) 和 quote (text) 这些字段。你可以用 FormHelper 助件的 input() 方法为所有这些表单字段创建适当的 input 标签::

        echo $this->Form->create();

        echo $this->Form->input('username');   //text
        echo $this->Form->input('password');   //password
        echo $this->Form->input('approved');   //day, month, year, hour, minute, meridian
        echo $this->Form->input('quote');      //textarea

        echo $this->Form->end('Add');


    (下面是)一个详细的例子，说明日期字段的一些选项::

        echo $this->Form->input('birth_dt', array(
            'label' => 'Date of birth',
            'dateFormat' => 'DMY',
            'minYear' => date('Y') - 70,
            'maxYear' => date('Y') - 18,
        ));

    ``input()``方法除了下面这些选项，你可以指定 input 类型的任何选项和任何 html 属性(例如 onfocus)。关于``$options``和``$htmlAttributes``的更多信息，请参看:doc:`/core-libraries/helpers/html`。

    假设 User hasAndBelongsToMany Group。在控制器中，设置一个驼峰命名(camelCase)的复数变量(在这里就是 group -> groups，或者 ExtraFunkyModel -> extraFunkyModels)作为 select 的可选项。在控制器动作中你可以这样写::

        $this->set('groups', $this->User->Group->find('list'));

    在视图中可以用这样简单的代码创建多选项::

        echo $this->Form->input('Group');

    如果你要在使用 belongsTo 或 hasOne 关系时创建 select 字段，你可以在 Users 控制器中添加下面的代码(假设 User belongsTo Group)::

        $this->set('groups', $this->User->Group->find('list'));

    然后，在你的表单视图中添加下面的代码::

        echo $this->Form->input('group_id');

    如果你的模型名称由两个或多个单词组成，例如，"UserGroup"，在使用 set() 传递数据时，你应当把数据命名为复数、驼峰命名(camelCase)的格式，象下面这样::

        $this->set('userGroups', $this->UserGroup->find('list'));
        // 或者
        $this->set('reallyInappropriateModelNames', $this->ReallyInappropriateModelName->find('list'));

    .. note::

        尽量避免使用`FormHelper::input()`方法来创建提交按键。而是使用:php:meth:`FormHelper::submit()`方法。

.. php:method:: inputs(mixed $fields = null, array $blacklist = null)

    为``$fields``生成一组 input 标签。如果 $fields 是 null，就会使用当前模型。

    除了控制器字段输出，``$fields``可以通过``fieldset``及``legend``键来控制 legend 和 fieldset 的渲染。``$this->Form->inputs(array('legend' => 'My legend'));``会输出一个带有定制的 legend 的 input 集合。你也可以通过``$fields``定制单个的 input。::

        echo $this->Form->inputs(array(
            'name' => array('label' => 'custom label')
        ));

    除了对字段的控制，inputs()还允许你使用一些其它的选项。

    - ``fieldset`` 设置为 false 来禁用 fieldset。如果提供的是字符串，就会被用作 fieldset 元素的(样式)类名(classname)。
    - ``legend`` 设置为 false 来对生成的 input 集合禁用 legend。或者提供一个字符串来定制 legend 的文字。

字段命名约定
------------------------

Form 助件相当聪明。只要你用表单助件的方法指定一个字段名称，它就会自动使用当前模型名以下面这样的格式来构建一个输入项(input):

.. code-block:: html

    <input type="text" id="ModelnameFieldname" name="data[Modelname][fieldname]">

在针对一个模型创建的表单中，为该模型生成输入项时，你可以省略模型名称。你可以为关联模型或任意模型创建输入项，只需把 Modelname.fieldname 作为第一个参数传入即可::

    echo $this->Form->input('Modelname.fieldname');

如果你要使用同样的字段名称来创建多个输入字段，从而生成一个数组，可以用 saveAll() 方法一起保存，就用下面的约定::

    echo $this->Form->input('Modelname.0.fieldname');
    echo $this->Form->input('Modelname.1.fieldname');

输出:

.. code-block:: html

    <input type="text" id="Modelname0Fieldname" name="data[Modelname][0][fieldname]">
    <input type="text" id="Modelname1Fieldname" name="data[Modelname][1][fieldname]">


FormHelper 助件对 datetime 输入项的创建，在内部使用几个字段后缀。如果你使用名称带有 ``year``，``month``，``day``，``hour``，``minute``或者``meridian``的字段，并无法得到正确的输入项，你可以设置``name``属性来取代缺省的行为::

    echo $this->Form->input('Model.year', array(
        'type' => 'text',
        'name' => 'data[Model][year]'
    ));


选项
-------

``FormHelper::input()``方法支持很多选项。除了它自身的选项，``input()``方法也接受生成的输入项类型的选项，以及 html 属性(attribute)。以下列出针对``FormHelper::input()``的选项。

* ``$options['type']`` 你可以提供一个类型，来强制指定输入项的类型，取代对模型的检测。除了在:ref:`automagic-form-elements`中介绍的字段类型，你也可以创建'file'、'password'和任何 HTML5支持的类型::

    echo $this->Form->input('field', array('type' => 'file'));
    echo $this->Form->input('email', array('type' => 'email'));

  输出:

  .. code-block:: html

    <div class="input file">
        <label for="UserField">Field</label>
        <input type="file" name="data[User][field]" value="" id="UserField" />
    </div>
    <div class="input email">
        <label for="UserEmail">Email</label>
        <input type="email" name="data[User][email]" value="" id="UserEmail" />
    </div>

* ``$options['div']`` 用这个选项来设置包含输入项的 div 的属性。使用字符串就会设置 div 的(样式)类名。用数组就可以把 div 的属性设为数组的键/值对。或者，你也可以把这个键设置为 false 从而不输出 div。

  设置(样式)类名::

    echo $this->Form->input('User.name', array(
        'div' => 'class_name'
    ));

  输出:

  .. code-block:: html

    <div class="class_name">
        <label for="UserName">Name</label>
        <input name="data[User][name]" type="text" value="" id="UserName" />
    </div>

  设置多个属性::

    echo $this->Form->input('User.name', array(
        'div' => array(
            'id' => 'mainDiv',
            'title' => 'Div Title',
            'style' => 'display:block'
        )
    ));

  输出:

  .. code-block:: html

    <div class="input text" id="mainDiv" title="Div Title" style="display:block">
        <label for="UserName">Name</label>
        <input name="data[User][name]" type="text" value="" id="UserName" />
    </div>

  禁止 div 输出::

    echo $this->Form->input('User.name', array('div' => false)); ?>

  输出:

  .. code-block:: html

    <label for="UserName">Name</label>
    <input name="data[User][name]" type="text" value="" id="UserName" />

* ``$options['label']`` 把这个键设置为你要显示在通常伴随 input 输入项的 label 标签内的字符串::

    echo $this->Form->input('User.name', array(
        'label' => 'The User Alias'
    ));

  输出:

  .. code-block:: html

    <div class="input">
        <label for="UserName">The User Alias</label>
        <input name="data[User][name]" type="text" value="" id="UserName" />
    </div>

  或者，设置该键为 false，从而禁止 label 标签的输出::

    echo $this->Form->input('User.name', array('label' => false));

  输出:

  .. code-block:: html

    <div class="input">
        <input name="data[User][name]" type="text" value="" id="UserName" />
    </div>

  把它设置为数组来为``label``元素提供额外的选项。如果你这么做，你可以在数组中用``text``键来定制 label 标签的文字::

    echo $this->Form->input('User.name', array(
        'label' => array(
            'class' => 'thingy',
            'text' => 'The User Alias'
        )
    ));

  输出:

  .. code-block:: html

    <div class="input">
        <label for="UserName" class="thingy">The User Alias</label>
        <input name="data[User][name]" type="text" value="" id="UserName" />
    </div>


* ``$options['error']`` 使用这个键让你可以取代缺省的模型错误信息，以及用于，例如，设置 i18n 信息。它有一些子选项，用来控制包裹的元素，包裹元素的(样式)类名，以及错误信息中的 HTML 是否要转义。

  要禁用错误信息输出和字段的(样式)类，设置 error 键为 false::

    $this->Form->input('Model.field', array('error' => false));

  要只禁用错误信息，但保持字段的(样式)类，设置 errorMessage 键为 false::

    $this->Form->input('Model.field', array('errorMessage' => false));

  要改变包裹元素的类型和它的(样式)类(class)，使用下面的格式::

    $this->Form->input('Model.field', array(
        'error' => array('attributes' => array('wrap' => 'span', 'class' => 'bzzz'))
    ));

  为防止在错误信息输出中的 HTML 被自动转义，设置 escape 子选项为 false::

    $this->Form->input('Model.field', array(
        'error' => array(
            'attributes' => array('escape' => false)
        )
    ));

  要取代模型的错误信息，用键与验证规则名称匹配的数组::

    $this->Form->input('Model.field', array(
        'error' => array('tooShort' => __('This is not long enough'))
    ));

  如上所示，你可以为模型中的每个验证规则设置错误信息。而且，你可以为表单提供国际化(i18n)的消息。

  .. versionadded:: 2.3
    在2.3版本中增加了对``errorMessage``的支持。

* ``$options['before']``, ``$options['between']``, ``$options['separator']``,
  和 ``$options['after']``

  如果你要在 input() 方法的输出中插入一些标记代码，就可以使用这些键::

      echo $this->Form->input('field', array(
          'before' => '--before--',
          'after' => '--after--',
          'between' => '--between---'
      ));

  输出:

  .. code-block:: html

      <div class="input">
      --before--
      <label for="UserField">Field</label>
      --between---
      <input name="data[User][field]" type="text" value="" id="UserField" />
      --after--
      </div>

  对 radio 输入项，'separator'属性可用来插入标记，来分隔每对 input/label::

      echo $this->Form->input('field', array(
          'before' => '--before--',
          'after' => '--after--',
          'between' => '--between---',
          'separator' => '--separator--',
          'options' => array('1', '2')
      ));

  输出:

  .. code-block:: html

      <div class="input">
      --before--
      <input name="data[User][field]" type="radio" value="1" id="UserField1" />
      <label for="UserField1">1</label>
      --separator--
      <input name="data[User][field]" type="radio" value="2" id="UserField2" />
      <label for="UserField2">2</label>
      --between---
      --after--
      </div>

  对于``date``和``datetime``类型的元素，'separator'可用来改变 select 元素之间的字符串。缺省为 '-'。

* ``$options['format']`` FormHelper 助件生成的 html 的顺序也是可以控制的。'format'选项支持字符串数组，指明上述元素遵从的模板。支持的数组的键为``array('before', 'input', 'between', 'label', 'after','error')``。


* ``$options['inputDefaults']`` 如果你发现在对 input() 的多个调用在重复相同的选项，你可以使用`inputDefaults``来保持你的代码 dry (译注: Don't Repeat Yourself,指不要重复代码。)

    echo $this->Form->create('User', array(
        'inputDefaults' => array(
            'label' => false,
            'div' => false
        )
    ));

  以下创建的所有输入项就都会继承 inputDefaults 之中声明的选项。你可以在 input() 调用中声明选项来覆盖缺省的选项::

    // 没有 div，没有 label
    echo $this->Form->input('password');

    // 有一个 label 元素
    echo $this->Form->input('username', array('label' => 'Username'));

  如果你以后需要改变缺省(选项)，你可以使用:php:meth:`FormHelper::inputDefaults()`方法。

生成特定类型的输入项(input)
===================================

除了通用的``input()``方法，``FormHelper``助件有特定的方法来生成一系列不同类型的输入项(input)。这些方法可以用来只是生成输入项部件本身，也可以和其它象:php:meth:`~FormHelper::label()`和:php:meth:`~FormHelper::error()`这样的方法来生成完全定制的表单布局。

.. _general-input-options:

通用选项
--------------

许多不同的输入项(input)元素方法支持一组通用的选项。``input()``方法也支持所有这些选项 。为避免重复，所有输入项(input)方法共用的通用选项如下:

* ``$options['class']`` 你可以为一个输入项设置(样式)类名(classname)::

    echo $this->Form->input('title', array('class' => 'custom-class'));

* ``$options['id']`` 设置此键来强制指定输入项(inout)的 DOM id 的值。

* ``$options['default']`` 用来设置输入项(input)的缺省值。如果传给表单的数据不包含该字段的值(或者根本没有数据传入)，该值就会被使用。

  使用的例子::

    echo $this->Form->input('ingredient', array('default' => 'Sugar'));

  select 字段的例子(尺寸"Medium"会作为缺省值被选中)::

    $sizes = array('s' => 'Small', 'm' => 'Medium', 'l' => 'Large');
    echo $this->Form->input('size', array('options' => $sizes, 'default' => 'm'));

  .. note::

    你无法使用``default``来勾选 checkbox —— 你可以在控制器中设置``$this->request->data``的值，或者把输入项(input)的选项``checked``设为 true。

    Date 和 datetime 字段的缺省值可以用'selected'键来设置。

    当心使用 false 来设置缺省值。false 值用来禁用/排除输入项(input)的选项，所以``'default' => false``完全不会设置任何值。而是(应当)使用``'default' => 0``。

除了上述的选项之外，你可以混入(mixin)任何你想使用的 html 属性。任何普通的选项名称，会被当作 HTML 属性，并应用于生成的 HTML 输入项(input)元素。


select，checkbox 和 radio 输入项(input)的选项
----------------------------------------------

* ``$options['selected']`` 与选择类型的输入项(input)(即 select，date，time，datetime 这些类型)结合使用。设置‘selected’为输入项(input)渲染时你要缺省情况下选中的项目的值::

    echo $this->Form->input('close_time', array(
        'type' => 'time',
        'selected' => '13:30:00'
    ));

  .. note::

    date 和 datetime 输入项(input)的 selected 键也可以是 UNIX 时间戳(timestamp)。

* ``$options['empty']`` 如果设置为 true，就会强制输入项(input)保持为空。

  当传递给一个 select 列表时，这会在你的下拉列表中创建一个带有空值的空选项(option)。如果你要空值有文字显示，而不是只是空的选项，给 empty 键传入一个字符串::

      echo $this->Form->input('field', array(
          'options' => array(1, 2, 3, 4, 5),
          'empty' => '(choose one)'
      ));

  输出:

  .. code-block:: html

      <div class="input">
          <label for="UserField">Field</label>
          <select name="data[User][field]" id="UserField">
              <option value="">(choose one)</option>
              <option value="0">1</option>
              <option value="1">2</option>
              <option value="2">3</option>
              <option value="3">4</option>
              <option value="4">5</option>
          </select>
      </div>

  .. note::

      如果你要设置一个密码(password)字段为空，转而使用'value' => ''。

  选项也可以以键值对的方式提供。

* ``$options['hiddenField']`` 对某些输入项类型(checkboxe、radio)会创建一个隐藏输入项(hidden input)，从而使 $this->request->data 中有一个键，即使没有值:

  .. code-block:: html

    <input type="hidden" name="data[Post][Published]" id="PostPublished_" value="0" />
    <input type="checkbox" name="data[Post][Published]" value="1" id="PostPublished" />

  这可以通过设置``$options['hiddenField'] = false``来禁用::

    echo $this->Form->checkbox('published', array('hiddenField' => false));

  这会输出:

  .. code-block:: html

    <input type="checkbox" name="data[Post][Published]" value="1" id="PostPublished" />

  如果你要在一个表单上中创建组织在一起的多组输入项，你就应该在除了第一个的所有输入项(input)上使用这个参数。如果页面中的隐藏输入项分布在多个地方，只有最后一组输入项(input)的值会被保存。

  在(下面)这个例子中，只有 tertiary colors 会被传递，primary colors 会被覆盖:

  .. code-block:: html

    <h2>Primary Colors</h2>
    <input type="hidden" name="data[Color][Color]" id="Colors_" value="0" />
    <input type="checkbox" name="data[Color][Color][]" value="5" id="ColorsRed" />
    <label for="ColorsRed">Red</label>
    <input type="checkbox" name="data[Color][Color][]" value="5" id="ColorsBlue" />
    <label for="ColorsBlue">Blue</label>
    <input type="checkbox" name="data[Color][Color][]" value="5" id="ColorsYellow" />
    <label for="ColorsYellow">Yellow</label>

    <h2>Tertiary Colors</h2>
``    <input type="hidden" name="data[Color][Color]" id="Colors_" value="0" />
    <input type="checkbox" name="data[Color][Color][]" value="5" id="ColorsGreen" />
    <label for="ColorsGreen">Green</label>
    <input type="checkbox" name="data[Color][Color][]" value="5" id="ColorsPurple" />
    <label for="ColorsPurple">Purple</label>
    <input type="checkbox" name="data[Addon][Addon][]" value="5" id="ColorsOrange" />
    <label for="ColorsOrange">Orange</label>

  对第二组输入项(input)禁用``'hiddenField'``，就可以阻止这种行为。

  你可以一个不同于0的隐藏字段值，比如'N'::

      echo $this->Form->checkbox('published', array(
          'value' => 'Y',
          'hiddenField' => 'N',
      ));

Datetime 选项
----------------

* ``$options['timeFormat']`` 用于指定一组与时间相关的选择输入项(select input)的格式。合法的格式包括 ``12``，``24`` 和 ``null``。

* ``$options['dateFormat']`` 用于指定一组与日期相关的选择输入项(select input)的格式。合法的格式包括'D'，'M'和'Y'的任意组合或者``null``。输入项会以 dateFormat 选项定义的顺序来放置。

* ``$options['minYear'], $options['maxYear']`` 与 date/datetime 输入项一起使用。定义在年的选择字段中显示的下限和/或上限的值。

* ``$options['orderYear']`` 与 date/datetime 输入项一起使用。定义年的值设置的顺序。有效的值包括 'asc'，'desc'。缺省值为 'desc'。

* ``$options['interval']`` 这个选项指定分钟选择框中每个选项之间间隔的分钟数::

    echo $this->Form->input('Model.time', array(
        'type' => 'time',
        'interval' => 15
    ));

  会在分钟选择框中创建4个选项，每15分钟一个。

表单元素相关的方法
=============================

.. php:method:: label(string $fieldName, string $text, array $options)

    创建一个 label 元素。``$fieldName``用于生成 DOM id。如果``$text``未定义，``$fieldName``会被用来转换(inflect)生成 label 元素的文字::

        echo $this->Form->label('User.name');
        echo $this->Form->label('User.name', 'Your username');

    输出:

    .. code-block:: html

        <label for="UserName">Name</label>
        <label for="UserName">Your username</label>

    ``$options``可以是一个 html 属性的数组，或者是一个会被用作样式类名的字符串::

        echo $this->Form->label('User.name', null, array('id' => 'user-label'));
        echo $this->Form->label('User.name', 'Your username', 'highlight');

    输出:

    .. code-block:: html

        <label for="UserName" id="user-label">Name</label>
        <label for="UserName" class="highlight">Your username</label>

.. php:method:: text(string $name, array $options)

    FormHelper 助件的其它方法是用来创建特定的表单元素的。这些方法中的许多也用到特殊的 $options 参数。不过，在这种情况下，$options 主要是用来指定 HTML 标签的属性(比如表单中的元素的值或者 DOM id)::

        echo $this->Form->text('username', array('class' => 'users'));

    将会输出:

    .. code-block:: html

        <input name="data[User][username]" type="text" class="users" id="UserUsername" />

.. php:method:: password(string $fieldName, array $options)

    创建一个密码字段。::

        echo $this->Form->password('password');

    将会输出:

    .. code-block:: html

        <input name="data[User][password]" value="" id="UserPassword" type="password" />

.. php:method:: hidden(string $fieldName, array $options)

    创建一个隐藏表单输入项。例如::

        echo $this->Form->hidden('id');

    将会输出:

    .. code-block:: html

        <input name="data[User][id]" value="10" id="UserId" type="hidden" />

    .. versionchanged:: 2.0
        隐藏字段不再去除(样式的)类属性。这意味着如果隐藏字段有验证错误，错误字段的(样式)类名就会被应用。

.. php:method:: textarea(string $fieldName, array $options)

    创建一个 textarea 输入字段。::

        echo $this->Form->textarea('notes');

    将会输出:

    .. code-block:: html

        <textarea name="data[User][notes]" id="UserNotes"></textarea>

    .. note::

        ``textarea``输入项类型允许``$options``属性``'escape'``，这决定 textarea 的内容是否要被转义。缺省值为``true``。

    ::

        echo $this->Form->textarea('notes', array('escape' => false);
        // 或者......
        echo $this->Form->input('notes', array('type' => 'textarea', 'escape' => false);


    **选项**

    除了 :ref:`general-input-options`，textarea()支持一些特定的选项:

    * ``$options['rows'], $options['cols']`` 这两个键指定行和列的数目::

        echo $this->Form->textarea('textarea', array('rows' => '5', 'cols' => '5'));

      输出:

    .. code-block:: html

        <textarea name="data[Form][textarea]" cols="5" rows="5" id="FormTextarea">
        </textarea>

.. php:method:: checkbox(string $fieldName, array $options)

    创建一个 checkbox 表单元素。该方法也会生成一个关联的隐藏表单输入项，强制提交指定字段的数据。::

        echo $this->Form->checkbox('done');

    将会输出:

    .. code-block:: html

        <input type="hidden" name="data[User][done]" value="0" id="UserDone_" />
        <input type="checkbox" name="data[User][done]" value="1" id="UserDone" />

    可以用 $options 数组来给出 checkbox 的值::

        echo $this->Form->checkbox('done', array('value' => 555));

    将会输出:

    .. code-block:: html

        <input type="hidden" name="data[User][done]" value="0" id="UserDone_" />
        <input type="checkbox" name="data[User][done]" value="555" id="UserDone" />

    如果你不想让 Form 助件创建隐藏输入项::

        echo $this->Form->checkbox('done', array('hiddenField' => false));

    将会输出:

    .. code-block:: html

        <input type="checkbox" name="data[User][done]" value="1" id="UserDone" />


.. php:method:: radio(string $fieldName, array $options, array $attributes)

    创建一组 radio 按钮输入项。

    **选项**

    * ``$attributes['value']`` 设置哪个值作为缺省值被选中。

    * ``$attributes['separator']`` 给出 radio 按钮之间的 HTML(例如 <br /)。

    * ``$attributes['between']`` 给出在 legend 和第一个元素之间插入的内容。

    * ``$attributes['disabled']`` 设置这个属性为``true``或``'disabled'``会禁用所有生成的 radio 按钮。

    * ``$attributes['legend']`` 缺省情况下 Radio 元素会包裹在 label 和 fieldset 之中。设置``$attributes['legend']``为 false 来去掉这些。::

        $options = array('M' => 'Male', 'F' => 'Female');
        $attributes = array('legend' => false);
        echo $this->Form->radio('gender', $options, $attributes);

      将会输出:

      .. code-block:: html

        <input name="data[User][gender]" id="UserGender_" value="" type="hidden" />
        <input name="data[User][gender]" id="UserGenderM" value="M" type="radio" />
        <label for="UserGenderM">Male</label>
        <input name="data[User][gender]" id="UserGenderF" value="F" type="radio" />
        <label for="UserGenderF">Female</label>

    如果出于某些原因你不想要隐藏输入项，设置``$attributes['value']``为选中的值或布尔值 false 就可以了。

    .. versionchanged:: 2.1
        ``$attributes['disabled']``选项是在2.1版本中增加的。


.. php:method:: select(string $fieldName, array $options, array $attributes)

    创建一个 select 元素，以``$options``中的项目填充，缺省选中以``$attributes['value']``指定的选项。设置``$attributes``变量中的'empty'键为 false，就可以去掉缺省的空选项::

        $options = array('M' => 'Male', 'F' => 'Female');
        echo $this->Form->select('gender', $options);

    将会输出:

    .. code-block:: html


        <select name="data[User][gender]" id="UserGender">
        <option value=""></option>
        <option value="M">Male</option>
        <option value="F">Female</option>
        </select>

    ``select``输入类型可以有一个特殊的``$option``属性，叫做``'escape'``，它接受布尔值，决定是否对 select 选项的内容进行 HTML 实体编码(HTML entity encode)。缺省为 true::

        $options = array('M' => 'Male', 'F' => 'Female');
        echo $this->Form->select('gender', $options, array('escape' => false));

    * ``$attributes['options']`` 这个键允许你手动指定 select 输入项或 radio 组的选项。除非'type'设置为'radio'，否则 FormHelper 助件将会认为希望的输出为 select 输入项::

        echo $this->Form->select('field', array(1,2,3,4,5));

      输出:

      .. code-block:: html

        <select name="data[User][field]" id="UserField">
            <option value="0">1</option>
            <option value="1">2</option>
            <option value="2">3</option>
            <option value="3">4</option>
            <option value="4">5</option>
        </select>

      选项也可以用键-值对的方式提供::

        echo $this->Form->select('field', array(
            'Value 1' => 'Label 1',
            'Value 2' => 'Label 2',
            'Value 3' => 'Label 3'
        ));

      输出:

      .. code-block:: html

        <select name="data[User][field]" id="UserField">
            <option value="Value 1">Label 1</option>
            <option value="Value 2">Label 2</option>
            <option value="Value 3">Label 3</option>
        </select>

      如果你想要生成带有 optgroups 的 select，只需传入层级结构的数据。这也适用于多个 checkbox 和 radio 按钮，只是不用  optgroups，而用 fieldsets 来包裹::

        $options = array(
           'Group 1' => array(
              'Value 1' => 'Label 1',
              'Value 2' => 'Label 2'
           ),
           'Group 2' => array(
              'Value 3' => 'Label 3'
           )
        );
        echo $this->Form->select('field', $options);

      输出:

      .. code-block:: html

        <select name="data[User][field]" id="UserField">
            <optgroup label="Group 1">
                <option value="Value 1">Label 1</option>
                <option value="Value 2">Label 2</option>
            </optgroup>
            <optgroup label="Group 2">
                <option value="Value 3">Label 3</option>
            </optgroup>
        </select>

    * ``$attributes['multiple']`` 如果对一个输出 select 的输入项设置'multiple'为 true，该 select 就会允许多选::

        echo $this->Form->select('Model.field', $options, array('multiple' => true));

      另外也可以设置'multiple'为'checkbox'，来输出一组相互关联的 check box::

        $options = array(
            'Value 1' => 'Label 1',
            'Value 2' => 'Label 2'
        );
        echo $this->Form->select('Model.field', $options, array(
            'multiple' => 'checkbox'
        ));

      输出:

      .. code-block:: html

        <div class="input select">
           <label for="ModelField">Field</label>
           <input name="data[Model][field]" value="" id="ModelField" type="hidden">
           <div class="checkbox">
              <input name="data[Model][field][]" value="Value 1" id="ModelField1" type="checkbox">
              <label for="ModelField1">Label 1</label>
           </div>
           <div class="checkbox">
              <input name="data[Model][field][]" value="Value 2" id="ModelField2" type="checkbox">
              <label for="ModelField2">Label 2</label>
           </div>
        </div>

    * ``$attributes['disabled']`` 当创建 checkbox 时，可以设置这个选项为``true``来禁用全部或者一些 checkbox。要禁用全部 checkbox，设置 disabled 为``true``::

        $options = array(
            'Value 1' => 'Label 1',
            'Value 2' => 'Label 2'
        );
        echo $this->Form->select('Model.field', $options, array(
            'multiple' => 'checkbox',
            'disabled' => array('Value 1')
        ));

      输出:

      .. code-block:: html

        <div class="input select">
           <label for="ModelField">Field</label>
           <input name="data[Model][field]" value="" id="ModelField" type="hidden">
           <div class="checkbox">
              <input name="data[Model][field][]" disabled="disabled" value="Value 1" id="ModelField1" type="checkbox">
              <label for="ModelField1">Label 1</label>
           </div>
           <div class="checkbox">
              <input name="data[Model][field][]" value="Value 2" id="ModelField2" type="checkbox">
              <label for="ModelField2">Label 2</label>
           </div>
        </div>

    .. versionchanged:: 2.3
        ``$attributes['disabled']``对数组的支持是在2.3版本中增加的。

.. php:method:: file(string $fieldName, array $options)

    要在表单中增加一个文件上传字段，你必须首先确保表单的 enctype 设置"multipart/form-data"，所以以下面这样的 create 函数开始::

        echo $this->Form->create('Document', array('enctype' => 'multipart/form-data'));
        // 或者
        echo $this->Form->create('Document', array('type' => 'file'));

    然后添加下面两行之一到表单视图文件中::

        echo $this->Form->input('Document.submittedfile', array(
            'between' => '<br />',
            'type' => 'file'
        ));

        // 或者

        echo $this->Form->file('Document.submittedfile');

    鉴于 HTML 本身的限制，无法为'file'类型的输入项字段设置缺省值。每次表单显示时，其值为空。

    在提交时，文件字段提供一个扩展的数据数组给接受表单数据的脚本(script)。

    对于上面的例子，如果 CakePHP 安装在 Windows 服务器上，在提交的数据数组中的值将有如下结构。在 Unix 环境下'tmp\_name'会有不同的路径::

        $this->request->data['Document']['submittedfile'] = array(
            'name' => 'conference_schedule.pdf',
            'type' => 'application/pdf',
            'tmp_name' => 'C:/WINDOWS/TEMP/php1EE.tmp',
            'error' => 0,
            'size' => 41737,
        );

    这个数组是 PHP 本身生成的，所以要了解 PHP 如何处理文件字段传递的数据，请`阅读 PHP 手册关于文件上载的章节 <http://php.net/features.file-upload>`_。

验证(文件)上载
------------------

下面是一个验证方法的例子，定义在模型中来验证文件上载是否成功::

    public function isUploadedFile($params) {
        $val = array_shift($params);
        if ((isset($val['error']) && $val['error'] == 0) ||
            (!empty( $val['tmp_name']) && $val['tmp_name'] != 'none')
        ) {
            return is_uploaded_file($val['tmp_name']);
        }
        return false;
    }

创建文件输入项::

    echo $this->Form->create('User', array('type' => 'file'));
    echo $this->Form->file('avatar');

将会输出:

.. code-block:: html

    <form enctype="multipart/form-data" method="post" action="/users/add">
    <input name="data[User][avatar]" value="" id="UserAvatar" type="file">

.. note::

    当使用``$this->Form->file()``方法时，记得通过在``$this->Form->create()``中设置类型选项为'file'来设置表单的编码类型。


创建按键和提交元素
====================================

.. php:method:: submit(string $caption, array $options)

    创建带有标题``$caption``的提交按键。如果给出的``$caption``是一个图像的 URL(含有‘.’字符)，提交按键就会渲染为图像。

    缺省情况下它会被包括在``div``标签之间；你可以提供声明``$options['div'] = false``来避免这样::

        echo $this->Form->submit();

    将会输出:

    .. code-block:: html

        <div class="submit"><input value="Submit" type="submit"></div>

    你可以为 caption 参数传入一个图像的相对或绝对网址，而不是标题文字。::

        echo $this->Form->submit('ok.png');

    将会输出:

    .. code-block:: html

        <div class="submit"><input type="image" src="/img/ok.png"></div>

.. php:method:: button(string $title, array $options = array())

    创建 HTML 按键，带有指定的标题和缺省的类型"button"。设置``$options['type']``可以输出三种可能的按键类型中的一种:

    #. submit: 等同于``$this->Form->submit``方法——(缺省值)。
    #. reset: 创建一个表单重置按键。
    #. button: 创建一个标准的按键。

    ::

        echo $this->Form->button('A Button');
        echo $this->Form->button('Another Button', array('type' => 'button'));
        echo $this->Form->button('Reset the Form', array('type' => 'reset'));
        echo $this->Form->button('Submit Form', array('type' => 'submit'));

    将会输出:

    .. code-block:: html

        <button type="submit">A Button</button>
        <button type="button">Another Button</button>
        <button type="reset">Reset the Form</button>
        <button type="submit">Submit Form</button>


    ``button``输入项类型支持``escape``选项，该选项接受布尔值，决定是否 HTML 实体编码 (HTML entity encode)按键的 $title。
    缺省值为 false::

        echo $this->Form->button('Submit Form', array('type' => 'submit', 'escape' => true));

.. php:method:: postButton(string $title, mixed $url, array $options = array ())

    创建一个``<button>``标签及包裹的通过 POST 提交的``<form>``标签。

    这个方法创建``<form>``元素。所以不要在开放的表单中使用这个方法，而是应当使用:php:meth:`FormHelper::submit()`或者:php:meth:`FormHelper::button()`。

.. php:method:: postLink(string $title, mixed $url = null, array $options = array (), string $confirmMessage = false)

    创建一个 HTML 链接，但使用 POST 来访问该链接。要求浏览器启用 javascript。

    该方法创建一个``<form>``元素，故此不要在一个表单中使用该方法，而是应当用:php:meth:`FormHelper::submit()`方法来添加提交按键。


    .. versionchanged:: 2.3
        增加了``method``选项。

创建日期和时间输入项
=============================

.. php:method:: dateTime($fieldName, $dateFormat = 'DMY', $timeFormat = '12', $attributes = array())

    为日期和时间创建一组 select 输入项。$dateformat 的合法值为‘DMY’，‘MDY’，‘YMD’或者‘NONE’。$timeFormat的合法值为‘12’，‘24’和 null。

    你可以通过在 attributes 参数中设置 "array('empty' => false)"来不显示空值。它也会用当前日期和时间预选(相应的)字段。

.. php:method:: year(string $fieldName, int $minYear, int $maxYear, array $attributes)

    创建一个 select 元素，填充以从``$minYear``到``$maxYear``的年份。HTML 属性可以在 $attributes 参数中提供。如果``$attributes['empty']``为 false，select 元素就不会包括空选项::

        echo $this->Form->year('purchased', 2000, date('Y'));

    将会输出:

    .. code-block:: html

        <select name="data[User][purchased][year]" id="UserPurchasedYear">
        <option value=""></option>
        <option value="2009">2009</option>
        <option value="2008">2008</option>
        <option value="2007">2007</option>
        <option value="2006">2006</option>
        <option value="2005">2005</option>
        <option value="2004">2004</option>
        <option value="2003">2003</option>
        <option value="2002">2002</option>
        <option value="2001">2001</option>
        <option value="2000">2000</option>
        </select>

.. php:method:: month(string $fieldName, array $attributes)

    创建一个 select 元素，填充以月份的名称::

        echo $this->Form->month('mob');

    将会输出:

    .. code-block:: html

        <select name="data[User][mob][month]" id="UserMobMonth">
        <option value=""></option>
        <option value="01">January</option>
        <option value="02">February</option>
        <option value="03">March</option>
        <option value="04">April</option>
        <option value="05">May</option>
        <option value="06">June</option>
        <option value="07">July</option>
        <option value="08">August</option>
        <option value="09">September</option>
        <option value="10">October</option>
        <option value="11">November</option>
        <option value="12">December</option>
        </select>

    你可以通过设置'monthNames'属性来传入自己要使用的月份数组，或者传入 false 来让月份显示为数字。(注意: 缺省的月份是国际化的，而且可以用本地化来翻译。)::

        echo $this->Form->month('mob', null, array('monthNames' => false));

.. php:method:: day(string $fieldName, array $attributes)

    创建一个 select 元素，填充以月份的(数字)日子。

    要添加一个带有你选择的提示文字的空选项(例如，第一个选项为'Day')，你可以在最后一个参数中提供该(提示)文字，如下所示::

        echo $this->Form->day('created');

    将会输出:

    .. code-block:: html

        <select name="data[User][created][day]" id="UserCreatedDay">
        <option value=""></option>
        <option value="01">1</option>
        <option value="02">2</option>
        <option value="03">3</option>
        ...
        <option value="31">31</option>
        </select>

.. php:method:: hour(string $fieldName, boolean $format24Hours, array $attributes)

    创建一个 select 元素，填充以一天中的各个小时。

.. php:method:: minute(string $fieldName, array $attributes)

    创建一个 select 元素，填充以一个小时中的各个分钟。

.. php:method:: meridian(string $fieldName, array $attributes)

    创建一个 select 元素，填充以‘am’和‘pm’。


显示及检查错误
==============================

.. php:method:: error(string $fieldName, mixed $text, array $options)

    当验证错误产生时，显示由 $text 指定的针对给定字段的验证错误信息。

    选项:

    -  'escape' bool 是否 html 转义错误内容。
    -  'wrap' mixed 是否将错误信息包裹在 div 中。如果是字符串，就会作为 HTML 标签使用。
    -  'class' string 错误信息的(样式)类名。

.. php:method:: isFieldError(string $fieldName)

    如果提供的 $fieldName 字段有有效的验证错误，返回 true。::

        if ($this->Form->isFieldError('gender')) {
            echo $this->Form->error('gender');
        }

    .. note::

        当使用:php:meth:`FormHelper::input()`方法时，缺省情况下错误会被渲染。

.. php:method:: tagIsInvalid()

    如果由当前项描述的给定表单字段没有错误，就返回 false，否则就返回验证错误。


对所有字段设置缺省值
===============================

.. versionadded:: 2.2

你可以使用:php:meth:`FormHelper::inputDefaults()`为``input()``声明一组缺省值。改变缺省选项允许你把重复的选项合并为一个方法调用::

    $this->Form->inputDefaults(array(
            'label' => false,
            'div' => false,
            'class' => 'fancy'
        )
    );

从此所有创建的输入项会继承在 inputDefaults 选项中声明的选项。你可以在 input() 调用中声明选项来覆盖缺省的选项::

    echo $this->Form->input('password'); // 没有 div，没有 label，带有'fancy'样式类
    echo $this->Form->input('username', array('label' => 'Username')); // 带有 label 及同样的缺省选项

与 SecurityComponent 组件一起使用
==================================

:php:meth:`SecurityComponent`组件提供了一些特性，使你的表单更加安全可靠。只需在控制器中引用``SecurityComponent``，你就自动获得(针对) CSRF 和表单篡改的特性。

正如之前所说，当使用 SecurityComponent 组件时，你应当总是使用 :php:meth:`FormHelper::end()` 关闭你的表单。这会保证生成特殊的``_Token``输入项。

.. php:method:: unlockField($name)

    对一个字段解锁，使得该字段免于``SecurityComponent``的字段哈希(编码)。这也允许这样的字段被 Javascript 操纵。``$name``参数应当是输入项的名称::

        $this->Form->unlockField('User.id');

.. php:method:: secure(array $fields = array())

    基于表单中使用的字段，生成带有安全哈希的隐藏字段。

.. _form-improvements-1-3:

2.0 updates
===========

**$selected 参数去掉了**

``$selected``参数从 FormHelper 助件的几个方法中去掉了。所有的方法现在支持``$attributes['value']``键，应当用它来代替``$selected``。这个改变简化了 FormHelper 助件的方法，减少了参数的数量，并减轻了``$selected``导致的重复。受此影响的方法有:

    * FormHelper::select()
    * FormHelper::dateTime()
    * FormHelper::year()
    * FormHelper::month()
    * FormHelper::day()
    * FormHelper::hour()
    * FormHelper::minute()
    * FormHelper::meridian()

**表单的缺省地址就是当前的动作**

所有表单的缺省地址，现在就是当前地址。包括传入(passed)、命名(named)和查询字符串(querystring)参数。你可以通过在``$this->Form->create()``方法的第二个参数中提供``$options['url']``来覆盖缺省值。


**FormHelper::hidden()**

隐藏字段不再去掉 class 属性。这意味着如果隐藏字段有验证错误，错误字段的(样式)类名就会被使用。


.. meta::
    :title lang=zh_CN: FormHelper
    :description lang=zh_CN: The FormHelper focuses on creating forms quickly, in a way that will streamline validation, re-population and layout.
    :keywords lang=zh_CN: html helper,cakephp html,form create,form input,form select,form file field,form label,form text,form password,form checkbox,form radio,form submit,form date time,form error,validate upload,unlock field,form security