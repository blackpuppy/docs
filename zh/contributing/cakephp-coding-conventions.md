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
        echo 'Boolean value is true';
        if ($stringVariable === 'moose') {
            echo 'We have encountered a moose';
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

    //很好，简答，已读
    $variable = isset($options['variable']) ? $options['variable'] : true;

    //嵌套的三元运算不好
    $variable = isset($options['variable']) ? isset($options['othervar']) ? true : false : false;


视图文件
--------

在视图文件(.ctp files)中，开发人员使用关键词控制结构。关键词控制结构
在复杂视图文件中更容易阅读。控制结构可以放在一段大的PHP代码段落中，也可以放
在单独的PHP标签中::

    <?php
    if ($isAdmin):
        echo '<p>You are the admin user.</p>';
    endif;
    ?>
    <p>下面也是可以接受的:</p>
    <?php if ($isAdmin): ?>
        <p>You are the admin user.</p>
    <?php endif; ?>


Function Calls
==============

Functions should be called without space between function's name and
starting bracket. There should be one space between every parameter of a
function call::

    $var = foo($bar, $bar2, $bar3);

As you can see above there should be one space on both sides of equals
sign (=).

Method definition
=================

Example of a function definition::

    function someFunction($arg1, $arg2 = '') {
        if (expr) {
            statement;
        }
        return $var;
    }

Parameters with a default value, should be placed last in function
definition. Try to make your functions return something, at least true
or false = so it can be determined whether the function call was
successful::

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

There are spaces on both side of the equals sign.

Commenting code
===============

All comments should be written in English, and should in a clear way
describe the commented block of code.

Comments can include the following `phpDocumentor <http://phpdoc.org>`_
tags:

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

PhpDoc tags are very much like JavaDoc tags in Java. Tags are only
processed if they are the first thing in a DocBlock line, for example::

    /**
     * Tag example.
     * @author this tag is parsed, but this @version is ignored
     * @version 1.0 this tag is also parsed
     */

::

    /**
     * Example of inline phpDoc tags.
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

Comment blocks, with the exception of the first block in a file, should
always be preceded by a newline.

Including files
===============

When including files with classes or libraries, use only and always the
`require\_once <http://php.net/require_once>`_ function.

PHP tags
========

Always use long tags (``<?php ?>``) Instead of short tags (<? ?>).

Naming convention
=================

Functions
---------

Write all functions in camelBack::

    function longFunctionName() {
    }

Classes
-------

Class names should be written in CamelCase, for example::

    class ExampleClass {
    }

Variables
---------

Variable names should be as descriptive as possible, but also as short
as possible. Normal variables should start with a lowercase letter, and
should be written in camelBack in case of multiple words. Variables
containing objects should start with a capital letter, and in some way
associate to the class the variable is an object of. Example::

    $user = 'John';
    $users = array('John', 'Hans', 'Arne');

    $Dispatcher = new Dispatcher();

Member visibility
-----------------

Use PHP5's private and protected keywords for methods and variables.  Additionally,
protected method or variable names start with a single underscore ("\_"). Example::

    class A {
        protected $_iAmAProtectedVariable;

        protected function _iAmAProtectedMethod() {
           /*...*/
        }
    }

Private methods or variable names start with double underscore ("\_\_"). Example::

    class A {
        private $__iAmAPrivateVariable;

        private function __iAmAPrivateMethod() {
            /*...*/
        }
    }

Method Chaining
---------------

Method chaining should have multiple methods spread across separate lines, and
indented with one tab::

    $email->from('foo@example.com')
        ->to('bar@example.com')
        ->subject('A great message')
        ->send();

Example addresses
-----------------

For all example URL and mail addresses use "example.com", "example.org"
and "example.net", for example:

*  Email: someone@example.com
*  WWW: `http://www.example.com <http://www.example.com>`_
*  FTP: `ftp://ftp.example.com <ftp://ftp.example.com>`_

The ``example.com`` domain name has been reserved for this (see :rfc:`2606`) and is recommended
for use in documentation or as examples.

Files
-----

File names which do not contain classes should be lowercased and underscored, for
example:

::

    long_file_name.php

Variable types
--------------

Variable types for use in DocBlocks:

Type
    Description
mixed
    A variable with undefined (or multiple) type.
integer
    Integer type variable (whole number).
float
    Float type (point number).
boolean
    Logical type (true or false).
string
    String type (any value in " " or ' ').
array
    Array type.
object
    Object type.
resource
    Resource type (returned by for example mysql\_connect()).
    Remember that when you specify the type as mixed, you should indicate
    whether it is unknown, or what the possible types are.

Constants
---------

Constants should be defined in capital letters:

::

    define('CONSTANT', 1);

If a constant name consists of multiple words, they should be separated
by an underscore character, for example:

::

    define('LONG_NAMED_CONSTANT', 2);


.. meta::
    :title lang=en: Coding Standards
    :keywords lang=en: curly brackets,indentation level,logical errors,control structures,control structure,expr,coding standards,parenthesis,foreach,readability,moose,new features,repository,developers
