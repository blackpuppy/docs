翻译行为
#########

.. php:class:: TranslateBehavior()

TranslateBehavior 行为其实很容易设置，并且只需很少配置即可工作。在本节中，你将看
到如何在任意模型中添加和设置该行为。

如果你在使用 TranslateBehavior 行为的过程中同时有 containable 的问题(译注: 不
太确定这句话的意思)，确保为你的查询设置了 'fields' 键。否则你可能会碰到生成非法
SQL 的错误。

初始化 i18n 数据库表
=====================================

你可以使用 CakePHP 命令行，或者你也可以手动创建。建议使用命令行，因为布局在将来的
版本中可能会发生变化。始终使用命令行可以保证你有正确的布局。::

    ./cake i18n

选择 ``[I]``，就会执行 i18n 数据库初始化脚本。你会被询问是否要删除现存的数据库表，
以及你是否要再创建它。如果你确定没有 i18n 表，回答 yes，然后再回答 yes 来创建该表。

把 Translate 行为附加到你的模型上
===============================================

使用 ``$actsAs`` 属性把它(Translate 行为)附加到你的模型上，象下面的例子这样。::

    class Post extends AppModel {
        public $actsAs = array(
            'Translate'
        );
    }

这样还是什么也不会发生，因为它还需要几个选项才可以开始生效。你要定义当前模型的哪
些字段要在我们第一步创建的翻译表中进行跟踪。

定义字段
===================

你只需用另一个数组来扩展``'Translate'``的值，就可以设置字段，象这样::

    class Post extends AppModel {
        public $actsAs = array(
            'Translate' => array(
                'fieldOne', 'fieldTwo', 'and_so_on'
            )
        );
    }

做完这之后(例如把 "title" 放入作为其中一个字段)，你就完成了基本的设置。很好！根
据我们现在的例子，模型应当象这样::

    class Post extends AppModel {
        public $actsAs = array(
            'Translate' => array(
                'title'
            )
        );
    }

当为 TranslateBehavior 行为定义要翻译的字段时，一定要省略那些翻译了的模型中的字段。
如果你把这样的字段也包括了，当使用后备地区(*fallback locale*)读取数据时就有可能发
生问题。

结论
==========

自此，每次记录被更新/创建，TranslateBehavior 就会把 "title" 的值以及当前的地区拷
贝到翻译表(缺省: i18n)中。地区(*locale*)，这么说吧，就是语言的标识。


读取翻译的内容
==========================

缺省情况下 TranslateBehavior 行为会自动根据当前地区读取和添加数据。当前地区是从
``Configure::read('Config.language')``读取的，而这又是由:php:class:`L10n`这个类赋
值的。你可以用``$Model->locale``即时(on the fly)覆盖这个缺省值。

读取翻译的字段在指定地区(的内容)
-----------------------------------------------

设置了 ``$Model->locale``，就可以读取指定地区的翻译::

    // 读取西班牙地区的数据。
    $this->Post->locale = 'es';
    $results = $this->Post->find('first', array(
        'conditions' => array('Post.id' => $id)
    ));
    // $results 就会含有西班牙文的翻译。

获取某一字段的所有翻译记录
--------------------------------------------

如果你要所有的翻译记录附加到当前模型记录，你只需象下面这样扩展行为设置中的**字段
数组**。命名完全由你决定。::

    class Post extends AppModel {
        public $actsAs = array(
            'Translate' => array(
                'title' => 'titleTranslation'
            )
        );
    }

有了这样的设置，``$this->Post->find()``的结果应当象这样::

    Array
    (
         [Post] => Array
             (
                 [id] => 1
                 [title] => Beispiel Eintrag
                 [body] => lorem ipsum...
                 [locale] => de_de
             )

         [titleTranslation] => Array
             (
                 [0] => Array
                     (
                         [id] => 1
                         [locale] => en_us
                         [model] => Post
                         [foreign_key] => 1
                         [field] => title
                         [content] => Example entry
                     )

                 [1] => Array
                     (
                         [id] => 2
                         [locale] => de_de
                         [model] => Post
                         [foreign_key] => 1
                         [field] => title
                         [content] => Beispiel Eintrag
                     )

             )
    )

.. note::

    模型记录包括一个叫做"locale"的*虚拟*字段。这说明在此结果中使用的是哪个地区。

注意，只有你直接进行\`find\`操作的模型字段才会被翻译。通过关联而附加的模型不会被
翻译，因为现在还不支持触发关联模型的回调。

使用 bindTranslation 方法
--------------------------------

你也可以用 bindTranslation 方法，只在你需要的时候，读取所有的翻译。

.. php:method:: bindTranslation($fields, $reset)

``$fields``是一个字段和关联名称的命名键数组(译注: 原文 named-key array，估计是
指关联数组 associative array)，其中键是翻译的字段，而值是虚关联名称。::

    $this->Post->bindTranslation(array('title' => 'titleTranslation'));
    $this->Post->find('all', array('recursive' => 1)); // 需要 recursive 至少为1才行。

有了这样的设置，find()的结果就应该象这样::

    Array
    (
         [Post] => Array
             (
                 [id] => 1
                 [title] => Beispiel Eintrag
                 [body] => lorem ipsum...
                 [locale] => de_de
             )

         [titleTranslation] => Array
             (
                 [0] => Array
                     (
                         [id] => 1
                         [locale] => en_us
                         [model] => Post
                         [foreign_key] => 1
                         [field] => title
                         [content] => Example entry
                     )

                 [1] => Array
                     (
                         [id] => 2
                         [locale] => de_de
                         [model] => Post
                         [foreign_key] => 1
                         [field] => title
                         [content] => Beispiel Eintrag
                     )

             )
    )

用另一种语言保存
==========================

你可以强迫让使用 TranslateBehavior 行为的模型用不同于检测到的语言的另外一种语言来
保存。

要告诉模型内容将使用何种语言，只需在保存数据到数据库前改变模型的 ``$locale`` 属性。
你可以在控制器中这么做，也可以直接在模型中定义。

**例子 A:** 在控制器中::

    class PostsController extends AppController {

        public function add() {
            if (!empty($this->request->data)) {
                $this->Post->locale = 'de_de'; // 我们要保存德文版
                $this->Post->create();
                if ($this->Post->save($this->request->data)) {
                    $this->redirect(array('action' => 'index'));
                }
            }
        }
    }

**例子 B:** 在模型中::

    class Post extends AppModel {
        public $actsAs = array(
            'Translate' => array(
                'title'
            )
        );

        // 选项 1) 直接定义属性
        public $locale = 'en_us';

        // 选项 2) 创建简单方法
        public function setLanguage($locale) {
            $this->locale = $locale;
        }
    }

多个翻译表
===========================

如果你预计有很多输入项，也许你会问如何应对快速增长的数据库表。TranslateBehavior
行为引入了两个属性，可以指定绑定哪个“模型”，来作为包含翻译的模型。

(这样的属性)是 **$translateModel** 和 **$translateTable**。

比如说我们要把所有帖子的翻译存入表 "post\_i18ns"，而不是缺省的 "i18n" 表。为此，
你需要这样设置你的模型::

    class Post extends AppModel {
        public $actsAs = array(
            'Translate' => array(
                'title'
            )
        );

        // 使用不同的模型(和表)
        public $translateModel = 'PostI18n';
    }

.. note::

    重用的是你要对表名使用单词的复数形式。现在这就是普通的模型，并且可以这样对待，
    所以就有相关的约定。表的定义必须与 CakePHP 命令行生成的一样。为确保其正确，可以先
    用命令行初始化一个空的 i18n 表，然后再把表改名。

创建 TranslateModel
-------------------------

为使其工作，你需要在 models 目录中创建实际的模型文件。原因在于，在使用该行为的模
型中，还没有属性可以直接设置 displayField。

确保你把 ``$displayField`` 改为 ``'field'``。::

    class PostI18n extends AppModel {
        public $displayField = 'field'; // 重要
    }
    // 文件名: PostI18n.php

这就行了。你也可以在这里添加模型的其它东西，比如 $useTable。但为了更好的一致性我
们可以在实际使用翻译模型的模型中这样做。这就是可选项``$translateTable``发挥作用的
地方。

改变使用的数据库表
------------------

如果你要改变数据库表的名字，只需在模型中这样定义 $translateTable::

    class Post extends AppModel {
        public $actsAs = array(
            'Translate' => array(
                'title'
            )
        );

        // 使用不同的模型
        public $translateModel = 'PostI18n';

        // 对 translateModel 使用不同的数据库表
        public $translateTable = 'post_translations';
    }

请注意**你不能单独使用 $translateTable**。如果你不想使用定制的 
``$translateModel``，就别碰这个属性。这是因为，(改了的话)那样会破坏你的设置，并
针对运行时创建的缺省 I18n 模型显示一条"Missing Table"(表未找到)的信息。


.. meta::
    :title lang=zh_CN: Translate
    :keywords lang=zh_CN: invalid sql,correct layout,translation table,layout changes,database tables,array,queries,cakephp,models,translate,public name