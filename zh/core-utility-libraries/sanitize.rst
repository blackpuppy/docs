Data Sanitization
#################

.. php:class:: Sanitize

The CakePHP Sanitize class can be used to rid user-submitted data
of malicious data and other unwanted information. Sanitize is a
core library, so it can be used anywhere inside of your code, but
is probably best used in controllers or models.

CakePHP的Sanitize类可以避免用户提交有害数据和其他并不需要的数据，Sanitize是核心库
，所以可以在代码的任何地方使用，但最好在控制器和模型中使用

CakePHP already protects you against SQ Injection **if** you use
CakePHP's ORM methods (such as find() and save()) and proper array
notation (ie. array('field' => $value)) instead of raw SQL. For
sanitization against XSS it's generally better to save raw HTML in
database without modification and sanitize at the tLime of
output/display.

CakePHP已经在ORM方法中(如find() and save())做了防sql注入处理，对于sanitization可以用来抵御XSS，在输出和显示时过滤处理html

All you need to do is include the Sanitize core library (e.g.
before the controller class definition)::

你需要做的只是在controller中引入核心库

    App::uses('Sanitize', 'Utility');
    
    class MyController extends AppController {
        ...
        ...
    }

Once you've done that, you can make calls to Sanitize statically.

.. php:静态方法:: Sanitize::clean($data, $options)

    :param mixed $data: Data to clean.要清理的数据
    :param mixed $options: Options to use when cleaning, see below.清理时的选项

    This function is an industrial-strength, multi-purpose cleaner,
    meant to be used on entire arrays (like $this->data, for example).
    The function takes an array (or string) and returns the clean
    version. The following cleaning operations are performed on each
    element in the array (recursively):

    这个一个强有力的，多用处的清理函数，
    function beforeFilter() {
        parent::beforeFilter();
        App::import('Sanitize');        
        $this->data = Sanitize::clean($this->data, array('encode' => false));
    }

    -  Odd spaces (including 0xCA) are replaced with regular spaces.
    -  Double-checking special chars and removal of carriage returns
       for increased SQL security.
    -  Adding of slashes for SQL (just calls the sql function outlined
       above).
    -  Swapping of user-inputted backslashes with trusted backslashes.

    The $options argument can either be a string or an array. When a
    string is provided it's the database connection name. If an array
    is provided it will be merged with the following options:

    $options参数可以是一个字符串或数组，当为字符串需要传入数据库连接名，若为数组见下


    -  connection
    -  odd_spaces
    -  encode
    -  dollar
    -  carriage
    -  unicode
    -  escape
    -  backslash
    -  remove_html (must be used in conjunction with the encode
       parameter必须同时需要encode参数)

    使用方法如下:

        $this->data = Sanitize::clean($this->data, array('encode' => false));


.. php:静态方法:: Sanitize::escape($string, $connection)

    :param string $string: Data to clean.
    :param string $connection: The name of the database to quote the string for, 
        as named in your app/Config/database.php file.

    Used to escape SQL statements by adding slashes, depending on the
    system's current magic\_quotes\_gpc setting,


.. php:staticmethod:: Sanitize::html($string, $options = array())

    :param string $string: Data to clean.
    :param array $options: An array of options to use, see below.

    防止用户注入有害代码，如插入图片或脚本造成破坏页面布局等问题

    This method prepares user-submitted data for display inside HTML.
    This is especially useful if you don't want users to be able to
    break your layouts or insert images or scripts inside of your HTML
    pages. 如果$remove选项设置为true，会删除HTML内容而不是转化为HTML实体::

        $badString = '<font size="99" color="#FF0000">HEY</font><script>...</script>';
        echo Sanitize::html($badString);
        // 输出: &lt;font size=&quot;99&quot; color=&quot;#FF0000&quot;&gt;HEY&lt;/font&gt;&lt;script&gt;...&lt;/script&gt;
        echo Sanitize::html($badString, array('remove' => true));
        // 输出: HEY...

    Escaping is often a better strategy than stripping, as it has less room
    for error, and isn't vulnerable to new types of attacks, the stripping 
    function does not know about.

.. php:静态方法:: Sanitize::paranoid($string, $allowedChars)

    过滤字符，只输出数字字母，$allowedChars是保留的字符

    :param string $string: Data to clean.
    :param array $allowedChars: An array of non alpha numeric characters allowed.

    This function strips anything out of the target $string that is not
    a plain-jane alphanumeric character. The function can be made to
    overlook certain characters by passing them in $allowedChars
    array::

        $badString = ";:<script><html><   // >@@#";
        echo Sanitize::paranoid($badString);
        // output: scripthtml
        echo Sanitize::paranoid($badString, array(' ', '@'));
        // output: scripthtml    @@


.. meta::
    :title lang=en: Data Sanitization
    :keywords lang=en: array notation,sql security,sql function,malicious data,controller class,data options,raw html,core library,carriage returns,database connection,orm,industrial strength,slashes,chars,multi purpose,arrays,cakephp,element,models
