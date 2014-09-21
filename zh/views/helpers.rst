助手
#######


助手对于视图的作用，就像组件对于控制器的作用。 助手包含在多个视图、元素或布局间共享的等用来显示的逻辑代码。本章将展示如何自定义助手，以及 CakePHP 的核心助手能实现的基本任务。

CakePHP 包含了许多有助于建立视图的助手。 助手帮助建立格式良好的HTMl（包括表单），格式化文本、时间和数字，甚至增强Ajax功能。关于 CakePHP 中的助手的更多信息，请浏览 :ref:`core-helpers`。


.. _configuring-helpers:

使用和配置助手
=============================

在 CakePHP 中，你可以通过设置控制器的$helpers属性来启用助手。 每个控制器有一个 $helpers 属性， :php:attr:`~Controller::$helpers` 将助手的名字添加到控制器的 $helpers 数组::

    class BakeriesController extends AppController {
        public $helpers = array('Form', 'Html', 'Js', 'Time');
    }

添加插件内的助手:term:`plugin syntax`::

    class BakeriesController extends AppController {
        public $helpers = array('Blog.Comment');
    }

你还可以在动作内添加助手，这样它们就只在这个动作中可用，但在同一控制器的其它动作中无法使用。这会节省那些不需要助手的动作的计算能力，同时保持控制器的良好组织::

    class BakeriesController extends AppController {
        public function bake {
            $this->helpers[] = 'Time';
        }
        public function mix {
            // Time helper在这里没有添加，因此不可用
        }
    }

如果需要在所有的控制器中使用一个助手，把``$helpers``数组将其加入到 ``/app/Controller/AppController.php`` 文件(不存在自建)中去。记住，默认包含 Html 和 Form 助手::

    class AppController extends Controller {
        public $helpers = array('Form', 'Html', 'Js', 'Time');
    }

你可以给助手传递选项。这些选项用来设置属性值或者修改助手的行为::

    class AwesomeHelper extends AppHelper {
        public function __construct(View $view, $settings = array()) {
            parent::__construct($view, $settings);
            debug($settings);
        }
    }

    class AwesomeController extends AppController {
        public $helpers = array('Awesome' => array('option1' => 'value1'));
    }

2.3 版本中选项被合并到了 Helper::$settings 属性。
As of 2.3 the options are merged with the ``Helper::$settings`` property of
the helper.

助手有一个 ``className`` 选项，允许在视图中建立助手别名。这个特性在你想要替换 ``$this->Html``或者引用自定义实现的其它公用助手时很有用::

    // app/Controller/PostsController.php
    class PostsController extends AppController {
        public $helpers = array(
            'Html' => array(
                'className' => 'MyHtml'
            )
        );
    }

    // app/View/Helper/MyHtmlHelper.php
    App::uses('HtmlHelper', 'View/Helper');
    class MyHtmlHelper extends HtmlHelper {
        // Add your code to override the core HtmlHelper
    }

上面的代码将视图中的 ``MyHtmlHelper`` 的别名*alias*设置为 ``$this->Html``。


.. 注解::
    为助手定义别名将在所有使用别名的位置替换其实例，包括在其它助手中。

.. note::
    Aliasing a helper replaces that instance anywhere that helper is used,
    including inside other Helpers.

.. 技巧::
    在使用核心的 PagesController 时，为 Html 或者 Session 助手定义别名将无法工作。 最好是将lib/Cake/Controller/PagesController.php 复制到 app/Controller/ 目录。

.. tip::
    Aliasing the Html or Session Helper while using the core PagesController
    will not work. It is better to copy
    ``lib/Cake/Controller/PagesController.php`` into your ``app/Controller/``
    folder.

使用助手配置的好处是可以在控制器动作之外维护，如果你有不能包含在类声明中的配置选项，你可以在控制器的 beforeRender 回调函数中设置它们：

Using helper settings allows you to declaratively configure your helpers and
keep configuration logic out of your controller actions.  If you have
configuration options that cannot be included as part of a class declaration,
you can set those in your controller's beforeRender callback::

    class PostsController extends AppController {
        public function beforeRender() {
            parent::beforeRender();
            $this->helpers['CustomStuff'] = $this->_getCustomStuffSettings();
        }
    }

使用助手
=============
一旦你已经在控制器中配置好了助手，它就成为视图中的公用属性，如果你使用助手 :php:class:`HtmlHelper` ，你就可以通过如下方式访问它::

    echo $this->Html->css('styles');

上面的代码调用了 HtmlHelper 的 ``css`` 方法。可以使用 $this->{$helperName} 访问任何已加载的助手。有时你可能需要从视图中动态加载一个助手。你可以使用视图的 :php:class:`HelperCollection` 来做到这一点::

    $mediaHelper = $this->Helpers->load('Media', $mediaSettings);

HelperCollection :doc:`collection </core-libraries/collections>`是一个 集合 ，并且支持在 CakePHP 的任意一处使用集合 API。

回调方法
================
助手包含几个允许你提高视图渲染能力的回调方法。更多信息参见助手 API :ref:`helper-api` 和:doc:`/core-libraries/collections`文档。

自定义助手
================

如果CakePHP自带的核心助手（或github 和 Bakery中的）不能满足要求，我们可以很容易的自己创建助手来满足业务需求。

假设我们想要创建一个能够用于输出一个特别制定的在应用程序的许多位置需要的 CSS 风格的链接的助手。为了适合你的逻辑及 CakePHP 现有助手结构，你需要在 /app/View/Helper 中创建一个新的类。调用我们的 LinkHelper 助手。这个真实的 PHP 类文件类似于::

    /* /app/View/Helper/LinkHelper.php */
    App::uses('AppHelper', 'View/Helper');

    class LinkHelper extends AppHelper {
        public function makeEdit($title, $url) {
            // Logic to create specially formatted link goes here...
        }
    }

.. 注解::

    助手必须继承 ``AppHelper` 或者 :php:class:`Helper`，也可以使用 :ref:`helper-api` 实现全部回调。

引入其它助手
-----------------------
在我们创建自定义助手的时候，也许会希望使用其它助手中已经存在的功能。要做到这一点，你可以指定助手使用 ``$helpers`` 数组，实例代码如下::

    /* /app/View/Helper/LinkHelper.php (使用其他助手) */
    App::uses('AppHelper', 'View/Helper');

    class LinkHelper extends AppHelper {
        public $helpers = array('Html');

        public function makeEdit($title, $url) {
            // 使用HTML助手来输出
            // 格式化数据:

            $link = $this->Html->link($title, $url, array('class' => 'edit'));

            return '<div class="editOuter">' . $link . '</div>';
        }
    }


.. _using-helpers:

使用自定义助手
-----------------

一旦创建了助手，并放进了 ``/app/View/Helper/``，就可以在控制器中引用了。

    class PostsController extends AppController {
        public $helpers = array('Link');
    }

只要控制器知道这个新类的存在，你就可以在视图中使用它（通过访问以这个助手命名的对象）::

    <!-- 使用新的助手生成链接 -->
    <?php echo $this->Link->makeEdit('Change this Recipe', '/recipes/edit/5'); ?>


为所有助手创建功能
======================================

所有的助手都继承自一个特殊类 AppHelper（类似于所有的模型都继承 AppModel 和所有的控制器都继承 AppController）。要为所有的助手创建功能，建立 ``/app/View/Helper/AppHelper.php`` 这个文件::

    App::uses('Helper', 'View');

    class AppHelper extends Helper {
        public function customMethod() {
        }
    }


.. _helper-api:

助手API
==========

.. php:class:: Helper

    所有助手的基类。提供了大量的实用方法和功能加载其他帮手。

.. php:method:: webroot($file)

    解析一个文件名到应用程序的 web 根目录。如果有主题被使用并且此文件在当前主题的 web 根目录中存在，将返回这个主题文件的路径。

.. php:method:: url($url, $full = false)

    创建一个 HTML 转义 URL，委托给 :php:meth:`Router::url()` 方法。

.. php:method:: value($options = array(), $field = null, $key = 'value')

    Get the value for a given input name.

.. php:method:: domId($options = null, $id = 'id')

    为当前所选的区域生成一个驼峰命名的 id 值，在 AppHelper 中覆盖这个方法将改变CakePHP默认生成ID属性的方式。

回调函数
---------

.. php:method:: beforeRenderFile($viewFile)

    每个视图文件被渲染前调用。 包括元素、视图、父视图和布局。

.. php:method:: afterRenderFile($viewFile, $content)

    每个视图文件被渲染后调用。包括元素、视图、父视图和布局。通过传入$content参数，可以改变默认的渲染给浏览器的内容。

    Is called after each view file is rendered.  This includes elements, views,
    parent views and layouts.  A callback can modify and return ``$content`` to
    change how the rendered content will be displayed in the browser.

.. php:method:: beforeRender($viewFile)

    在控制器的beforeRender方法之后和在控制器渲染视图和布局之前被调用，接收布局文件名作为其参数。

.. php:method:: afterRender($viewFile)

    视图渲染之后但布局渲染之前调用

.. php:method:: beforeLayout($layoutFile)

    布局渲染开始之前调用。接收布局文件名作为其参数。

.. php:method:: afterLayout($layoutFile)

    布局渲染完成之后调用。接收布局文件名作为其参数。

核心助手
============

:doc:`/core-libraries/helpers/cache`
    提供缓存视图内容的方法
:doc:`/core-libraries/helpers/form`
    提供便捷创建HTML表单的方法
:doc:`/core-libraries/helpers/html`
    提供便捷创建格式良好的HTML标签
:doc:`/core-libraries/helpers/js`
    提供创建兼容各种 Javascript库的方法
:doc:`/core-libraries/helpers/number`
    格式化数字和货币
:doc:`/core-libraries/helpers/paginator`
    模型数据分页和排序
:doc:`/core-libraries/helpers/rss`
    便捷输出 RSS feed XML 数据
:doc:`/core-libraries/helpers/session`
    操作Session
:doc:`/core-libraries/helpers/text`
    漂亮的链接、高亮、智能字符截断处理
:doc:`/core-libraries/helpers/time`
    时间检测（如判断某个日期是否是明年），漂亮的字符串格式化（如显示为"today, 10:30 am"）和时区转换



.. meta::
    :title lang=zh_CN: Helpers
    :keywords lang=zh_CN: php class,time function,presentation layer,processing power,ajax,markup,array,functionality,logic,syntax,elements,cakephp,plugins
