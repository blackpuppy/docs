数据验证
###############

数据验证是任何应用程序的重要组成部分，因为这有助于确保模型中的数据符合应用程序的业务规则。例如，你也许要确保密码至少有八个字符，或者用户名是唯一的。定义验证规则使得表单的处理容易得多得多。

验证过程有很多方面。本节中我们只涉及模型中的部分。基本上这意味着: 当你调用模型的 save() 方法时会发生什么。关于如何处理验证错误的显示的更多信息，请参看 :doc:`/core-libraries/helpers/form`。

数据验证的第一步是在模型中建立验证规则。这需要用到在模型中定义的 Model::validate 数组，例如::

    class User extends AppModel {
        public $validate = array();
    }

在上面的例子中，``$validate`` 数组被加到 User 模型中，但此数组还不包含任何验证规则。假设 users 表中有 login，password，email 和 born 这些字段，在下面的例子中是一些针对这些字段的简单验证规则::

    class User extends AppModel {
        public $validate = array(
            'login' => 'alphaNumeric',
            'email' => 'email',
            'born'  => 'date'
        );
    }

上面的例子说明验证规则如何针对模型的字段。login 字段只接受字母和数字，email 应当是合法的电子邮件，以及 born 应当是合法的日期。定义了验证规则之后，如果提交的数据不符合定义的规则，CakePHP 就能够在表单中自动显示错误信息。

CakePHP 有许多验证规则，使用起来相当容易。一些内置的验证规则让你可以检查电子邮件，网址和信用卡的格式——不过我们稍后才会详细介绍这些。

这是一个利用这些内置验证规则的更复杂的例子::

    class User extends AppModel {
        public $validate = array(
            'login' => array(
                'alphaNumeric' => array(
                    'rule'     => 'alphaNumeric',
                    'required' => true,
                    'message'  => '只接受字母和数字'
                ),
                'between' => array(
                    'rule'    => array('between', 5, 15),
                    'message' => '5到15个字符'
                )
            ),
            'password' => array(
                'rule'    => array('minLength', '8'),
                'message' => '最少8个字符长'
            ),
            'email' => 'email',
            'born' => array(
                'rule'       => 'date',
                'message'    => '请输入合法的日期',
                'allowEmpty' => true
            )
        );
    }

login 字段有两个验证规则: 它只能包含字母和数字，长度介于5到15之间。password 字段至少要有8个字符长。email 字段必须是合法的电子邮件，而born 字段必须是合法的日期。另外，请注意如何定义在这些验证规则被违反时 CakePHP 可以使用的错误信息 。

如上例所示，一个字段可以有多个验证规则。另外，如果内置的规则不符合你的要求，在必要时你总是可以增加自己的验证规则。

现在你已经看到验证大致是如何工作的，让我们再来看看这些规则在模型中是如何定义的。定义验证规则有三种不同的方式: 简单的数组，一个字段仅一个规则，一个字段有多个规则。


简单的规则
============

正如名称所说的，这是定义验证规则最简单的方式。其通常的语法为::

    public $validate = array('字段名称' => '规则名称');

其中，'字段名称' 是定义的规则针对的字段名称，‘规则名称’ 是预先定义的规则名称，比如'alphaNumeric'，'email' 或者 'isUnique'。

例如，为确保用户提供正确格式的电子邮件地址，你可以使用这个规则:

    public $validate = array('user_email' => 'email');


一个字段一个规则
==================

这种定义方式可以更好地控制验证规则如何起作用。但在讨论这些之前，让我们先来看看给一个字段加一个规则的常用模式::

    public $validate = array(
        '字段名称1' => array(
            'rule'       => '规则名称', // 或者: array(' 规则名称', '参数1', '参数2' ...)
            'required'   => true,
            'allowEmpty' => false,
            'on'         => 'create', // 或者: 'update'
            'message'    => '你的错误信息'
        )
    );

'rule' 键是必需的。如果你只设置 'required' => true，表单验证不会正常工作。这是因为'required' 实际上不是一个规则。

这里你可以看到，每个字段(上面只显示了一个字段)与一个数组联系在一起，该数组有5个键:‘rule’,
‘required’，‘allowEmpty’，‘on’ 和 ‘message’。让我们更仔细地看看这些键。

rule
----

'rule' 键定义了验证的方法，对应的可以是单一的值，也可以是一个数组。指定的 'rule' 可以是模型的方法名称，核心验证类的方法，或者正则表达式。关于在缺省情况下可用的规则的更多信息，请参看 :ref:`core-validation-rules`。

如果规则不要求任何参数，'rule' 就可以是单一值，例如::

    public $validate = array(
        'login' => array(
            'rule' => 'alphaNumeric'
        )
    );

如果规则要求一些参数(比如最大值，最小值或者范围)，'rule' 就应当是一个数组::

    public $validate = array(
        'password' => array(
            'rule' => array('minLength', 8)
        )
    );

谨记，'rule' 键对于用数组定义的规则是必需的。

required
--------

这个键接受布尔值，``create`` 或者 ``update``。把这个键置为 ``true`` 就会使该字段总是必需的。而把它设成 ``create`` 或  ``update`` 就会使该字段只在创建或者更新操作时是必需的。如果 'required' 的值为真，则该字段在数据数组中必须存在。例如，如果验证规则如下定义::

    public $validate = array(
        'login' => array(
            'rule'     => 'alphaNumeric',
            'required' => true
        )
    );

传给模型的 save() 方法的数据中必须含有 login 字段的数据，否则验证就会失败。该键的缺省值为布尔类型 false。

``required => true`` 和验证规则 ``notEmpty()`` 并不是一回事。``required => true`` 意味着数组的*键*必须存在——这不意味着必须有值。所以，如果字段在数据集中不存在，验证就会失败，但如果提交的值为空('')，验证有可能(取决于规则)会成功。

.. versionchanged:: 2.1增加了对 ``create`` 和 ``update`` 的支持。

allowEmpty
----------

如果设为 ``false``，字段的值必须为*不空*，而"不空"定义为 ``!empty($value) || is_numeric($value)``。对数字的检查是为了使 CakePHP 能正确处理 ``$value`` 为零的情况。

``required`` 和 ``allowEmpty`` 的区别可能令人迷惑。``'required' => true`` 意味着，在 ``$this->data`` 中没有该字段的*键*，你就不能保存模型(检查使用的是 ``isset``); 然而，``'allowEmpty' => false`` 确保当前字段的*值*不为空，如前所述。

on
--

'on'键可以设置为下列值之一: 'update' 或者 'create'。这提供了一种机制，允许某个规则要么在创建新记录时起作用，要么在更新记录时起作用。

如果一条规则含有 'on' => 'create'，该规则只会在新记录创建时起作用。类似的，如果定义为 'on' => 'update'，则只会在记录更新时起作用。

'on' 的缺省值是 null。当 'on' 为 null 时，规则在创建和更新时都会起作用。

message
-------

message 键允许你为规则定义验证错误信息::

    public $validate = array(
        'password' => array(
            'rule'    => array('minLength', 8),
            'message' => '密码至少8个字符长'
        )
    );

一个字段多条规则
========================

上面给出的方法比简单的规则赋值提供了更多的灵活性，但我们可以更进一步，就可以更精细地控制数据验证。下面介绍的方法允许我们对一个模型字段设置多条验证规则。

如果你想要给一个字段设置多条验证规则，基本上就是这样::

    public $validate = array(
        '字段名称' => array(
            '规则名称' => array(
                'rule' => '规则名称',
                // 其他的键，比如 on，required 等等，放在这里 ...
            ),
            '规则名称2' => array(
                'rule' => '规则名称2',
                // 其他的键，比如 on，required 等等，放在这里 ...
            )
        )
    );

你可以看到，这很象我们在前一节做的。在前一节，对每个字段我们只有一个数组的验证参数。而现在，每个'字段名'有一个数组的规则索引，每个'规则名称'有一个单独数组的验证参数。

用一个实际的例子能够更好地说明::

    public $validate = array(
        'login' => array(
            'login 规则-1' => array(
                'rule'    => 'alphaNumeric',
                'message' => '只允许字母和数字',
             ),
            'login 规则-2' => array(
                'rule'    => array('minLength', 8),
                'message' => '最少8个字符'
            )
        )
    );

上面的例子对 login 字段设置了2个规则: login 规则-1和 login 规则-2。你可以看到，每个规则都由一个随意选定的名字标识。

当对一个字段使用多条规则时，'required' 和 'allowEmpty' 键只需在第一条规则中设置一次。

last
-------

当一个字段有多条规则时，缺省情况下，如果一条规则验证失败，那么这条规则的错误信息就会返回，而该字段的其它规则就不会继续执行了。如果你希望,即使在一条规则验证失败时，验证也继续执行，就把该条规则的 ``last`` 设置为 ``false``。

在下面的例子中，就算'规则1'验证失败，'规则2'也会继续执行，而且，如果'规则2'也失败，则两条失败规则的错误信息都会返回::

    public $validate = array(
        'login' => array(
            '规则1' => array(
                'rule'    => 'alphaNumeric',
                'message' => '只允许字母和数字',
                'last'    => false
             ),
            '规则2' => array(
                'rule'    => array('minLength', 8),
                'message' => '最少8个字符'
            )
        )
    );

当使用这种数组设置验证规则时，可以不必有 ``message`` 键。考虑下面的例子::

    public $validate = array(
        'login' => array(
            '只允许字母和数字' => array(
                'rule'    => 'alphaNumeric',
             ),
        )
    );

如果 ``alphaNumeric`` 规则验证失败，因为没有设置 ``message`` 键，数组中该规则的键'只允许字母和数字'就会作为错误信息返回。


定制的验证规则
=======================

如果你到此还没有找到你需要的(验证规则)，你总是能够创建你自己的验证规则。有两种方法: 用定制的正则表达式，或者创建定制的验证方法。

使用定制的正则表达式进行验证
------------------------------------

如果你需要的验证可以使用正则表达式匹配完成，那么你就可以设置定制的正则表达式作为字段验证规则::

    public $validate = array(
        'login' => array(
            'rule'    => '/^[a-z0-9]{3,}$/i',
            'message' => '只允许字母和数字，至少3个字符'
        )
    );

上面的例子检查 login 字段是否只包含字母和数字，至少3个字符。

``rule`` 之中的正则表达式必须由斜线界定起始。最后一个斜线之后的 'i' 是可以省略的，表示正则表达式是大小写无关。

添加你自己的验证方法
----------------------------------

有时候使用正则表达式检查数据是不够的。比如，如果你想确保一个折扣号码只能使用25次，你就需要添加自己的验证函数，如下所示::

    class User extends AppModel {

        public $validate = array(
            'promotion_code' => array(
                'rule'    => array('limitDuplicates', 25),
                'message' => '这个号码使用太多次了。'
            )
        );

        public function limitDuplicates($check, $limit) {
            // $check 的值为: array('promotion_code' => 'some-value')
            // $limit 的值为: 25
            $existing_promo_count = $this->find('count', array(
                'conditions' => $check,
                'recursive' => -1
            ));
            return $existing_promo_count < $limit;
        }
    }

要验证的当前字段会以关联数组的形式传入函数的第一个参数，字段名为键，提交的数据为值。

如果你要给验证函数传入其他参数，在 ‘rule’ 数组中加入更多元素，再在你的函数中(在主要的 ``$check`` 参数之后)作为其他参数处理。

你的验证函数可以定义在模型中(正如上面的例子)，也可以定义在一个模型实现的行为中。这包括映射方法(*mapped method*)。

模型/行为方法会优先考虑，之后才会查找 ``Validation`` 类的方法。这意味着你可以重载现存的验证方法(例如 ``alphaNumeric()``)，或者在应用程序级别(通过给 ``AppModel`` 添加方法)，或者在模型级别。

当你编写一个可以用于多个字段的验证规则时，注意从 $check 提取字段的值。$check 数组传入时以表单名为键，以字段的值为其值。要被验证的整个记录保存在 $this->data 成员变量中::

    class Post extends AppModel {

        public $validate = array(
            'slug' => array(
                'rule'    => 'alphaNumericDashUnderscore',
                'message' => 'Slug 只能是字母，数字，减号和下划线'
            )
        );

        public function alphaNumericDashUnderscore($check) {
            // $data 数组用表单字段名为键传入
            // 必须提取其值，使函数通用
            $value = array_values($check);
            $value = $value[0];

            return preg_match('|^[0-9a-zA-Z_-]*$|', $value);
        }
    }

.. note::

    你自己的验证方法必须有 ``public``。``protected`` 和 ``private`` 的验证方法是不支持的。

如果值合法，方法应该返回 ``true``。如果验证失败，返回 `false``。其它合法的返回值可以是字符串，作为错误信息显示。返回字符串意味着验证失败。字符串会覆盖 $validate 数组中设置的信息，作为字段不合法的原因，显示在视图的表单中。


动态改变验证规则
===================================

使用 ``$validate`` 属性来声明验证规则是为一个类定义静态规则的好方法。但难免会有一些情况下，你想对预先定义的规则集动态添加、修改或删除验证规则。

所有的验证规则都保存在一个 ``ModelValidator`` 对象中，你模型中每个字段的验证规则集都在这里。定义新的规则简单到只需告诉该对象来存储你需要的字段新的验证方法。


添加新的验证规则
---------------------------

.. versionadded:: 2.2

``ModelValidator`` 对象允许多种方法添加新字段到集合中。第一种是使用 ``add`` 方法::

    // 在一个模型类中
    $this->validator()->add('password', 'required', array(
        'rule' => 'notEmpty',
        'required' => 'create'
    ));

这会为模型中的 `password` 字段添加一个规则。你可以链接多个 add 方法来添加任意多个规则::

    // 在一个模型类中
    $this->validator()
        ->add('password', 'required', array(
            'rule' => 'notEmpty',
            'required' => 'create'
        ))
        ->add('password', 'size', array(
            'rule' => array('between', 8, 20),
            'message' => '密码必须至少有8个字符'
        ));

也可以为一个字段一次添加多个规则::

    $this->validator()->add('password', array(
        'required' => array(
            'rule' => 'notEmpty',
            'required' => 'create'
        ),
        'size' => array(
            'rule' => array('between', 8, 20),
            'message' => '密码必须至少有8个字符'
        )
    ));

或者，你可以用 validator 对象使用存取数组的方式直接对字段设置验证规则::

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
----------------------------------

.. versionadded:: 2.2

使用 validator 对象也可以修改当前的验证规则。有若干种方法可以修改现存规则，对一个字段添加验证方法，或者从一个字段的验证规则集合中完全删除一条规则::

    // 在一个模型类中
    $this->validator()->getField('password')->setRule('required', array(
        'rule' => 'required',
        'required' => true
    ));

你也可以用类似的方法完全替换掉一个字段的所有规则::

    // 在一个模型类中
    $this->validator()->getField('password')->setRules(array(
        'required' => array(...),
        'otherRule' => array(...)
    ));

如果只要改变一个规则中的一个属性，你可以直接设置 ``CakeValidationRule`` 的属性::

    // 在一个模型类中
    $this->validator()->getField('password')
        ->getRule('required')->message = '这个字段不能为空';

用模型的 ``$validate`` 属性来定义验证规则可以使用的合法数组的键，就可以作为任何 ``CakeValidationRule`` 的属性的名字。

类似于对集合添加新规则，也可以用存取数组的方式修改现存的规则::

    $validator = $this->validator();
    $validator['username']['unique'] = array(
        'rule' => 'isUnique',
        'required' => 'create'
    );

    $validator['username']['unique']->last = true;
    $validator['username']['unique']->message = '名字已经被占用';


从集合中删除规则
---------------------------

.. versionadded:: 2.2

可以完全删除一个字段的所有规则，或者一个字段规则集合中的一条规则::

    // 完全删除一个字段的所有规则
    $this->validator()->remove('username');

    // 删除字段 password 的 'required' 规则
    $this->validator()->remove('password', 'required');

另外，你可以用数组访问的方式从集合中删除规则::

    $validator = $this->validator();
    // 完全删除一个字段的所有规则
    unset($validator['username']);

    // 完删除 password 字段的 'required' 规则
     unset($validator['password']['required']);

.. _core-validation-rules:

核心验证规则
=====================

.. php:class:: Validation

CakePHP 的 Validation 类有许多验证规则，可以使模型数据的验证容易得多。这个类有许多常用的验证方法，你就可以不必自己写了。下面，你可以看到所有验证规则的完整列表，以及如何使用的例子。

.. php:staticmethod:: alphaNumeric(mixed $check)

    字段的数据只能含有字母和数字。::

        public $validate = array(
            'login' => array(
                'rule'    => 'alphaNumeric',
                'message' => '用户名只能含有字母和数字。'
            )
        );

.. php:staticmethod:: between(string $check, integer $min, integer $max)

    字段的数据长度必须在指定的数字范围内。最小值和最大值都必须提供。
    Uses = not.::

        public $validate = array(
            'password' => array(
                'rule'    => array('between', 5, 15),
                'message' => '密码的长度必须在5到15个字符之间。'
            )
        );

    数据的长度是"数据的字符串表示方式的字节数"。当心，在处理非 ASCII
    字符时，这可能会长于数据的字符数。


.. php:staticmethod:: blank(mixed $check)

    这个规则用来保证字段为空或者只含有空字符。空字符包括空格、制表符、回车和换行。::

        public $validate = array(
            'id' => array(
                'rule' => 'blank',
                'on'   => 'create'
            )
        );


.. php:staticmethod:: boolean(string $check)

    字符的数据必须是布尔值。合法的值为 true 或 false，整数0或1，或者字符串'0'或'1'。::

        public $validate = array(
            'myCheckbox' => array(
                'rule'    => array('boolean'),
                'message' => 'myCheckbox 的值不正确'
            )
        );


.. php:staticmethod:: cc(mixed $check, mixed $type = 'fast', boolean $deep = false, string $regex = null)

    这个规则用来检查数据是否是一个合法的信用卡号码。它接受3个参数: ‘type’，‘deep’ 和 ‘regex’。

    ‘type’ 键可以赋值为 ‘fast’，‘all’ 或者任意下面的值:

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

    如果 ‘type’ 设置为 ‘fast’，数据就会用主要的信用卡号码格式来检查。设置 ‘type’ 为 ‘all’，就会检查所有信用卡类型。你也可以设置 type 为一个你想匹配的类型的数组。

    ‘deep’ 键应当设置为布尔值。如果设为 true，就会检查信用卡的 Luhn 算法(`http://en.wikipedia.org/wiki/Luhn\_algorithm <http://en.wikipedia.org/wiki/Luhn_algorithm>`_)。缺省值为 false。

    ‘regex’ 键允许你提供自己的正则表达式，用来验证信用卡号码::

        public $validate = array(
            'ccnumber' => array(
                'rule'    => array('cc', array('visa', 'maestro'), false, null),
                'message' => '您提供的信用卡号码不正确。'
            )
        );


.. php:staticmethod:: comparison(mixed $check1, string $operator = null, integer $check2 = null)

    Comparison 用来比较数值。它支持"大于"，"小于"，"大于等于"，"小于等于"，"等于"，"不等于"。下面是一些例子::

        public $validate = array(
            'age' => array(
                'rule'    => array('comparison', '>=', 18),
                'message' => '年龄至少18岁才具有资格。'
            )
        );

        public $validate = array(
            'age' => array(
                'rule'    => array('comparison', 'greater or equal', 18),
                'message' => '年龄至少18岁才具有资格。'
            )
        );


.. php:staticmethod:: custom(mixed $check, string $regex = null)

    当需要定制的正则表达式时使用::

        public $validate = array(
            'infinite' => array(
                'rule'    => array('custom', '\u221E'),
                'message' => '请输入一个无穷数。'
            )
        );


.. php:staticmethod:: date(string $check, mixed $format = 'ymd', string $regex = null)

    这个规则确保数据是以合法的日期格式输入的。可以传入单个参数(可以是一个数组)，用来检查输入日期的格式。参数的值可以为下列之一:

    -  ‘dmy’ 例如27-12-2006或者27-12-06(分隔符可以是空格，英文句号，破折号，斜线)
    -  ‘mdy’ 例如12-27-2006或者12-27-06(分隔符可以是空格，英文句号，破折号，斜线)
    -  ‘ymd’ 例如2006-12-27或者06-12-27(分隔符可以是空格，英文句号，破折号，斜线)
    -  ‘dMy’ 例如27 December 2006或者27 Dec 2006
    -  ‘Mdy’ 例如December 27, 2006或者Dec 27, 2006(逗号可以省略)
    -  ‘My’ 例如(December 2006或者Dec 2006)
    -  ‘my’ 例如12/2006或者12/06(分隔符可以是空格，英文句号，破折号，斜线)

    如果键没有提供，将使用缺省的键值 ‘ymd’::

        public $validate = array(
            'born' => array(
                'rule'       => array('date', 'ymd'),
                'message'    => '请以 YY-MM-DD 的格式输入合法的日期。',
                'allowEmpty' => true
            )
        );

    虽然很多数据存储方式要求某个特定的日期格式，但是也许你应该考虑承担麻烦的部分，
    接受众多的日期格式，然后再尝试进行转换，而不是强制用户使用指定的格式。你能为用户做的越多越好。


.. php:staticmethod:: datetime(array $check, mixed $dateFormat = 'ymd', string $regex = null)

    这条规则确保数据是合法的 datetime 格式。可以传入一个参数(可以是数组)
    来指定日期的格式。参数的值可以是下面的一个或多个:

    -  ‘dmy’ 例如27-12-2006或者27-12-06(分隔符可以是空格，英文句号，破折号，斜线)
    -  ‘mdy’ 例如12-27-2006或者12-27-06(分隔符可以是空格，英文句号，破折号，斜线)
    -  ‘ymd’ 例如2006-12-27或者06-12-27(分隔符可以是空格，英文句号，破折号，斜线)
    -  ‘dMy’ 例如27 December 2006或者27 Dec 2006
    -  ‘Mdy’ 例如December 27, 2006或者Dec 27, 2006(逗号可以省略)
    -  ‘My’ 例如(December 2006或者Dec 2006)
    -  ‘my’ 例如12/2006或者12/06(分隔符可以是空格，英文句号，破折号，斜线)

    如果键没有提供，将使用缺省的键值 ‘ymd’::

        public $validate = array(
            'birthday' => array(
                'rule'    => array('datetime', 'dmy'),
                'message' => '请输入合法的日期和时间。'
            )
        );

    也可以传入第二个参数，指定一个定制的正则表达式。如果使用这个参数，这就会是
    执行的唯一验证。

    注意，和 date()不同，datetime()会验证日期和时间。


.. php:staticmethod:: decimal(integer $check, integer $places = null, string $regex = null)

    这个规则确保数据是合法的 decimal 数值。可以传入参数来指定小数点后需要
    多少位小数。如果没有参数传入，数据将会当做科学计数法的浮点数来验证，
    这样的话，如果小数点后面没有数字，验证就会失败::

        public $validate = array(
            'price' => array(
                'rule' => array('decimal', 2)
            )
        );


.. php:staticmethod:: email(string $check, boolean $deep = false, string $regex = null)

    这条规则检查数据是否是合法的电子邮件地址。给规则的第二个参数传入布尔值
    true，就会同时也验证电子邮件的主机地址(*host*)是否也是合法的::

        public $validate = array('email' => array('rule' => 'email'));

        public $validate = array(
            'email' => array(
                'rule'    => array('email', true),
                'message' => '请输入合法的电子邮件地址。'
            )
        );


.. php:staticmethod:: equalTo(mixed $check, mixed $compareTo)

    这条规则确保数据的值等于给定的值，并且是相同的类型。

    ::

        public $validate = array(
            'food' => array(
                'rule'    => array('equalTo', 'cake'),
                'message' => '值必须是字符串 cake'
            )
        );


.. php:staticmethod:: extension(mixed $check, array $extensions = array('gif', 'jpeg', 'png', 'jpg'))

    这条规则检查合法的文件扩展名，比如.jpg或者.png。
    允许多个扩展名以数组的形式传入。

    ::

        public $validate = array(
            'image' => array(
                'rule'    => array('extension', array('gif', 'jpeg', 'png', 'jpg')),
                'message' => '请上传合法的图像。'
            )
        );

.. php:staticmethod:: fileSize($check, $operator = null, $size = null)

    这条规则允许你检查文件大小。你可以用 ``$operator`` 来决定你要
    使用的比较方法。所有 :php:func:`~Validation::comparison()` 支持的
    操作符这里都可以使用。这个方法可以自动处理来自 ``$_FILES`` 的数组，
    它可以从 ``tmp_name`` 键读取，只要 ``$check`` 是个数组，并且含有这个键::

        public $validate = array(
            'image' => array(
                'rule' => array('fileSize', '<=', '1MB'),
                'message' => '图像必须小于1MB'
            )
        );

    .. versionadded:: 2.3
        这个方法是在2.3版本中添加的。

.. php:staticmethod:: inList(string $check, array $list)

    这条规则确保数据限于一个给定的集合中。它需要以数组形式提供的一组值。如果数据能够和
    给定的数组中的一个值匹配，字段就是合法的。

    例如::

        public $validate = array(
            'function' => array(
                 'allowedChoice' => array(
                     'rule'    => array('inList', array('Foo', 'Bar')),
                     'message' => '请输入 Foo 或者 Bar。'
                 )
             )
         );


.. php:staticmethod:: ip(string $check, string $type = 'both')

    这条规则确保提交的是合法的 IPv4 或 IPv6 的地址。允许 'both' (缺省值)，
    'IPv4'或者'IPv6'。

    ::

        public $validate = array(
            'clientip' => array(
                'rule'    => array('ip', 'IPv4'), // 或者'IPv6'， 或者'both'(缺省值)
                'message' => '请提供合法的 IP 地址。'
            )
        );


.. php:method:: Model::isUnique()

    字段的数据必须唯一，它不可以被其他任何数据行使用。

    ::

        public $validate = array(
            'login' => array(
                'rule'    => 'isUnique',
                'message' => '这个用户名已经被别人占用了。'
            )
        );

.. php:staticmethod:: luhn(string|array $check, boolean $deep = false)

    Luhn 算法：一个校验码公式，来验证各种识别号码。更多信息，请参见
    `Luhn 算法 <http://en.wikipedia.org/wiki/Luhn_algorithm>`_。


.. php:staticmethod:: maxLength(string $check, integer $max)

    这个规则确保数据在最大长度范围内。

    ::

        public $validate = array(
            'login' => array(
                'rule'    => array('maxLength', 15),
                'message' => '用户名不得超过15个字符长。'
            )
        );

    这里的长度是“数据的字符串表示的字节数”。当心，在处理非 ASCII
    字符时，这可能会长于数据的字符数。

.. php:staticmethod:: mimeType(mixed $check, array $mimeTypes)

    .. versionadded:: 2.2

    这个规则检查合法的 mimeType

    ::

        public $validate = array(
            'image' => array(
                'rule'    => array('mimeType', array('image/gif')),
                'message' => '非法的 mime 类型。'
            ),
        );

.. php:staticmethod:: minLength(string $check, integer $min)

    这个规则确保数据满足最小长度要求。

    ::

        public $validate = array(
            'login' => array(
                'rule'    => array('minLength', 8),
                'message' => '用户名至少8个字符长。'
            )
        );

    这里的长度是“数据的字符串表示的字节数”。当心，在处理非 ASCII
    字符时，这可能会长于数据的字符数。


.. php:staticmethod:: money(string $check, string $symbolPosition = 'left')

    这条规则确保数值是正确的财务金额。

    第二个参数指定货币符号在哪里(左/右)。

    ::

        public $validate = array(
            'salary' => array(
                'rule'    => array('money', 'left'),
                'message' => '请提供正确的金额。'
            )
        );

.. php:staticmethod:: multiple(mixed $check, mixed $options = array())

    用这条规则验证一个多选输入。它支持"in"，"max"和"min"参数。

    ::

        public $validate = array(
            'multiple' => array(
                'rule' => array('multiple', array(
                    'in'  => array('do', 're', 'mi', 'fa', 'sol', 'la', 'ti'),
                    'min' => 1,
                    'max' => 3
                )),
                'message' => '请选择一项，两项或者三项'
            )
        );


.. php:staticmethod:: notEmpty(mixed $check)

    确保一个字段不为空的基本规则::

        public $validate = array(
            'title' => array(
                'rule'    => 'notEmpty',
                'message' => '该字段不能为空'
            )
        );

    不要对一个多选输入使用该规则，因为这会引起错误。请使用 "multiple"。


.. php:staticmethod:: numeric(string $check)

    检查传入的数据是一个正确的数。::

        public $validate = array(
            'cars' => array(
                'rule'    => 'numeric',
                'message' => '请输入汽车的数量。'
            )
        );

.. php:staticmethod:: naturalNumber(mixed $check, boolean $allowZero = false)

    .. versionadded:: 2.2

    这个规则检查传入的数据是否是正确的自然数。
    如果 ``$allowZero`` 设为 true，零也可以接受。

    ::

        public $validate = array(
            'wheels' => array(
                'rule'    => 'naturalNumber',
                'message' => '请输入车轮的数量。'
            ),
            'airbags' => array(
                'rule'    => array('naturalNumber', true),
                'message' => '请输入气囊的数量。'
            ),
        );


.. php:staticmethod:: phone(mixed $check, string $regex = null, string $country = 'all')

    Phone 规则验证美国的电话号码。如果你要验证美国以外的电话号码，你可以在第二个参数用一个正则表达式来处理其他的号码格式。

    ::

        public $validate = array(
            'phone' => array(
                'rule' => array('phone', null, 'us')
            )
        );


.. php:staticmethod:: postal(mixed $check, string $regex = null, string $country = 'us')

    Postal 规则验证美国(us)，加拿大(ca)，英国(uk)，意大利(it)，德国(de)和比利时(be)的邮政编码。对于其他的邮政编码格式，你可以在第二个参数提供一个正则表达式。

    ::

        public $validate = array(
            'zipcode' => array(
                'rule' => array('postal', null, 'us')
            )
        );


.. php:staticmethod:: range(string $check, integer $lower = null, integer $upper = null)

    这条规则确保数值在一个给定范围内。如果没有指定范围，规则会检查数值是当前平台上的合法有限数。

    ::

        public $validate = array(
            'number' => array(
                'rule'    => array('range', -1, 11),
                'message' => '请输入0到10之间的数'
            )
        );


    上面的例子会接受大于0(比如0.01)而且小于10 (比如9.99)的任何数值。

    .. note::

        上下限的值是不包括在内的。


.. php:staticmethod:: ssn(mixed $check, string $regex = null, string $country = null)

    Ssn 规则验证美国(us)，丹麦(dk)，和荷兰(nl)的社会保险号码。对于其他的社会保险号码，你可以指定正则表达式。

    ::

        public $validate = array(
            'ssn' => array(
                'rule' => array('ssn', null, 'us')
            )
        );


.. php:staticmethod:: time(string $check)

    Time 验证规则决定传入的字符串是否是正确的时间。以24小时(HH:MM)或上午/下午([H]H:MM[a|p]m)来验证。不允许/验证秒。

.. php:staticmethod:: uploadError(mixed $check)

    .. versionadded:: 2.2

    这条规则检查文件上载是否有错。

    ::

        public $validate = array(
            'image' => array(
                'rule'    => 'uploadError',
                'message' => '上载出错了。'
            ),
        );

.. php:staticmethod:: url(string $check, boolean $strict = false)

    这条规则检查合法的网址格式。支持 http(s)，ftp(s),
    file，news，and gopher 协议::

        public $validate = array(
            'website' => array(
                'rule' => 'url'
            )
        );

    为确保协议在网址中，可以象这样使用严格模式::

        public $validate = array(
            'website' => array(
                'rule' => array('url', true)
            )
        );


.. php:staticmethod:: userDefined(mixed $check, object $object, string $method, array $args = null)

    执行用户定义的验证。


.. php:staticmethod:: uuid(string $check)

    检查数据是合法的 uuid: http://tools.ietf.org/html/rfc4122。


本地化验证
====================

验证规则 phone() 和 postal() 会把它们不知道如何处理的国家前缀交给适当命名的其他类来处理。例如，如果你住在荷兰，你就可以创建这样一个类::

    class NlValidation {
        public static function phone($check) {
            // ...
        }
        public static function postal($check) {
            // ...
        }
    }
这个文件可以放在 ``APP/Validation/`` 或者 ``App/PluginName/Validation/``，但必须在使用之前用 App::uses() 导入。在你的模型验证中你可以这样使用 NlValidation 类::

    public $validate = array(
        'phone_no' => array('rule' => array('phone', null, 'nl')),
        'postal_code' => array('rule' => array('postal', null, 'nl')),
    );

当你的模型数据被验证时，验证程序会知道它无法处理 ``nl`` 地区，就会尝试把任务交给 ``NlValidation::postal()``，该方法的返回值就会被用作验证通过/失败的标志。这个方法允许你创建一些类来处理一组或一个子集的地区，这是一个大的 switch 语句无法实现的。单个验证方法的用法并没有改变，只是增加了跳转到其他验证的功能。

.. tip::

    Localized 插件已经包括许多可以使用的规则:
    https://github.com/cakephp/localized
    另外，随意贡献你的本地化验证规则。

.. toctree::

    data-validation/validating-data-from-the-controller


.. meta::
    :title lang=zh_CN: Data Validation
    :keywords lang=zh_CN: validation rules,validation data,validation errors,data validation,credit card numbers,core libraries,password email,model fields,login field,model definition,php class,many different aspects,eight characters,letters and numbers,business rules,validation process,date validation,error messages,array,formatting