数据验证
Data Validation
###############

数据验证是任何应用程序的重要组成部分, 因为这确保模型中的数据符合应用程序的业务规则。例如, 你也许要确保密码至少有八个字符, 或者用户名是唯一的。定义验证规则使得表单的处理容易得多得多。
Data validation is an important part of any application, as it
helps to make sure that the data in a Model conforms to the
business rules of the application. For example, you might want to
make sure that passwords are at least eight characters long, or
ensure that usernames are unique. Defining validation rules makes
form handling much, much easier.

验证过程有很多方面。本节中我们只涉及模型中的部分。基本上: 当你调用模型的 save() 方法时会发生什么。关于如何处理验证错误的显示的更多信息, 请参看:doc:`/core-libraries/helpers/form`。
There are many different aspects to the validation process. What
we’ll cover in this section is the model side of things.
Essentially: what happens when you call the save() method of your
model. For more information about how to handle the displaying of
validation errors, check out
:doc:`/core-libraries/helpers/form`.

数据验证的第一步是在模型中建立验证规则。这要用到 Model::validate 数组, 例如::
The first step to data validation is creating the validation rules
in the Model. To do that, use the Model::validate array in the
Model definition, for example::

    class User extends AppModel {
        public $validate = array();
    }

在上面的例子中, ``$validate`` 数组被加到 User 模型中, 但此数组还不包含任何验证规则。假设 users 表中有 login, password, email 和 born 这些字段, 在下面的例子中是一些针对这些字段的简单验证规则::
In the example above, the ``$validate`` array is added to the User
Model, but the array contains no validation rules. Assuming that
the users table has login, password, email and born fields, the
example below shows some simple validation rules that apply to
those fields::

    class User extends AppModel {
        public $validate = array(
            'login' => 'alphaNumeric',
            'email' => 'email',
            'born'  => 'date'
        );
    }

上面的例子说明验证规则如何针对模型的字段。login 字段只接受字母和数字, email 应当是合法的电子邮件, 以及 born 应当是合法的日期。定义了验证规则之后, 如果提交的数据不符合定义的规则, CakePHP 就能够在表单中自动显示错误信息。
This last example shows how validation rules can be added to model
fields. For the login field, only letters and numbers will be
accepted, the email should be valid, and born should be a valid
date. Defining validation rules enables CakePHP’s automagic showing
of error messages in forms if the data submitted does not follow
the defined rules.

CakePHP 有许多验证规则, 使用起来相当容易。一些内置的验证规则让你可以检查电子邮件, 网址和信用卡的格式 - 不过我们稍后才会详细介绍这些。
CakePHP has many validation rules and using them can be quite easy.
Some of the built-in rules allow you to verify the formatting of
emails, URLs, and credit card numbers – but we’ll cover these in
detail later on.

这是一个利用这些内置验证规则的更复杂的例子::
Here is a more complex validation example that takes advantage of
some of these built-in validation rules::

    class User extends AppModel {
        public $validate = array(
            'login' => array(
                'alphaNumeric' => array(
                    'rule'     => 'alphaNumeric',
                    'required' => true,
                    'message'  => '只接受字母和数字 Alphabets and numbers only'
                ),
                'between' => array(
                    'rule'    => array('between', 5, 15),
                    'message' => '5到15个字符 Between 5 to 15 characters'
                )
            ),
            'password' => array(
                'rule'    => array('minLength', '8'),
                'message' => '最少8个字符长 Minimum 8 characters long'
            ),
            'email' => 'email',
            'born' => array(
                'rule'       => 'date',
                'message'    => '请输入合法的日期 Enter a valid date',
                'allowEmpty' => true
            )
        );
    }

login 字段有两个验证规则: 它只能包含字母和数字, 长度介于5到15之间。password 字段至少要有8个字符长。email 字段必须是合法的电子邮件, 而born 字段必须是合法的日期。另外, 请注意如何定义在这些验证规则被违反时 CakePHP 可以使用的错误信息 。
Two validation rules are defined for login: it should contain
letters and numbers only, and its length should be between 5 and
15. The password field should be a minimum of 8 characters long.
The email should be a valid email address, and born should be a
valid date. Also, notice how you can define specific error messages
that CakePHP will use when these validation rules fail.

如上例所示, 一个字段可以有多个验证规则。另外, 如果内置的规则不符合你的要求, 在必要时你总是可以增加自己的验证规则。
As the example above shows, a single field can have multiple
validation rules. And if the built-in rules do not match your
criteria, you can always add your own validation rules as
required.

现在你已经看到验证大致是如何工作的, 让我们再来看看这些规则在模型中是如何定义的。定义验证规则有三种不同的方式: 简单的数组, 一个字段仅一个规则, 一个字段有多个规则。
Now that you’ve seen the big picture on how validation works, let’s
look at how these rules are defined in the model. There are three
different ways that you can define validation rules: simple arrays,
single rule per field, and multiple rules per field.


简单的规则
Simple Rules
============

正如名称所说的, 这是定义验证规则最简单的方式。其通常的语法为::
As the name suggests, this is the simplest way to define a
validation rule. The general syntax for defining rules this way
is::

    public $validate = array('fieldName' => 'ruleName');

其中, 'fieldName' 是定义规则的字段名称, ‘ruleName’ 是预先定义的规则名称, 比如'alphaNumeric', 'email' 或者 'isUnique'。
Where, 'fieldName' is the name of the field the rule is defined
for, and ‘ruleName’ is a pre-defined rule name, such as
'alphaNumeric', 'email' or 'isUnique'.

例如, 为确保用户提供正确格式的电子邮件地址, 你可以使用这个规则:
For example, to ensure that the user is giving a well formatted
email address, you could use this rule::

    public $validate = array('user_email' => 'email');


一个字段一个规则
One Rule Per Field
==================

这种定义方式可以更好地控制验证规则如何起作用。但在讨论这些之前, 让我们先来看看给一个字段加一个规则的常用模式::
This definition technique allows for better control of how the
validation rules work. But before we discuss that, let’s see the
general usage pattern adding a rule for a single field::

    public $validate = array(
        'fieldName1' => array(
            'rule'       => 'ruleName', // or: array('ruleName', 'param1', 'param2' ...)
            'required'   => true,
            'allowEmpty' => false,
            'on'         => 'create', // or: 'update'
            'message'    => '你的错误信息 Your Error Message'
        )
    );

'rule' 键是必需的。如果你只设置 'required' => true, 表单验证不会正常工作。这是因为'required' 实际上不是一个规则。
The 'rule' key is required. If you only set 'required' => true, the
form validation will not function correctly. This is because
'required' is not actually a rule.

这里你可以看到, 每个字段(上面只显示了一个字段)与一个数组联系在一起, 该数组有5个键:‘rule’,
‘required’, ‘allowEmpty’, ‘on’ 和 ‘message’。让我们更仔细地看看这些键。
As you can see here, each field (only one field shown above) is
associated with an array that contains five keys: ‘rule’,
‘required’, ‘allowEmpty’, ‘on’ and ‘message’. Let’s have a closer
look at these keys.

rule
----

'rule' 键定义了验证的方法, 对应的可以是单一的值, 也可以是一个数组。指定的 'rule' 可以是模型的方法, 核心验证类的方法, 或者正则表达式。关于默认情况下可用的规则的更多信息, 请参看 :ref:`core-validation-rules`。
The 'rule' key defines the validation method and takes either a
single value or an array. The specified 'rule' may be the name of a
method in your model, a method of the core Validation class, or a
regular expression. For more information on the rules available by
default, see
:ref:`core-validation-rules`.

如果规则不要求任何参数, 'rule' 就可以是单一值, 例如::
If the rule does not require any parameters, 'rule' can be a single
value e.g.::

    public $validate = array(
        'login' => array(
            'rule' => 'alphaNumeric'
        )
    );

如果规则要求一些参数(比如最大值, 最小值或者范围), 'rule' 就应当是一个数组::
If the rule requires some parameters (like the max, min or range),
'rule' should be an array::

    public $validate = array(
        'password' => array(
            'rule' => array('minLength', 8)
        )
    );

谨记, 'rule' 键对于用数组定义的规则是必需的。
Remember, the 'rule' key is required for array-based rule
definitions.

required
--------

这个键接受布尔值, ``create`` 或者 ``update``。把这个键置为 ``true`` 就会使该字段总是必需的。而把它设成 ``create`` 或  ``update`` 就会使该字段仅在创建或者更新操作时是必需的。如果 'required' 的值为真, 则该字段在数据数组中必须存在。例如, 如果验证规则如下定义::
This key accepts either a boolean, or ``create`` or ``update``.  Setting this
key to ``true`` will make the field always required.  While setting it to
``create`` or ``update`` will make the field required only for update or  create
operations. If 'required' is evaluated to true, the field must be present in the
data array.  For example, if the validation rule has been defined as follows::

    public $validate = array(
        'login' => array(
            'rule'     => 'alphaNumeric',
            'required' => true
        )
    );

传给模型的 save() 方法的数据中必须包括 login 字段, 否则验证就会失败。该键的缺省值为布尔类型 false。
The data sent to the model’s save() method must contain data for
the login field. If it doesn’t, validation will fail. The default
value for this key is boolean false.

``required => true`` 和验证规则 ``notEmpty()`` 并不是一回事。``required => true`` 意味着数组的*键*必须存在 - 这不意味着必须有值。所以, 如果字段在数据集中不存在, 验证就会失败, 但如果提交的值为空(''), 验证有可能(取决于规则)会成功。
``required => true`` does not mean the same as the validation rule
``notEmpty()``. ``required => true`` indicates that the array *key*
must be present - it does not mean it must have a value. Therefore
validation will fail if the field is not present in the dataset,
but may (depending on the rule) succeed if the value submitted is
empty ('').

.. versionchanged:: 2.1增加了对 ``create`` 和 ``update`` 的支持。
.. versionchanged:: 2.1
    Support for ``create`` and ``update`` were added.

allowEmpty
----------

如果设为 ``false``, 字段的值必须为*不空*, 而"不空"定义为 ``!empty($value) || is_numeric($value)``。对数字的检查是为了使 CakePHP 能正确处理 ``$value`` 为零的情况。
If set to ``false``, the field value must be **nonempty**, where
"nonempty" is defined as ``!empty($value) || is_numeric($value)``.
The numeric check is so that CakePHP does the right thing when
``$value`` is zero.

``required`` 和 ``allowEmpty`` 的区别可能令人迷惑。``'required' => true`` 意味着, 在 ``$this->data`` 中没有该字段的*键*, 你就不能保存模型(检查使用的是 ``isset``); 然而, ``'allowEmpty' => false`` 确保当前字段的*值*不为空, 如前所述。
The difference between ``required`` and ``allowEmpty`` can be
confusing. ``'required' => true`` means that you cannot save the
model without the *key* for this field being present in
``$this->data`` (the check is performed with ``isset``); whereas,
``'allowEmpty' => false`` makes sure that the current field *value*
is nonempty, as described above.

on
--

'on'键可以设置为下列值之一: 'update' 或者 'create'。这提供了一种机制, 允许某个规则要么在创建新记录时起作用, 要么在更新记录时起作用。
The 'on' key can be set to either one of the following values:
'update' or 'create'. This provides a mechanism that allows a
certain rule to be applied either during the creation of a new
record, or during update of a record.

如果一条规则含有 'on' => 'create', 该规则只会在记录创建时执行。类似的, 如果定义为 'on' =>'update', 则只会在记录更新时执行。
If a rule has defined 'on' => 'create', the rule will only be
enforced during the creation of a new record. Likewise, if it is
defined as 'on' => 'update', it will only be enforced during the
updating of a record.

'on' 的缺省值是 null。当 'on' 为 null 时, 规则在创建和更新时都会执行。
The default value for 'on' is null. When 'on' is null, the rule
will be enforced during both creation and update.

message
-------

message键允许你为规则定制验证错误信息::
The message key allows you to define a custom validation error
message for the rule::

    public $validate = array(
        'password' => array(
            'rule'    => array('minLength', 8),
            'message' => '密码至少8个字符长Password must be at least 8 characters long'
        )
    );

一个字段多条规则
Multiple Rules per Field
========================

上面给出的方法比简单的规则赋值提供了更多的灵活性, 但我们可以更进一步, 就可以更细致地控制数据验证。下面介绍的方法允许我们对一个字段设置多条验证规则。
The technique outlined above gives us much more flexibility than
simple rules assignment, but there’s an extra step we can take in
order to gain more fine-grained control of data validation. The
next technique we’ll outline allows us to assign multiple
validation rules per model field.

如果你想要给一个字段设置多条验证规则, 基本上就是这样::
If you would like to assign multiple validation rules to a single
field, this is basically how it should look::

    public $validate = array(
        '字段名fieldName' => array(
            '规则名称ruleName' => array(
                'rule' => '规则名称ruleName',
                // 其他的键, 比如 on, required等等, 放在这里 extra keys like on, required, etc. go here...
            ),
            '规则名称ruleName2' => array(
                'rule' => '规则名称ruleName2',
                // 其他的键, 比如 on, required等等, 放在这里 extra keys like on, required, etc. go here...
            )
        )
    );

你可以看到, 这很象我们在前一节做的。在前一节, 对每个字段我们只有一个数组的验证参数。而现在, 每个'字段名'有一个数组的规则索引。每个'规则名称'有一个单独数组的验证参数。
As you can see, this is quite similar to what we did in the
previous section. There, for each field we had only one array of
validation parameters. In this case, each ‘fieldName’ consists of
an array of rule indices. Each 'ruleName' contains a separate array
of validation parameters.

用一个实际的例子能够更好地说明::
This is better explained with a practical example::

    public $validate = array(
        'login' => array(
            'login 规则Rule-1' => array(
                'rule'    => 'alphaNumeric',
                'message' => '只允许字母和数字Only alphabets and numbers allowed',
             ),
            'login 规则Rule-2' => array(
                'rule'    => array('minLength', 8),
                'message' => '最少8个字符Minimum length of 8 characters'
            )
        )
    );

上面的例子对 login 字段设置了2个规则: login 规则-1和 login 规则-2。你可以看到, 每个规则都由一个随意选定的名字标识。
The above example defines two rules for the login field:
loginRule-1 and loginRule-2. As you can see, each rule is
identified with an arbitrary name.

当对一个字段使用多条规则时, 'required'和'allowEmpty'只需在第一条规则中设置一次。
When using multiple rules per field the 'required' and 'allowEmpty'
keys need to be used only once in the first rule.

last
-------

当一个字段有多条规则时, 缺省情况下, 如果一条规则验证失败, 那么这条规则的错误信息就会返回, 而该字段的其它规则就不会继续执行了。如果你希望,即使在一条规则验证失败时, 验证也继续执行, 就把该条规则的``last``设置为``false``。
In case of multiple rules per field by default if a particular rule
fails error message for that rule is returned and the following rules
for that field are not processed. If you want validation to continue
in spite of a rule failing set key ``last`` to ``false`` for that rule.

在下面的例子中, 就算'规则1'验证失败, '规则2'也会继续执行, 而且, 如果'规则2'也未失败, 则2条失败规则的错误信息都会返回::
In the following example even if "rule1" fails "rule2" will be processed
and error messages for both failing rules will be returned if "rule2" also
fails::

    public $validate = array(
        'login' => array(
            '规则rule1' => array(
                'rule'    => 'alphaNumeric',
                'message' => '只允许字母和数字Only alphabets and numbers allowed',
                'last'    => false
             ),
            '规则rule2' => array(
                'rule'    => array('minLength', 8),
                'message' => '最少8个字符Minimum length of 8 characters'
            )
        )
    );

当使用这种数组设置验证规则时, 可以不必有 ``message`` 键。考虑下面的例子::
When specifying validation rules in this array form its possible to avoid
providing the ``message`` key. Consider this example::

    public $validate = array(
        'login' => array(
            '只允许字母和数字Only alphabets and numbers allowed' => array(
                'rule'    => 'alphaNumeric',
             ),
        )
    );

如果 ``alphaNumeric`` 规则验证失败, 因为没有 ``message`` 键, 数组中该规则的键'只允许字母和数字'就会作为错误信息返回。
If the ``alphaNumeric`` rules fails the array key for this rule
'Only alphabets and numbers allowed' will be returned as error message since
the ``message`` key is not set.


定制的验证规则
Custom Validation Rules
=======================

如果你到此还没有找到你需要的, 你总是能够创建你自己的验证规则。有两种方法: 用定制的正则表达式, 或者创建定制的验证方法。
If you haven’t found what you need thus far, you can always create
your own validation rules. There are two ways you can do this: by
defining custom regular expressions, or by creating custom
validation methods.

使用定制的正则表达式进行验证
Custom Regular Expression Validation
------------------------------------

如果你需要的验证可以使用正则表达式匹配完成, 那么你就可以设置定制的正则表达式作为字段验证规则::
If the validation technique you need to use can be completed by
using regular expression matching, you can define a custom
expression as a field validation rule::

    public $validate = array(
        'login' => array(
            'rule'    => '/^[a-z0-9]{3,}$/i',
            'message' => '只允许字母和数字, 至少3个字符Only letters and integers, min 3 characters'
        )
    );

上面的例子检查 login 字段是否只包含字母和数字, 至少3个字符。
The example above checks if the login contains only letters and
integers, with a minimum of three characters.

``rule`` 之中的正则表达式必须由斜线界定起始。最后一个斜线之后可以省略的'i'表示正则表达式是大小写无关。
The regular expression in the ``rule`` must be delimited by
slashes. The optional trailing 'i' after the last slash means the
reg-exp is case *i*\ nsensitive.

添加你自己的验证方法
Adding your own Validation Methods
----------------------------------

有时候使用正则表达式检查数据是不够的。例如, 如果你想确保一个折扣代码只能使用25次, 你就需要添加自己的验证函数, 如下所示::
Sometimes checking data with regular expression patterns is not
enough. For example, if you want to ensure that a promotional code
can only be used 25 times, you need to add your own validation
function, as shown below::

    class User extends AppModel {

        public $validate = array(
            'promotion_code' => array(
                'rule'    => array('limitDuplicates', 25),
                'message' => '这个代码使用太多次了。This code has been used too many times.'
            )
        );

        public function limitDuplicates($check, $limit) {
            // $check will have value: array('promotion_code' => 'some-value')
            // $limit will have value: 25
            $existing_promo_count = $this->find('count', array(
                'conditions' => $check,
                'recursive' => -1
            ));
            return $existing_promo_count < $limit;
        }
    }

要验证的当前字段会以关联数组的形式传入函数的第一个参数, 字段名为键, 提交的数据为值。
The current field to be validated is passed into the function as
first parameter as an associated array with field name as key and
posted data as value.

如果你要给验证函数传入其他参数, 在 ‘rule’ 数组中加入更多元素(在主要的 ``$check`` 参数之后), 再在你的函数中作为其他参数处理。
If you want to pass extra parameters to your validation function,
add elements onto the ‘rule’ array, and handle them as extra params
(after the main ``$check`` param) in your function.

你的验证函数可以在模型中(正如上面的例子), 或者在一个模型实现的行为中。这包括映射的方法。
Your validation function can be in the model (as in the example
above), or in a behavior that the model implements. This includes
mapped methods.

模型/行为方法会优先考虑, 之后才会查找 ``Validation`` 类的方法。这意味着你可以重载现存的验证方法(例如 ``alphaNumeric()``), 或者在应用程序级别(通过给 ``AppModel`` 添加方法), 或者在模型级别。
Model/behavior methods are checked first, before looking for a
method on the ``Validation`` class. This means that you can
override existing validation methods (such as ``alphaNumeric()``)
at an application level (by adding the method to ``AppModel``), or
at model level.

当你编写一个可以用于多个字段的验证规则时, 注意从 $check 提取字段的值。$check 数组传入时以表单名为键, 以字段的值为其值。要被验证的整个记录保存在 $this->data 成员变量中。
When writing a validation rule which can be used by multiple
fields, take care to extract the field value from the $check array.
The $check array is passed with the form field name as its key and
the field value as its value. The full record being validated is
stored in $this->data member variable::

    class Post extends AppModel {

        public $validate = array(
            'slug' => array(
                'rule'    => 'alphaNumericDashUnderscore',
                'message' => 'Slug只能是字母, 数字, 减号和下划线 Slug can only be letters, numbers, dash and underscore'
            )
        );

        public function alphaNumericDashUnderscore($check) {
            // $data array is passed using the form field name as the key
            // have to extract the value to make the function generic
            $value = array_values($check);
            $value = $value[0];

            return preg_match('|^[0-9a-zA-Z_-]*$|', $value);
        }
    }

.. note::

    你自己的验证方法必须有 ``public``。``protected`` 和 ``private`` 的验证方法是不支持的。
    Your own validation methods must have ``public`` visibility. Validation
    methods that are ``protected`` and ``private`` are not supported.

如果值合法, 方法应该返回 ``true``。如果验证失败, 返回 `false``。其它合法的返回值可以是字符串, 作为错误信息显示。返回字符串意味着验证失败。字符串会覆盖 $validate 数组中设置的信息, 作为字段不合法的原因, 显示在视图的表单中。
The method should return ``true`` if the value is valid. If the validation
failed, return ``false``. The other valid return value are strings which will
be shown as the error message. Returning a string means the validation failed.
The string will overwrite the message set in the $validate array and be shown
in the view's form as the reason why the field was not valid.


动态改变验证规则
Dynamically change validation rules
===================================

使用 ``$validate`` 属性来声明验证规则是为一个类定义静态规则的好方法。但难免会有一些情况下, 你想对预先定义的规则集添加, 修改或删除验证规则。
Using ``$validate`` property to declare validation rules is a good ways of defining
statically rules for each model. Nevertheless there are cases when you want to
dynamically add, change or remove validation rules from the predefined set.

所有的验证规则都保存在一个 ``ModelValidator`` 对象中, 你模型中每个字段的验证规则集都在这里。定义新的规则简单到只需告诉该对象来存储你要的字段的验证方法。
All validation rules are stored in a ``ModelValidator`` object, which holds
every rule set for each field in your model. Defining new validation rules is as
easy as telling this object to store new validation methods for the fields you
want to.


添加新的验证规则
Adding new validation rules
---------------------------

.. versionadded:: 2.2

``ModelValidator`` 对象允许多种方法添加新字段到集合中。第一种是使用 ``add`` 方法::
The ``ModelValidator`` objects allows several ways for adding new fields to the
set. The first one is using the ``add`` method::

    // 在一个模型类中Inside a model class
    $this->validator()->add('password', 'required', array(
        'rule' => 'notEmpty',
        'required' => 'create'
    ));

这会为模型中的 `password` 字段添加一个规则。你可以链接多个 add 方法来添加任意多个规则::
This will add a single rule to the `password` field in the model. You can chain
multiple calls to add to create as many rules as you like::

    // 在一个模型类中Inside a model class
    $this->validator()
        ->add('password', 'required', array(
            'rule' => 'notEmpty',
            'required' => 'create'
        ))
        ->add('password', 'size', array(
            'rule' => array('between', 8, 20),
            'message' => '密码必须至少有8个字符Password should be at least 8 chars long'
        ));

也可以为一个字段一次添加多个规则::
It is also possible to add multiple rules at once for a single field::

    $this->validator()->add('password', array(
        'required' => array(
            'rule' => 'notEmpty',
            'required' => 'create'
        ),
        'size' => array(
            'rule' => array('between', 8, 20),
            'message' => '密码必须至少有8个字符 Password should be at least 8 chars long'
        )
    ));

或者, 你可以用validator对象使用数组访问的方式直接对字段设置验证规则::
Alternatively, you can use the validator object to set rules directly to fields
using the array interface::

    $validator = $this->validator();
    $validator['username'] = array(
        'unique' => array(
            'rule' => 'isUnique',
            'required' => 'create'
        ),
        'alphanumeric' => array(
            'rule' => 'alphanumeric'
        )
    );

修改现存的验证规则
Modifying current validation rules
----------------------------------

.. versionadded:: 2.2

使用 validator 对象也可以修改当前的验证规则。有若干种方法可以修改现存规则, 对一个字段添加验证方法, 或者从一个字段的验证规则集合中完全删除一个规则::
Modifying current validation rules is also possible using the validator object,
there are several ways in which you can alter current rules, append methods to a
field or completely remove a rule from a field rule set::

    // 在一个模型方法中In a model class
    $this->validator()->getField('password')->setRule('required', array(
        'rule' => 'required',
        'required' => true
    ));

你也可以用类似的方法完全替换掉一个字段的所有规则::
You can also completely replace all the rules for a field using a similar
method::

    // 在一个模型中In a model class
    $this->validator()->getField('password')->setRules(array(
        'required' => array(...),
        'otherRule' => array(...)
    ));

如果只要改变一个规则中的一个属性, 你可以直接设置 ``CakeValidationRule`` 的属性::
If you wish to just modify a single property in a rule you can set properties
directly into the ``CakeValidationRule`` object::

    // 在一个模型中 In a model class
    $this->validator()->getField('password')
        ->getRule('required')->message = '这个字段不能为空This field cannot be left blank';

用模型的 ``$validate`` 属性来定义验证规则可以使用的合法数组的键, 就可以作为任何 ``CakeValidationRule`` 的属性的名字。
Properties in any ``CakeValidationRule`` are named as the valid array keys you
can use for defining such rules using the ``$validate`` property in the model.

类似于对集合添加新规则, 也可以用数组访问的方式修改现存的规则::
As with adding new rule to the set, it is also possible to modify existing rules
using the array interface::

    $validator = $this->validator();
    $validator['username']['unique'] = array(
        'rule' => 'isUnique',
        'required' => 'create'
    );

    $validator['username']['unique']->last = true;
    $validator['username']['unique']->message = '名字已经被占用Name already taken';


从集合中删除规则
Removing rules from the set
---------------------------

.. versionadded:: 2.2

可以完全删除一个字段的所有规则, 或者一个字段规则集合中的一条规则::
It is possible to both completely remove all rules for a field and to delete a
single rule in a field's rule set::

    // 完全删除一个字段的所有规则Completely remove all rules for a field
    $this->validator()->remove('username');

    // 删除字段password的'required'规则 Remove 'required' rule from password
    $this->validator()->remove('password', 'required');

另外, 你可以用数组访问的方式从集合中删除规则:
Optionally, you can use the array interface to delete rules from the set::

    $validator = $this->validator();
    // 完全删除一个字段的所有规则 Completely remove all rules for a field
    unset($validator['username']);

    // 完删除 password 字段的 'required' 规则 Remove 'required' rule from password
    unset($validator['password']['required']);

.. _core-validation-rules:

核心验证规则
Core Validation Rules
=====================

.. php:class:: Validation

CakePHP 的 Validation 类有许多验证规则, 可以使模型数据的验证容易得多。这个类有许多常用的验证方法, 你就可以不必自己写了。下面, 你可以看到所有验证规则的完整列表, 以及如何使用的例子。
The Validation class in CakePHP contains many validation rules that
can make model data validation much easier. This class contains
many oft-used validation techniques you won’t need to write on your
own. Below, you'll find a complete list of all the rules, along
with usage examples.

.. php:staticmethod:: alphaNumeric(mixed $check)

    字段的数据只能含有字母和数字。::
    The data for the field must only contain letters and numbers.::

        public $validate = array(
            'login' => array(
                'rule'    => 'alphaNumeric',
                'message' => '用户名只能含有字母和数字。 Usernames must only contain letters and numbers.'
            )
        );

.. php:staticmethod:: between(string $check, integer $min, integer $max)

    字段的数据长度必须在指定的范围内。最小值和最大值都必须提供。
    The length of the data for the field must fall within the specified
    numeric range. Both minimum and maximum values must be supplied.
    Uses = not.::

        public $validate = array(
            'password' => array(
                'rule'    => array('between', 5, 15),
                'message' => '密码的长度必须在5到15个字符之间。Passwords must be between 5 and 15 characters long.'
            )
        );

    数据的长度是"数据的字符串表示方式的字节数"。当心, 在处理非ASCII
    字符时, 这可能会长于数据的字符数。
    The length of data is "the number of bytes in the string
    representation of the data". Be careful that it may be larger than
    the number of characters when handling non-ASCII characters.


.. php:staticmethod:: blank(mixed $check)

    这个规则用来保证字段为空或者只含有空字符。空字符包括空格, 制表符, 回车, 和换行。::
    This rule is used to make sure that the field is left blank or only
    white space characters are present in its value. White space
    characters include space, tab, carriage return, and newline.::

        public $validate = array(
            'id' => array(
                'rule' => 'blank',
                'on'   => 'create'
            )
        );


.. php:staticmethod:: boolean(string $check)

    字符的数据必须是布尔值。合法的值为 true 或 false, 整数0或1, 或者字符串'0'或'1'。::
    The data for the field must be a boolean value. Valid values are
    true or false, integers 0 or 1 or strings '0' or '1'.::

        public $validate = array(
            'myCheckbox' => array(
                'rule'    => array('boolean'),
                'message' => 'myCheckbox 的值不正确 Incorrect value for myCheckbox'
            )
        );


.. php:staticmethod:: cc(mixed $check, mixed $type = 'fast', boolean $deep = false, string $regex = null)

    这个规则用来检查数据是否是一个合法的信用卡号码。它有3个参数: ‘type’, ‘deep’ 和 ‘regex’。
    This rule is used to check whether the data is a valid credit card
    number. It takes three parameters: ‘type’, ‘deep’ and ‘regex’.

    ‘type’ 键可以赋值为 ‘fast’, ‘all’ 或者任意下面的值:
    The ‘type’ key can be assigned to the values of ‘fast’, ‘all’ or
    any of the following:

    -  amex
    -  bankcard
    -  diners
    -  disc
    -  electron
    -  enroute
    -  jcb
    -  maestro
    -  mc
    -  solo
    -  switch
    -  visa
    -  voyager

    如果‘type’设置为‘fast’,数据就会用主要的信用卡号码格式来检查。设置 ‘type’ 为 ‘all’, 就会检查检查所有信用卡类型。你也可以设置为任何一种你想匹配的类型。
    If ‘type’ is set to ‘fast’, it validates the data against the major
    credit cards’ numbering formats. Setting ‘type’ to ‘all’ will check
    with all the credit card types. You can also set ‘type’ to an array
    of the types you wish to match.

    ‘deep’ 键应当设置为布尔值。如果设为 true,就会检查信用卡的 Luhn 算法(`http://en.wikipedia.org/wiki/Luhn\_algorithm <http://en.wikipedia.org/wiki/Luhn_algorithm>`_)。缺省值为 false。
    The ‘deep’ key should be set to a boolean value. If it is set to
    true, the validation will check the Luhn algorithm of the credit
    card
    (`http://en.wikipedia.org/wiki/Luhn\_algorithm <http://en.wikipedia.org/wiki/Luhn_algorithm>`_).
    It defaults to false.

    ‘regex’ 键允许你提供自己的正则表达式, 用来验证信用卡号码::
    The ‘regex’ key allows you to supply your own regular expression
    that will be used to validate the credit card number::

        public $validate = array(
            'ccnumber' => array(
                'rule'    => array('cc', array('visa', 'maestro'), false, null),
                'message' => '您提供的信用卡号码不正确。The credit card number you supplied was invalid.'
            )
        );


.. php:staticmethod:: comparison(mixed $check1, string $operator = null, integer $check2 = null)

    Comparison 用来比较数值。它支持"大于", "小于", "大于等于", "小于等于", "等于", "不等于"。下面是一些例子::
    Comparison is used to compare numeric values. It supports “is
    greater”, “is less”, “greater or equal”, “less or equal”, “equal
    to”, and “not equal”. Some examples are shown below::

        public $validate = array(
            'age' => array(
                'rule'    => array('comparison', '>=', 18),
                'message' => '年龄至少18岁才具有资格。Must be at least 18 years old to qualify.'
            )
        );

        public $validate = array(
            'age' => array(
                'rule'    => array('comparison', 'greater or equal', 18),
                'message' => '年龄至少18岁才具有资格。Must be at least 18 years old to qualify.'
            )
        );


.. php:staticmethod:: custom(mixed $check, string $regex = null)

    当需要定制的正则表达式时使用::
    Used when a custom regular expression is needed::

        public $validate = array(
            'infinite' => array(
                'rule'    => array('custom', '\u221E'),
                'message' => '请输入一个无穷数。Please enter an infinite number.'
            )
        );


.. php:staticmethod:: date(string $check, mixed $format = 'ymd', string $regex = null)

    这个规则确保数据是以合法的日期格式输入的。可以是单个参数(可以是一个数组), 用来检查输入日期的格式。参数可以为下面之一的值:
    This rule ensures that data is submitted in valid date formats. A
    single parameter (which can be an array) can be passed that will be
    used to check the format of the supplied date. The value of the
    parameter can be one of the following:

    -  ‘dmy’ 例如27-12-2006或者27-12-06(分隔符可以是空格, 英文句号, 破折号, 斜线)
    -  ‘mdy’ 例如12-27-2006或者12-27-06(分隔符可以是空格, 英文句号, 破折号, 斜线)
    -  ‘ymd’ 例如2006-12-27或者06-12-27(分隔符可以是空格, 英文句号, 破折号, 斜线)
    -  ‘dMy’ 例如27 December 2006或者27 Dec 2006
    -  ‘Mdy’ 例如December 27, 2006或者Dec 27, 2006(逗号可以省略)
    -  ‘My’ 例如(December 2006或者Dec 2006)
    -  ‘my’ 例如12/2006或者12/06(分隔符可以是空格, 英文句号, 破折号, 斜线)

    如果键没有提供, 缺省的键值为‘ymd’::
    If no keys are supplied, the default key that will be used is
    ‘ymd’::

        public $validate = array(
            'born' => array(
                'rule'       => array('date', 'ymd'),
                'message'    => '以YY-MM-DD的格式输入合法的日期。 Enter a valid date in YY-MM-DD format.',
                'allowEmpty' => true
            )
        );

    虽然很多数据存储要求某个特定的日期格式, 但是也许你应该考虑承担麻烦的部分，
    接受更多的日期格式, 然后再进行转换, 而不是要求用户使用指定的格式。
    你能为用户做的越多越好。
    While many data stores require a certain date format, you might
    consider doing the heavy lifting by accepting a wide-array of date
    formats and trying to convert them, rather than forcing users to
    supply a given format. The more work you can do for your users, the
    better.


.. php:staticmethod:: datetime(array $check, mixed $dateFormat = 'ymd', string $regex = null)

    这条规则确保数据是合法的 datetime 格式。可以传入一个参数(可以是数组)
    来指定日期的格式。参数可以使下面的一个或多个值:
    This rule ensures that the data is a valid datetime format. A
    parameter (which can be an array) can be passed to specify the format
    of the date. The value of the parameter can be one or more of the
    following:

    -  ‘dmy’ 例如27-12-2006或者27-12-06(分隔符可以是空格, 英文句号, 破折号, 斜线)
    -  ‘mdy’ 例如12-27-2006或者12-27-06(分隔符可以是空格, 英文句号, 破折号, 斜线)
    -  ‘ymd’ 例如2006-12-27或者06-12-27(分隔符可以是空格, 英文句号, 破折号, 斜线)
    -  ‘dMy’ 例如27 December 2006或者27 Dec 2006
    -  ‘Mdy’ 例如December 27, 2006或者Dec 27, 2006(逗号可以省略)
    -  ‘My’ 例如(December 2006或者Dec 2006)
    -  ‘my’ 例如12/2006或者12/06(分隔符可以是空格, 英文句号, 破折号, 斜线)

    如果键没有提供, 缺省的键值为‘ymd’::
    If no keys are supplied, the default key that will be used is
    ‘ymd’::

        public $validate = array(
            'birthday' => array(
                'rule'    => array('datetime', 'dmy'),
                'message' => '请输入合法的日期和时间。Please enter a valid date and time.'
            )
        );

    也可以传入第二个参数，指定一个正则表达式。如果使用这个参数，这就会是
    执进行的唯一验证。
    Also a second parameter can be passed to specify a custom regular
    expression. If this parameter is used, this will be the only
    validation that will occur.

    注意和date()不同，datetime()会验证日期和时间。
    Note that unlike date(), datetime() will validate a date and a time.


.. php:staticmethod:: decimal(integer $check, integer $places = null, string $regex = null)

    这个规则确保数据是合法的 decimal 数值。可以用参数指定小数点后需要
    多少位小数。如果没有参数传入，数据将会当做科学计数法的浮点数来验证，
    这样的话，如果小数点后面没有数字，验证就会失败。
    This rule ensures that the data is a valid decimal number. A
    parameter can be passed to specify the number of digits required
    after the decimal point. If no parameter is passed, the data will
    be validated as a scientific float, which will cause validation to
    fail if no digits are found after the decimal point::

        public $validate = array(
            'price' => array(
                'rule' => array('decimal', 2)
            )
        );


.. php:staticmethod:: email(string $check, boolean $deep = false, string $regex = null)

    这条规则检查数据是否是合法的电子邮件地址。给规则的第二个参数传入布尔值
    true，就会检查电子邮件的主机地址(*host*)也是合法的::
    This checks whether the data is a valid email address. Passing a
    boolean true as the second parameter for this rule will also
    attempt to verify that the host for the address is valid::

        public $validate = array('email' => array('rule' => 'email'));

        public $validate = array(
            'email' => array(
                'rule'    => array('email', true),
                'message' => '请输入合法的电子邮件地址。'
            )
        );


.. php:staticmethod:: equalTo(mixed $check, mixed $compareTo)

    这条规则确保数据的值等于给定的值，并且是相同的类型。
    This rule will ensure that the value is equal to, and of the same
    type as the given value.

    ::

        public $validate = array(
            'food' => array(
                'rule'    => array('equalTo', 'cake'),
                'message' => '值必须是字符串cake This value must be the string cake'
            )
        );


.. php:staticmethod:: extension(mixed $check, array $extensions = array('gif', 'jpeg', 'png', 'jpg'))

    这条规则检查合法的文件扩展名，比如.jpg或者.png。
    多个扩展名允许以数组的形式传入。
    This rule checks for valid file extensions like .jpg or .png. Allow
    multiple extensions by passing them in array form.

    ::

        public $validate = array(
            'image' => array(
                'rule'    => array('extension', array('gif', 'jpeg', 'png', 'jpg')),
                'message' => '请上传合法的图像。Please supply a valid image.'
            )
        );

.. php:staticmethod:: fileSize($check, $operator = null, $size = null)

    这条规则允许你检查文件大小。你可以用 ``$operator`` 来决定你要
    使用的比较方法。所有 :php:func:`~Validation::comparison()` 支持的
    操作符这里都可以使用。这个方法可以自动处理来自 ``$_FILES`` 的数组，
    它可以从 ``tmp_name`` 键读取，只要 ``$check`` 是个数组，并且含有这个键。
    This rule allows you to check filesizes.  You can use ``$operator`` to
    decide the type of comparison you want to use.  All the operators supported
    by :php:func:`~Validation::comparison()` are supported here as well.  This
    method will automatically handle array values from ``$_FILES`` by reading
    from the ``tmp_name`` key if ``$check`` is an array an contains that key::

        public $validate = array(
            'image' => array(
                'rule' => array('fileSize', '<=', '1MB'),
                'message' => '图像必须小于1MB Image must be less than 1MB'
            )
        );

    .. versionadded:: 2.3
        This method was added in 2.3

.. php:staticmethod:: inList(string $check, array $list)

    这条规则确保数据存在于一个给定的集合中。它需要一系列的值。如果数据能够和
    给定的数组中的一个值匹配，字段就是合法的。
    This rule will ensure that the value is in a given set. It needs an
    array of values. The field is valid if the field's value matches
    one of the values in the given array.

    例子Example::

        public $validate = array(
            'function' => array(
                 'allowedChoice' => array(
                     'rule'    => array('inList', array('Foo', 'Bar')),
                     'message' => '输入 Foo 或者 Bar。Enter either Foo or Bar.'
                 )
             )
         );


.. php:staticmethod:: ip(string $check, string $type = 'both')

    这条规则确保提交的是合法的IPv4或IPv6的地址。允许 'both' (缺省值)，
    'IPv4'或者'IPv6'。
    This rule will ensure that a valid IPv4 or IPv6 address has been
    submitted. Accepts as option 'both' (default), 'IPv4' or 'IPv6'.

    ::

        public $validate = array(
            'clientip' => array(
                'rule'    => array('ip', 'IPv4'), // 或者'IPv6'， 或者'both'(缺省值)
                'message' => '请输入合法的 IP 地址。Please supply a valid IP address.'
            )
        );


.. php:method:: Model::isUnique()

    字段的数据必须唯一，它不可以被其他任何数据行使用。
    The data for the field must be unique, it cannot be used by any
    other rows.

    ::

        public $validate = array(
            'login' => array(
                'rule'    => 'isUnique',
                'message' => '这个用户名已经被别人注册了。This username has already been taken.'
            )
        );

.. php:staticmethod:: luhn(string|array $check, boolean $deep = false)

    Luhn 算法：一个校验码公式，来验证各种识别号码。更多信息，请参见
    `Luhn algorithm <http://en.wikipedia.org/wiki/Luhn_algorithm>`_。
    The Luhn algorithm: A checksum formula to validate a variety of
    identification numbers. See http://en.wikipedia.org/wiki/Luhn_algorithm for
    more information.


.. php:staticmethod:: maxLength(string $check, integer $max)

    这个规则确保数据在最大长度范围内。
    This rule ensures that the data stays within a maximum length
    requirement.

    ::

        public $validate = array(
            'login' => array(
                'rule'    => array('maxLength', 15),
                'message' => '用户名不得超过15个字符长。Usernames must be no larger than 15 characters long.'
            )
        );

    这里的长度是“数据的字符串表示的字节数”。当心, 在处理非 ASCII
    字符时, 这可能会长于数据的字符数。
    The length here is "the number of bytes in the string
    representation of the data". Be careful that it may be larger than
    the number of characters when handling non-ASCII characters.

.. php:staticmethod:: mimeType(mixed $check, array $mimeTypes)

    .. versionadded:: 2.2

    这个规则检查合法的mimeType
    This rule checks for valid mimeType

    ::

        public $validate = array(
            'image' => array(
                'rule'    => array('mimeType', array('image/gif')),
                'message' => '非法的mime类型。Invalid mime type.'
            ),
        );

.. php:staticmethod:: minLength(string $check, integer $min)

    这个规则确保数据满足最小长度要求。
    This rule ensures that the data meets a minimum length
    requirement.

    ::

        public $validate = array(
            'login' => array(
                'rule'    => array('minLength', 8),
                'message' => '用户名至少8个字符长。Usernames must be at least 8 characters long.'
            )
        );

    这里的长度是“数据的字符串表示的字节数”。当心, 在处理非 ASCII
    字符时, 这可能会长于数据的字符数。
    The length here is "the number of bytes in the string
    representation of the data". Be careful that it may be larger than
    the number of characters when handling non-ASCII characters.


.. php:staticmethod:: money(string $check, string $symbolPosition = 'left')

    这条规则确保数值是正确的财务金额。
    This rule will ensure that the value is in a valid monetary
    amount.

    第二个参数指定货币符号在哪里(左/右)。
    Second parameter defines where symbol is located (left/right).

    ::

        public $validate = array(
            'salary' => array(
                'rule'    => array('money', 'left'),
                'message' => '请输入正确的金额。Please supply a valid monetary amount.'
            )
        );

.. php:staticmethod:: multiple(mixed $check, mixed $options = array())

    用这条规则验证一个多选输入。它支持"in", "max"和"min"。
    Use this for validating a multiple select input. It supports
    parameters "in", "max" and "min".

    ::

        public $validate = array(
            'multiple' => array(
                'rule' => array('multiple', array(
                    'in'  => array('do', 're', 'mi', 'fa', 'sol', 'la', 'ti'),
                    'min' => 1,
                    'max' => 3
                )),
                'message' => '请选择一项, 两项或者三项Please select one, two or three options'
            )
        );


.. php:staticmethod:: notEmpty(mixed $check)

    确保一个字段不为空的基本规则::
    The basic rule to ensure that a field is not empty.::

        public $validate = array(
            'title' => array(
                'rule'    => 'notEmpty',
                'message' => '该字段不能为空This field cannot be left blank'
            )
        );

    不要对一个多选输入使用该规则, 因为这会引起一个错误。请使用 "multiple"。
    Do not use this for a multiple select input as it will cause an
    error. Instead, use "multiple".


.. php:staticmethod:: numeric(string $check)

    检查传入的数据是一个正确的数。
    Checks if the data passed is a valid number.::

        public $validate = array(
            'cars' => array(
                'rule'    => 'numeric',
                'message' => '请输入车辆的数量。Please supply the number of cars.'
            )
        );

.. php:staticmethod:: naturalNumber(mixed $check, boolean $allowZero = false)

    .. versionadded:: 2.2

    这个规则检查传入的数据是正确的自然数。
    This rule checks if the data passed is a valid natural number.
    如果 ``$allowZero`` 设为 true, 零也可以接受。
    If ``$allowZero`` is set to true, zero is also accepted as a value.

    ::

        public $validate = array(
            'wheels' => array(
                'rule'    => 'naturalNumber',
                'message' => '请输入车轮的数量。Please supply the number of wheels.'
            ),
            'airbags' => array(
                'rule'    => array('naturalNumber', true),
                'message' => '请输入气袋的数量。Please supply the number of airbags.'
            ),
        );


.. php:staticmethod:: phone(mixed $check, string $regex = null, string $country = 'all')

    Phone 规则验证美国的电话号码。如果你要验证美国以外的电话号码, 你可以在第二个参数用一个正则表达式来处理其他的号码格式。
    Phone validates US phone numbers. If you want to validate non-US
    phone numbers, you can provide a regular expression as the second
    parameter to cover additional number formats.

    ::

        public $validate = array(
            'phone' => array(
                'rule' => array('phone', null, 'us')
            )
        );


.. php:staticmethod:: postal(mixed $check, string $regex = null, string $country = 'us')

    Postal 规则验证美国(us), 加拿大(ca), 英国(uk), 意大利(it), 德国(de)和比利时(be)的邮政编码。对于其他的邮政编码格式, 你可以在第二个参数用一个正则表达式。
    Postal is used to validate ZIP codes from the U.S. (us), Canada
    (ca), U.K (uk), Italy (it), Germany (de) and Belgium (be). For
    other ZIP code formats, you may provide a regular expression as the
    second parameter.

    ::

        public $validate = array(
            'zipcode' => array(
                'rule' => array('postal', null, 'us')
            )
        );


.. php:staticmethod:: range(string $check, integer $lower = null, integer $upper = null)

    这条规则确保数值在一个给定范围内。如果没有指定范围, 规则会检查数值是当前平台上合法有限数。
    This rule ensures that the value is in a given range. If no range
    is supplied, the rule will check to ensure the value is a legal
    finite on the current platform.

    ::

        public $validate = array(
            'number' => array(
                'rule'    => array('range', -1, 11),
                'message' => '请输入0到10之间的数 Please enter a number between 0 and 10'
            )
        );

    上面的例子会接受大于0(比如0.01)而且小于10 (比如9.99)的任何数值。
    The above example will accept any value which is larger than 0
    (e.g., 0.01) and less than 10 (e.g., 9.99).

    .. note::

    上下限的值是不包括在内的。
        The range lower/upper are not inclusive


.. php:staticmethod:: ssn(mixed $check, string $regex = null, string $country = null)

    Ssn 规则验证美国(us), 丹麦(dk), 和荷兰(nl)的社会保险号码。对于其他的社会保险号码, 你可以指定正则表达式。
    Ssn validates social security numbers from the U.S. (us), Denmark
    (dk), and the Netherlands (nl). For other social security number
    formats, you may provide a regular expression.

    ::

        public $validate = array(
            'ssn' => array(
                'rule' => array('ssn', null, 'us')
            )
        );


.. php:staticmethod:: time(string $check)

    Time验证规则决定传入的字符串是否是正确的时间。以24小时(HH:MM)或上午/下午([H]H:MM[a|p]m)来验证。不允许/验证秒。
    Time validation, determines if the string passed is a valid time. Validates
    time as 24hr (HH:MM) or am/pm ([H]H:MM[a|p]m) Does not allow/validate
    seconds.

.. php:staticmethod:: uploadError(mixed $check)

    .. versionadded:: 2.2

    这条规则检查文件上载是否有错。
    This rule checks if a file upload has an error.

    ::

        public $validate = array(
            'image' => array(
                'rule'    => 'uploadError',
                'message' => '上载出错了。Something went wrong with the upload.'
            ),
        );

.. php:staticmethod:: url(string $check, boolean $strict = false)

    这条规则检查合法的网址格式。支持 http(s), ftp(s),
    file, news, and gopher 协议::
    This rule checks for valid URL formats. Supports http(s), ftp(s),
    file, news, and gopher protocols::

        public $validate = array(
            'website' => array(
                'rule' => 'url'
            )
        );

    为确保某个协议在网址中, 可以象这样使用严格模式::
    To ensure that a protocol is in the url, strict mode can be enabled
    like so::

        public $validate = array(
            'website' => array(
                'rule' => array('url', true)
            )
        );


.. php:staticmethod:: userDefined(mixed $check, object $object, string $method, array $args = null)

    执行用户定义的验证。
    Runs an user-defined validation.


.. php:staticmethod:: uuid(string $check)

    检查数据是合法的 uuid: http://tools.ietf.org/html/rfc4122。
    Checks that a value is a valid uuid: http://tools.ietf.org/html/rfc4122


本地化验证
Localized Validation
====================

验证规则 phone() 和 postal() 会把它们不知道如何处理的国家前缀交给适当命名的其他类来处理。例如, 如果你住在荷兰, 你就可以创建这样一个类::
The validation rules phone() and postal() will pass off any country prefix
they do not know how to handle to another class with the appropriate name. For
example if you lived in the Netherlands you would create a class like::

    class NlValidation {
        public static function phone($check) {
            // ...
        }
        public static function postal($check) {
            // ...
        }
    }
这个文件可以放在 ``APP/Validation/`` 或者 ``App/PluginName/Validation/``, 但必须在使用之前用 App::uses() 导入。在你的模型验证中你可以这样使用 NlValidation 类::
This file could be placed in ``APP/Validation/`` or
``App/PluginName/Validation/``, but must be imported via App::uses() before
attempting to use it. In your model validation you could use your NlValidation
class by doing the following::

    public $validate = array(
        'phone_no' => array('rule' => array('phone', null, 'nl')),
        'postal_code' => array('rule' => array('postal', null, 'nl')),
    );

当你的数据被验证时, 验证程序会知道它无法处理 ``nl`` 地区, 就会尝试把任务交给 ``NlValidation::postal()``, 该方法的返回值就会用作验证通过/失败的标志。这个方法允许你创建一些类来处理一组地区或子集, 这是一个大的 switch 语句无法实现的。单个验证方法的用法并没有改变, 只是增加了跳转到其他验证的功能。
When your model data is validated, Validation will see that it cannot handle
the ``nl`` locale and will attempt to delegate out to
``NlValidation::postal()`` and the return of that method will be used as the
pass/fail for the validation. This approach allows you to create classes that
handle a subset or group of locales, something that a large switch would not
have. The usage of the individual validation methods has not changed, the
ability to pass off to another validator has been added.

.. tip::

    Localized 插件已经包括许多可以使用的规则:
    https://github.com/cakephp/localized
    另外, 随意贡献你的本地化验证规则。
    The Localized Plugin already contains a lot of rules ready to use:
    https://github.com/cakephp/localized
    Also feel free to contribute with your localized validation rules.

.. toctree::

    data-validation/validating-data-from-the-controller


.. meta::
    :title lang=en: Data Validation
    :keywords lang=en: validation rules,validation data,validation errors,data validation,credit card numbers,core libraries,password email,model fields,login field,model definition,php class,many different aspects,eight characters,letters and numbers,business rules,validation process,date validation,error messages,array,formatting