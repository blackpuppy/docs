安全
########

.. php:class:: Security

`安全类库 <http://api20.cakephp.org/class/security>`_ 处理基本的安全措施,
如提供哈希和加密数据的方法。

The `security library <http://api20.cakephp.org/class/security>`_
handles basic security measures such as providing methods for
hashing and encrypting data.

安全 API
============

.. php:staticmethod:: cipher( $text, $key )

    :rtype: string

    使用给定的key加密/解密文本
    Encrypts/Decrypts a text using the given key.::

        // 使用my_key来加密文本
        $secret = Security::cipher('hello world', 'my_key');

        // 解密文本
        $nosecret = Security::cipher($secret, 'my_key');

    ``cipher()`` 是 **微弱的** 加密方法。 **not** 用它来加密重要或敏感的数据。

.. php:staticmethod:: rijndael($text, $key, $mode)

    :param string $text: 需要加密的文本
    :param string $key: 用来加密的key。 必须大于32 bytes。
    :param string $mode: 要使用的模式，'加密' 或 '解密'。

    加密/解密文本使用rijndael-256 cipher。需要安装php的 `mcrypt 扩展<http://php.net/mcrypt>` ::
    Encrypts/Decrypts text using the rijndael-256 cipher. This requires the
    `mcrypt extension <http://php.net/mcrypt>`_ to be installed::

        // 解密数据。
        $encrypted = Security::rijndael('a secret', Configure::read('Security.key'), 'encrypt');

        // 解密。
        $decrypted = Security::rijndael($encrypted, Configure::read('Security.key'), 'decrypt');

    ``rijndael()`` 可以用来存储晚些时候需要解密的数据。像cookie内容。**永远** 不要用它来存储密码。
    应该使用后面提供的哈希方法 :php:meth:`~Security::hash()`

    ``rijndael()`` can be used to store data you need to decrypt later, like the
    contents of cookies.  It should **never** be used to store passwords.
    Instead you should use the one way hashing methods provided by
    :php:meth:`~Security::hash()`

    .. versionadded:: 2.2
        ``Security::rijndael()`` was added in 2.2.

.. php:staticmethod:: generateAuthKey( )

    :rtype: string

    	生成授权哈希。
        Generate authorization hash.

.. php:staticmethod:: getInstance( )

    :rtype: object

	实现单例对象实例。
    Singleton implementation to get object instance.


.. php:staticmethod:: hash( $string, $type = NULL, $salt = false )

    :rtype: string

    从给定的字符串创建一个哈希值。如果 ``$salt`` 被设置为true,
    将使用应用程序中salt的值::

    Create a hash from string using given method. Fallback on next
    available method. If ``$salt`` is set to true, the applications salt
    value will be used::

        // 使用应用程序的salt value
        $sha1 = Security::hash('CakePHP Framework', 'sha1', true);

        // 使用自定义salt value
        $md5 = Security::hash('CakePHP Framework', 'md5', 'my-salt');

        // 使用默认的hash算法
        $hash = Security::hash('CakePHP Framework');

    ``hash()`` 函数支持更多的安全哈希算法。比如bcrypt。当使用bcrypt，会有略小的差别。

    also supports more secure hashing algorithms like bcrypt.  When
    using bcrypt, you should be mindful of the slightly different usage.
    Creating an initial hash works the same as other algorithms::

        // 使用bcrypt创建哈希
        Security::setHash('blowfish');
        $hash = Security::hash('CakePHP Framework');

    Unlike other hash types comparing plain text values to hashed values should
    be done as follows::

        // $storedPassword, 是之前生成的bcrypt hash。
        $newHash = Security::hash($newPassword, 'blowfish', $storedPassword);

    When comparing values hashed with bcrypt, the original hash should be
    provided as the ``$salt`` parameter.  This allows bcrypt to reuse the same
    cost and salt values, allowing the generated hash to end up with the same
    resulting hash given the same input value.

    .. versionchanged:: 2.3
        2.3中新加入支持bcrypt


.. php:staticmethod:: inactiveMins( )

    :rtype: integer

	基于安全级别得到允许静止运动的分钟数
    Get allowed minutes of inactivity based on security level.::

        $mins = Security::inactiveMins();
        // If your config Security.level is set to 'medium' then $mins will equal 100

.. php:staticmethod:: setHash( $hash )

    :rtype: void

    为Security对象设置默认的hash方法。会影响到使用Security::hash()的所有对象。
    Sets the default hash method for the Security object. This
    affects all objects using Security::hash().

.. php:staticmethod:: validateAuthKey( $authKey )

    :rtype: boolean

    验证授权哈希
    Validate authorization hash.


.. todo::

    添加更多实例 :|

.. meta::
    :title lang=zh_CN: Security
    :keywords lang=zh_CN: security api,secret password,cipher text,php class,class security,text key,security library,object instance,security measures,basic security,security level,string type,fallback,hash,data security,singleton,inactivity,php encrypt,implementation,php security
