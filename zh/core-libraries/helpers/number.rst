NumberHelper
############

.. php:class:: NumberHelper(View $view, array $settings = array())

NumberHelper包含方便的方法使得数字以共同的格式在视图中展示。
这些方法有格式化货币，百分比，数据大小，格式化数字为指定的精度和更多的灵活性
格式化数字。

The NumberHelper contains convenience methods that enable display
numbers in common formats in your views. These methods include ways
to format currency, percentages, data sizes, format numbers to
specific precisions and also to give you more flexibility with
formatting numbers.

.. versionchanged:: 2.1

   ``NumberHelper`` 已经被重构到 :php:class:`CakeNumber` 类。可以非常简单在``View``
   层外被调用。
   在视图层内，这些方法通过`NumberHelper``调用。可以像普通的助手方法一样进行
   调用``$this->Number->method($args);``。

   ``NumberHelper`` have been refactored into :php:class:`CakeNumber` class to
   allow easier use outside of the ``View`` layer.
   Within a view, these methods are accessible via the ``NumberHelper``
   class and you can call it as you would call a normal helper method:
   ``$this->Number->method($args);``.

.. include:: ../../core-utility-libraries/number.rst
    :start-after: start-cakenumber
    :end-before: end-cakenumber

.. meta::
    :title lang=zh: NumberHelper
    :description lang=zh: The Number Helper contains convenience methods that enable display numbers in common formats in your views.
    :keywords lang=zh: number helper,currency,number format,number precision,format file size,format numbers
