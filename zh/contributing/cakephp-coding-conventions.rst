编码规范
########

Cake开发人员将使用下面的编码规范。

我们建议其他开发Cake组成部分的人员也应当遵循同样的规范。

你可以使用`CakePHP Code Sniffer <https://github.com/cakephp/cakephp-codesniffer>`_来
检查你的代码是否遵循了必要的规范。

添加新特性
==========

添加新特性，必须伴随相应的测试用例，在提交到代码仓库前，测试用例必须通过。

缩进
====

缩进使用一个制表符。

所以，缩进应当看起来象这样::

    // 底层
        // 第1层
            // 第2层
        // 第1层
    // 底层

或者::

    $booleanVariable = true;
    $stringVariable = 'moose';
    if ($booleanVariable) {
        echo '布尔值为真';
        if ($stringVariable === '驼鹿') {
            echo '我们遇到了一只驼鹿';
        }
    }

控制结构
========

控制结构是"``if``"，"``for``"，"``foreach``"，"``while``"，"``switch``"这些。
下面是使用"``if``"的一个例子::

    if ((expr_1) || (expr_2)) {
        // action_1;
    } elseif (!(expr_3) && (expr_4)) {
        // action_2;
    } else {
        // default_action;
    }

*  在控制结构中，在第一个括号之前应该有一个空格，在最后一个括号和开始的大括
   号之间也应该有一个空格。
*  在控制结构中总是使用大括号，即使他们是不必要的。这会提高代码的可读性，也
   导致较少的逻辑错误。
*  开始的大括号应与控制结构放在同一行上。结束的大括号应该新起一行，并且与控制
   结构应该有相同的缩进级别。包括在大括号中的语句应该新起一行，其代码也应该再
   缩进一层。

::

    // 错 = 没有大括号，语句的位置也不对
    if (expr) statement;

    // 错 = 没有大括号
    if (expr)
        statement;

    // 正确
    if (expr) {
        statement;
    }

三元运算符
----------

当整个三元运算可以放在一行之内时，三元运算符是允许的。更长的三元运算就应该分成
``if else``语句。三元运算符绝不允许嵌套。括号虽然不必须，但是可以用在三元运算的
条件检查之外，使其更清晰::

    //很好，简单，易读
    $variable = isset($options['variable']) ? $options['variable'] : true;

    //嵌套的三元运算不好
    $variable = isset($options['variable']) ? isset($options['othervar']) ? true : false : false;


视图文件
--------

在视图文件(.ctp files)中，开发人员使用关键词控制结构。关键词控制结构
在复杂的视图文件中更容易阅读。控制结构可以放在一段大的PHP代码段落中，
也可以放在单独的PHP标签中::

    <?php
    if ($isAdmin):
        echo '<p>You are the admin user.</p>';
    endif;
    ?>
    <p>下面也是可以接受的:</p>
    <?php if ($isAdmin): ?>
        <p>You are the admin user.</p>
    <?php endif; ?>


函数调用
========

在函数调用中，函数名和开始的括号之间不允许有空格，在每个参数之间应当有一个空格::

    $var = foo($bar, $bar2, $bar3);

如上所示，在等号(=)的两边都应该有一个空格。

方法的定义
==========

函数定义的例子::

    function someFunction($arg1, $arg2 = '') {
        if (expr) {
            statement;
        }
        return $var;
    }

带缺省值的参数应该放在函数定义的最后。尽量让你的函数返回一些东西, 至少是
true或者false = 这样就可以判断函数调用是否成功::

    public function connection($dns, $persistent = false) {
        if (is_array($dns)) {
            $dnsInfo = $dns;
        } else {
            $dnsInfo = BD::parseDNS($dns);
        }

        if (!($dnsInfo) || !($dnsInfo['phpType'])) {
            return $this->addError();
        }
        return true;
    }

等号两边都有空格。

代码的注释
==========

所有的注释都应该是英文, 并且应该清楚地描述被注释的代码段。

注释可以包括以下`phpDocumentor <http://phpdoc.org>`_标签:

*  `@access <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.access.pkg.html>`_
*  `@author <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.author.pkg.html>`_
*  `@copyright <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.copyright.pkg.html>`_
*  `@deprecated <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.deprecated.pkg.html>`_
*  `@example <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.example.pkg.html>`_
*  `@ignore <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.ignore.pkg.html>`_
*  `@internal <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.internal.pkg.html>`_
*  `@link <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.link.pkg.html>`_
*  `@see <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.see.pkg.html>`_
*  `@since <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.since.pkg.html>`_
*  `@tutorial <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.tutorial.pkg.html>`_
*  `@version <http://manual.phpdoc.org/HTMLframesConverter/phpdoc.de/phpDocumentor/tutorial_tags.version.pkg.html>`_

PhpDoc标签非常类似于Java中的JavaDoc标签。标签只有最先出现在
DocBlock行中才会起作用, 例如::

    /**
     * Tag example.
     * @author 这个标签会被处理, 但这个@version会被忽略
     * @version 1.0 这个标签也会被处理
     */

::

    /**
     * 内嵌phpDoc的例子。
     *
     * This function works hard with foo() to rule the world.
     */
    function bar() {
    }

    /**
     * Foo function
     */
    function foo() {
    }

所有注释段, 除了一个文件中的第一段, 之前总是应当有一个空行。

包括文件
========

当包括类或者库的文件时, 总是只使用`require\_once
<http://php.net/require_once>`_函数。

PHP标签
=======

总是使用长标签(``<?php ?>``), 而不用短标签(<? ?>)。

命名规则
========

函数
----

所有函数名都应为camelBack::

    function longFunctionName() {
    }

类
--

类名应为CamelCase, 例如::

    class ExampleClass {
    }

变量
----

变量名应当尽可能具有描述性, 但同时越短越好。普通变量应当以小写字母开头,
如果含有多个词, 则应当为camelBack。对象变量的变量名应当以大写字母开头,
并且与对象所属的类应当以某种方式相关联。例如::

    $user = 'John';
    $users = array('John', 'Hans', 'Arne');

    $Dispatcher = new Dispatcher();

成员的可见范围
--------------

方法和变量应当使用PHP5的private和protected关键字。另外,
protected的方法和变量应当以一个下划线开头("\_")。例如::

    class A {
        protected $_iAmAProtectedVariable;

        protected function _iAmAProtectedMethod() {
           /*...*/
        }
    }

私有方法和变量应当以双下划线("\_\_")开头。例如::

    class A {
        private $__iAmAPrivateVariable;

        private function __iAmAPrivateMethod() {
            /*...*/
        }
    }

方法链接
--------

方法链接时, 多个方法应当在各自的行上, 并且缩进一个制表符::

    $email->from('foo@example.com')
        ->to('bar@example.com')
        ->subject('A great message')
        ->send();

示例地址
--------

所有示例用的网址和电子邮箱地址应当使用"example.com", "example.org"
和"example.net", 例如:

*  电子邮箱地址: someone@example.com
*  网址: `http://www.example.com <http://www.example.com>`_
*  FTP: `ftp://ftp.example.com <ftp://ftp.example.com>`_

``example.com``域名已为此目的而保留(参见:rfc:`2606`), 建议在文档中或者作为例子使用。

文件
----

不包含类的文件, 其文件名应当小写, 并且以下划线分隔单词, 例如:

::

    long_file_name.php

变量类型
--------

DocBlock中使用的变量类型:

类型
    描述
mixed
    有未定义(或多种)类型的变量。
integer
    整数类型变量(整数)。
float
    浮点数类型(浮点数)。
boolean
    逻辑类型(true或者false)。
string
    字符串类型(位于" "或' '中的任何值)。
array
    数组类型。
object
    对象类型。
resource
    资源类型(例如由mysql\_connect()返回的)。
    记住, 如果你指定了混合类型, 则需指明是未知, 或者可以是哪些类型。

常量
----

常量名称应当大写:

::

    define('CONSTANT', 1);

如果常量名称由多个单词组成的，则应当用下划线分隔，例如：

::

    define('LONG_NAMED_CONSTANT', 2);


.. meta::
    :title lang=en: Coding Standards
    :keywords lang=en: curly brackets,indentation level,logical errors,control structures,control structure,expr,coding standards,parenthesis,foreach,readability,moose,new features,repository,developers
