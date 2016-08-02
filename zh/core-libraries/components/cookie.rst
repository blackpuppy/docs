Cookie
######

.. php:class:: CookieComponent(ComponentCollection $collection, array $settings = array())

CookieComponent(Cookie组件)是对原生php中``setcookie``的封装。它还包括许多有用的
功能，使得在你的控制器中使用起来很方便。在使用CookieComponent之前,必须确保'Cookie'出现在
控制器的$components变量数组中。

The CookieComponent is a wrapper around the native PHP ``setcookie``
method. It also includes a host of delicious icing to make coding
cookies in your controllers very convenient. Before attempting to
use the CookieComponent, you must make sure that 'Cookie' is listed
in your controllers' $components array.


Controller Setup
控制器设置
================

有许多控制器变量的来允许你配置cookies创建和管理。请在控制器的beforeFilter()方法定义这些
特殊的变量,来使得定义CookieComponent如何工作。

There are a number of controller variables that allow you to
configure the way cookies are created and managed. Defining these
special variables in the beforeFilter() method of your controller
allows you to define how the CookieComponent works.

+-----------------+--------------+------------------------------------------------------+
| Cookie 变量     | 默认值       | 描述                                                 |
+=================+==============+======================================================+
| string $name    |'CakeCookie'  | cookie名.                                            |
+-----------------+--------------+------------------------------------------------------+
| string $key     | null         | 这个字符串用来加密                                   |
|                 |              | 值写进cookie.                                        |
|                 |              | 这个字符串应该是随机的并且难以去猜。                 |
|                 |              |                                                      |
|                 |              | 当使用rijndael加密方式，值的长度会超过32 bytes。     |
+-----------------+--------------+------------------------------------------------------+
| string $domain  | ''           | cookie允许访问的主机名. 例如：                       |
|                 |              | 使用'.yourdomain.com' 可以允许所有从你的子域名访问   |
|                 |              |                                                      |
+-----------------+--------------+------------------------------------------------------+
| int or string   | '5 Days'     | cookie过期时间. 数字类型会被解析为秒，当值为0等价于  |
|                 |              | 'session cookie': 例如： 浏览器关闭就会过期。        |
|                 |              | 若为字符型，会被PHP函数strtotime()解析               |
|                 |              | 可以直接在write()方法中设置。                        |
+-----------------+--------------+------------------------------------------------------+
| string $path    | '/'          | cookie采用的服务器路径。                             |
|                 |              | 如果$path设置为'/foo/', cookie仅会在/foo/目录和所有的|
|                 |              | 子目录中生效，默认值是整个域名，可以直接在write()方法|
|                 |              | 中设置。                                             |
|                 |              |                                                      |
+-----------------+--------------+------------------------------------------------------+
| boolean $secure | false        | 指明cookie只能通过安全的HTTPS连接传输。              |
|                 |              | 当设为true，为安全连接时，cookie只会被设置，         |
|                 |              | 也可以直接在write()方法中设置。                      |
|                 |              |                                                      |
|                 |              |                                                      |
+-----------------+--------------+------------------------------------------------------+
| boolean         | false        | 设置true仅允许HTTP访问cookies. 禁止在Javascript中    |
| $httpOnly       |              | 访问。                                               |
+-----------------+--------------+------------------------------------------------------+

下面是控制器中的代码片段。来展示如何引入CookieComponent并且为'example.com'域名设置了
名称为'baker\_id'的安全链接，路径为‘/bakers/preferences/’
过期时间一个小时和只允许HTTP访问的cookie::

The following snippet of controller code shows how to include the
CookieComponent and set up the controller variables needed to write
a cookie named 'baker\_id' for the domain 'example.com' which needs
a secure connection, is available on the path
‘/bakers/preferences/’, expires in one hour and is HTTP only::

    public $components = array('Cookie');
    public function beforeFilter() {
        parent::beforeFilter();
        $this->Cookie->name = 'baker_id';
        $this->Cookie->time = 3600;  // or '1 hour'
        $this->Cookie->path = '/bakers/preferences/';
        $this->Cookie->domain = 'example.com';
        $this->Cookie->secure = true;  // i.e. only sent if using secure HTTPS
        $this->Cookie->key = 'qSI232qs*&sXOw!adre@34SAv!@*(XSL#$%)asGb$@11~_+!@#HKis~#^';
        $this->Cookie->httpOnly = true;
    }

接下来，让我们看下如何使用Cookie组件中的各种方法。
Next, let’s look at how to use the different methods of the Cookie
Component.

Using the Component
使用组件
===================

CookieComponent提供了一系列处理Cookies的方法。
The CookieComponent offers a number of methods for working with Cookies.

.. php:method:: write(mixed $key, mixed $value = null, boolean $encrypt = true, mixed $expires = null)

    write()方法是cookie组件的核心，$key是cookie的变量名，$value是要存储的信息::

    The write() method is the heart of cookie component, $key is the
    cookie variable name you want, and the $value is the information to
    be stored::

        $this->Cookie->write('name', 'Larry');

    通过点记法中的键名参数可以对变量进行分组::
    You can also group your variables by supplying dot notation in the
    key parameter::

        $this->Cookie->write('User.name', 'Larry');
        $this->Cookie->write('User.role', 'Lead');

    如果想一次写入多个cookie值，可以传个数组::
    If you want to write more than one value to the cookie at a time,
    you can pass an array::

        $this->Cookie->write('User',
            array('name' => 'Larry', 'role' => 'Lead')
        );

    cookie中所有的值默认被加密。如果想以纯文本存储。设置write()方法的第三个
    参数为false。对cookie值执行的是相当简单的加密系统。用到了``Security.salt``
    和配置类中预定义的变量``Security.cipherSeed``。为了更加安全，可以改变
    app/Config/core.php中的``Security.cipherSeed``。

    All values in the cookie are encrypted by default. If you want to
    store the values as plain-text, set the third parameter of the
    write() method to false. The encryption performed on cookie values
    is fairly uncomplicated encryption system. It uses
    ``Security.salt`` and a predefined Configure class var
    ``Security.cipherSeed`` to encrypt values. To make your cookies
    more secure you should change ``Security.cipherSeed`` in
    app/Config/core.php to ensure a better encryption.::

        $this->Cookie->write('name', 'Larry', false);

    最后一个参数是$expires，cookie过期的秒数。为了方便，也可以传递一个
    php方法strtotime()理解的日期字符串。

    The last parameter to write is $expires – the number of seconds
    before your cookie will expire. For convenience, this parameter can
    also be passed as a string that the php strtotime() function
    understands::

        // Both cookies expire in one hour.
        // 两个cookies将在一小时后过期
        $this->Cookie->write('first_name', 'Larry', false, 3600);
        $this->Cookie->write('last_name', 'Masters', false, '1 hour');

.. php:method:: read(mixed $key = null)

    读取指定$key的cookie的变量值
    This method is used to read the value of a cookie variable with the
    name specified by $key.::

        // Outputs “Larry”
        echo $this->Cookie->read('name');

        // You can also use the dot notation for read
        // 也可以使用点记法
        echo $this->Cookie->read('User.name');

        // To get the variables which you had grouped
        // using the dot notation as an array use something like
        // 获取组中的变量集合
        $this->Cookie->read('User');

        // this outputs something like array('name' => 'Larry', 'role' => 'Lead')

.. php:method:: check($key)

    :param string $key: The key to check.

    // 检测key/path是否存在，并且不是空值。
    Used to check if a key/path exists and has not-null value.

    .. versionadded:: 2.3
        ``CookieComponent::check()`` was added in 2.3

.. php:method:: delete(mixed $key)

    删除指定$key的cookie变量。可用点记法表示::

    Deletes a cookie variable of the name in $key. Works with dot
    notation::

        // Delete a variable
        // 删除一个cookie变量
        $this->Cookie->delete('bar');

        // Delete the cookie variable bar, but not all under foo
        // 删除foo下的cookie变量bar，并不是foo下所有变量。
        $this->Cookie->delete('foo.bar');

.. php:method:: destroy()

    销毁当前cookie

    Destroys the current cookie.

.. php:method:: type($type)

    改变加密模式。默认使用'cipher'模式。可以使用'rijndael'模式来提高安全性。

    Allows you to change the encryption scheme.  By default the 'cipher' scheme
    is used. However, you should use the 'rijndael' scheme for improved
    security.

    .. versionchanged:: 2.2
        The 'rijndael' type was added.


.. meta::
    :title lang=zh: Cookie
    :keywords lang=zh: array controller,php setcookie,cookie string,controller setup,string domain,default description,string name,session cookie,integers,variables,domain name,null
