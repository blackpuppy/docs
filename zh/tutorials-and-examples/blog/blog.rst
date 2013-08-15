blog�̳�
*************

��ӭʹ��CakePHP������̳̻������˽�����й�CakePHP����ι����ġ����ǵ�Ŀ���������������ʹ�������Ȥ������ϣ�������������ʱ����ܵ���

����̳̽�ָ���㽨��һ���򵥵�blogӦ�ã����ǽ����úͰ�װCake���������������ݿ⣬�����㹻��Ӧ���߼�ȥ�г������嵥����ӡ��༭��ɾ��blog���¡�

����������Ҫ��:

#. һ�������е�web�����������ǽ��ٶ���ʹ�õ��� Apache,
   ʹ�����������������ã����裩Ҳ��ࡣ. ���ǽ�����΢�Ķ�
   �������������ļ�, ������������ Cake ������Ҫ�κ����õĸ�
   ���Ϳ�����������ȷ�����PHP�İ汾�� 5.2.8 ����ߡ�
#. һ�����ݿ���������ڱ��̳������ǽ�ʹ�� MySQL ���ݿ⡣
   �㽫����Ҫ��SQL��һ�����˽��Ա㴴��һ�����ݿ⣺Cake����
   ����ӹ����ݿ⡣ʹ��MySQL��ͬʱҪȷ������PHP�п���
   �� ``pdo_mysql`` ģ��.
#. ������ PHP ֪ʶ. ��ʹ�����������Խ��Խ�ã��������ֻ��
    һ��������Ҳ��Ҫ���¡�
#. ���, �㽫��Ҫ��MVC���ģʽ�л������˽⡣ 
    ����������ҵ�һ�����ٵļ��:doc:`/cakephp-overview/
	understanding-model-view-controller`.���õ���, ֻ�ǰ���ֽ����.

�����ǿ�ʼ�ɣ�

��ȡ Cake
============

���ȣ������ǻ�ȡһ�����µ�Cake�Ĵ��뿽����

Ҫ������µĴ��룬Ҫ������ GitHub �ϵ� CakePHP ��Ŀ:
`https://github.com/cakephp/cakephp/tags <https://github.com/cakephp/cakephp/tags>`_
���������µķ��а� 2.0

��Ҳ����ͨ��git������µĴ���
`git <http://git-scm.com/>`_.
``git clone git://github.com/cakephp/cakephp.git``

��������ͨ��ʲô��ʽ���صģ������غ�Ĵ���ŵ����
��Ŀ¼���Щ����ɺ󣬰�װ��Ŀ¼������������::

    /path_to_document_root
        /app
        /lib
        /plugins
        /vendors
        .htaccess
        index.php
        README

�����Ǹ���ʱ��ȥ�˽�һ��Cake�������֯Ŀ¼�ģ������ :doc:`/getting-started/cakephp-folder-structure` �½� ��

���� Blog �����ݿ�
==========================

��һ��������blog�����ݿ⣬�����û������Щ���ʹ���һ�����̳�Ҫ�õ�
�յ����ݿ⣬�����������������Ҫ����һ�������洢���ǵ����£�Ȼ��
��д�뼸ƪ���²����ã������ݿ�����ִ������SQL���::

    /* ���ȣ��������ǵ���־��: */
    CREATE TABLE posts (
        id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(50),
        body TEXT,
        created DATETIME DEFAULT NULL,
        modified DATETIME DEFAULT NULL
    );
    
    /* Ȼ�󣬲���һЩ��־�ļ�¼�����߲�����: */
    INSERT INTO posts (title,body,created)
        VALUES ('The title', 'This is the post body.', NOW());
    INSERT INTO posts (title,body,created)
        VALUES ('A title once again', 'And the post body follows.', NOW());
    INSERT INTO posts (title,body,created)
        VALUES ('Title strikes back', 'This is really exciting! Not.', NOW());


����е����ֲ���������ȡ�ģ��������ѭCake�����ݿ�����Լ����
�Լ����������Լ�����鿴�ĵ� :doc:`/getting-started/cakephp-conventions`��
�㽫������������ֳɵĹ��ܲ��������á�
Cake�Ǿ����㹻������ԣ�����Ӧ��ʹ���
���������ݿ�ܹ�, ������Լ������ʡ����ʱ�䡣

�鿴 :doc:`/getting-started/cakephp-conventions` ��ø������Ϣ,
����ֻ��˵����'posts'�����Զ��������󶨵������ǵ�ģ��Post���Ա��
'�޸�'��'����'����Cake�Զ��ع���

Cake ���ݿ� ����
===========================

������:�����Ǹ���Cake���ǵ����ݿ���������Լ����ȥ����
�����������˵���⽫�ǵ�һ��Ҳ�����һ�����á�

��``/app/Config/database.php.default``�����ҵ�һ��CakePHP�������ļ�. 
���Ʋ��������Ŀ¼�У�������Ϊ ``database.php``.

��������ļ�Ӧ�÷ǳ�ֱ�ӣ� �����滻�� ``$default`` ��������Ӧ��ֵ���ɣ�����������ݿⰲװ���õ�ֵ����
һ���������������ӿ�����Ӧ��������::

    public $default = array(
        'datasource' => 'Database/Mysql',
        'persistent' => false,
        'host' => 'localhost',
        'port' => '',
        'login' => 'cakeBlog',
        'password' => 'c4k3-rUl3Z',
        'database' => 'cake_blog_tutorial',
        'schema' => '',
        'prefix' => '',
        'encoding' => ''
    );

һ�����Ѿ��������µ� ``database.php`` �ļ�, ��Ӧ���ܹ�����������
������Cake�Ļ�ӭҳ�����������������ݿ������ļ��Ѿ����ҵ���Cake�Ѿ�
�ɹ����ӵ����ݿ��ˡ�

.. ע��::

    ��ס�������Ҫʹ�� PDO������Ҫ��php.ini�м��� pdo_mysql ģ�顣

��ѡ������
======================

����������������ѡ��������ã�����������߶��������Щ�����嵥��
���������Ǳ��ν̳���������Ҫ��ġ�һ���Ƕ����Զ����ַ��������ߡ�salt����
����ע��salt�����뱣�����������������ϣ��һ������ַ�����
�����ɰ�ȫ��ϣ���ڶ������Զ���һ�����֣����ߡ�seed�����������ܣ���������
����CakePHP��Ŀ¼ ``tmp`` ӵ��дȨ�ޡ�

��ȫ�������������ɹ�ϣ�ģ������� ``/app/Config/core.php`` line 187 �ı�salt��ֵ��
������������µ�ֵ��ʲô�����������ѱ��³���::

    /**
     * һ��������ַ����������������ɰ�ȫ�Ĺ�ϣ
     */
    Configure::write('Security.salt', 'pl345e-P45s_7h3*S@l7!');

���������������ܺͽ����ַ���. �� ``/app/Config/core.php`` line 192 ��
�ı�seed��ֵ.ͬsalt����ͬ�����Ա��µ�::

    /**
     * һ������ַ��� (ֻ��������) �������������ܺͽ���.
     */
    Configure::write('Security.cipherSeed', '7485712659625147843639846751');

������������Ŀ¼ ``app/tmp``  ���Ա�webд����õķ������ҳ����
webserver�û���˭ (``<?php echo `whoami`; ?>``) ����Ŀ¼ ``app/tmp`` ��Ϊ���û�ӵ��. 
�� \*nix ��ϵͳ�е��������::

    $ chown -R www-data app/tmp

�����Ϊ����ԭ�� CakePHP ����д�뵽��Ŀ¼, �ڷ�����ģʽ���㽫�ᱻ���档

ע�� mod\_rewrite
======================

ż��һ���ĵ��û�����������mod\_rewrite ����. �������CakePHP �Ļ�ӭҳ���������Ź� (����ʵͼƬ������û��css����ʽ),
��Ϳ����� mod\_rewrite�����ϵͳ��û������. �������webserver��url��д:

.. toctree::

    /installation/url-rewriting


���������� :doc:`/tutorials-and-examples/blog/part-two` ��ʼ������һ�� CakePHP Ӧ��.


.. meta::
    :title lang=en: Blog Tutorial
    :keywords lang=en: model view controller,object oriented programming,application logic,directory setup,basic knowledge,database server,server configuration,reins,documentroot,readme,repository,web server,productivity,lib,sql,aim,cakephp,servers,apache,downloads
