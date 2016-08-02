FormHelper
################

.. php:class:: FormHelper(View $view, array $settings = array())

FormHelper 助件在创建表单的过程中承担了大部分繁重的工作。FormHelper 助件注重快速创建表单，简化
验证、重新填充和布局。FormHelper 助件也是灵活的——它几乎做任何
事情都使用约定，当然你也可以用特定的方法获得你需要的（不同）效果。

The FormHelper does most of the heavy lifting in form creation.
The FormHelper focuses on creating forms quickly, in a way that
will streamline validation, re-population and layout. The
FormHelper is also flexible - it will do almost everything for
you using conventions, or you can use specific methods to get
only what you need.

创建表单
==============

Creating Forms
==============

为了利用 FormHelper 助件，首先要使用的一个方法是 ``create()`` 方法。这个特别的方法
输出一个开始的 form 标签。

The first method you'll need to use in order to take advantage of
the FormHelper is ``create()``. This special method outputs an
opening form tag.

.. php:method:: create(string $model = null, array $options = array())

    所有的参数都是可选的。如果调用 ``create()`` 方法时没有提供参数，就会认为构建
    的表单是通过当前的网址（*URL*）提交给当前的控制器。提交表单的默认方法是
    POST。返回的 form 元素带有一个 DOM ID。这个 ID 是用模型的名称和控制器动作的名称，
    按照驼峰命名方式（*CamelCased*）生成的。例如在 UsersController 的视图中调用
    ``create()`` 方法，在渲染得到的视图中会看到下面的输出:

    All parameters are optional. If ``create()`` is called with no
    parameters supplied, it assumes you are building a form that
    submits to the current controller, via the current URL.
    The default method for form submission is POST.
    The form element is also returned with a DOM ID. The ID is
    generated using the name of the model, and the name of the
    controller action, CamelCased. If I were to call ``create()``
    inside a UsersController view, I'd see something like the following
    output in the rendered view:

    .. code-block:: html

        <form id="UserAddForm" method="post" action="/users/add">

    .. note::

        你也可以给 ``$model`` 参数传入 ``false``。这样就会把表单数据放进数组：
        ``$this->request->data`` 中（而不是次级数组
        ``$this->request->data['Model']`` 中）。这对于不代表任何数据库中的数据的
        简易表单，是很方便的。

        You can also pass ``false`` for ``$model``. This will place your
        form data into the array: ``$this->request->data`` (instead of in the
        sub-array: ``$this->request->data['Model']``). This can be handy for short
        forms that may not represent anything in your database.

    其实，``create()`` 方法允许我们用参数对表单做更多定制。首先，你可以指定模型
    名称。为表单指定模型，就是创建了表单的 *上下文（context）*。所有的字段都认为是属于
    该模型（除非另外说明），所有引用的模型都与之关联。如果你不指定模型，就认为是
    使用当前控制器的默认模型::

    The ``create()`` method allows us to customize much more using the
    parameters, however. First, you can specify a model name. By
    specifying a model for a form, you are creating that form's
    *context*. All fields are assumed to belong to this model (unless
    otherwise specified), and all models referenced are assumed to be
    associated with it. If you do not specify a model, then it assumes
    you are using the default model for the current controller::

        // 如果你在 /recipes/add 页面
        // If you are on /recipes/add
        echo $this->Form->create('Recipe');

    输出:

    Output:

    .. code-block:: php

        <form id="RecipeAddForm" method="post" action="/recipes/add">

    这会把表单数据以 POST 方式提交给 RecipesController 控制器的 ``add()`` 动作。当然，
    你也可以用同样的逻辑创建编辑（*edit*）表单。FormHelper助件用
    ``$this->request->data`` 属性来自动探知是创建新增（*add*）还是编辑（*edit*）表单。如果
    ``$this->request->data`` 包含一个以表单的模型命名的数组元素，而且该数组包含
    模型主键的非空值，那么 FormHelper 助件就会为该记录创建一个编辑表单。例如，如果
    我们浏览 http://site.com/recipes/edit/5 页面，我们会得到下面的输出::

    This will POST the form data to the ``add()`` action of
    RecipesController. However, you can also use the same logic to
    create an edit form. The FormHelper uses the ``$this->request->data``
    property to automatically detect whether to create an add or edit
    form. If ``$this->request->data`` contains an array element named after the
    form's model, and that array contains a non-empty value of the
    model's primary key, then the FormHelper will create an edit form
    for that record. For example, if we browse to
    http://site.com/recipes/edit/5, we would get the following::

        // Controller/RecipesController.php:
        public function edit($id = null) {
            if (empty($this->request->data)) {
                $this->request->data = $this->Recipe->findById($id);
            } else {
                // Save logic goes here
            }
        }

        // View/Recipes/edit.ctp:
        // 因为 $this->request->data['Recipe']['id'] = 5，
        // 我们会得到编辑表单
        // Since $this->request->data['Recipe']['id'] = 5,
        // we will get an edit form
        <?php echo $this->Form->create('Recipe'); ?>

    输出:

    Output:

    .. code-block:: html

        <form id="RecipeEditForm" method="post" action="/recipes/edit/5">
        <input type="hidden" name="_method" value="PUT" />

    .. note::

        因为这是一个编辑表单，生成了一个 hidden 类型的 input 字段来取代默认的 HTTP 方法。

        Since this is an edit form, a hidden input field is generated to
        override the default HTTP method.

    在为插件中的模型创建表单时，你应当总是使用 :term:`plugin syntax` 来创建表单。
    这会确保生成正确的表单::

    When creating forms for models in plugins, you should always use
    :term:`plugin syntax` when creating a form. This will ensure the form is
    correctly generated::

        echo $this->Form->create('ContactManager.Contact');

    绝大部分对表单的配置是通过 ``$options`` 数组进行的。这个特殊的数组可以包含
    一系列不同的键-值对，影响生成的表单标签。

    The ``$options`` array is where most of the form configuration
    happens. This special array can contain a number of different
    key-value pairs that affect the way the form tag is generated.

    .. versionchanged:: 2.0
        所有表单的默认网址，现在是当前的网址，包括传入（*passed*）、命名（*named*
        ）和查询字符串（*querystring*）参数。你可以通过给
        ``$this->Form->create()`` 方法的第二个参数中提供 ``$options['url']`` 来
        改变这个默认值。
        The default URL for all forms, is now the current URL including
        passed, named, and querystring parameters. You can override this
        default by supplying ``$options['url']`` in the second parameter of
        ``$this->Form->create()``.

create() 方法的选项
--------------------

Options for create()
--------------------

create() 方法有一些选项:

There are a number of options for create():

* ``$options['type']`` 这个键用来指明要创建的表单的类型。合法的值包括'post'、
  'get'、'file'、'put'和'delete'。

* ``$options['type']`` This key is used to specify the type of form to be created. Valid
  values include 'post', 'get', 'file', 'put' and 'delete'.

  提供'post'或者'get'会相应地改变表单提交的方法::

  Supplying either 'post' or 'get' changes the form submission method
  accordingly::

      echo $this->Form->create('User', array('type' => 'get'));

  输出:

  Output:

  .. code-block:: html

     <form id="UserAddForm" method="get" action="/users/add">

  指定'file'会把表单提交方法改为'post'，并且在表单标签中包括一个值为
  "multipart/form-data"的 enctype 属性。如果表单中有任何 file 元素，就应该使用这个（
  属性）。如果没有正确的 enctype 属性，文件上传就无法工作::

  Specifying 'file' changes the form submission method to 'post', and
  includes an enctype of "multipart/form-data" on the form tag. This
  is to be used if there are any file elements inside the form. The
  absence of the proper enctype attribute will cause the file uploads
  not to function::

      echo $this->Form->create('User', array('type' => 'file'));

  输出:

  Output:

  .. code-block:: html

     <form id="UserAddForm" enctype="multipart/form-data"
        method="post" action="/users/add">

  当使用'put'或者'delete'时，表单功能上等同于'post'表单，但在提交时，HTTP请求
  方法会被相应地改变为'PUT'或'DELETE'。这让 CakePHP 可以在网络浏览器中模拟正确的
  REST 支持。

  When using 'put' or 'delete', your form will be functionally
  equivalent to a 'post' form, but when submitted, the HTTP request
  method will be overridden with 'PUT' or 'DELETE', respectively.
  This allows CakePHP to emulate proper REST support in web
  browsers.

* ``$options['action']`` action键让你可以把表单指向当前控制器中的某一特定动作。
  例如，如果你要把表单指向当前控制器的login()动作，你可以提供下面这样的$options
  数组::

* ``$options['action']`` The action key allows you to point the form to a
  specific action in your current controller. For example, if you'd like to
  point the form to the login() action of the current controller, you would
  supply an $options array like the following::

    echo $this->Form->create('User', array('action' => 'login'));

  输出:

  Output:

  .. code-block:: html

     <form id="UserLoginForm" method="post" action="/users/login">

  .. deprecated:: 2.8.0
     在 2.8.0 版本中，``$options['action']`` 选项已经作废。
     请使用 ``$options['url']`` 和 ``$options['id']`` 选项。
     The ``$options['action']`` option was deprecated as of 2.8.0.
     Use the ``$options['url']`` and ``$options['id']`` options instead.

* ``$options['url']`` 如果需要的表单动作不在当前控制器中，你可以用$options数组的
  ‘url’键来为表单动作指定一个网址。提供的网址可以是相对于你的CakePHP应用程序::

* ``$options['url']`` If the desired form action isn't in the current
  controller, you can specify a URL for the form action using the 'url' key of
  the $options array. The supplied URL can be relative to your CakePHP
  application::

    echo $this->Form->create(false, array(
        'url' => array('controller' => 'recipes', 'action' => 'add'),
        'id' => 'RecipesAdd'
    ));

  输出:

  Output:

  .. code-block:: html

     <form method="post" action="/recipes/add">

  或者也可以指向外部域名::

  or can point to an external domain::

    echo $this->Form->create(false, array(
        'url' => 'http://www.google.com/search',
        'type' => 'get'
    ));

  输出:

  Output:

  .. code-block:: html

    <form method="get" action="http://www.google.com/search">

  也请查看 :php:meth:`HtmlHelper::url()` 方法，以了解更多不同类型的网址的例子。

  Also check :php:meth:`HtmlHelper::url()` method for more examples of
  different types of URLs.

  .. versionchanged:: 2.8.0

     如果你不希望输出网址作为表单的动作（*action*），请使用 ``'url' => false``。

     Use ``'url' => false`` if you don’t want to output a URL as the form action.

* ``$options['default']`` 如果'default'被设为布尔值false，表单的提交动作就会改成
  按动提交按键时不会提交表单。如果表单要通过AJAX提交，设置'default'为false阻止了
  表单默认的行为，你就可以抓取数据并通过AJAX提交。

* ``$options['default']`` If 'default' has been set to boolean false, the form's
  submit action is changed so that pressing the submit button does not submit
  the form. If the form is meant to be submitted via AJAX, setting 'default' to
  false suppresses the form's default behavior so you can grab the data and
  submit it via AJAX instead.

* ``$options['inputDefaults']`` 你可以用 ``inputDefaults`` 键为 ``input()``
  方法设置一组默认选项，来自定义默认的输入项（*input*）的创建方式。

* ``$options['inputDefaults']`` You can declare a set of default options for
  ``input()`` with the ``inputDefaults`` key to customize your default input
  creation::

    echo $this->Form->create('User', array(
        'inputDefaults' => array(
            'label' => false,
            'div' => false
        )
    ));

  之后所有创建的input标签就会继承inputDefaults中指定的选项。你可以在对input()方法
  的调用中声明选项来改变默认选项::

  All inputs created from that point forward would inherit the
  options declared in inputDefaults. You can override the
  default options by declaring the option in the input() call::

    echo $this->Form->input('password'); // 没有 div，没有 label No div, no label
    // 有一个 label 元素
    // has a label element
    echo $this->Form->input(
        'username',
        array('label' => 'Username')
    );

结束表单
================

Closing the Form
================

.. php:method:: end($options = null, $secureAttributes = array())

    FormHelper助件有一个 ``end()`` 方法，用来完成表单。``end()`` 方法经常只输出一个结束表单标签，但使用 ``end()`` 方法也可以让FormHelper助件插入 :php:class:`SecurityComponent` 组件要求的隐藏表单元素:

    The FormHelper includes an ``end()`` method that completes the
    form. Often, ``end()`` only outputs a closing form tag, but
    using ``end()`` also allows the FormHelper to insert needed hidden
    form elements that :php:class:`SecurityComponent` requires:

    .. code-block:: php

        <?php echo $this->Form->create(); ?>

        <!-- Form elements go here -->

        <?php echo $this->Form->end(); ?>

    如果提供一个字符串作为 ``end()`` 方法的第一个参数，FormHelper助件就会和结束表单标签一起输出一个相应(以输入参数)命名的submit按键。

    If a string is supplied as the first parameter to ``end()``, the
    FormHelper outputs a submit button named accordingly along with the
    closing form tag::

        <?php echo $this->Form->end('Finish'); ?>

    就会输出:

    Will output:

    .. code-block:: html

        <div class="submit">
            <input type="submit" value="Finish" />
        </div>
        </form>

    你可以传入一个数组给 ``end()`` 方法来指定详细设置::

    You can specify detail settings by passing an array to ``end()``::

        $options = array(
            'label' => 'Update',
            'div' => array(
                'class' => 'glass-pill',
            )
        );
        echo $this->Form->end($options);

    就会输出:

    Will output:

    .. code-block:: html

        <div class="glass-pill"><input type="submit" value="Update" name="Update">
        </div>

    欲知更多细节，请参看 `Form Helper API <http://api.cakephp.org/2.8/class-FormHelper.html>`_。

    See the `Form Helper API <http://api.cakephp.org/2.8/class-FormHelper.html>`_ for further details.

    .. note::

        如果你在应用程序中使用 :php:class:`SecurityComponent` 组件，你应当总是用 ``end()`` 方法结束表单。

        If you are using :php:class:`SecurityComponent` in your application you
        should always end your forms with ``end()``.

    .. versionchanged:: 2.5
        在2.5版本中增加了 ``$secureAttributes`` 参数。
        The ``$secureAttributes`` parameter was added in 2.5.

.. _automagic-form-elements:

创建表单元素
======================

Creating form elements
======================

使用FormHelper助件，有多种方法可以创建表单 input 元素。我们从 ``input()`` 方法开始说起。这个方法会自动检查提供给它的模型字段，从而为那个字段创建适当的input元素。在内部 ``input()`` 方法调用FormHelper助件的其他方法。

There are a few ways to create form inputs with the FormHelper. We'll start by
looking at ``input()``. This method will automatically inspect the model field it
has been supplied in order to create an appropriate input for that
field. Internally ``input()`` delegates to other methods in FormHelper.

.. php:method:: input(string $fieldName, array $options = array())

    根据给定的 ``Model.field`` 创建下列元素:

    Creates the following elements given a particular ``Model.field``:

    * 包裹的div元素。
    * Label元素
    * （一个或多个）input元素
    * 如果适用，错误消息元素

    * Wrapping div.
    * Label element
    * Input element(s)
    * Error element with message if applicable.

    创建的input元素的类型取决于列的数据类型:

    The type of input created depends on the column datatype:

    列的类型
        获得的表单输入字段
    Column Type
        Resulting Form Field
    string (char, varchar, etc.)
        text
    boolean, tinyint(1)
        checkbox
    text
        textarea
    以password、passwd或psword命名的文字类型
        password
    text, with name of password, passwd, or psword
        password
    以email命名的文字类型
        email
    text, with name of email
        email
    以tel、telephone或phone命名的文字类型
        tel
    text, with name of tel, telephone, or phone
        tel
    date
        日、月和年的select输入项
    date
        day, month, and year selects
    datetime, timestamp
        日、月、年、小时、分钟和上下午的select输入项
    datetime, timestamp
        day, month, year, hour, minute, and meridian selects
    time
        小时、分钟和上下午的select输入项
    time
        hour, minute, and meridian selects
    binary 二进制类型
        file

    ``$options`` 参数让你定制 ``input()`` 方法如何工作，并微调生成的内容。

    The ``$options`` parameter allows you to customize how ``input()`` works,
    and finely control what is generated.

    如果模型字段的验证规则没有指定 ``allowEmpty =>
    true``，包裹的div元素就会带有 ``required`` 的（样式）类名。这种行为的一个局限是，字段所在的模型在当前请求（的处理过程）中必须已经加载，或者直接与提供给 :php:meth:`~FormHelper::create()` 方法的模型相关联。

    The wrapping div will have a ``required`` class name appended if the
    validation rules for the Model's field do not specify ``allowEmpty =>
    true``. One limitation of this behavior is the field's model must have
    been loaded during this request. Or be directly associated to the
    model supplied to :php:meth:`~FormHelper::create()`.

    .. versionadded:: 2.5
        binary类型现在映射成file类型的input元素。
        The binary type now maps to a file input.

    .. versionadded:: 2.3

    .. _html5-required:

    自2.3版本起，HTML5的 ``required`` 属性也会根据验证规则被添加到input元素上。你可以对某一字段在options数组中显式地设置 ``required`` 键，来改变这一点。要对整个表单省略浏览器验证的触发，你可以对使用 :php:meth:`FormHelper::submit()` 方法生成的input按键设置选项 ``'formnovalidate' => true``，或者在 :php:meth:`FormHelper::create()` 方法的选项中设置 ``'novalidate' => true``。

    Since 2.3 the HTML5 ``required`` attribute will also be added to the input
    based on validation rules. You can explicitly set ``required`` key in
    options array to override it for a field. To skip browser validation
    triggering for the whole form you can set option ``'formnovalidate' => true``
    for the input button you generate using :php:meth:`FormHelper::submit()` or
    set ``'novalidate' => true`` in options for :php:meth:`FormHelper::create()`.

    例如，假设User模型包括username（varchar）、password（varchar）、approved（datetime）和quote（text）这些字段。你可以用FormHelper助件的input()方法为所有这些表单字段创建适当的input元素::

    For example, let's assume that your User model includes fields for a
    username (varchar), password (varchar), approved (datetime) and
    quote (text). You can use the input() method of the FormHelper to
    create appropriate inputs for all of these form fields::

        echo $this->Form->create();

        echo $this->Form->input('username');   //text
        echo $this->Form->input('password');   //password
        echo $this->Form->input('approved');   //day, month, year, hour, minute,
                                               //meridian 日，月，年，小时，分钟，上下午
        echo $this->Form->input('quote');      //textarea

        echo $this->Form->end('Add');

    （下面是）说明日期字段的一些选项的一个更详细的例子::

    A more extensive example showing some options for a date field::

        echo $this->Form->input('birth_dt', array(
            'label' => 'Date of birth',
            'dateFormat' => 'DMY',
            'minYear' => date('Y') - 70,
            'maxYear' => date('Y') - 18,
        ));

    ``input()`` 方法除了下面这些选项，你可以指定input类型的任何选项和任何html属性（例如onfocus）。欲知关于 ``$options`` 和 ``$htmlAttributes`` 的更多信息，请参看 :doc:`/core-libraries/helpers/html`。

    Besides the specific options for ``input()`` found below, you can specify
    any option for the input type & any HTML attribute (for instance onfocus).
    For more information on ``$options`` and ``$htmlAttributes`` see
    :doc:`/core-libraries/helpers/html`.

    假设User hasAndBelongsToMany Group。在控制器中，设置一个驼峰命名（*camelCase*）的复数变量（在这里就是group -> groups，或者ExtraFunkyModel -> extraFunkyModels）作为select的可选项。在控制器动作中你可以这样写::

    Assuming that User hasAndBelongsToMany Group. In your controller, set a
    camelCase plural variable (group -> groups in this case, or ExtraFunkyModel
    -> extraFunkyModels) with the select options. In the controller action you
    would put the following::

        $this->set('groups', $this->User->Group->find('list'));

    然后在视图中就可以用这样简单的代码创建多选项::

    And in the view a multiple select can be created with this simple
    code::

        echo $this->Form->input('Group');

    如果你要在使用belongsTo或hasOne关系时创建select字段，你可以在Users控制器中添加下面的代码（假设User belongsTo Group）::

    If you want to create a select field while using a belongsTo - or
    hasOne - Relation, you can add the following to your Users-controller
    (assuming your User belongsTo Group)::

        $this->set('groups', $this->User->Group->find('list'));

    然后，在你的表单视图中添加下面的代码::

    Afterwards, add the following to your form-view::

        echo $this->Form->input('group_id');

    如果你的模型名称由两个或多个单词组成，例如，"UserGroup"，在使用set()方法传递数据时，你应当把数据命名为复数、驼峰命名的格式，象下面这样::

    If your model name consists of two or more words, e.g.,
    "UserGroup", when passing the data using set() you should name your
    data in a pluralised and camelCased format as follows::

        $this->set('userGroups', $this->UserGroup->find('list'));
        // 或者
        // or
        $this->set(
            'reallyInappropriateModelNames',
            $this->ReallyInappropriateModelName->find('list')
        );

    .. note::

        尽量避免使用 `FormHelper::input()` 方法来创建提交按键。而是使用 :php:meth:`FormHelper::submit()` 方法。

        Try to avoid using `FormHelper::input()` to generate submit buttons. Use
        :php:meth:`FormHelper::submit()` instead.

.. php:method:: inputs(mixed $fields = null, array $blacklist = null, $options = array())

    为 ``$fields`` 生成一组input标签。如果$fields是null，就会使用当前模型中除了在 ``$blacklist`` 参数中指定的字段之外的所有字段。

    Generate a set of inputs for ``$fields``. If ``$fields`` is null all fields,
    except of those defined in ``$blacklist``, of the current model will be used.

    除了控制字段输出，还可以用 ``$fields`` 参数通过 ``fieldset`` 及 ``legend`` 键来控制legend和fieldset的渲染。``$this->Form->inputs(array('legend' => 'My legend'));`` 会输出一个带有自定义的legend的input元素集合。你也可以通过 ``$fields`` 参数单独定制每个input。::

    In addition to controlling fields output, ``$fields`` can be used to control
    legend and fieldset rendering with the ``fieldset`` and ``legend`` keys.
    ``$this->Form->inputs(array('legend' => 'My legend'));``
    Would generate an input set with a custom legend. You can customize
    individual inputs through ``$fields`` as well. ::

        echo $this->Form->inputs(array(
            'name' => array('label' => 'custom label')
        ));

    除了对字段的控制，inputs()方法还允许你使用一些其他的选项。

    In addition to fields control, inputs() allows you to use a few additional
    options.

    - ``fieldset`` 设置为false来禁用fieldset。如果提供的是字符串，就会被用作fieldset元素的（样式）类名（*classname*）。
    - ``legend`` 设置为false来对生成的input元素集合禁用legend。也可以提供一个字符串来自定义legend的文字。

    - ``fieldset`` Set to false to disable the fieldset. If a string is supplied
      it will be used as the class name for the fieldset element.
    - ``legend`` Set to false to disable the legend for the generated input set.
      Or supply a string to customize the legend text.

字段命名约定
------------------------

Field naming conventions
------------------------

表单助件相当聪明。只要你用表单助件的方法指定一个字段名称，它就会自动使用当前模型名以下面这样的格式来构建一个input元素：

The Form helper is pretty smart. Whenever you specify a field name
with the form helper methods, it'll automatically use the current
model name to build an input with a format like the following:

.. code-block:: html

    <input type="text" id="ModelnameFieldname" name="data[Modelname][fieldname]">

在针对一个模型创建的表单中，为该模型生成input元素时，可以省略模型名称。你可以为关联模型或任意模型创建input元素，只需把Modelname.fieldname作为第一个参数传入即可::

This allows you to omit the model name when generating inputs for the model that
the form was created for. You can create inputs for associated models, or
arbitrary models by passing in Modelname.fieldname as the first parameter::

    echo $this->Form->input('Modelname.fieldname');

如果你要使用同样的字段名称来创建多个输入字段，从而生成一个可以用saveAll()方法一起保存的数组，请使用下面的约定::

If you need to specify multiple fields using the same field name,
thus creating an array that can be saved in one shot with
saveAll(), use the following convention::

    echo $this->Form->input('Modelname.0.fieldname');
    echo $this->Form->input('Modelname.1.fieldname');

输出:

Output:

.. code-block:: html

    <input type="text" id="Modelname0Fieldname"
        name="data[Modelname][0][fieldname]">
    <input type="text" id="Modelname1Fieldname"
        name="data[Modelname][1][fieldname]">


FormHelper助件对datetime input 元素的创建，在内部使用几个字段后缀。如果你使用名称带有 ``year``、``month``、``day``、``hour``、``minute`` 或者 ``meridian`` 的字段，并无法得到正确的输入项，你可以设置 ``name`` 属性来取代默认的行为::

FormHelper uses several field-suffixes internally for datetime input creation.
If you are using fields named ``year``, ``month``, ``day``, ``hour``,
``minute``, or ``meridian`` and having issues getting the correct input, you can
set the ``name`` attribute to override the default behavior::

    echo $this->Form->input('Model.year', array(
        'type' => 'text',
        'name' => 'data[Model][year]'
    ));


选项
-------

Options
-------

``FormHelper::input()`` 方法支持很多选项。除了它自身的选项，``input()`` 方法也接受生成的inout元素类型的选项，以及HTML属性（*attribute*）。以下列出 ``FormHelper::input()`` 相关的选项。

``FormHelper::input()`` supports a large number of options. In addition to its
own options ``input()`` accepts options for the generated input types, as well as
HTML attributes. The following will cover the options specific to
``FormHelper::input()``.

* ``$options['type']`` 你可以提供一个类型，来强制指定输入项的类型，忽略对模型的检测。除了在 :ref:`automagic-form-elements` 中介绍的字段类型，你也可以创建'file'、'password'和任何HTML5支持的类型::

* ``$options['type']`` You can force the type of an input, overriding model
  introspection, by specifying a type. In addition to the field types found in
  the :ref:`automagic-form-elements`, you can also create 'file', 'password',
  and any type supported by HTML5::

    echo $this->Form->input('field', array('type' => 'file'));
    echo $this->Form->input('email', array('type' => 'email'));

  输出:

  Output:

  .. code-block:: html

    <div class="input file">
        <label for="UserField">Field</label>
        <input type="file" name="data[User][field]" value="" id="UserField" />
    </div>
    <div class="input email">
        <label for="UserEmail">Email</label>
        <input type="email" name="data[User][email]" value="" id="UserEmail" />
    </div>

* ``$options['div']`` 用这个选项来设置包含input元素的div的属性。使用字符串就会设置div的（样式）类名。用数组就可以把div的属性设为数组的键/值对。或者，你也可以把这个键设置为false从而不输出div。

* ``$options['div']`` Use this option to set attributes of the input's
  containing div. Using a string value will set the div's class name. An array
  will set the div's attributes to those specified by the array's keys/values.
  Alternatively, you can set this key to false to disable the output of the div.

  设置（样式）类名::

  Setting the class name::

    echo $this->Form->input('User.name', array(
        'div' => 'class_name'
    ));

  输出:

  Output:

  .. code-block:: html

    <div class="class_name">
        <label for="UserName">Name</label>
        <input name="data[User][name]" type="text" value="" id="UserName" />
    </div>

  设置多个属性::

  Setting multiple attributes::

    echo $this->Form->input('User.name', array(
        'div' => array(
            'id' => 'mainDiv',
            'title' => 'Div Title',
            'style' => 'display:block'
        )
    ));

  输出:

  Output:

  .. code-block:: html

    <div class="input text" id="mainDiv" title="Div Title"
        style="display:block">
        <label for="UserName">Name</label>
        <input name="data[User][name]" type="text" value="" id="UserName" />
    </div>

  禁止div输出::

  Disabling div output::

    echo $this->Form->input('User.name', array('div' => false)); ?>

  输出:

  Output:

  .. code-block:: html

    <label for="UserName">Name</label>
    <input name="data[User][name]" type="text" value="" id="UserName" />

* ``$options['label']`` 把这个键设置为你要显示在通常伴随input元素的label元素内的字符串::

* ``$options['label']`` Set this key to the string you would like to be
  displayed within the label that usually accompanies the input::

    echo $this->Form->input('User.name', array(
        'label' => 'The User Alias'
    ));

  输出:

  Output:

  .. code-block:: html

    <div class="input">
        <label for="UserName">The User Alias</label>
        <input name="data[User][name]" type="text" value="" id="UserName" />
    </div>

  或者，设置该键为false，从而禁止label元素的输出::

  Alternatively, set this key to false to disable the output of the
  label::

    echo $this->Form->input('User.name', array('label' => false));

  输出:

  Output:

  .. code-block:: html

    <div class="input">
        <input name="data[User][name]" type="text" value="" id="UserName" />
    </div>

  把它设置为数组来为 ``label`` 元素提供额外的选项。如果这么做，你可以在数组中用 ``text`` 键来自定义label元素的文字::

  Set this to an array to provide additional options for the
  ``label`` element. If you do this, you can use a ``text`` key in
  the array to customize the label text::

    echo $this->Form->input('User.name', array(
        'label' => array(
            'class' => 'thingy',
            'text' => 'The User Alias'
        )
    ));

  输出:

  Output:

  .. code-block:: html

    <div class="input">
        <label for="UserName" class="thingy">The User Alias</label>
        <input name="data[User][name]" type="text" value="" id="UserName" />
    </div>


* ``$options['error']`` 使用这个键让你可以改变默认的模型错误消息，以及用于，例如，设置国际化（*i18n*）消息。它有一些子选项，用来控制包裹的元素，包裹元素的（样式）类名，以及错误消息中的HTML是否要转义。

* ``$options['error']`` Using this key allows you to override the default model
  error messages and can be used, for example, to set i18n messages. It has a
  number of suboptions which control the wrapping element, wrapping element
  class name, and whether HTML in the error message will be escaped.

  要禁用错误消息输出和字段的（样式）类，设置error键为false::

  To disable error message output & field classes set the error key to false::

    $this->Form->input('Model.field', array('error' => false));

  要只禁用错误消息，但保持字段的（样式）类，设置errorMessage键为false::

  To disable only the error message, but retain the field classes, set the
  errorMessage key to false::

    $this->Form->input('Model.field', array('errorMessage' => false));

  要改变包裹元素的类型和它的（样式）类（*class*），使用下面的格式::

  To modify the wrapping element type and its class, use the
  following format::

    $this->Form->input('Model.field', array(
        'error' => array(
            'attributes' => array('wrap' => 'span', 'class' => 'bzzz')
        )
    ));

  为防止在错误消息输出中的HTML被自动转义，设置escape子选项为false::

  To prevent HTML being automatically escaped in the error message
  output, set the escape suboption to false::

    $this->Form->input('Model.field', array(
        'error' => array(
            'attributes' => array('escape' => false)
        )
    ));

  要改变模型的错误消息，用键与验证规则名称匹配的数组::

  To override the model error messages use an array with
  the keys matching the validation rule names::

    $this->Form->input('Model.field', array(
        'error' => array('tooShort' => __('This is not long enough'))
    ));

  如上所示，你可以为模型中的每个验证规则设置错误消息。而且，你可以为表单提供国际化的消息。

  As seen above you can set the error message for each validation
  rule you have in your models. In addition you can provide i18n
  messages for your forms.

  .. versionadded:: 2.3
    在2.3版本中增加了对 ``errorMessage`` 的支持。
    Support for the ``errorMessage`` option was added in 2.3

* ``$options['before']``、``$options['between']``、``$options['separator']``
  和 ``$options['after']``

* ``$options['before']``, ``$options['between']``, ``$options['separator']``,
  and ``$options['after']``

  如果你要在input()方法的输出中间插入一些标记语言代码，就可以使用这些键::

  Use these keys if you need to inject some markup inside the output
  of the input() method::

      echo $this->Form->input('field', array(
          'before' => '--before--',
          'after' => '--after--',
          'between' => '--between---'
      ));

  输出:

  Output:

  .. code-block:: html

      <div class="input">
      --before--
      <label for="UserField">Field</label>
      --between---
      <input name="data[User][field]" type="text" value="" id="UserField" />
      --after--
      </div>

  对radio类型的input元素，'separator'属性可用来插入标记语言代码，来分隔每对input/label::

  For radio inputs the 'separator' attribute can be used to
  inject markup to separate each input/label pair::

      echo $this->Form->input('field', array(
          'before' => '--before--',
          'after' => '--after--',
          'between' => '--between---',
          'separator' => '--separator--',
          'options' => array('1', '2'),
          'type' => 'radio'
      ));

  输出:

  Output:

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

  对于 ``date`` 和 ``datetime`` 类型的元素，'separator'属性可用来改变select元素之间的字符串。默认为 '-'。

  For ``date`` and ``datetime`` type elements the 'separator'
  attribute can be used to change the string between select elements.
  Defaults to '-'.

* ``$options['format']`` FormHelper助件生成的html的顺序也是可以控制的。'format'选项支持使用一个字符串数组来描述上述元素遵从的模板。支持的数组的键为 ``array('before', 'input', 'between', 'label', 'after', 'error')``。

* ``$options['format']`` The ordering of the HTML generated by FormHelper is
  controllable as well. The 'format' options supports an array of strings
  describing the template you would like said element to follow. The supported
  array keys are:
  ``array('before', 'input', 'between', 'label', 'after', 'error')``.


* ``$options['inputDefaults']`` 如果你发现在对input()方法的多次调用中重复相同的选项，你可以使用 ``inputDefaults`` 来保持你的代码dry（译注: `Don't Repeat Yourself <http://tech.it168.com/a2009/0622/593/000000593268.shtml>`_ ，不要重复代码。）

* ``$options['inputDefaults']`` If you find yourself repeating the same options
  in multiple input() calls, you can use `inputDefaults`` to keep your code dry::

    echo $this->Form->create('User', array(
        'inputDefaults' => array(
            'label' => false,
            'div' => false
        )
    ));

  在这之后创建的所有input元素就都会继承inputDefaults之中声明的选项。你可以在input()方法的调用中声明选项来改变默认的选项::

  All inputs created from that point forward would inherit the
  options declared in inputDefaults. You can override the
  default options by declaring the option in the input() call::

    // 没有div，没有label
    // No div, no label
    echo $this->Form->input('password');

    // 有label元素
    // has a label element
    echo $this->Form->input('username', array('label' => 'Username'));

  如果你以后需要改变默认（选项），你可以使用 :php:meth:`FormHelper::inputDefaults()` 方法。

  If you need to later change the defaults you can use
  :php:meth:`FormHelper::inputDefaults()`.

* ``$options['maxlength']`` 设置该键来设置 ``input`` 字段的 ``maxlength`` 属性为特定值。当该键省略时，且 input 类型是 ``text``、``textarea``、``email``、``tel``、``url`` 或 ``search`` 时，而字段定义不是 ``decimal``、``time`` 或 ``datetime`` 之一，就会使用数据库字段的长度。

* ``$options['maxlength']`` Set this key to set the ``maxlength`` attribute of the ``input``
  field to a specific value. When this key is omitted and the input-type is ``text``,
  ``textarea``, ``email``, ``tel``, ``url`` or ``search`` and the field-definition is not
  one of ``decimal``, ``time`` or ``datetime``, the length option of the database field is
  used.

GET 表单 input 字段
-------------------

GET Form Inputs
---------------

当使用 ``FormHelper`` 来生成 ``GET`` 的 input 元素时，input 的 name 会自动缩写，提供更易读的名称。例如::

When using ``FormHelper`` to generate inputs for ``GET`` forms, the input names
will automatically be shortened to provide more human friendly names. For
example::

    // 生成 <input name="email" type="text" />
    // Makes <input name="email" type="text" />
    echo $this->Form->input('User.email');

    // 生成 <select name="Tags" multiple="multiple">
    // Makes <select name="Tags" multiple="multiple">
    echo $this->Form->input('Tags.Tags', array('multiple' => true));

如果你想要改变生成的 name 属性，可以使用 ``name`` 选项::

If you want to override the generated name attributes you can use the ``name``
option::

    // 生成更标准的 <input name="data[User][email]" type="text" />
    // Makes the more typical <input name="data[User][email]" type="text" />
    echo $this->Form->input('User.email', array('name' => 'data[User][email]'));

生成特定类型的input元素
===================================

Generating specific types of inputs
===================================

除了通用的 ``input()`` 方法，``FormHelper`` 助件有特定的方法来生成一系列不同类型的input元素。这些方法可以用来只是生成input部件本身，也可以结合其他象 :php:meth:`~FormHelper::label()` 和 :php:meth:`~FormHelper::error()` 这样的方法来生成完全定制的表单布局。

In addition to the generic ``input()`` method, ``FormHelper`` has specific
methods for generating a number of different types of inputs. These can be used
to generate just the input widget itself, and combined with other methods like
:php:meth:`~FormHelper::label()` and :php:meth:`~FormHelper::error()` to
generate fully custom form layouts.

.. _general-input-options:

通用选项
--------------

Common options
--------------

许多不同的input元素方法支持一组通用的选项。``input()`` 方法也支持所有这些选项 。为避免重复，所有输入项方法共用的通用选项在此说明:

Many of the various input element methods support a common set of options. All
of these options are also supported by ``input()``. To reduce repetition the
common options shared by all input methods are as follows:

* ``$options['class']`` 你可以为input元素设置（样式）类名(classname)::

* ``$options['class']`` You can set the class name for an input::

    echo $this->Form->input('title', array('class' => 'custom-class'));

* ``$options['id']`` 设置此键来强制指定input元素的 DOM id 的值。

* ``$options['id']`` Set this key to force the value of the DOM id for the input.

* ``$options['default']`` 用来设置输入项的默认值。如果传给表单的数据不包含该字段的值(或者根本没有数据传入)，该值就会被使用。

* ``$options['default']`` Used to set a default value for the input field. The
  value is used if the data passed to the form does not contain a value for the
  field (or if no data is passed at all).

  使用的例子::

  Example usage::

    echo $this->Form->input('ingredient', array('default' => 'Sugar'));

  select 字段的例子(尺寸"Medium"会作为默认值被选中)::

  Example with select field (Size "Medium" will be selected as
  default)::

    $sizes = array('s' => 'Small', 'm' => 'Medium', 'l' => 'Large');
    echo $this->Form->input(
        'size',
        array('options' => $sizes, 'default' => 'm')
    );

  .. note::

    你无法使用 ``default`` 来勾选 checkbox —— 为此你可以在控制器中设置 ``$this->request->data`` 的值，或者把input元素的选项 ``checked`` 设为 true。

    You cannot use ``default`` to check a checkbox - instead you might
    set the value in ``$this->request->data`` in your controller,
    or set the input option ``checked`` to true.

    Date 和 datetime 字段的默认值可以用'selected'键来设置。

    Date and datetime fields' default values can be set by using the
    'selected' key.

    当心使用 false 来设置默认值。false 值用来禁用/排除input元素的选项，所以 ``'default' => false`` 完全不会设置任何值。而是(应当)使用 ``'default' => 0``。

    Beware of using false to assign a default value. A false value is used to
    disable/exclude options of an input field, so ``'default' => false`` would
    not set any value at all. Instead use ``'default' => 0``.

除了上述的选项之外，你可以混入(*mixin*)任何你想使用的 HTML 属性。任何未特别提到的选项名称，会被当作 HTML 属性，并应用于生成的 HTML input元素。

In addition to the above options, you can mixin any HTML attribute you wish to
use. Any non-special option name will be treated as an HTML attribute, and
applied to the generated HTML input element.


select，checkbox 和 radio 类型的 input 元素的选项
--------------------------------------------------

Options for select, checkbox and  radio inputs
----------------------------------------------

* ``$options['selected']`` 与选择类型（即 select，date，time，datetime 这些类型）的 input 元素结合使用。设置‘selected’为 input 元素渲染时你要在默认情况下选中的项目的值::

* ``$options['selected']`` Used in combination with a select-type input (i.e.
  For types select, date, time, datetime). Set 'selected' to the value of the
  item you wish to be selected by default when the input is rendered::

    echo $this->Form->input('close_time', array(
        'type' => 'time',
        'selected' => '13:30:00'
    ));

  .. note::

    date 和 datetime 类型的 input 元素的 selected 键也可以是 UNIX 时间戳(timestamp)。

    The selected key for date and datetime inputs may also be a UNIX
    timestamp.

* ``$options['empty']`` 如果设置为 true，就会强制 input 元素保持为空。

* ``$options['empty']`` If set to true, forces the input to remain empty.

  当传递给一个 select 列表时，这会在下拉列表中创建一个带有空值的空 option 元素。如果你要空值有文字显示，而不是只是空 option 元素，给 empty 键传入一个字符串::

  When passed to a select list, this creates a blank option with an
  empty value in your drop down list. If you want to have a empty
  value with text displayed instead of just a blank option, pass in a
  string to empty::

      echo $this->Form->input('field', array(
          'options' => array(1, 2, 3, 4, 5),
          'empty' => '(choose one)'
      ));

  输出:

  Output:

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

    如果你要设置一个密码（*password*）字段为空，请使用 'value' => ''。

    If you need to set the default value in a password field to blank,
    use 'value' => '' instead.

    对 date 或 datetime 类型的字段，可以提供键值对列表::

    A list of key-value pairs can be supplied for a date or datetime field::

        echo $this->Form->dateTime('Contact.date', 'DMY', '12',
          array(
            'empty' => array(
              'day' => 'DAY', 'month' => 'MONTH', 'year' => 'YEAR',
              'hour' => 'HOUR', 'minute' => 'MINUTE', 'meridian' => false
            )
          )
        );

  输出:

  Output:

  .. code-block:: html

    <select name="data[Contact][date][day]" id="ContactDateDay">
        <option value="">DAY</option>
        <option value="01">1</option>
        // ...
        <option value="31">31</option>
    </select> - <select name="data[Contact][date][month]" id="ContactDateMonth">
        <option value="">MONTH</option>
        <option value="01">January</option>
        // ...
        <option value="12">December</option>
    </select> - <select name="data[Contact][date][year]" id="ContactDateYear">
        <option value="">YEAR</option>
        <option value="2036">2036</option>
        // ...
        <option value="1996">1996</option>
    </select> <select name="data[Contact][date][hour]" id="ContactDateHour">
        <option value="">HOUR</option>
        <option value="01">1</option>
        // ...
        <option value="12">12</option>
        </select>:<select name="data[Contact][date][min]" id="ContactDateMin">
        <option value="">MINUTE</option>
        <option value="00">00</option>
        // ...
        <option value="59">59</option>
    </select> <select name="data[Contact][date][meridian]" id="ContactDateMeridian">
        <option value="am">am</option>
        <option value="pm">pm</option>
    </select>

* ``$options['hiddenField']`` 对某些 input 类型(checkboxe、radio)会创建一个 hidden 类型的 input 元素，从而使 $this->request->data 中有一个键，即使没有值:

* ``$options['hiddenField']`` For certain input types (checkboxes, radios) a
  hidden input is created so that the key in $this->request->data will exist
  even without a value specified:

  .. code-block:: html

    <input type="hidden" name="data[Post][Published]" id="PostPublished_"
        value="0" />
    <input type="checkbox" name="data[Post][Published]" value="1"
        id="PostPublished" />

  这可以通过设置 ``$options['hiddenField'] = false`` 来禁用::

  This can be disabled by setting the ``$options['hiddenField'] = false``::

    echo $this->Form->checkbox('published', array('hiddenField' => false));

  这会输出:

  Which outputs:

  .. code-block:: html

    <input type="checkbox" name="data[Post][Published]" value="1"
        id="PostPublished" />

  如果你要在一个表单上中创建成组的多组 input 元素，你就应该在除了第一个的所有 input 元素上使用这个参数。如果页面中的 hidden 类型的 input 元素分布在多个地方，只有最后一组 input 元素的值会被保存。

  If you want to create multiple blocks of inputs on a form that are
  all grouped together, you should use this parameter on all inputs
  except the first. If the hidden input is on the page in multiple
  places, only the last group of input's values will be saved

  在(下面)这个例子中，只有 tertiary colors 会被传递，primary colors 会被覆盖:

  In this example, only the tertiary colors would be passed, and the
  primary colors would be overridden:

  .. code-block:: html

    <h2>Primary Colors</h2>
    <input type="hidden" name="data[Color][Color]" id="Colors_" value="0" />
    <input type="checkbox" name="data[Color][Color][]" value="5"
        id="ColorsRed" />
    <label for="ColorsRed">Red</label>
    <input type="checkbox" name="data[Color][Color][]" value="5"
        id="ColorsBlue" />
    <label for="ColorsBlue">Blue</label>
    <input type="checkbox" name="data[Color][Color][]" value="5"
        id="ColorsYellow" />
    <label for="ColorsYellow">Yellow</label>

    <h2>Tertiary Colors</h2>
    <input type="hidden" name="data[Color][Color]" id="Colors_" value="0" />
    <input type="checkbox" name="data[Color][Color][]" value="5"
        id="ColorsGreen" />
    <label for="ColorsGreen">Green</label>
    <input type="checkbox" name="data[Color][Color][]" value="5"
        id="ColorsPurple" />
    <label for="ColorsPurple">Purple</label>
    <input type="checkbox" name="data[Addon][Addon][]" value="5"
        id="ColorsOrange" />
    <label for="ColorsOrange">Orange</label>

  对第二组输入项禁用 ``'hiddenField'``，就可以防止这样的事情。

  Disabling the ``'hiddenField'`` on the second input group would
  prevent this behavior.

  你可以设置不是0的 hidden 字段值，比如 'N'::

  You can set a different hidden field value other than 0 such as 'N'::

      echo $this->Form->checkbox('published', array(
          'value' => 'Y',
          'hiddenField' => 'N',
      ));

Datetime 选项
----------------

Datetime options
----------------

* ``$options['timeFormat']`` 用于指定一组与时间相关的 select 类型的 input 元素的格式。合法的格式包括 ``12``，``24`` 和 ``null``。

* ``$options['timeFormat']`` Used to specify the format of the select inputs for
  a time-related set of inputs. Valid values include ``12``, ``24``, and ``null``.

* ``$options['dateFormat']`` 用于指定一组与日期相关的 select 类型的 input 元素的格式。合法的格式包括'D'，'M'和'Y'的任意组合，或者 ``null``。input 元素会以 dateFormat 选项定义的顺序来放置。

* ``$options['dateFormat']`` Used to specify the format of the select inputs for
  a date-related set of inputs. Valid values include any combination of 'D',
  'M' and 'Y' or ``null``. The inputs will be put in the order defined by the
  dateFormat option.

* ``$options['minYear'], $options['maxYear']`` 与 date/datetime input 元素一起使用。定义在年的 select 字段中显示的下限和/或上限的值。

* ``$options['minYear'], $options['maxYear']`` Used in combination with a
  date/datetime input. Defines the lower and/or upper end of values shown in the
  years select field.

* ``$options['orderYear']`` 与 date/datetime input 元素一起使用。定义年的值显示的顺序。有效的值包括 'asc'，'desc'。默认值为 'desc'。

* ``$options['orderYear']`` Used in combination with a date/datetime input.
  Defines the order in which the year values will be set. Valid values include
  'asc', 'desc'. The default value is 'desc'.

* ``$options['interval']`` 这个选项指定分钟选择框中每个选项之间间隔的分钟数::

* ``$options['interval']`` This option specifies the number of minutes between
  each option in the minutes select box::

    echo $this->Form->input('Model.time', array(
        'type' => 'time',
        'interval' => 15
    ));

  会在分钟选择框中创建4个选项，每15分钟一个。

  Would create 4 options in the minute select. One for each 15
  minutes.

* ``$options['round']`` 可以设置为 `up` 或者 `down`，强制向某一方向的舍入/取整。默认值为 null，即根据 `interval` 的一半向上取整。

* ``$options['round']`` Can be set to `up` or `down` to force rounding in either direction.
  Defaults to null which rounds half up according to `interval`.

  .. versionadded:: 2.4

表单元素相关的方法
=============================

Form Element-Specific Methods
=============================

在上面的例子中，所有的元素都是创建在针对 ``User`` 模型的表单中。所以，生成的 HTML 代码会包含引用 User 模型的属性。例如：name=data[User][username], id=UserUsername。

All elements are created under a form for the ``User`` model as in the examples above.
For this reason, the HTML code generated will contain attributes that reference to the User model.
Ex: name=data[User][username], id=UserUsername

.. php:method:: label(string $fieldName, string $text, array $options)

    创建一个 label 元素。``$fieldName`` 用于生成 DOM id。如果 ``$text`` 未定义，``$fieldName`` 会被用来转换（*inflect*）生成 label 元素的文字::

    Create a label element. ``$fieldName`` is used for generating the
    DOM id. If ``$text`` is undefined, ``$fieldName`` will be used to inflect
    the label's text::

        echo $this->Form->label('User.name');
        echo $this->Form->label('User.name', 'Your username');

    输出:

    Output:

    .. code-block:: html

        <label for="UserName">Name</label>
        <label for="UserName">Your username</label>

    ``$options`` 可以是一个 HTML 属性的数组，或者是一个会被用作样式类名的字符串::

    ``$options`` can either be an array of HTML attributes, or a string that
    will be used as a class name::

        echo $this->Form->label('User.name', null, array('id' => 'user-label'));
        echo $this->Form->label('User.name', 'Your username', 'highlight');

    输出:

    Output:

    .. code-block:: html

        <label for="UserName" id="user-label">Name</label>
        <label for="UserName" class="highlight">Your username</label>

.. php:method:: text(string $name, array $options)

    FormHelper助件的其他方法是用来创建特定的表单元素的。这些方法中的许多也用到特殊的 $options 参数。不过，在这种情况下，$options 主要是用来指定 HTML 标签的属性(比如表单中元素的值或者 DOM id)::

    The rest of the methods available in the FormHelper are for
    creating specific form elements. Many of these methods also make
    use of a special $options parameter. In this case, however,
    $options is used primarily to specify HTML tag attributes (such as
    the value or DOM id of an element in the form)::

        echo $this->Form->text('username', array('class' => 'users'));

    将会输出:

    Will output:

    .. code-block:: html

        <input name="data[User][username]" type="text" class="users"
            id="UserUsername" />

.. php:method:: password(string $fieldName, array $options)

    创建一个密码字段。::

    Creates a password field. ::

        echo $this->Form->password('password');

    将会输出:

    Will output:

    .. code-block:: html

        <input name="data[User][password]" value="" id="UserPassword"
            type="password" />

.. php:method:: hidden(string $fieldName, array $options)

    创建一个 hidden 类型的表单 input 元素。例如::

    Creates a hidden form input. Example::

        echo $this->Form->hidden('id');

    将会输出:

    Will output:

    .. code-block:: html

        <input name="data[User][id]" id="UserId" type="hidden" />

    如果表单是用于修改（即，数组 ``$this->request->data`` 会包含 ``User`` 模型已经保存的数据），对应 ``id`` 字段的值就会自动加到生成的 HTML 中。data[User][id] = 10 的例子：

    If the form is edited (that is, the array ``$this->request->data`` will
    contain the information saved for the ``User`` model), the value
    corresponding to ``id`` field will automatically be added to the HTML
    generated. Example for data[User][id] = 10:

    .. code-block:: html

        <input name="data[User][id]" id="UserId" type="hidden" value="10" />

    .. versionchanged:: 2.0
        隐藏字段不再去除（样式的）class 属性。这意味着如果隐藏字段有验证错误，错误字段的（样式）class 就会被应用。
        Hidden fields no longer remove the class attribute. This means
        that if there are validation errors on hidden fields, the
        error-field class name will be applied.

.. php:method:: textarea(string $fieldName, array $options)

    创建一个 textarea 类型的 input 字段。::

    Creates a textarea input field. ::

        echo $this->Form->textarea('notes');

    将会输出:

    Will output:

    .. code-block:: html

        <textarea name="data[User][notes]" id="UserNotes"></textarea>

    如果表单是用于修改（即，数组 ``$this->request->data`` 会包含 ``User`` 模型已经保存的数据），对应 ``notes`` 字段的值就会自动加到生成的 HTML 中。例如：

    If the form is edited (that is, the array ``$this->request->data`` will
    contain the information saved for the ``User`` model), the value
    corresponding to ``notes`` field will automatically be added to the HTML
    generated. Example:

    .. code-block:: html

        <textarea name="data[User][notes]" id="UserNotes">
        This text is to be edited.
        </textarea>

    .. note::

        ``textarea`` input 元素类型允许 ``$options`` 的属性 ``'escape'``，这决定 textarea 的内容是否要被转义。默认值为 ``true``。

        The ``textarea`` input type allows for the ``$options`` attribute
        of ``'escape'`` which determines whether or not the contents of the
        textarea should be escaped. Defaults to ``true``.

    ::

        echo $this->Form->textarea('notes', array('escape' => false);
        // 或者......
        // OR....
        echo $this->Form->input(
            'notes',
            array('type' => 'textarea', 'escape' => false)
        );


    **选项**

    **Options**

    除了 :ref:`general-input-options`，textarea() 方法支持一些特定的选项:

    In addition to the :ref:`general-input-options`, textarea() supports a few
    specific options:

    * ``$options['rows']，$options['cols']`` 这两个键指定行数和列数::

    * ``$options['rows'], $options['cols']`` These two keys specify the number of
      rows and columns::

        echo $this->Form->textarea(
            'textarea',
            array('rows' => '5', 'cols' => '5')
        );

      输出:

      Output:

      .. code-block:: html

        <textarea name="data[Form][textarea]" cols="5" rows="5" id="FormTextarea">
        </textarea>

.. php:method:: checkbox(string $fieldName, array $options)

    创建一个 checkbox 表单元素。该方法也会生成一个关联的 hidden 类型的表单 input 元素，强制提交指定字段的数据。::

    Creates a checkbox form element. This method also generates an
    associated hidden form input to force the submission of data for
    the specified field. ::

        echo $this->Form->checkbox('done');

    将会输出:

    Will output:

    .. code-block:: html

        <input type="hidden" name="data[User][done]" value="0" id="UserDone_" />
        <input type="checkbox" name="data[User][done]" value="1" id="UserDone" />

    可以用 $options 数组来给出 checkbox 的值::

    It is possible to specify the value of the checkbox by using the
    $options array::

        echo $this->Form->checkbox('done', array('value' => 555));

    将会输出:

    Will output:

    .. code-block:: html

        <input type="hidden" name="data[User][done]" value="0" id="UserDone_" />
        <input type="checkbox" name="data[User][done]" value="555" id="UserDone" />

    如果你不想让 Form 助件创建 hidden 类型的 input 元素::

    If you don't want the Form helper to create a hidden input::

        echo $this->Form->checkbox('done', array('hiddenField' => false));

    将会输出:

    Will output:

    .. code-block:: html

        <input type="checkbox" name="data[User][done]" value="1" id="UserDone" />


.. php:method:: radio(string $fieldName, array $options, array $attributes)

    创建一组 radio 按钮类型的 input 元素。

    Creates a set of radio button inputs.

    **选项**

    **Options**

    * ``$attributes['value']`` 设置哪个值作为默认值被选中。

    * ``$attributes['value']`` to set which value should be selected default.

    * ``$attributes['separator']`` 给出 radio 按钮之间的 HTML(例如 <br /)。

    * ``$attributes['separator']`` to specify HTML in between radio
      buttons (e.g. <br />).

    * ``$attributes['between']`` 给出在 legend 和第一个元素之间插入的内容。

    * ``$attributes['between']`` specify some content to be inserted between the
      legend and first element.

    * ``$attributes['disabled']`` 设置这个属性为 ``true`` 或 ``'disabled'`` 会禁用所有生成的 radio 按钮。

    * ``$attributes['disabled']`` Setting this to ``true`` or ``'disabled'``
      will disable all of the generated radio buttons.

    * ``$attributes['legend']`` 默认情况下 radio 元素会包裹在 label 和 fieldset 之中。设置 ``$attributes['legend']`` 为 false 来去掉这些。::

    * ``$attributes['legend']`` Radio elements are wrapped with a legend and
      fieldset by default. Set ``$attributes['legend']`` to false to remove
      them. ::

        $options = array('M' => 'Male', 'F' => 'Female');
        $attributes = array('legend' => false);
        echo $this->Form->radio('gender', $options, $attributes);

      将会输出:

      Will output:

      .. code-block:: html

        <input name="data[User][gender]" id="UserGender_" value=""
            type="hidden" />
        <input name="data[User][gender]" id="UserGenderM" value="M"
            type="radio" />
        <label for="UserGenderM">Male</label>
        <input name="data[User][gender]" id="UserGenderF" value="F"
            type="radio" />
        <label for="UserGenderF">Female</label>


    如果出于某些原因你不想要 hidden 类型的 input 元素，设置 ``$attributes['value']`` 为选中的值或布尔值 false 就可以了。

    If for some reason you don't want the hidden input, setting
    ``$attributes['value']`` to a selected value or boolean false will
    do just that.

    * ``$attributes['fieldset']`` 如果 legend 属性没有设置成 false，那么这个属性可以用来设置 fieldset 元素的样式类名。

    * ``$attributes['fieldset']`` If legend attribute is not set to false, then this
      attribute can be used to set the class of the fieldset element.


    .. versionchanged:: 2.1
        在 2.1 版本中增加了 ``$attributes['disabled']`` 选项。
        The ``$attributes['disabled']`` option was added in 2.1.

    .. versionchanged:: 2.8.5
        在 2.8.5 版本中增加了 ``$attributes['fieldset']`` 选项。
        The ``$attributes['fieldset']`` option was added in 2.8.5.


.. php:method:: select(string $fieldName, array $options, array $attributes)

    创建一个 select 元素，以 ``$options`` 中的项目填充，默认选中以 ``$attributes['value']`` 指定的选项。设置 ``$attributes`` 变量中的'empty'键为 false，就可以去掉默认的空选项::

    Creates a select element, populated with the items in ``$options``,
    with the option specified by ``$attributes['value']`` shown as selected by
    default. Set the 'empty' key in the ``$attributes`` variable to false to
    turn off the default empty option::

        $options = array('M' => 'Male', 'F' => 'Female');
        echo $this->Form->select('gender', $options);

    将会输出:

    Will output:

    .. code-block:: html

        <select name="data[User][gender]" id="UserGender">
        <option value=""></option>
        <option value="M">Male</option>
        <option value="F">Female</option>
        </select>

    ``select`` 类型可以有一个特殊的 ``$option`` 属性，叫做 ``'escape'``，它接受布尔值，决定是否对 select 选项的内容进行 HTML 实体编码(HTML entity encode)。默认为 true::

    The ``select`` input type allows for a special ``$option``
    attribute called ``'escape'`` which accepts a bool and determines
    whether to HTML entity encode the contents of the select options.
    Defaults to true::

        $options = array('M' => 'Male', 'F' => 'Female');
        echo $this->Form->select('gender', $options, array('escape' => false));

    * ``$attributes['options']`` 这个键允许你手动指定 select 元素或一组 radio 元素的选项。除非'type'设置为'radio'，否则 FormHelper 助件将会认为希望的输出为 select 元素::

    * ``$attributes['options']`` This key allows you to manually specify options for a
      select input, or for a radio group. Unless the 'type' is specified as 'radio',
      the FormHelper will assume that the target output is a select input::

        echo $this->Form->select('field', array(1,2,3,4,5));

      输出:

      Output:

      .. code-block:: html

        <select name="data[User][field]" id="UserField">
            <option value="0">1</option>
            <option value="1">2</option>
            <option value="2">3</option>
            <option value="3">4</option>
            <option value="4">5</option>
        </select>

      选项也可以用键-值对的方式提供::

      Options can also be supplied as key-value pairs::

        echo $this->Form->select('field', array(
            'Value 1' => 'Label 1',
            'Value 2' => 'Label 2',
            'Value 3' => 'Label 3'
        ));

      输出:

      Output:

      .. code-block:: html

        <select name="data[User][field]" id="UserField">
            <option value=""></option>
            <option value="Value 1">Label 1</option>
            <option value="Value 2">Label 2</option>
            <option value="Value 3">Label 3</option>
        </select>

      如果你想要生成带有 optgroups 的 select 元素，只需传入层级结构的数据。这也适用于多个 checkbox 元素和 radio 按钮元素，只是不用  optgroups，而是用 fieldsets 来包裹元素::

      If you would like to generate a select with optgroups, just pass
      data in hierarchical format. This works on multiple checkboxes and radio
      buttons too, but instead of optgroups wraps elements in fieldsets::

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

      Output:

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

    * ``$attributes['multiple']`` 如果对一个输出 select 的 input 设置'multiple'为 true，该 select 就会允许多选::

    * ``$attributes['multiple']`` If 'multiple' has been set to true for an input that
      outputs a select, the select will allow multiple selections::

        echo $this->Form->select(
            'Model.field',
            $options,
            array('multiple' => true)
        );

      另外也可以设置'multiple'为'checkbox'，来输出一组相互关联的 check box::

      Alternatively set 'multiple' to 'checkbox' to output a list of
      related check boxes::

        $options = array(
            'Value 1' => 'Label 1',
            'Value 2' => 'Label 2'
        );
        echo $this->Form->select('Model.field', $options, array(
            'multiple' => 'checkbox'
        ));

      输出:

      Output:

      .. code-block:: html

        <div class="input select">
           <label for="ModelField">Field</label>
           <input name="data[Model][field]" value="" id="ModelField"
            type="hidden">
           <div class="checkbox">
              <input name="data[Model][field][]" value="Value 1"
                id="ModelField1" type="checkbox">
              <label for="ModelField1">Label 1</label>
           </div>
           <div class="checkbox">
              <input name="data[Model][field][]" value="Value 2"
                id="ModelField2" type="checkbox">
              <label for="ModelField2">Label 2</label>
           </div>
        </div>

    * ``$attributes['disabled']`` 当创建 checkbox 时，可以设置这个选项为 ``true`` 来禁用全部或者一些 checkbox。要禁用全部 checkbox，设置 disabled 为 ``true``::

    * ``$attributes['disabled']`` When creating checkboxes, this option can be set
      to disable all or some checkboxes. To disable all checkboxes set disabled
      to ``true``::

        $options = array(
            'Value 1' => 'Label 1',
            'Value 2' => 'Label 2'
        );
        echo $this->Form->select('Model.field', $options, array(
            'multiple' => 'checkbox',
            'disabled' => array('Value 1')
        ));

      输出:

      Output:

      .. code-block:: html

        <div class="input select">
           <label for="ModelField">Field</label>
           <input name="data[Model][field]" value="" id="ModelField"
            type="hidden">
           <div class="checkbox">
              <input name="data[Model][field][]" disabled="disabled"
                value="Value 1" id="ModelField1" type="checkbox">
              <label for="ModelField1">Label 1</label>
           </div>
           <div class="checkbox">
              <input name="data[Model][field][]" value="Value 2"
                id="ModelField2" type="checkbox">
              <label for="ModelField2">Label 2</label>
           </div>
        </div>

    .. versionchanged:: 2.3
        ``$attributes['disabled']`` 对数组的支持是在2.3版本中增加的。
        Support for arrays in ``$attributes['disabled']`` was added in 2.3.

.. php:method:: file(string $fieldName, array $options)

    要在表单中增加一个文件上传字段，你必须首先确保表单的 enctype 设置为"multipart/form-data"，所以要用下面这样的 create 函数开始::

    To add a file upload field to a form, you must first make sure that
    the form enctype is set to "multipart/form-data", so start off with
    a create function such as the following::

        echo $this->Form->create('Document', array(
            'enctype' => 'multipart/form-data'
        ));
        // 或者
        // OR
        echo $this->Form->create('Document', array('type' => 'file'));

    然后添加下面两行之一到表单视图文件中::

    Next add either of the two lines to your form view file::

        echo $this->Form->input('Document.submittedfile', array(
            'between' => '<br />',
            'type' => 'file'
        ));

        // 或者
        // OR

        echo $this->Form->file('Document.submittedfile');

    鉴于 HTML 本身的限制，无法为'file'类型的 input 字段设置默认值。每次表单显示时，其值为空。

    Due to the limitations of HTML itself, it is not possible to put
    default values into input fields of type 'file'. Each time the form
    is displayed, the value inside will be empty.

    在提交时，file 字段提供一个扩展的数据数组给接受表单数据的脚本（*script*）。

    Upon submission, file fields provide an expanded data array to the
    script receiving the form data.

    对于上面的例子，如果 CakePHP 安装在 Windows 服务器上，在提交的数据数组中的值将有如下结构。在 Unix 环境下'tmp\_name'会有不同的路径::

    For the example above, the values in the submitted data array would
    be organized as follows, if the CakePHP was installed on a Windows
    server. 'tmp\_name' will have a different path in a Unix
    environment::

        $this->request->data['Document']['submittedfile'] = array(
            'name' => 'conference_schedule.pdf',
            'type' => 'application/pdf',
            'tmp_name' => 'C:/WINDOWS/TEMP/php1EE.tmp',
            'error' => 0,
            'size' => 41737,
        );

    这个数组是 PHP 本身生成的，所以要了解 PHP 如何处理通过 file 字段传递的数据，请 `阅读 PHP 手册中关于文件上载的章节 <http://php.net/features.file-upload>`_。

    This array is generated by PHP itself, so for more detail on the
    way PHP handles data passed via file fields
    `read the PHP manual section on file uploads <http://php.net/features.file-upload>`_.

验证（文件）上载
------------------

Validating Uploads
------------------

下面是一个验证方法的例子，可以定义在模型中来验证文件上载是否成功::

Below is an example validation method you could define in your
model to validate whether a file has been successfully uploaded::

    public function isUploadedFile($params) {
        $val = array_shift($params);
        if ((isset($val['error']) && $val['error'] == 0) ||
            (!empty( $val['tmp_name']) && $val['tmp_name'] != 'none')
        ) {
            return is_uploaded_file($val['tmp_name']);
        }
        return false;
    }

创建 file 类型的 input 元素::

Creates a file input::

    echo $this->Form->create('User', array('type' => 'file'));
    echo $this->Form->file('avatar');

将会输出:

Will output:

.. code-block:: html

    <form enctype="multipart/form-data" method="post" action="/users/add">
    <input name="data[User][avatar]" value="" id="UserAvatar" type="file">

.. note::

    当使用 ``$this->Form->file()`` 方法时，记得要通过在 ``$this->Form->create()`` 方法中设置类型选项为'file'来设置表单的编码类型。

    When using ``$this->Form->file()``, remember to set the form
    encoding-type, by setting the type option to 'file' in
    ``$this->Form->create()``


创建按键和提交元素
====================================

Creating buttons and submit elements
====================================

.. php:method:: submit(string $caption, array $options)

    创建带有标题 ``$caption`` 的提交按键。如果给出的 ``$caption`` 是一个图像的网址（含有‘.’字符），提交按键就会渲染为图像。

    Creates a submit button with caption ``$caption``. If the supplied
    ``$caption`` is a URL to an image (it contains a '.' character),
    the submit button will be rendered as an image.

    默认情况下它会被包括在 ``div`` 标签内；你可以通过声明 ``$options['div'] = false`` 来避免::

    It is enclosed between ``div`` tags by default; you can avoid this
    by declaring ``$options['div'] = false``::

        echo $this->Form->submit();

    将会输出:

    Will output:

    .. code-block:: html

        <div class="submit"><input value="Submit" type="submit"></div>

    你可以为 caption 参数传入一个图像的相对或绝对网址，而不是标题文字。::

    You can also pass a relative or absolute URL to an image for the
    caption parameter instead of caption text. ::

        echo $this->Form->submit('ok.png');

    将会输出:

    Will output:

    .. code-block:: html

        <div class="submit"><input type="image" src="/img/ok.png"></div>

.. php:method:: button(string $title, array $options = array())

    创建 HTML 按键，带有指定的标题和默认的类型"button"。设置 ``$options['type']`` 可以输出三种可能的按键类型中的一种:

    Creates an HTML button with the specified title and a default type
    of "button". Setting ``$options['type']`` will output one of the
    three possible button types:

    #. submit: 等同于``$this->Form->submit``方法——(默认值)。
    #. reset: 创建一个表单重置按键。
    #. button: 创建一个标准的按键。

    #. submit: Same as the ``$this->Form->submit`` method - (the
       default).
    #. reset: Creates a form reset button.
    #. button: Creates a standard push button.

    ::

        echo $this->Form->button('A Button');
        echo $this->Form->button('Another Button', array('type' => 'button'));
        echo $this->Form->button('Reset the Form', array('type' => 'reset'));
        echo $this->Form->button('Submit Form', array('type' => 'submit'));

    将会输出:

    Will output:

    .. code-block:: html

        <button type="submit">A Button</button>
        <button type="button">Another Button</button>
        <button type="reset">Reset the Form</button>
        <button type="submit">Submit Form</button>


    ``button`` 类型的 input 元素支持 ``escape`` 选项，该选项接受布尔值，决定是否 HTML 实体编码（*HTML entity encode*）按键的 $title。
    默认值为 false::

    The ``button`` input type supports the ``escape`` option, which accepts a
    bool and determines whether to HTML entity encode the $title of the button.
    Defaults to false::

        echo $this->Form->button('Submit Form', array(
            'type' => 'submit',
            'escape' => true
        ));

.. php:method:: postButton(string $title, mixed $url, array $options = array ())

    创建一个 ``<button>`` 标签，包裹在用 POST 方式提交的 ``<form>`` 标签内。

    Create a ``<button>`` tag with a surrounding ``<form>`` that submits via
    POST.

    这个方法创建 ``<form>`` 元素。所以不要在表单内使用这个方法，而是应当使用 :php:meth:`FormHelper::submit()` 或者 :php:meth:`FormHelper::button()` 在表单内创建按键。

    This method creates a ``<form>`` element. So do not use this method in some
    opened form. Instead use :php:meth:`FormHelper::submit()` or
    :php:meth:`FormHelper::button()` to create buttons inside opened forms.

.. php:method:: postLink(string $title, mixed $url = null, array $options = array ())

    创建一个 HTML 链接，但使用 POST 来访问该链接。要求浏览器启用 javascript。

    Creates an HTML link, but access the URL using method POST. Requires
    JavaScript to be enabled in browser.

    该方法创建一个 ``<form>`` 元素。如果你要在现有表单中使用该方法，必须用 ``inline`` 或 ``block`` 选项，这样新的表单就生成会在现有表单之外。

    This method creates a ``<form>`` element. If you want to use this method
    inside of an existing form, you must use the ``inline`` or ``block`` options
    so that the new form can be rendered outside of the existing form.

    如果你需要的只是一个按键来提交表单，那么就应当使用 :php:meth:`FormHelper::submit()`。

    If all you are looking for is a button to submit your form, then you should
    use :php:meth:`FormHelper::submit()` instead.

    .. versionchanged:: 2.3
        增加了 ``method`` 选项。
        The ``method`` option was added.

    .. versionchanged:: 2.5
        增加了 ``inline`` 和 ``block`` 选项。这允许缓存生成的 form 标签，而不是直接返回。这有助于避免嵌套的 form 标签。设置 ``'inline' => false`` 会把 form 标签加到 ``postLink`` 代码块，不过如果你想使用自定义的代码块，可以转而用 ``block`` 选项指定自定义代码块。
        The ``inline`` and ``block`` options were added. They allow buffering
        the generated form tag, instead of returning with the link. This helps
        avoiding nested form tags. Setting ``'inline' => false`` will add
        the form tag to the ``postLink`` content block, if you want to use a
        custom block you can specify it using the ``block`` option instead.

    .. versionchanged:: 2.6
        参数 ``$confirmMessage`` 已经作废。请使用 ``$options`` 中的 ``confirm`` 键。
        The argument ``$confirmMessage`` was deprecated. Use ``confirm`` key
        in ``$options`` instead.

创建日期和时间类型的 input 元素
================================

Creating date and time inputs
=============================

.. php:method:: dateTime($fieldName, $dateFormat = 'DMY', $timeFormat = '12', $attributes = array())

    为日期和时间创建一组 select 类型的标签。$dateFormat 的合法值为'DMY'，'MDY'，'YMD'或者'NONE'。$timeFormat的合法值为'12'，'24'和 null。

    Creates a set of select inputs for date and time. Valid values for
    $dateformat are 'DMY', 'MDY', 'YMD' or 'NONE'. Valid values for
    $timeFormat are '12', '24', and null.

    你可以通过在 attributes 参数中设置 "array('empty' => false)"来不显示空值。它也会用当前日期和时间预选(相应的)字段。

    You can specify not to display empty values by setting
    "array('empty' => false)" in the attributes parameter. It will also
    pre-select the fields with the current datetime.

.. php:method:: year(string $fieldName, int $minYear, int $maxYear, array $attributes)

    创建一个 select 元素，填充以从 ``$minYear`` 到 ``$maxYear`` 的年份。HTML 属性可以在 $attributes 参数中提供。如果 ``$attributes['empty']`` 为 false，select 元素就不会包括空选项::

    Creates a select element populated with the years from ``$minYear``
    to ``$maxYear``. HTML attributes may be supplied in $attributes. If
    ``$attributes['empty']`` is false, the select will not include an
    empty option::

        echo $this->Form->year('purchased', 2000, date('Y'));

    将会输出:

    Will output:

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

    Creates a select element populated with month names::

        echo $this->Form->month('mob');

    将会输出:

    Will output:

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

    你可以通过设置'monthNames'属性来传入自己要使用的月份数组，或者传入 false 来让月份显示为数字。（注意: 默认的月份是国际化的，而且可以用本地化来翻译。）::

    You can pass in your own array of months to be used by setting the
    'monthNames' attribute, or have months displayed as numbers by
    passing false. (Note: the default months are internationalized and
    can be translated using localization.)::

        echo $this->Form->month('mob', array('monthNames' => false));

.. php:method:: day(string $fieldName, array $attributes)

    创建一个 select 元素，填充以月份的(数字)日子。

    Creates a select element populated with the (numerical) days of the
    month.

    要添加一个带有你选择的提示文字的空选项(例如，第一个选项为'Day')，你可以在最后一个参数中提供该(提示)文字，如下所示::

    To create an empty option with prompt text of your choosing (e.g.
    the first option is 'Day'), you can supply the text as the final
    parameter as follows::

        echo $this->Form->day('created');

    将会输出:

    Will output:

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

    Creates a select element populated with the hours of the day.

.. php:method:: minute(string $fieldName, array $attributes)

    创建一个 select 元素，填充以一个小时中的各个分钟。

    Creates a select element populated with the minutes of the hour.

.. php:method:: meridian(string $fieldName, array $attributes)

    创建一个 select 元素，填充以 'am' 和 'pm'。

    Creates a select element populated with 'am' and 'pm'.


显示及检查错误
==============================

Displaying and checking errors
==============================

.. php:method:: error(string $fieldName, mixed $text, array $options)

    当验证错误产生时，显示由 $text 指定的针对给定字段的验证错误信息。

    Shows a validation error message, specified by $text, for the given
    field, in the event that a validation error has occurred.

    选项:

    Options:

    -  'escape' bool 是否 html 转义错误内容。
    -  'wrap' mixed 是否将错误信息包裹在 div 中。如果是字符串，就会作为 HTML 标签使用。
    -  'class' string 错误信息的（样式）类名。

    -  'escape' bool Whether or not to HTML escape the contents of the
       error.
    -  'wrap' mixed Whether or not the error message should be wrapped
       in a div. If a string, will be used as the HTML tag to use.
    -  'class' string The class name for the error message

.. php:method:: isFieldError(string $fieldName)

    如果提供的 $fieldName 字段有验证错误，返回 true。::

    Returns true if the supplied $fieldName has an active validation
    error. ::

        if ($this->Form->isFieldError('gender')) {
            echo $this->Form->error('gender');
        }

    .. note::

        当使用 :php:meth:`FormHelper::input()` 方法时，默认情况下错误会显示。

        When using :php:meth:`FormHelper::input()`, errors are rendered by default.

.. php:method:: tagIsInvalid()

    如果由当前项描述的给定表单字段没有错误，就返回 false，否则就返回验证错误。

    Returns false if given form field described by the current entity has no
    errors. Otherwise it returns the validation message.


对所有字段设置默认值
===============================

Setting Defaults for all fields
===============================

.. versionadded:: 2.2

你可以使用 :php:meth:`FormHelper::inputDefaults()` 为 ``input()`` 方法声明一组默认值。改变默认选项允许你把重复的选项合并为一个方法调用::

You can declare a set of default options for ``input()`` using
:php:meth:`FormHelper::inputDefaults()`. Changing the default options allows
you to consolidate repeated options into a single method call::

    $this->Form->inputDefaults(array(
            'label' => false,
            'div' => false,
            'class' => 'fancy'
        )
    );

从此所有创建的 input 元素会继承在 inputDefaults 选项中声明的选项。你可以在 input() 的调用中声明选项来改变默认的选项::

All inputs created from that point forward will inherit the options declared in
inputDefaults. You can override the default options by declaring the option in the
input() call::

    echo $this->Form->input('password'); // 没有 div，没有 label，带有'fancy'样式类 No div, no label with class 'fancy'
    // 带有 label 及同样的默认选项
    // has a label element same defaults
    echo $this->Form->input(
        'username',
        array('label' => 'Username')
    );

与 SecurityComponent 组件一起使用
==================================

Working with SecurityComponent
==============================

:php:meth:`SecurityComponent` 组件提供了一些特性，使你的表单更加安全可靠。只需在控制器中引用 ``SecurityComponent``，你就自动获得（针对） CSRF 和表单篡改（*form tampering*）的特性。

:php:meth:`SecurityComponent` offers several features that make your forms safer
and more secure. By simply including the ``SecurityComponent`` in your
controller, you'll automatically benefit from CSRF and form tampering features.

正如之前所说，当使用 SecurityComponent 组件时，你应当总是使用 :php:meth:`FormHelper::end()` 结束你的表单。这会保证生成特殊的 ``_Token`` input 元素。

As mentioned previously when using SecurityComponent, you should always close
your forms using :php:meth:`FormHelper::end()`. This will ensure that the
special ``_Token`` inputs are generated.

.. php:method:: unlockField($name)

    对一个字段解锁，使得该字段免于 ``SecurityComponent`` 的字段散列化（*hashing*）。这样可以让字段用 Javascript 操纵。``$name`` 参数应当是 input 元素的字段名称::

    Unlocks a field making it exempt from the ``SecurityComponent`` field
    hashing. This also allows the fields to be manipulated by JavaScript.
    The ``$name`` parameter should be the entity name for the input::

        $this->Form->unlockField('User.id');

.. php:method:: secure(array $fields = array())

    基于表单中使用的多个字段，生成带有安全散列值的隐藏字段。

    Generates a hidden field with a security hash based on the fields used
    in the form.

.. _form-improvements-1-3:

2.0 updates
===========

**$selected 参数去掉了**

**$selected parameter removed**

``$selected`` 参数从 FormHelper 助件的几个方法中去掉了。所有的方法现在支持 ``$attributes['value']`` 键，应当用它来代替 ``$selected``。这个改变简化了 FormHelper 助件的方法，减少了参数的数量，并减轻了 ``$selected`` 导致的重复。受此影响的方法有:

The ``$selected`` parameter was removed from several methods in
FormHelper. All methods now support a ``$attributes['value']`` key
now which should be used in place of ``$selected``. This change
simplifies the FormHelper methods, reducing the number of
arguments, and reduces the duplication that ``$selected`` created.
The effected methods are:

    * FormHelper::select()
    * FormHelper::dateTime()
    * FormHelper::year()
    * FormHelper::month()
    * FormHelper::day()
    * FormHelper::hour()
    * FormHelper::minute()
    * FormHelper::meridian()

**表单的默认地址就是当前的动作**

**Default URLs on forms is the current action**

所有表单的默认地址，现在就是当前地址。包括传入（*passed*）、命名（*named*）和查询字符串g*querystring*）参数。你可以通过在 ``$this->Form->create()`` 方法的第二个参数中提供 ``$options['url']`` 来改变默认值。

The default URL for all forms, is now the current URL including
passed, named, and querystring parameters. You can override
this default by supplying ``$options['url']`` in the second
parameter of ``$this->Form->create()``


**FormHelper::hidden()**

隐藏字段不再去掉 class 属性。这意味着如果隐藏字段有验证错误，错误字段的（样式）类名就会起作用。

Hidden fields no longer remove the class attribute. This means
that if there are validation errors on hidden fields,
the error-field class name will be applied.


.. meta::
    :title lang=zh: FormHelper
    :description lang=zh: The FormHelper focuses on creating forms quickly, in a way that will streamline validation, re-population and layout.
    :keywords lang=zh: html helper,cakephp html,form create,form input,form select,form file field,form label,form text,form password,form checkbox,form radio,form submit,form date time,form error,validate upload,unlock field,form security