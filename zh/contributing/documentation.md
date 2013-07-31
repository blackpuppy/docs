文档
####

给文档做贡献是很简单的。这些文件都托管在http://github.com/cakephp/docs。
请随意创建分支(fork，易和branch混淆，要找个不同的词)，加入你的
更改/改进/翻译，然后发出拉取请求来提交你的改动。你甚至可以在github上
在线地编辑文档，而完全不用下载文件。

翻译
====

发邮件给文档小组(docs at cakephp dot org)，或者通过IRC(freenode上的#cakephp)，
来讨论任何你想参与的翻译工作。

关于翻译的一些忠告:

- 用要翻译的语言来进行浏览、编辑 - 否则你将无法看到哪些已经翻译了。
- 如果你选择的语言在本书中已经存在，请随意加入。
- 请使用`非正式形式 <http://en.wikipedia.org/wiki/Register_(linguistics)>`_。
- 请将内容和标题一起翻译。
- 在提交一个更正之前，请先和英文版本的内容进行比较(如果你改正了一些东西，却
  没有整合“上游”的改动，你提交的东西将不会被接受)。
- 如果你要写一个术语，请把它放在``<em>``标签之内。比如，"asdf asdf *Controller* asdf"
  或者"asdf asdf Kontroller (*Controller*) asfd"，请适为选用。
- 请不要提交不完整的翻译。
- 请不要编辑正在改动的部分。
- 对于标以重音符号的字符，请不要使用
  `html实体 <http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references>`_，
  本书使用UTF-8。
- 请不要显着改变的标记(HTML)或增加新的内容。
- 如果原始的内容遗漏了某些内容，请先提交修改。

文档格式指南
============

这份新的CakePHP文档是以`ReST formatted text <http://en.wikipedia.org/wiki/ReStructuredText>`_格式写的。
ReST (Re Structured Text)是与markdown或者textile类似的纯文本标记语法。
在为CakePHP的文档做出贡献时，为了保持一致性，建议你遵循下面的准则，来你格式化和
组织你的文字。

每行的长度
----------

每行文字应在80列处折行。唯一的例外是长的网址和代码片断。

标题和小节
----------

小节的标题要在下一行以至少相同长度的标点符号来标识。

- ``#`` 用来标识网页标题。
- ``=`` 用于标识在一个页面中的小节。
- ``-`` 用于标识下一级的小节。
- ``~`` 用于标识再下一级的小节。
- ``^`` 用于标识更下一级的小节。

标题的嵌套深度不应超过5层。标题之前和之后都应留有一个空行。

段落
----

段落是简单的文本块，缩进在同一级别。段落之间应以一个以上的空行分隔。

内嵌标记
--------

* one asterisk: *text* for emphasis (italics),
* two asterisks: **text** for strong emphasis (boldface), and
* backquotes: ``text`` for code samples.

If asterisks or backquotes appear in running text and could be confused with inline markup
delimiters, they have to be escaped with a backslash.

Inline markup has a few restrictions:

* It **may not** be nested.
* Content may not start or end with whitespace: ``* text*`` is wrong.
* Content must be separated from surrounding text by non-word characters. Use a
  backslash escaped space to work around that: ``onelong\ *bolded*\ word``.

Lists
-----

List markup is very similar to markdown.  Unordered lists are indicated by
starting a line with a single asterisk and a space.  Numbered lists can be
created with either numerals, or ``#`` for auto numbering::

    * This is a bullet
    * So is this.  But this line
      has two lines.

    1. First line
    2. Second line

    #. Automatic numbering
    #. Will save you some time.

Indented lists can also be created, by indenting sections and separating them
with an empty line::

    * First line
    * Second line

        * Going deeper
        * Whoah

    * Back to the first level.

Definition lists can be created by doing the following::

    term
        definition
    CakePHP
        An MVC framework for PHP

Terms cannot be more than one line, but definitions can be multi-line and all
lines should be indented consistently.

Links
-----

There are several kinds of links, each with their own uses.

External links
~~~~~~~~~~~~~~

Links to external documents can be with the following::

    `External Link <http://example.com>`_

The above would generate a link pointing to http://example.com

Links to other pages
~~~~~~~~~~~~~~~~~~~~

.. rst:role:: doc

    Other pages in the documentation can be linked to using the ``:doc:`` role.
    You can link to the specified document using either an absolute or relative
    path reference.  You should omit the ``.rst`` extension.  For example, if
    the reference ``:doc:`form``` appears in the document ``core-helpers/html``,
    then the link references ``core-helpers/form``.  If the reference was
    ``:doc:`/core-helpers```, it would always reference ``/core-helpers``
    regardless of where it was used.

Cross referencing links
~~~~~~~~~~~~~~~~~~~~~~~

.. rst:role:: ref

    You can cross reference any arbitrary title in any document using the
    ``:ref:`` role.  Link label targets must be unique across the entire
    documentation.  When creating labels for class methods, it's best to use
    ``class-method`` as the format for your link label.

    The most common use of labels is above a title.  Example::

        .. _label-name:

        Section heading
        ---------------

        More content here.

    Elsewhere you could reference the above section using ``:ref:`label-name```.
    The link's text would be the title that the link preceded.  You can also
    provide custom link text using ``:ref:`Link text <label-name>```.

Describing classes and their contents
-------------------------------------

The CakePHP documentation uses the `phpdomain
<http://pypi.python.org/pypi/sphinxcontrib-phpdomain>`_ to provide custom
directives for describing PHP objects and constructs.  Using these directives
and roles is required to give proper indexing and cross referencing features.

Describing classes and constructs
---------------------------------

Each directive populates the index, and or the namespace index.

.. rst:directive:: .. php:global:: name

   This directive declares a new PHP global variable.

.. rst:directive:: .. php:function:: name(signature)

   Defines a new global function outside of a class.

.. rst:directive:: .. php:const:: name

   This directive declares a new PHP constant, you can also use it nested
   inside a class directive to create class constants.

.. rst:directive:: .. php:exception:: name

   This directive declares a new Exception in the current namespace. The
   signature can include constructor arguments.

.. rst:directive:: .. php:class:: name

   Describes a class.  Methods, attributes, and constants belonging to the class
   should be inside this directive's body::

        .. php:class:: MyClass

            Class description

           .. php:method:: method($argument)

           Method description


   Attributes, methods and constants don't need to be nested.  They can also just
   follow the class declaration::

        .. php:class:: MyClass

            Text about the class

        .. php:method:: methodName()

            Text about the method


   .. seealso:: :rst:dir:`php:method`, :rst:dir:`php:attr`, :rst:dir:`php:const`

.. rst:directive:: .. php:method:: name(signature)

   Describe a class method, its arguments, return value, and exceptions::

        .. php:method:: instanceMethod($one, $two)

            :param string $one: The first parameter.
            :param string $two: The second parameter.
            :returns: An array of stuff.
            :throws: InvalidArgumentException

           This is an instance method.

.. rst:directive:: .. php:staticmethod:: ClassName::methodName(signature)

    Describe a static method, its arguments, return value and exceptions,
    see :rst:dir:`php:method` for options.

.. rst:directive:: .. php:attr:: name

   Describe an property/attribute on a class.

Cross Referencing
~~~~~~~~~~~~~~~~~

The following roles refer to php objects and links are generated if a
matching directive is found:

.. rst:role:: php:func

   Reference a PHP function.

.. rst:role:: php:global

   Reference a global variable whose name has ``$`` prefix.

.. rst:role:: php:const

   Reference either a global constant, or a class constant.  Class constants should
   be preceded by the owning class::

        DateTime has an :php:const:`DateTime::ATOM` constant.

.. rst:role:: php:class

   Reference a class by name::

     :php:class:`ClassName`

.. rst:role:: php:meth

   Reference a method of a class. This role supports both kinds of methods::

     :php:meth:`DateTime::setDate`
     :php:meth:`Classname::staticMethod`

.. rst:role:: php:attr

   Reference a property on an object::

      :php:attr:`ClassName::$propertyName`

.. rst:role:: php:exc

   Reference an exception.


Source code
-----------

Literal code blocks are created by ending a paragraph with ``::``. The literal
block must be indented, and like all paragraphs be separated by single lines::

    This is a paragraph::

        while ($i--) {
            doStuff()
        }

    This is regular text again.

Literal text is not modified or formatted, save that one level of indentation is removed.


Notes and warnings
------------------

There are often times when you want to inform the reader of an important tip,
special note or a potential hazard. Admonitions in sphinx are used for just
that.  There are three kinds of admonitions.

* ``.. tip::`` Tips are used to document or re-iterate interesting or important
  information. The content of the directive should be written in complete
  sentences and include all appropriate punctuation.
* ``.. note::`` Notes are used to document an especially important piece of
  information. The content of the directive should be written in complete
  sentences and include all appropriate punctuation.
* ``.. warning::`` Warnings are used to document potential stumbling blocks, or
  information pertaining to security.  The content of the directive should be
  written in complete sentences and include all appropriate punctuation.

All admonitions are made the same::

    .. note::

        Indented and preceded and followed by a blank line. Just like a paragraph.

    This text is not part of the note.

Samples
~~~~~~~

.. tip::

    This is a helpful tid-bit you probably forgot.

.. note::

    You should pay attention here.

.. warning::

    It could be dangerous.


.. meta::
    :title lang=en: Documentation
    :keywords lang=en: partial translations,translation efforts,html entities,text markup,asfd,asdf,structured text,english content,markdown,formatted text,dot org,repo,consistency,translator,freenode,textile,improvements,syntax,cakephp,submission
