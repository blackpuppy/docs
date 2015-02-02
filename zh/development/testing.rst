测试
####

CakePHP 内置带有全面的测试支持。CakePHP 自带与 `PHPUnit <http://phpunit.de>`_ 的集成。除了 PHPUnit 提供的特性，CakePHP 提供了一些额外的功能，使得测试更为容易。本节将介绍 PHPUnit 的安装，开始进行单元测试，以及如何使用 CakePHP 提供的扩展。

CakePHP comes with comprehensive testing support built-in. CakePHP comes with
integration for `PHPUnit <http://phpunit.de>`_. In addition to the features
offered by PHPUnit, CakePHP offers some additional features to make testing
easier. This section will cover installing PHPUnit, and getting started with
Unit Testing, and how you can use the extensions that CakePHP offers.

安装 PHPUnit
==================

Installing PHPUnit
==================

CakePHP 使用 PHPUnit 作为其底层测试框架。PHPUnit 是 PHP 单元测试事实上的标准。它提供了一套深刻而强大的功能，确保你的代码做了你认为它所要做的事情。

CakePHP uses PHPUnit as its underlying test framework. PHPUnit is the de-facto
standard for unit testing in PHP. It offers a deep and powerful set of features
for making sure your code does what you think it does.

通过 Composer 安装
--------------------

Install via Composer
--------------------

较新版本的 PHPUnit 当前不能与 CakePHP 集成::

The newer versions of phpunit do not currently work with CakePHP::

    "phpunit/phpunit": "3.7.32"

通过 .phar 包来安装
--------------------
 
Install via .phar Package
-------------------------

你也可以直接下载文件。只是要注意从 https://phar.phpunit.de/ 得到了正确的版本。确保 /usr/local/bin 位于 php.ini 文件的 include_path 中::

You can also download the file directly. Just make sure you get the correct version from https://phar.phpunit.de/. 
Make sure /usr/local/bin is in your php.ini file's include_path::

    wget https://phar.phpunit.de/phpunit-3.7.32.phar
    chmod +x phpunit.phar
    mv phpunit.phar /usr/local/bin/phpunit

.. note::

    PHPUnit 4 与 CakePHP 的单元测试不兼容。

    PHPUnit 4 is not compatible with CakePHP's Unit Testing.

    根据你系统的配置，你可能需要用 ``sudo`` 运行上面的命令。

    Depending on your system's configuration, you may need to run the previous
    commands with ``sudo``

一旦用 PEAR 安装程序安装了 PHPUnit，应当确认 PHPUnit 库在 PHP 的  ``include_path`` 中。为此你可以检查 php.ini 文件，确保 PHPUnit 的文件在 ``include_path`` 的其中一个目录中。

Once PHPUnit is installed with the PEAR installer, you should confirm that the
PHPUnit libraries are on PHP's ``include_path``. You can do this by checking
your php.ini file and making sure that the PHPUnit files are in one of the
``include_path`` directories.

.. tip::

    当使用 PHPUnit 3.6+ 时，所有的输出都会被吞没。如果使用 CLI，可以添加 ``--debug`` 修饰符；如果使用 web 运行器来显示输出，可以添加 ``&debug=1`` 到网址中。

    All output is swallowed when using PHPUnit 3.6+. Add the ``--debug``
    modifier if using the CLI or add ``&debug=1`` to the URL if using the web
    runner to display output.

测试数据库的设置
===================

Test Database Setup
===================

记得在运行任何测试之前，在 ``app/Config/core.php`` 文件中的调试(debug)级别至少是 1。当调试级别是 0 时，无法通过 web 运行器访问测试。在运行任何测试之前，应当确保添加 ``$test`` 数据库配置。该配置被 CakePHP 用于测试夹具(*fixture*)的表和数据::

Remember to have a debug level of at least 1 in your ``app/Config/core.php``
file before running any tests. Tests are not accessible via the web runner when
debug is equal to 0. Before running any tests you should be sure to add a
``$test`` database configuration. This configuration is used by CakePHP for
fixture tables and data::

    public $test = array(
        'datasource' => 'Database/Mysql',
        'persistent' => false,
        'host'       => 'dbhost',
        'login'      => 'dblogin',
        'password'   => 'dbpassword',
        'database'   => 'test_database'
    );

.. note::

    把测试数据库和实际的数据库分成不同的数据库比较好。这可以避免将来任何令人尴尬的错误。

    It's a good idea to make the test database and your actual database
    different databases. This will prevent any embarrassing mistakes later.

检查测试数据库的设置
=======================

Checking the Test Setup
=======================

安装完了 PHPUnit，设置好了 ``$test`` 数据库配置，可以运行核心测试中的一个，来确保你可以编写和运行你自己的测试。测试有两个内置的运行器，我们从 web 运行器开始。浏览 http://localhost/your_app/test.php 就可以访问测试，应当能看到核心测试列表了。点击 'AllConfigure' 测试。你应当看到一个绿色的(进度)条，和运行的测试的更多信息，以及通过的测试数量。

After installing PHPUnit and setting up your ``$test`` database configuration
you can make sure you're ready to write and run your own tests by running one of
the core tests. There are two built-in runners for testing, we'll start off by
using the web runner. The tests can then be accessed by browsing to
http://localhost/your_app/test.php. You should see a list of the core test
cases. Click on the 'AllConfigure' test. You should see a green bar with some
additional information about the tests run, and number passed.

恭喜，你现在可以开始编写测试了！

Congratulations, you are now ready to start writing tests!

测试用例约定
=====================

Test Case Conventions
=====================

象 CakePHP 中的大部分东西，测试用例也有一些约定。涉及测试的：

#. 包含测试的 PHP 文件应当位于 ``app/Test/Case/[Type]`` 目录。
#. 这些文件的文件名应当以 ``Test.php`` 结尾，而不能仅仅是.php。
#. 含有测试的类应当扩展 ``CakeTestCase``，``ControllerTestCase`` 或 ``PHPUnit_Framework_TestCase``。
#. 象其它类名，测试用例类名应当与文件名匹配。文件 ``RouterTest.php`` 应当包含 ``class RouterTest extends CakeTestCase``。
#. 包含测试(即包含断言(*assertion*))的任何方法的名称应当以 ``test`` 开头，例如 ``testPublished()``。也可以使用 ``@test`` 标注(*annotation*)来标记方法为测试方法。

Like most things in CakePHP, test cases have some conventions. Concerning
tests:

#. PHP files containing tests should be in your
   ``app/Test/Case/[Type]`` directories.
#. The filenames of these files should end in ``Test.php`` instead
   of just .php.
#. The classes containing tests should extend ``CakeTestCase``,
   ``ControllerTestCase`` or ``PHPUnit_Framework_TestCase``.
#. Like other class names, the test case class names should match the filename.
   ``RouterTest.php`` should contain ``class RouterTest extends CakeTestCase``.
#. The name of any method containing a test (i.e. containing an
   assertion) should begin with ``test``, as in ``testPublished()``.
   You can also use the ``@test`` annotation to mark methods as test methods.

在创建了测试用例之后，可以浏览 ``http://localhost/your_app/test.php`` (取决于你配置是怎样的)来运行。点击 App test cases，再点击测试文件的链接。也可以从命令行使用测试外壳(*shell*)来运行测试::

When you have created a test case, you can execute it by browsing
to ``http://localhost/your_app/test.php`` (depending on
how your specific setup looks). Click App test cases, and
then click the link to your specific file. You can run tests from the command
line using the test shell::

    ./Console/cake test app Model/Post

例如，就会运行 Post 模型的测试。

For example, would run the tests for your Post model.

创建你的第一个测试用例
=============================

Creating Your First Test Case
=============================

在下面的例子中，我们会为一个很简单的助件(*helper*)方法创建一个测试用例。我们要测试的助件会生成进度条 HTML。助件是这样的::

In the following example, we'll create a test case for a very simple helper
method. The helper we're going to test will be formatting progress bar HTML.
Our helper looks like::

    class ProgressHelper extends AppHelper {
        public function bar($value) {
            $width = round($value / 100, 2) * 100;
            return sprintf(
                '<div class="progress-container">
                    <div class="progress-bar" style="width: %s%%"></div>
                </div>', $width);
        }
    }

这是个很简单的例子，不过可以展示如何创建简单的测试用例。创建并保存助件后，我们来创建测试用例文件 ``app/Test/Case/View/Helper/ProgressHelperTest.php``。在该文件中我们以如下代码开始::

This is a very simple example, but it will be useful to show how you can create
a simple test case. After creating and saving our helper, we'll create the test
case file in ``app/Test/Case/View/Helper/ProgressHelperTest.php``. In that file
we'll start with the following::

    App::uses('Controller', 'Controller');
    App::uses('View', 'View');
    App::uses('ProgressHelper', 'View/Helper');

    class ProgressHelperTest extends CakeTestCase {
        public function setUp() {

        }

        public function testBar() {

        }
    }

我们很快就会填充这个骨架。我们增加了两个方法。第一个是 ``setUp()``。这个方法会在测试用例类中的每个 *测试* 方法被调用之前调用。setup 方法应当初始化测试需要的对象，做任何需要的配置。在我们的 setup 方法中，我们添加如下代码::

We'll flesh out this skeleton in a minute. We've added two methods to start
with. First is ``setUp()``. This method is called before every *test* method
in a test case class. Setup methods should initialize the objects needed for the
test, and do any configuration needed. In our setup method we'll add the
following::

    public function setUp() {
        parent::setUp();
        $Controller = new Controller();
        $View = new View($Controller);
        $this->Progress = new ProgressHelper($View);
    }

在测试用例中调用父类方法很重要，因为 CakeTestCase::setUp() 方法完成一些事情，比如备份 :php:class:`Configure` 类中的值，以及保存 :php:class:`App` 类中的路径。

Calling the parent method is important in test cases, as CakeTestCase::setUp()
does a number things like backing up the values in :php:class:`Configure` and,
storing the paths in :php:class:`App`.

接下来，我们要填写测试方法。我们会使用一些断言(*assertion*)来确保我们的代码生成了我们希望的输出::

Next, we'll fill out the test method. We'll use some assertions to ensure that
our code creates the output we expect::

    public function testBar() {
        $result = $this->Progress->bar(90);
        $this->assertContains('width: 90%', $result);
        $this->assertContains('progress-bar', $result);

        $result = $this->Progress->bar(33.3333333);
        $this->assertContains('width: 33%', $result);
    }

上述测试很简单，但展示了使用测试用例的潜在好处。我们用 ``assertContains()`` 来确保助件返回的字符串包含我们期望的内容。如果结果不包含期望的内容，测试就会失败，我们就知道我们的代码不对了。

The above test is a simple one but shows the potential benefit of using test
cases. We use ``assertContains()`` to ensure that our helper is returning a
string that contains the content we expect. If the result did not contain the
expected content the test would fail, and we would know that our code is
incorrect.

使用测试用例，可以轻易地描述一组已知输入和它们期望的输出之间的关系。这可以帮助你对正在编写的代码更有信心，因为你可以容易地检查你写的代码满足测试所做的期望和断言。而且，因为测试是代码，无论何时你做了一处改动，它们都很容易再次运行。这帮助防止了新错误(*bug*)的出现。

By using test cases you can easily describe the relationship between a set of
known inputs and their expected output. This helps you be more confident of the
code you're writing as you can easily check that the code you wrote fulfills the
expectations and assertions your tests make. Additionally because tests are
code, they are easy to re-run whenever you make a change. This helps prevent
the creation of new bugs.

.. _running-tests:

运行测试
=============

Running Tests
=============

一旦安装了 PHPUnit，写了一些测试用例，你就应当很频繁地运行测试用例。在提交任何改动之前运行测试比较好，可以帮助确保你没有破坏任何东西。

Once you have PHPUnit installed and some test cases written, you'll want to run
the test cases very frequently. It's a good idea to run tests before committing
any changes to help ensure you haven't broken anything.

从浏览器运行测试
----------------------------

Running tests from a browser
----------------------------

CakePHP 提供了运行测试的 web 界面，这样，如果你觉得这个环境更舒服，你可以通过浏览器运行测试。你可以通过访问 ``http://localhost/your_app/test.php`` 来访问 web 运行器。test.php 的确切位置根据你的设置而变化。不过该文件和 ``index.php`` 在同一级。

CakePHP provides a web interface for running tests, so you can execute your
tests through a browser if you're more comfortable in that environment. You can
access the web runner by going to ``http://localhost/your_app/test.php``. The
exact location of test.php will change depending on your setup. But the file is
at the same level as ``index.php``.

一旦加载了测试运行器，就可以在 App、Core 和 Plugin 测试套件之间切换。点击单个测试用例就会运行该测试，并显示结果。

Once you've loaded up the test runner, you can navigate App, Core and Plugin test
suites. Clicking an individual test case will run that test and display the
results.

查看代码覆盖
~~~~~~~~~~~~~~~~~~~~~

Viewing code coverage
~~~~~~~~~~~~~~~~~~~~~

如果你安装了 `XDebug <http://xdebug.org>`_，就可以查看代码覆盖的结果。代码覆盖可以告诉你，你的测试没有触及代码的哪部分。覆盖率用于决定在哪里今后还应当添加测试，并给你一个度量来监测你测试的进展。

If you have `XDebug <http://xdebug.org>`_ installed, you can view code coverage
results. Code coverage is useful for telling you what parts of your code your
tests do not reach. Coverage is useful for determining where you should add
tests in the future, and gives you one measurement to track your testing
progress with.

.. |Code Coverage| image:: /_static/img/code-coverage.png

|Code Coverage|

内嵌的代码覆盖使用绿色行来表示运行过的行。如果把鼠标悬停在一个绿色的行上，会有提示说明哪些测试覆盖了该行。红色的行没有运行，即没有被测试检验。灰色的行被 XDebug 认为无法运行。

The inline code coverage uses green lines to indicate lines that have been run.
If you hover over a green line a tooltip will indicate which tests covered the
line. Lines in red did not run, and have not been exercised by your tests. Grey
lines are considered unexecutable code by xdebug.

.. _run-tests-from-command-line:

从命令行运行测试
-------------------------------

Running tests from command line
-------------------------------

CakePHP 提供 ``test`` 外壳(*shell*)来运行测试。你可以用 test 外壳容易地运行 app、core 和 plugin 的测试。它也接受通常 PHPUnit 命令行期望的的所有参数。从 app 目录，可以用下面的命令来运行测试::

CakePHP provides a ``test`` shell for running tests. You can run app, core
and plugin tests easily using the test shell. It accepts all the arguments
you would expect to find on the normal PHPUnit command line tool as well. From
your app directory you can do the following to run tests::

    # 运行 app 中的模型测试
    # Run a model tests in the app
    ./Console/cake test app Model/Article

    # 运行插件中的组件测试
    # Run a component test in a plugin
    ./Console/cake test DebugKit Controller/Component/ToolbarComponent

    # 运行 CakePHP 中的 configure 类测试
    # Run the configure class test in CakePHP
    ./Console/cake test core Core/Configure

.. note::

    如果你运行与会话(*session*)交互的测试，通常最好使用 ``--stderr`` 选项。这可以修正由于 headers_sent 警告引起的测试失败的问题。

    If you are running tests that interact with the session it's generally a good
    idea to use the ``--stderr`` option. This will fix issues with tests
    failing because of headers_sent warnings.

.. versionchanged:: 2.1
    在 2.1 版本中增加了 ``test`` 外壳。2.0 版本的 ``testsuite`` 外壳仍然可以使用，但建议使用新语法。
    The ``test`` shell was added in 2.1. The 2.0 ``testsuite`` shell is still
    available but the new syntax is preferred.

也可以在项目根目录下运行 ``test`` 外壳。这会显示你现有全部测试的列表。你可以自由地选择要运行的一个或多个测试::

You can also run ``test`` shell in the project root directory. This shows
you a full list of all the tests that you currently have. You can then freely
choose what test(s) to run::

    # 在项目根目录中运行叫做 app 的应用程序目录的测试
    # Run test in project root directory for application folder called app
    lib/Cake/Console/cake test app

    # 在项目根目录中运行位于 ./myapp 目录中的应用程序的测试
    # Run test in project root directory for an application in ./myapp
    lib/Cake/Console/cake test --app myapp app

过滤测试用例
~~~~~~~~~~~~~~~~~~~~

Filtering test cases
~~~~~~~~~~~~~~~~~~~~

在你有大量测试用例的情况下，当你试图修复单个失败的用例时，你会经常要运行测试方法的一个子集。使用 CLI 运行器，你可以使用一个选项来过滤测试方法::

When you have larger test cases, you will often want to run a subset of the test
methods when you are trying to work on a single failing case. With the
CLI runner you can use an option to filter test methods::

    ./Console/cake test core Console/ConsoleOutput --filter testWriteArray

过滤参数作为大小写敏感的正则表达式，来过滤要运行的测试方法。

The filter parameter is used as a case-sensitive regular expression for filtering
which test methods to run.

生成代码覆盖率
~~~~~~~~~~~~~~~~~~~~~~~~

Generating code coverage
~~~~~~~~~~~~~~~~~~~~~~~~

你可以从命令行使用 PHPUnit 内置的代码覆盖工具来生成代码覆盖报告。PHPUnit 会生成一组包含覆盖结果的静态 HTML 文件。你可以像下面这样来生成一个测试用例的覆盖报告::

You can generate code coverage reports from the command line using PHPUnit's
built-in code coverage tools. PHPUnit will generate a set of static HTML files
containing the coverage results. You can generate coverage for a test case by
doing the following::

    ./Console/cake test app Model/Article --coverage-html webroot/coverage

这会把覆盖结果放在应用程序的 webroot 目录中。你应当能够在 ``http://localhost/your_app/coverage`` 看到结果。

This will put the coverage results in your application's webroot directory. You
should be able to view the results by going to
``http://localhost/your_app/coverage``.

运行使用会话的测试
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Running tests that use sessions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

在命令行运行使用会话的测试时，需要加上 ``--stderr`` 标志。不这么做会导致会话无法工作。PHPUnit 默认会输出测试进程到标准输出(*stdout*)，这会引起 PHP 以为头部信息已经发送，从而阻止会话启动。切换 PHPUnit 输出到 stderr，避免了这个问题。

When running tests on the command line that use sessions you'll need to include
the ``--stderr`` flag. Failing to do so will cause sessions to not work.
PHPUnit outputs test progress to stdout by default, this causes PHP to assume
that headers have been sent which prevents sessions from starting. By switching
PHPUnit to output on stderr, this issue is avoided.


测试用例生命周期回调
=============================

Test Case Lifecycle Callbacks
=============================

测试用例有一些生命周期回调函数，可以在测试时使用：

* ``setUp`` 在每个测试方法之前调用。应当用来创建要测试的对象，为测试初始化任何数据。记得一定要调用 ``parent::setUp()``。
* ``tearDown`` 在每个测试方法之后调用。应当用来在测试完成之后进行清理。记得一定要调用  ``parent::tearDown()``。
* ``setupBeforeClass`` 在一个用例中的测试方法开始之前只调用一次。该方法必须是 *静态的*。
* ``tearDownAfterClass`` 在一个用例中的测试方法开始之后只调用一次。该方法必须是 *静态的*。

Test cases have a number of lifecycle callbacks you can use when doing testing:

* ``setUp`` is called before every test method. Should be used to create the
  objects that are going to be tested, and initialize any data for the test.
  Always remember to call ``parent::setUp()``
* ``tearDown`` is called after every test method. Should be used to cleanup after
  the test is complete. Always remember to call ``parent::tearDown()``.
* ``setupBeforeClass`` is called once before test methods in a case are started.
  This method must be *static*.
* ``tearDownAfterClass`` is called once after test methods in a case are started.
  This method must be *static*.

测试夹具
========

Fixtures
========

当测试代码依赖于模型和数据库时，可以使用 **测试夹具** 来生成临时数据库表，加载样例数据，用于测试。使用测试夹具的好处是，你的测试不会破坏实际的应用程序数据。而且，在真的为应用程序开发实际内容之前，你就可以测试你的代码。

When testing code that depends on models and the database, one can use
**fixtures** as a way to generate temporary data tables loaded with sample data
that can be used by the test. The benefit of using fixtures is that your test
has no chance of disrupting live application data. In addition, you can begin
testing your code prior to actually developing live content for an application.

CakePHP 使用 ``app/Config/database.php`` 配置文件中的名为 ``$test`` 的(数据库)连接。如果该连接无法使用，将引发一个异常，就无法使用数据库夹具了。

CakePHP uses the connection named ``$test`` in your ``app/Config/database.php``
configuration file. If this connection is not usable, an exception will be
raised and you will not be able to use database fixtures.

在一个基于夹具的测试用例的运行过程中，CakePHP 执行下面的操作：

#. 创建每个夹具需要的表。
#. 如果夹具中通过了数据，用数据填充表。
#. 运行测试方法。
#. 清空夹具的表。
#. 从数据库删除夹具的表。

CakePHP performs the following during the course of a fixture based
test case:

#. Creates tables for each of the fixtures needed.
#. Populates tables with data, if data is provided in fixture.
#. Runs test methods.
#. Empties the fixture tables.
#. Removes fixture tables from database.

创建夹具
-----------------

Creating fixtures
-----------------

在创建夹具时，注意定义两件事情：如何创建表(表包含哪些字段)，哪些记录要首先填充到表中。让我们来创建第一个夹具，用于测试 Article 模型。在 ``app/Test/Fixture`` 目录中创建以下内容的文件 ``ArticleFixture.php``::

When creating a fixture you will mainly define two things: how the table is
created (which fields are part of the table), and which records will be
initially populated to the table. Let's create our first fixture, that will be
used to test our own Article model. Create a file named ``ArticleFixture.php``
in your ``app/Test/Fixture`` directory, with the following content::

    class ArticleFixture extends CakeTestFixture {

          // Optional.
          // Set this property to load fixtures to a different test datasource
          // 可选。
          // 设置该属性来加载夹具到不同的测试数据源
          public $useDbConfig = 'test';
          public $fields = array(
              'id' => array('type' => 'integer', 'key' => 'primary'),
              'title' => array(
                'type' => 'string',
                'length' => 255,
                'null' => false
              ),
              'body' => 'text',
              'published' => array(
                'type' => 'integer',
                'default' => '0',
                'null' => false
              ),
              'created' => 'datetime',
              'updated' => 'datetime'
          );
          public $records = array(
              array(
                'id' => 1,
                'title' => 'First Article',
                'body' => 'First Article Body',
                'published' => '1',
                'created' => '2007-03-18 10:39:23',
                'updated' => '2007-03-18 10:41:31'
              ),
              array(
                'id' => 2,
                'title' => 'Second Article',
                'body' => 'Second Article Body',
                'published' => '1',
                'created' => '2007-03-18 10:41:23',
                'updated' => '2007-03-18 10:43:31'
              ),
              array(
                'id' => 3,
                'title' => 'Third Article',
                'body' => 'Third Article Body',
                'published' => '1',
                'created' => '2007-03-18 10:43:23',
                'updated' => '2007-03-18 10:45:31'
              )
          );
     }

``$useDbConfig`` 属性定义夹具要使用的数据源。如果应用程序使用多个数据源，你应当使夹具匹配模型的数据源，但是加上 ``test_`` 前缀。例如，如果模型使用 ``mydb`` 数据源，夹具应当使用 ``test_mydb`` 数据源。如果 ``test_mydb`` 连接不存在，模型就会使用默认的 ``test`` 数据源。夹具数据源必须前缀以 ``test`` 来降低运行测试时意外清除应用程序的所有数据的可能性。

The ``$useDbConfig`` property defines the datasource of which the fixture will
use. If your application uses multiple datasources, you should make the
fixtures match the model's datasources but prefixed with ``test_``.
For example if your model uses the ``mydb`` datasource, your fixture should use
the ``test_mydb`` datasource. If the ``test_mydb`` connection doesn't exist,
your models will use the default ``test`` datasource. Fixture datasources must
be prefixed with ``test`` to reduce the possibility of accidentally truncating
all your application's data when running tests.

我们使用 ``$fields`` 来指定这个表有哪些字段，以及它们是如何定义的。用来定义这些字段的格式和 :php:class:`CakeSchema` 类使用的相同。表定义可以使用的键为：

``type``
    CakePHP 内部的数据类型。当前支持：
        - ``string``: 映射为 ``VARCHAR``
        - ``text``: 映射为 ``TEXT``
        - ``integer``: 映射为 ``INT``
        - ``float``: 映射为 ``FLOAT``
        - ``datetime``: 映射为 ``DATETIME``
        - ``timestamp``: 映射为 ``TIMESTAMP``
        - ``time``: 映射为 ``TIME``
        - ``date``: 映射为 ``DATE``
        - ``binary``: 映射为 ``BLOB``
``key``
    设置为 ``primary`` 来使该字段 AUTO\_INCREMENT，作为表的主键。
``length``
    设置为字段需要的长度。
``null``
    设置为 ``true`` (允许 NULL) 或者 ``false`` (不允许 NULL)。
``default``
    字段的默认值。

We use ``$fields`` to specify which fields will be part of this table,
and how they are defined. The format used to define these fields is
the same used with :php:class:`CakeSchema`. The keys available for table
definition are:

``type``
    CakePHP internal data type. Currently supported:
        - ``string``: maps to ``VARCHAR``
        - ``text``: maps to ``TEXT``
        - ``integer``: maps to ``INT``
        - ``float``: maps to ``FLOAT``
        - ``datetime``: maps to ``DATETIME``
        - ``timestamp``: maps to ``TIMESTAMP``
        - ``time``: maps to ``TIME``
        - ``date``: maps to ``DATE``
        - ``binary``: maps to ``BLOB``
``key``
    Set to ``primary`` to make the field AUTO\_INCREMENT, and a PRIMARY KEY
    for the table.
``length``
    Set to the specific length the field should take.
``null``
    Set to either ``true`` (to allow NULLs) or ``false`` (to disallow NULLs).
``default``
    Default value the field takes.

我们可以定义一组记录，在表创建之后填充到表里。其格式是相当简单的，``$records`` 为记录数组。``$records`` 中的每项为一行。在每行中，应当是该行的列和值的关联数组。只是要记住 $records 数组中的每条记录对必须有 ``$fields`` 数组中指定的 **每个** 字段都必须有一个键。如果某条记录的一个字段需要有 ``null`` 值，只需指定该键的值为 ``null``。

We can define a set of records that will be populated after the fixture table is
created. The format is fairly straight forward, ``$records`` is an array of
records. Each item in ``$records`` should be a single row. Inside each row,
should be an associative array of the columns and values for the row. Just keep
in mind that each record in the $records array must have a key for **every**
field specified in the ``$fields`` array. If a field for a particular record needs
to have a ``null`` value, just specify the value of that key as ``null``.

动态数据和夹具
-------------------------

Dynamic data and fixtures
-------------------------

既然夹具的记录声明为类属性，就不能容易地使用函数或者其它动态数据来定义夹具。为了解决这个问题，可以在夹具的 init() 方法中定义 ``$records``。例如，如果要所有 created 和 updated 时间标签反应今天的日期，可以这样做::

Since records for a fixture are declared as a class property, you cannot easily
use functions or other dynamic data to define fixtures. To solve this problem,
you can define ``$records`` in the init() function of your fixture. For example
if you wanted all the created and updated timestamps to reflect today's date you
could do the following::

    class ArticleFixture extends CakeTestFixture {

        public $fields = array(
            'id' => array('type' => 'integer', 'key' => 'primary'),
            'title' => array('type' => 'string', 'length' => 255, 'null' => false),
            'body' => 'text',
            'published' => array('type' => 'integer', 'default' => '0', 'null' => false),
            'created' => 'datetime',
            'updated' => 'datetime'
        );

        public function init() {
            $this->records = array(
                array(
                    'id' => 1,
                    'title' => 'First Article',
                    'body' => 'First Article Body',
                    'published' => '1',
                    'created' => date('Y-m-d H:i:s'),
                    'updated' => date('Y-m-d H:i:s'),
                ),
            );
            parent::init();
        }
    }

当重载 ``init()`` 方法时，只需记得一定要调用 ``parent::init()``。

When overriding ``init()`` just remember to always call ``parent::init()``.


导入表信息和记录
---------------------------------------

Importing table information and records
---------------------------------------

应用程序可能已经有正常工作的模型及相关的真实数据，而你可能会决定要使用这些数据来测试应用程序。这样在夹具中定义表和/或记录就是重复的事情了。幸好，有办法从现有的模型或表来定义(夹具的)表和/或记录。

Your application may have already working models with real data
associated to them, and you might decide to test your application with
that data. It would be then a duplicate effort to have to define
the table definition and/or records on your fixtures. Fortunately,
there's a way for you to define that table definition and/or
records for a particular fixture come from an existing model or an
existing table.

让我们从一个例子开始。假定在应用程序中有一个叫做 Article 的模型(映射到名为 articles 的表)，修改前一节的夹具例子(``app/Test/Fixture/ArticleFixture.php``)为::

Let's start with an example. Assuming you have a model named
Article available in your application (that maps to a table named
articles), change the example fixture given in the previous section
(``app/Test/Fixture/ArticleFixture.php``) to::

    class ArticleFixture extends CakeTestFixture {
        public $import = 'Article';
    }

这句话告诉测试套件从叫做 Article 的模型连接的表导入表的定义。你可以使用应用程序中的任何可以使用的模型。这条语句只导入 Article 的数据结构(*schema*)，而不导入记录。要导入记录，你可以这样做::

This statement tells the test suite to import your table definition from the
table linked to the model called Article. You can use any model available in
your application. The statement will only import the Article schema, and  does
not import records. To import records you can do the following::

    class ArticleFixture extends CakeTestFixture {
        public $import = array('model' => 'Article', 'records' => true);
    }

另一方面，如果有一个创建好的表，而没有响应的模型，可以指定导入只读取那个表的信息。例如::

If on the other hand you have a table created but no model
available for it, you can specify that your import will take place
by reading that table information instead. For example::

    class ArticleFixture extends CakeTestFixture {
        public $import = array('table' => 'articles');
    }

会使用 CakePHP 名为 'default' 的数据库连接从叫做 'articles' 的表导入表的定义。如果要使用不同的连接，可以使用::

Will import table definition from a table called 'articles' using
your CakePHP database connection named 'default'. If you want to
use a different connection use::

    class ArticleFixture extends CakeTestFixture {
        public $import = array('table' => 'articles', 'connection' => 'other');
    }

因为它使用 CakePHP 的数据库连接，如果声明了然后表前缀，读取表的信息时就会自动使用该前缀。上述两段代码片段不会从表导入记录。要让夹具也导入记录，把导入改为::

Since it uses your CakePHP database connection, if there's any
table prefix declared it will be automatically used when fetching
table information. The two snippets above do not import records
from the table. To force the fixture to also import its records,
change the import to::

    class ArticleFixture extends CakeTestFixture {
        public $import = array('table' => 'articles', 'records' => true);
    }

也可以很自然地从现有的模型/表导入表的定义，但是象前一节所示的那样直接在夹具中定义记录。例如::

You can naturally import your table definition from an existing
model/table, but have your records defined directly on the fixture
as it was shown on previous section. For example::

    class ArticleFixture extends CakeTestFixture {
        public $import = 'Article';
        public $records = array(
            array(
              'id' => 1,
              'title' => 'First Article',
              'body' => 'First Article Body',
              'published' => '1',
              'created' => '2007-03-18 10:39:23',
              'updated' => '2007-03-18 10:41:31'
            ),
            array(
              'id' => 2,
              'title' => 'Second Article',
              'body' => 'Second Article Body',
              'published' => '1',
              'created' => '2007-03-18 10:41:23',
              'updated' => '2007-03-18 10:43:31'
            ),
            array(
              'id' => 3,
              'title' => 'Third Article',
              'body' => 'Third Article Body',
              'published' => '1',
              'created' => '2007-03-18 10:43:23',
              'updated' => '2007-03-18 10:45:31'
            )
        );
    }

在测试用例中加载夹具
-----------------------------------

Loading fixtures in your test cases
-----------------------------------

夹具创建好之后，就要在测试用例中使用。在每个测试用例中应当加载需要的夹具。对每个要运行查询语句的模型都应当加载夹具。要加载夹具，在模型中定义 ``$fixtures`` 属性::

After you've created your fixtures, you'll want to use them in your test cases.
In each test case you should load the fixtures you will need. You should load a
fixture for every model that will have a query run against it. To load fixtures
you define the ``$fixtures`` property in your model::

    class ArticleTest extends CakeTestCase {
        public $fixtures = array('app.article', 'app.comment');
    }

上述代码会从应用程序的 Fixture 目录加载 Article 和 Comment 夹具。也可以从 CakePHP 核心或插件中加载夹具::

The above will load the Article and Comment fixtures from the application's
Fixture directory. You can also load fixtures from CakePHP core, or plugins::

    class ArticleTest extends CakeTestCase {
        public $fixtures = array('plugin.debug_kit.article', 'core.comment');
    }

使用 ``core`` 前缀会从 CakePHP 加载夹具，使用插件名称作为前缀会从该命名的插件加载夹具。

Using the ``core`` prefix will load fixtures from CakePHP, and using a plugin
name as the prefix, will load the fixture from the named plugin.

你可以设置 :php:attr:`CakeTestCase::$autoFixtures` 为 ``false`` 来扩展何时加载夹具，之后再用 :php:meth:`CakeTestCase::loadFixtures()` 来加载::

You can control when your fixtures are loaded by setting
:php:attr:`CakeTestCase::$autoFixtures` to ``false`` and later load them using
:php:meth:`CakeTestCase::loadFixtures()`::

    class ArticleTest extends CakeTestCase {
        public $fixtures = array('app.article', 'app.comment');
        public $autoFixtures = false;

        public function testMyFunction() {
            $this->loadFixtures('Article', 'Comment');
        }
    }

从 2.5.0 版本开始，可以加载在子目录中的夹具。如果你有一个大型的应用程序，使用多个目录可以更容易地组织夹具。要加载子目录中的夹具，执行在夹具名称中包括子目录名称::

As of 2.5.0, you can load fixtures in subdirectories. Using multiple directories
can make it easier to organize your fixtures if you have a larger application.
To load fixtures in subdirectories, simply include the subdirectory name in the
fixture name::

    class ArticleTest extends CakeTestCase {
        public $fixtures = array('app.blog/article', 'app.blog/comment');
    }

在上述例子中，两个夹具都会从 ``App/Test/Fixture/blog/`` 目录中加载。

In the above example, both fixtures would be loaded from
``App/Test/Fixture/blog/``.

.. versionchanged:: 2.5
    从 2.5.0 版本开始，可以加载在子目录中的夹具。
    As of 2.5.0 you can load fixtures in subdirectories.

测试模型
==============

Testing Models
==============

比方说我们已经有了定义在 ``app/Model/Article.php`` 目录中的 Article 模型，是这样的::

Let's say we already have our Article model defined on
``app/Model/Article.php``, which looks like this::

    class Article extends AppModel {
        public function published($fields = null) {
            $params = array(
                'conditions' => array(
                    $this->name . '.published' => 1
                ),
                'fields' => $fields
            );

            return $this->find('all', $params);
        }
    }

现在要建立使用这个模型的测试，但是要通过夹具，来测试模型中的一些功能。CakePHP 测试套件只加载最少的一组文件(来保持测试独立)，这样我们必须由加载模型开始——这里就是我们已经定义了的 Article 模型。

We now want to set up a test that will use this model definition, but through
fixtures, to test some functionality in the model. CakePHP test suite loads a
very minimum set of files (to keep tests isolated), so we have to start by
loading our model - in this case the Article model which we already defined.

现在在目录 ``app/Test/Case/Model`` 中来创建文件 ``ArticleTest.php``，包含如下内容::

Let's now create a file named ``ArticleTest.php`` in your
``app/Test/Case/Model`` directory, with the following contents::

    App::uses('Article', 'Model');

    class ArticleTest extends CakeTestCase {
        public $fixtures = array('app.article');
    }

在测试用例的变量 ``$fixtures`` 中定义一组要使用的夹具。应当记的包含所有要运行查询的夹具。

In our test cases' variable ``$fixtures`` we define the set of fixtures that
we'll use. You should remember to include all the fixtures that will have
queries run against them.

.. note::
    你可以通过指定 ``$useDbConfig`` 属性来覆盖测试模型数据库。确保相关的夹具使用相同的值，这样会在正确的数据库中创建表。

    You can override the test model database by specifying the ``$useDbConfig``
    property. Ensure that the relevant fixture uses the same value so that the
    table is created in the correct database.

创建测试方法
----------------------

Creating a test method
----------------------

现在来添加一个方法来测试 Article 中的函数 published()。编辑文件 ``app/Test/Case/Model/ArticleTest.php``，让它象这样::

Let's now add a method to test the function published() in the
Article model. Edit the file
``app/Test/Case/Model/ArticleTest.php`` so it now looks like
this::

    App::uses('Article', 'Model');

    class ArticleTest extends CakeTestCase {
        public $fixtures = array('app.article');

        public function setUp() {
            parent::setUp();
            $this->Article = ClassRegistry::init('Article');
        }

        public function testPublished() {
            $result = $this->Article->published(array('id', 'title'));
            $expected = array(
                array('Article' => array('id' => 1, 'title' => 'First Article')),
                array('Article' => array('id' => 2, 'title' => 'Second Article')),
                array('Article' => array('id' => 3, 'title' => 'Third Article'))
            );

            $this->assertEquals($expected, $result);
        }
    }

你可以看到我们添加了方法 ``testPublished()``。我们开始先创建一个 ``Article`` 模型的实例，然后运行 ``published()`` 方法。在变量 ``$expected`` 中设置我们期望正确的结果应当有的值(因为我们定义了开始要填充到文章(*artilce*)表中的记录。)我们使用 ``assertEquals`` 方法测试结果等于我们的期望。欲知如何运行测试用例，请参考 :ref:`running-tests` 一节。

You can see we have added a method called ``testPublished()``. We start by
creating an instance of our ``Article`` model, and then run our ``published()``
method. In ``$expected`` we set what we expect should be the proper result (that
we know since we have defined which records are initially populated to the
article table.) We test that the result equals our expectation by using the
``assertEquals`` method. See the :ref:`running-tests` section for more
information on how to run your test case.

.. note::

    在为测试设置模型时，确保使用 ``ClassRegistry::init('YourModelName');``，因为它知道要使用测试数据库连接。

    When setting up your Model for testing be sure to use
    ``ClassRegistry::init('YourModelName');`` as it knows to use your test
    database connection.

模拟模型方法
---------------------

Mocking model methods
---------------------

有时在测试模型方法时你要模拟这些方法。你应当使用 ``getMockForModel`` 来创建模型的测试模拟。这避免了通常模拟的反射的属性的问题

There will be times you'll want to mock methods on models when testing them. You should
use ``getMockForModel`` to create testing mocks of models. It avoids issues
with reflected properties that normal mocks have::

    public function testSendingEmails() {
        $model = $this->getMockForModel('EmailVerification', array('send'));
        $model->expects($this->once())
            ->method('send')
            ->will($this->returnValue(true));

        $model->verifyEmail('test@example.com');
    }

.. versionadded:: 2.3
    在 2.3 版本中增加了 CakeTestCase::getMockForModel()。

    CakeTestCase::getMockForModel() was added in 2.3.

测试控制器
===================

Testing Controllers
===================

虽然你可以用和助件(*Helper*)、模型(*Model*)和组件(*Component*)相同的方式测试控制器类，CakePHP 提供了特别的 ``ControllerTestCase`` 类。用该类作为控制器测试用例的基类，让你可以使用 ``testAction()`` 方法，使测试用例更简单。``ControllerTestCase`` 让你容易地模拟组件和模型，以及象 :php:meth:`~Controller::redirect()` 这样可能更难测试的方法。

While you can test controller classes in a similar fashion to Helpers, Models,
and Components, CakePHP offers a specialized ``ControllerTestCase`` class.
Using this class as the base class for your controller test cases allows you to
use ``testAction()`` for simpler test cases. ``ControllerTestCase`` allows you
to easily mock out components and models, as well as potentially difficult to
test methods like :php:meth:`~Controller::redirect()`.

假设你有一个典型的 Articles 控制器和相应的模型。控制器代码是这样的::

Say you have a typical Articles controller, and its corresponding
model. The controller code looks like::

    App::uses('AppController', 'Controller');
    
    class ArticlesController extends AppController {
        public $helpers = array('Form', 'Html');

        public function index($short = null) {
            if (!empty($this->request->data)) {
                $this->Article->save($this->request->data);
            }
            if (!empty($short)) {
                $result = $this->Article->find('all', array('id', 'title'));
            } else {
                $result = $this->Article->find('all');
            }

            if (isset($this->params['requested'])) {
                return $result;
            }

            $this->set('title', 'Articles');
            $this->set('articles', $result);
        }
    }

在 ``app/Test/Case/Controller`` 目录中创建一个名为 ``ArticlesControllerTest.php`` 的文件，放入一下代码::

Create a file named ``ArticlesControllerTest.php`` in your
``app/Test/Case/Controller`` directory and put the following inside::

    class ArticlesControllerTest extends ControllerTestCase {
        public $fixtures = array('app.article');

        public function testIndex() {
            $result = $this->testAction('/articles/index');
            debug($result);
        }

        public function testIndexShort() {
            $result = $this->testAction('/articles/index/short');
            debug($result);
        }

        public function testIndexShortGetRenderedHtml() {
            $result = $this->testAction(
               '/articles/index/short',
                array('return' => 'contents')
            );
            debug($result);
        }

        public function testIndexShortGetViewVars() {
            $result = $this->testAction(
                '/articles/index/short',
                array('return' => 'vars')
            );
            debug($result);
        }

        public function testIndexPostData() {
            $data = array(
                'Article' => array(
                    'user_id' => 1,
                    'published' => 1,
                    'slug' => 'new-article',
                    'title' => 'New Article',
                    'body' => 'New Body'
                )
            );
            $result = $this->testAction(
                '/articles/index',
                array('data' => $data, 'method' => 'post')
            );
            debug($result);
        }
    }

这个例子展示了一些使用 testAction 方法测试控制器的方式。``testAction`` ；方法的第一个参数应当总是要测试的网址(*URL*)。CakePHP 会创建一个请求，调度(*dispatch*)控制器和动作。

This example shows a few of the ways you can use testAction to test your
controllers. The first parameter of ``testAction`` should always be the URL you
want to test. CakePHP will create a request and dispatch the controller and
action.

在测试包含 ``redirect()`` 方法和其它重定向(*redirect*)之后的代码，更好的是在重定向时返回。这是因为，``redirect()`` 方法在测试中是模拟的，并不像正常状态是存在的。它不会使代码退出，而是继续运行重定向之后的代码。例如::

When testing actions that contain ``redirect()`` and other code following the
redirect it is generally a good idea to return when redirecting. The reason for
this, is that ``redirect()`` is mocked in testing, and does not exit like
normal. And instead of your code exiting, it will continue to run code following
the redirect. For example::

    App::uses('AppController', 'Controller');
    
    class ArticlesController extends AppController {
        public function add() {
            if ($this->request->is('post')) {
                if ($this->Article->save($this->request->data)) {
                    $this->redirect(array('action' => 'index'));
                }
            }
            // 更多代码
            // more code
        }
    }

当测试上述代码时，就算运行到重定向，也还是会继续运行 ``// 更多代码``。所以，应当这样写代码::

When testing the above code, you will still run ``// more code`` even when the
redirect is reached. Instead, you should write the code like::

    App::uses('AppController', 'Controller');
    
    class ArticlesController extends AppController {
        public function add() {
            if ($this->request->is('post')) {
                if ($this->Article->save($this->request->data)) {
                    return $this->redirect(array('action' => 'index'));
                }
            }
            // 更多代码
            // more code
        }
    }

这样，``// 更多代码`` 就不会执行，因为一到重定向那里就会返回了。

In this case ``// more code`` will not be executed as the method will return
once the redirect is reached.

模拟 GET 请求
-----------------------

Simulating GET requests
-----------------------

正如上面的 ``testIndexPostData()`` 例子中看到的，可以用 ``testAction()`` 方法来测试 POST 动作，也可以测试 GET 动作。提供了 ``data`` 键，提交给控制器的请求就会是 POST。默认情况下，所有的请求都是 POST 请求。可以设置 method 键来模拟 GET 请求::

As seen in the ``testIndexPostData()`` example above, you can use
``testAction()`` to test POST actions as well as GET actions. By supplying the
``data`` key, the request made to the controller will be POST. By default all
requests will be POST requests. You can simulate a GET request by setting the
method key::

    public function testAdding() {
        $data = array(
            'Post' => array(
                'title' => 'New post',
                'body' => 'Secret sauce'
            )
        );
        $this->testAction('/posts/add', array('data' => $data, 'method' => 'get'));
        // 一些断言(*assertion*)。
        // some assertions.
    }

在模拟 GET 请求时，data 键会作为查询字符串(*query string*)参数。

The data key will be used as query string parameters when simulating a GET
request.

选择返回类型
------------------------

Choosing the return type
------------------------

你可以从多种检查控制器动作是否成功的方法中进行选择。每一种都提供了不同的方法来确保代码执行了你的期望：

* ``vars`` 得到设置的视图(*view*)变量。
* ``view`` 得到渲染的不含布局(*layout*)的视图。
* ``contents`` 得到渲染的包含布局(*layout*)的视图。
* ``result`` 得到控制器动作的返回值。可用于测试 requestAction 方法。

You can choose from a number of ways to inspect the success of your controller
action. Each offers a different way to ensure your code is doing what you
expect:

* ``vars`` Get the set view variables.
* ``view`` Get the rendered view, without a layout.
* ``contents`` Get the rendered view including the layout.
* ``result`` Get the return value of the controller action. Useful
  for testing requestAction methods.

默认值为 ``result``。只要返回类型不是 ``result``，也可以在测试用例中用属性访问其它返回类型::

The default value is ``result``. As long as your return type is not ``result``
you can also access the various other return types as properties in the test
case::

    public function testIndex() {
        $this->testAction('/posts/index');
        $this->assertInternalType('array', $this->vars['posts']);
    }


和 testAction 方法一起使用模拟
-------------------------------

Using mocks with testAction
---------------------------

有时你要用部分或完全模拟的对象来代替组件(*component*)或者模型(*model*)。为此可以使用 :php:meth:`ControllerTestCase::generate()`。``generate()`` 方法从控制器接过生成模拟的困难工作。如果你决定要生成用于测试的控制器，你可以一起生成模拟版本的模型和组件::

There will be times when you want to replace components or models with either
partially mocked objects or completely mocked objects. You can do this by using
:php:meth:`ControllerTestCase::generate()`. ``generate()`` takes the hard work
out of generating mocks on your controller. If you decide to generate a
controller to be used in testing, you can generate mocked versions of its models
and components along with it::

    $Posts = $this->generate('Posts', array(
        'methods' => array(
            'isAuthorized'
        ),
        'models' => array(
            'Post' => array('save')
        ),
        'components' => array(
            'RequestHandler' => array('isPut'),
            'Email' => array('send'),
            'Session'
        )
    ));

上面的代码会创建模拟的 ``PostsController``，带有 ``isAuthorized`` 方法。附带的 Post 模型会有 ``save()`` 方法，而附带的组件会有相应的方法。可以选择不传递方法来模拟整个类，就像上面例子中的 Session。

The above would create a mocked ``PostsController``, stubbing out the ``isAuthorized``
method. The attached Post model will have ``save()`` stubbed, and the attached
components would have their respective methods stubbed. You can choose to stub
an entire class by not passing methods to it, like Session in the example above.

生成的控制器自动作为测试控制器，用于测试。要启用自动生成，设置测试用例的 ``autoMock`` 变量为 true。如果 ``autoMock`` 为 false，测试就会使用原来的控制器。

Generated controllers are automatically used as the testing controller to test.
To enable automatic generation, set the ``autoMock`` variable on the test case to
true. If ``autoMock`` is false, your original controller will be used in the test.

生成的控制器的 response 对象总是被一个不发送头部信息的模拟对象所取代。在使用了 ``generate()`` 或 ``testAction()`` 方法之后，可以用 ``$this->controller`` 来访问控制器对象。

The response object in the generated controller is always replaced with a mock
that does not send headers. After using ``generate()`` or ``testAction()`` you
can access the controller object at ``$this->controller``.

更复杂的例子
----------------------

A more complex example
----------------------

作为最简单的形式， ``testAction()`` 方法会在测试控制器上(或者自动生成的控制器上)包括所有模拟的模型和组件上运行 ``PostsController::index()``。测试的结果保存在 ``vars`` 、 ``contents`` 、 ``view`` 和 ``return`` 属性中。还有 headers 属性供你访问已经发送的 ``headers``，让你可以查看重定向::

In its simplest form, ``testAction()`` will run ``PostsController::index()`` on
your testing controller (or an automatically generated one), including all of the
mocked models and components. The results of the test are stored in the ``vars``,
``contents``, ``view``, and ``return`` properties. Also available is a headers
property which gives you access to the ``headers`` that would have been sent,
allowing you to check for redirects::

    public function testAdd() {
        $Posts = $this->generate('Posts', array(
            'components' => array(
                'Session',
                'Email' => array('send')
            )
        ));
        $Posts->Session
            ->expects($this->once())
            ->method('setFlash');
        $Posts->Email
            ->expects($this->once())
            ->method('send')
            ->will($this->returnValue(true));

        $this->testAction('/posts/add', array(
            'data' => array(
                'Post' => array('title' => 'New Post')
            )
        ));
        $this->assertContains('/posts', $this->headers['Location']);
    }

    public function testAddGet() {
        $this->testAction('/posts/add', array(
            'method' => 'GET',
            'return' => 'contents'
        ));
        $this->assertRegExp('/<html/', $this->contents);
        $this->assertRegExp('/<form/', $this->view);
    }


这个例子展示 ``testAction()`` 和 ``generate()`` 方法稍微复杂一点儿的用法。首先，生成测试控制器，模拟 :php:class:`SessionComponent` 组件。现在模拟了 SessionComponent 组件，我们就可以在它上面运行测试方法。假设 ``PostsController::add()`` 方法重定向用户到 index，发送一封邮件，设置闪动提示消息，测试就会通过。添加了第二个测试对获取 add 表单时进行基本的健全测试。我们检查真格渲染的内容，看布局(*layout*)是否加载，并检查 form 标签来查看视图(*view*)。如你所见，这些改动极大地增加了测试控制器和容易地模拟控制器类的自由，

This example shows a slightly more complex use of the ``testAction()`` and
``generate()`` methods. First, we generate a testing controller and mock the
:php:class:`SessionComponent`. Now that the SessionComponent is mocked, we have
the ability to run testing methods on it. Assuming ``PostsController::add()``
redirects us to index, sends an email and sets a flash message, the test will
pass. A second test was added to do basic sanity testing when fetching the add
form. We check to see if the layout was loaded by checking the entire rendered
contents, and checks the view for a form tag. As you can see, your freedom to
test controllers and easily mock its classes is greatly expanded with these
changes.

在用使用静态方法的模拟对象来测试控制器时，你不得不用另外一种方法来表明对模拟对象的期望。例如，如果要想模拟 :php:meth:`AuthComponent::user()`，就必须这样做::

When doing controller tests using mocks that use static methods you'll have to
use a different method to register your mock expectations. For example if you
wanted to mock out :php:meth:`AuthComponent::user()` you'd have to do the
following::

    public function testAdd() {
        $Posts = $this->generate('Posts', array(
            'components' => array(
                'Session',
                'Auth' => array('user')
            )
        ));
        $Posts->Auth->staticExpects($this->any())
            ->method('user')
            ->with('id')
            ->will($this->returnValue(2));
    }

使用 ``staticExpects`` 方法，就可以模拟和操控组建和模型的静态方法。

By using ``staticExpects`` you will be able to mock and manipulate static
methods on components and models.

测试返回 JSON 响应的控制器
------------------------------------

Testing a JSON Responding Controller
------------------------------------

在构建网络服务(*web service*)时，JSON 是非常友好和常用的格式。用 CakePHP 测试网络服务的端点很简单。我们先看一个简单的返回 JSON 的控制器例子::

JSON is a very friendly and common format to use when building a web service.
Testing the endpoints of your web service is very simple with CakePHP. Let us
begin with a simple example controller that responds in JSON::

    class MarkersController extends AppController {
        public $autoRender = false;
        public function index() {
            $data = $this->Marker->find('first');
            $this->response->body(json_encode($data));
        }
    }

现在我们创建文件 ``app/Test/Case/Controller/MarkersControllerTest.php``，确保网络服务返回正确的响应::

Now we create the file ``app/Test/Case/Controller/MarkersControllerTest.php``
and make sure our web service is returning the proper response::

    class MarkersControllerTest extends ControllerTestCase {
        public function testIndex() {
            $result = $this->testAction('/markers/index.json');
            $result = json_decode($result, true);
            $expected = array(
                'Marker' => array('id' => 1, 'lng' => 66, 'lat' => 45),
            );
            $this->assertEquals($expected, $result);
        }
    }

Testing Views
=============

通常大部分应用程序不会直接测试它们的 HTML 代码。这么做经常会导致脆弱、难以维护的测试套件，容易破坏。在使用编写功能性测试时，可以设置 ``return`` 选项为 'view' 来检视渲染的视图内容。虽然有可能使用 ControllerTestCase 测试视图内容，更健壮、易于维护的集成/视图测试可以使用象 `Selenium webdriver <http://seleniumhq.org>`_ 这样的工具来实现。

Generally most applications will not directly test their HTML code. Doing so is
often results in fragile, difficult to maintain test suites that are prone to
breaking. When writing functional tests using :php:class:`ControllerTestCase`
you can inspect the rendered view content by setting the ``return`` option to
'view'. While it is possible to test view content using ControllerTestCase,
more robust and maintainable integration/view testing can be accomplished using
tools like `Selenium webdriver <http://seleniumhq.org>`_.


测试组件
==================

Testing Components
==================

假设在应用程序中有一个名为 PagematronComponent 的组件。该组件帮我们设置使用它的控制器的分页限制。下面是位于 ``app/Controller/Component/PagematronComponent.php`` 的组件例子::

Let's pretend we have a component called PagematronComponent in our application.
This component helps us set the pagination limit value across all the
controllers that use it. Here is our example component located in
``app/Controller/Component/PagematronComponent.php``::

    class PagematronComponent extends Component {
        public $Controller = null;

        public function startup(Controller $controller) {
            parent::startup($controller);
            $this->Controller = $controller;
            // 确保控制器使用分页
            // Make sure the controller is using pagination
            if (!isset($this->Controller->paginate)) {
                $this->Controller->paginate = array();
            }
        }

        public function adjust($length = 'short') {
            switch ($length) {
                case 'long':
                    $this->Controller->paginate['limit'] = 100;
                break;
                case 'medium':
                    $this->Controller->paginate['limit'] = 50;
                break;
                default:
                    $this->Controller->paginate['limit'] = 20;
                break;
            }
        }
    }

选择我们可以编写测试来确保分页 ``limit`` 参数被组件的 ``adjust`` 方法正确设置。我们创建文件``app/Test/Case/Controller/Component/PagematronComponentTest.php``::

Now we can write tests to ensure our paginate ``limit`` parameter is being
set correctly by the ``adjust`` method in our component. We create the file
``app/Test/Case/Controller/Component/PagematronComponentTest.php``::

    App::uses('Controller', 'Controller');
    App::uses('CakeRequest', 'Network');
    App::uses('CakeResponse', 'Network');
    App::uses('ComponentCollection', 'Controller');
    App::uses('PagematronComponent', 'Controller/Component');

    // 测试的假的控制器
    // A fake controller to test against
    class PagematronControllerTest extends Controller {
        public $paginate = null;
    }

    class PagematronComponentTest extends CakeTestCase {
        public $PagematronComponent = null;
        public $Controller = null;

        public function setUp() {
            parent::setUp();
            // 设置组件和假的测试控制器
            // Setup our component and fake test controller
            $Collection = new ComponentCollection();
            $this->PagematronComponent = new PagematronComponent($Collection);
            $CakeRequest = new CakeRequest();
            $CakeResponse = new CakeResponse();
            $this->Controller = new PagematronControllerTest($CakeRequest, $CakeResponse);
            $this->PagematronComponent->startup($this->Controller);
        }

        public function testAdjust() {
            // 用不同的测试测试 adjust 方法
            // Test our adjust method with different parameter settings
            $this->PagematronComponent->adjust();
            $this->assertEquals(20, $this->Controller->paginate['limit']);

            $this->PagematronComponent->adjust('medium');
            $this->assertEquals(50, $this->Controller->paginate['limit']);

            $this->PagematronComponent->adjust('long');
            $this->assertEquals(100, $this->Controller->paginate['limit']);
        }

        public function tearDown() {
            parent::tearDown();
            // 完成后清理干净
            // Clean up after we're done
            unset($this->PagematronComponent);
            unset($this->Controller);
        }
    }

测试助件
===============

Testing Helpers
===============

既然相当一部分逻辑存在于助件类中，确保这些类被测试覆盖就很重要。

Since a decent amount of logic resides in Helper classes, it's
important to make sure those classes are covered by test cases.

我们先创建一个助件样例用于测试。``CurrencyRendererHelper`` 可以在试图中帮助显示金额，为了简单，只有一个方法 ``usd()``。

First we create an example helper to test. The ``CurrencyRendererHelper`` will
help us display currencies in our views and for simplicity only has one method
``usd()``.

::

    // app/View/Helper/CurrencyRendererHelper.php
    class CurrencyRendererHelper extends AppHelper {
        public function usd($amount) {
            return 'USD ' . number_format($amount, 2, '.', ',');
        }
    }

我们设置小数点为 2 位，小数点分隔符为点，千位分隔符为逗号，在格式化的数字前缀以 'USD' 字符串。

Here we set the decimal places to 2, decimal separator to dot, thousands
separator to comma, and prefix the formatted number with 'USD' string.

现在来创建测试::

Now we create our tests::

    // app/Test/Case/View/Helper/CurrencyRendererHelperTest.php

    App::uses('Controller', 'Controller');
    App::uses('View', 'View');
    App::uses('CurrencyRendererHelper', 'View/Helper');

    class CurrencyRendererHelperTest extends CakeTestCase {
        public $CurrencyRenderer = null;

        // Here we instantiate our helper
        public function setUp() {
            parent::setUp();
            $Controller = new Controller();
            $View = new View($Controller);
            $this->CurrencyRenderer = new CurrencyRendererHelper($View);
        }

        // Testing the usd() function
        public function testUsd() {
            $this->assertEquals('USD 5.30', $this->CurrencyRenderer->usd(5.30));

            // We should always have 2 decimal digits
            $this->assertEquals('USD 1.00', $this->CurrencyRenderer->usd(1));
            $this->assertEquals('USD 2.05', $this->CurrencyRenderer->usd(2.05));

            // Testing the thousands separator
            $this->assertEquals(
              'USD 12,000.70',
              $this->CurrencyRenderer->usd(12000.70)
            );
        }
    }

这里，我们用不同的参数调用 ``usd()`` 方法，让测试套件检查返回值是否等于所期望的。

Here, we call ``usd()`` with different parameters and tell the test suite to
check if the returned values are equal to what is expected.

保存并执行测试。你应当看见一个绿色条和消息，表示 1 个通过测试和 4 句断言（*assertion*)。

Save this in and execute the test. You should see a green bar and messaging
indicating 1 pass and 4 assertions.

创建测试套件
====================

Creating Test Suites
====================

如果你想要几个测试一起运行，可以创建测试套件。一个测试套件由多个测试用例组成。``CakeTestSuite`` 提供了一些方法，来基于文件系统轻松地创建测试套件。如果我们要为所有的模型创建测试套件，可以创建 ``app/Test/Case/AllModelTest.php``。放入如下代码::

If you want several of your tests to run at the same time, you can
create a test suite. A test suite is composed of several test cases.
``CakeTestSuite`` offers a few methods for easily creating test suites based on
the file system. If we wanted to create a test suite for all our model tests we
would create ``app/Test/Case/AllModelTest.php``. Put the following in it::

    class AllModelTest extends CakeTestSuite {
        public static function suite() {
            $suite = new CakeTestSuite('All model tests');
            $suite->addTestDirectory(TESTS . 'Case/Model');
            return $suite;
        }
    }

以上代码会把目录``/app/Test/Case/Model/`` 中所有的测试用例组织在一起。要添加单个文件，使用 ``$suite->addTestFile($filename);`` 方法。可以用下面的办法递归添加一个目录中的所有测试::

The code above will group all test cases found in the
``/app/Test/Case/Model/`` folder. To add an individual file, use
``$suite->addTestFile($filename);``. You can recursively add a directory
for all tests using::

    $suite->addTestDirectoryRecursive(TESTS . 'Case/Model');

这就会递归添加 ``app/Test/Case/Model`` 目录中的所有测试用例。你可以用多个测试套件构成一个套件，来运行应用程序的所有测试::

Would recursively add all test cases in the ``app/Test/Case/Model``
directory. You can use test suites to build a suite that runs all your
application's tests::

    class AllTestsTest extends CakeTestSuite {
        public static function suite() {
            $suite = new CakeTestSuite('All tests');
            $suite->addTestDirectoryRecursive(TESTS . 'Case');
            return $suite;
        }
    }

然后就可以用下面的命令从命令行运行这个测试::

You can then run this test on the command line using::

    $ Console/cake test app AllTests

创建插件的测试
==========================

Creating Tests for Plugins
==========================

插件的测试在插件目录中自己的目录中创建。 ::

Tests for plugins are created in their own directory inside the
plugins folder. ::

    /app
        /Plugin
            /Blog
                /Test
                    /Case
                    /Fixture

插件的测试象普通的测试一样，但要记得在导入类时要使用插件的命名约定。这是本手册中 ``BlogPost`` 模型的测试例子。与其它测试的区别在第一行，导入了 'Blog.BlogPost' 模型。也需要对插件夹具(*fixture*)使用前缀 ``plugin.blog.blog_post``::

They work just like normal tests but you have to remember to use
the naming conventions for plugins when importing classes. This is
an example of a testcase for the ``BlogPost`` model from the plugins
chapter of this manual. A difference from other tests is in the
first line where 'Blog.BlogPost' is imported. You also need to
prefix your plugin fixtures with ``plugin.blog.blog_post``::

    App::uses('BlogPost', 'Blog.Model');

    class BlogPostTest extends CakeTestCase {

        // 插件夹具位于 /app/Plugin/Blog/Test/Fixture/
        // Plugin fixtures located in /app/Plugin/Blog/Test/Fixture/
        public $fixtures = array('plugin.blog.blog_post');
        public $BlogPost;

        public function testSomething() {
            // ClassRegistry 让模型使用测试数据库连接
            // ClassRegistry makes the model use the test database connection
            $this->BlogPost = ClassRegistry::init('Blog.BlogPost');

            // 这里进行一些有用的测试
            // do some useful test here
            $this->assertTrue(is_object($this->BlogPost));
        }
    }

如果想要在 app 的测试中使用创建夹具，可以在 ``$fixtures`` 数组中使用 ``plugin.pluginName.fixtureName`` 语法来引用它们。

If you want to use plugin fixtures in the app tests you can
reference them using ``plugin.pluginName.fixtureName`` syntax in the
``$fixtures`` array.

与 Jenkins 集成
========================

Integration with Jenkins
========================

`Jenkins <http://jenkins-ci.org>`_ 是持续集成服务器，可以帮你自动化运行测试用例。这有助于确保保持所有测试通过，应用程序总是准备就绪的。

`Jenkins <http://jenkins-ci.org>`_ is a continuous integration server, that can
help you automate the running of your test cases. This helps ensure that all
your tests stay passing and your application is always ready.

CakePHP 应用程序与 Jenkins 的集成是相当直截了当的。下面假设你已经在 \*nix 系统上安装好了 Jenkins，并且可以管理它。你也知道如何创建作业(*job*)，运行构建。如果你对这些有任何不确定，请参考 `Jenkins 文档 <http://jenkins-ci.org/>`_ 

Integrating a CakePHP application with Jenkins is fairly straightforward. The
following assumes you've already installed Jenkins on \*nix system, and are able
to administer it. You also know how to create jobs, and run builds. If you are
unsure of any of these, refer to the `Jenkins documentation <http://jenkins-ci.org/>`_ .

创建作业
------------

Create a job
------------

开始先为应用程序创建作业，连接到你的代码仓库(*repository*)，这样 jenkins 才能获得你的代码。

Start off by creating a job for your application, and connect your repository
so that jenkins can access your code.

添加测试数据库配置
------------------------

Add test database config
------------------------

让 Jenkins 使用分开的数据库通常比较好，这样就可以防止连带的危害，避免一些基本的问题。一旦在 jenkins 能够访问的数据库服务器上创建了新的数据库，在构建(*build*)中添加包含如下代码的 *外壳脚本步骤(shell script step)*::

Using a separate database just for Jenkins is generally a good idea, as it stops
bleed through and avoids a number of basic problems. Once you've created a new
database in a database server that jenkins can access (usually localhost). Add
a *shell script step* to the build that contains the following::

    cat > app/Config/database.php <<'DATABASE_PHP'
    <?php
    class DATABASE_CONFIG {
        public $test = array(
            'datasource' => 'Database/Mysql',
            'host'       => 'localhost',
            'database'   => 'jenkins_test',
            'login'      => 'jenkins',
            'password'   => 'cakephp_jenkins',
            'encoding'   => 'utf8'
        );
    }
    DATABASE_PHP

这确保你总有 Jenkins 要求的数据库配置。对任何其它需要的配置文件做同样处理。经常，更好的做法是，在每次构建之前也要删除再重新创建数据库。这样隔绝了串联的失败，即一个失败的构建引起其它构建也失败。在构建中加入另一个 *外壳脚本步骤(shell script step)*，包含如下代码::

This ensures that you'll always have the correct database configuration that
Jenkins requires. Do the same for any other configuration files you need to.
It's often a good idea to drop and re-create the database before each build as
well. This insulates you from chained failures, where one broken build causes
others to fail. Add another *shell script step* to the build that contains the
following::

    mysql -u jenkins -pcakephp_jenkins -e 'DROP DATABASE IF EXISTS jenkins_test; CREATE DATABASE jenkins_test';

添加测试
--------------

Add your tests
--------------

在构建中加入另一个 *外壳脚本步骤(shell script step)*。在这个步骤中运行应用程序的测试。创建 JUnit 日志文件或者 clover 测试覆盖(*coverage*)，通常更好，因为这为测试结果提供了一个不错的图形显示::

Add another *shell script step* to your build. In this step run the tests for
your application. Creating a junit log file, or clover coverage is often a nice
bonus, as it gives you a nice graphical view of your testing results::

    app/Console/cake test app AllTests \
    --stderr \
    --log-junit junit.xml \
    --coverage-clover clover.xml

如果你使用 clover 测试覆盖(*coverage*) 或者 JUnit 日志文件，确保这些也在 Jenkins 中配置好了。如果没有配置这些步骤，就不能看到结果。

If you use clover coverage, or the junit results, make sure to configure those
in Jenkins as well. Failing to configure those steps will mean you won't see the results.

运行构建
-----------

Run a build
-----------

现在你应当能够运行构建了。检查控制台输出，并作出必要的修改让构建通过。

You should be able to run a build now. Check the console output and make any
necessary changes to get a passing build.


.. meta::
    :title lang=zh_CN: Testing
    :keywords lang=zh_CN: web runner,phpunit,test database,database configuration,database setup,database test,public test,test framework,running one,test setup,de facto standard,pear,runners,array,databases,cakephp,php,integration
