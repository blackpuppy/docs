Inflector
#########

.. php:class:: Inflector

Inflector类提供的方法可以接收一个字符串，将其单词变量转变为复数形式或驼峰
形式的写法。所有方法都是静态方法。举例
``Inflector::pluralize('example')`` 返回 "examples".

The Inflector class takes a string and can manipulate it to handle
word variations such as pluralizations or camelizing and is
normally accessed statically. Example:
``Inflector::pluralize('example')`` returns "examples".

.. php:staticmethod:: pluralize($singular)

    * **输入:** Apple, Orange, Person, Man
    * **输出:** Apples, Oranges, People, Men

.. php:staticmethod:: singularize($plural)

    **输入:** Apples, Oranges, People, Men
    **输出:** Apple, Orange, Person, Man

.. php:staticmethod:: camelize($underscored)

    * **输入:** Apple\_pie, some\_thing, people\_person
    * **输出:** ApplePie, SomeThing, PeoplePerson

.. php:staticmethod:: underscore($camelCase)

	应当注意underscore()方法只转换驼峰格式的单词，单词包含的空格将小写化，
	并不会带上下划线。

    It should be noted that underscore will only convert camelCase
    formatted words. Words that contains spaces will be lower-cased,
    but will not contain an underscore.

    * **输入:** applePie, someThing
    * **输出:** apple\_pie, some\_thing

.. php:staticmethod:: humanize($underscored)

    * **输入:** apple\_pie, some\_thing, people\_person
    * **输出:** Apple Pie, Some Thing, People Person

.. php:staticmethod:: tableize($camelCase)

    * **输入:** Apple, UserProfileSetting, Person
    * **输出:** apples, user\_profile\_settings, people

.. php:staticmethod:: classify($underscored)

    * **输入:** apples, user\_profile\_settings, people
    * **输出:** Apple, UserProfileSetting, Person

.. php:staticmethod:: variable($underscored)

    * **输入:** apples, user\_result, people\_people
    * **输出:** apples, userResult, peoplePeople

.. php:staticmethod:: slug($word, $replacement = '_')

	slug()方法将特殊的字符转换为拉丁版本，并且将空格转换为下划线。

    Slug converts special characters into latin versions and converting
    unmatched characters and spaces to underscores. The slug method
    expects UTF-8 encoding.

    * **输入:** apple purée
    * **输出:** apple\_puree

.. php:staticmethod:: reset()

	重置Inflector退回到初始的状态，用于测试。

    Resets Inflector back to its initial state, useful in testing.

.. php:staticmethod:: rules($type, $rules, $reset = false)

	定义一个新的规则供Inflector类使用。参见 :ref:`inflection-configuration`。

    Define new inflection and transliteration rules for Inflector to use.
    See :ref:`inflection-configuration` for more information.


.. meta::
    :title lang=zh: Inflector
    :keywords lang=zh: apple orange,word variations,apple pie,person man,latin versions,profile settings,php class,initial state,puree,slug,apples,oranges,user profile,underscore
