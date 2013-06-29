Data Sanitization
#################

.. php:class:: Sanitize

CakePHP的Sanitize类可以避免用户提交有害的和其他不需要的数据，Sanitize是核心库
，所以可以在代码的任何地方使用，但最好在控制器和模型中用到它。

**如果**你用到了CakePHP的ORM方法(如：find() and save())和适当的数组写法(比如：array('field' => $value))而不是原生SQL语句,CakePHP已经帮你做了防sql注入处理，因为sanitization可以用来抵御XSS，通常最好在未经修改和清理输出展示的时候保存原生的html到数据库(For
sanitization against XSS it's generally better to save raw HTML in
database without modification and sanitize at the time of
output/display.)

你需要做的只是在controller中引入Sanitize核心库(你可以在定义控制器的语句之前引入)::

    App::uses('Sanitize', 'Utility');
    
    class MyController extends AppController {
        ...
        ...
    }

一旦引用，就可以调用Sanitize中的静态方法。

.. php:staticmethod:: Sanitize::clean($data, $options)

    :param mixed $data: Data to clean.
    :param mixed $options: Options to use when cleaning, see below.

    这是一个强有力的，多用途的清理数据的方法，可以处理整个数组(比如：$this->data)方法接收一个字符或字符串，返回经过处理的数据
    下面的清理选项可以递归作用于数组中的每一个元素：

    -  Odd spaces (including 0xCA) are replaced with regular spaces.
    -  Double-checking special chars and removal of carriage returns
       for increased SQL security.
    -  Adding of slashes for SQL (just calls the sql function outlined
       above).
    -  Swapping of user-inputted backslashes with trusted backslashes.

    $options参数可以是个字符串或数组，若为字符串需要提供数据库的连接名，若为数组，可以用下面的选项：


    -  connection
    -  odd\_spaces
    -  encode
    -  dollar
    -  carriage
    -  unicode
    -  escape
    -  backslash
    -  remove\_html (must be used in conjunction with the encode
       parameter)

    Usage of clean() with options looks something like the following::

        $this->data = Sanitize::clean($this->data, array('encode' => false));


.. php:staticmethod:: Sanitize::escape($string, $connection)

    :param string $string: 需要清理的数据
    :param string $connection: 带引号的数据库名，来源是你的app/Config/database.php文件。The name of the database to quote the string for, 
        as named in your app/Config/database.php file.

    Used to escape SQL statements by adding slashes, depending on the
    system's current magic\_quotes\_gpc setting,


.. php:staticmethod:: Sanitize::html($string, $options = array())

    :param string $string: Data to clean.
    :param array $options: An array of options to use, see below.

    This method prepares user-submitted data for display inside HTML.
    This is especially useful if you don't want users to be able to
    break your layouts or insert images or scripts inside of your HTML
    pages. If the $remove option is set to true, HTML content detected
    is removed rather than rendered as HTML entities::

        $badString = '<font size="99" color="#FF0000">HEY</font><script>...</script>';
        echo Sanitize::html($badString);
        // output: &lt;font size=&quot;99&quot; color=&quot;#FF0000&quot;&gt;HEY&lt;/font&gt;&lt;script&gt;...&lt;/script&gt;
        echo Sanitize::html($badString, array('remove' => true));
        // output: HEY...

    Escaping is often a better strategy than stripping, as it has less room
    for error, and isn't vulnerable to new types of attacks, the stripping 
    function does not know about.

.. php:staticmethod:: Sanitize::paranoid($string, $allowedChars)

    :param string $string: 需要清理的字符串
    :param array $allowedChars: 数组类型，允许保留的字符，不能包含字母数字。

    该函数会清除$string中除字母数字的其他所有字符。若传入第二个参数$allowedChars会保留该数组内的字符::

        $badString = ";:<script><html><   // >@@#";
        echo Sanitize::paranoid($badString);
        // 输出: scripthtml
        echo Sanitize::paranoid($badString, array(' ', '@'));
        // 输出: scripthtml    @@


.. meta::
    :title lang=en: Data Sanitization
    :keywords lang=en: array notation,sql security,sql function,malicious data,controller class,data options,raw html,core library,carriage returns,database connection,orm,industrial strength,slashes,chars,multi purpose,arrays,cakephp,element,models