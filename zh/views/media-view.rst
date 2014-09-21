媒体视图
===========

.. php:class:: MediaView

.. 弃用:: 2.3
   替换为 :ref:`cake-response-file` 。
   
媒体视图允许你发送二进制文件给用户。例如，你希望有一个webroot
目录之外的目录存放文件防止用户直接访问它们。你可以使用媒体
视图将文件拉取到 /app/ 中的一个特殊目录，并在传送文件之前验证用户。

使用媒体视图，你需要告诉你的控制器使用视图 MediaView 。
然后只需要将你存放文件的位置填入参数中 ::

    class ExampleController extends AppController {
        public function download() {
            $this->viewClass = 'Media';
            // Download app/outside_webroot_dir/example.zip
            $params = array(
                'id'        => 'example.zip',
                'name'      => 'example',
                'download'  => true,
                'extension' => 'zip',
                'path'      => APP . 'outside_webroot_dir' . DS
            );
            $this->set($params);
        }
    }

这是一个不属于 MediaView 的 ``$mimeType`` 中的mime类型的例子，
同时使用一个相对于 ``app/webroot`` 目录的路径::

    public function download() {
        $this->viewClass = 'Media';
        // Render app/webroot/files/example.docx
        $params = array(
            'id'        => 'example.docx',
            'name'      => 'example',
            'extension' => 'docx',
            'mimeType'  => array(
                'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
            ),
            'path'      => 'files' . DS
        );
        $this->set($params);
    }

可设变量
-------------------

``id``
    ID 是位于文件服务器上的文件的名字包括扩展名。

``name``
    name 可以让你定义显示给用户的文件名字，不包括文件扩展名。

``download``
    一个布尔值，在头文件中标识是否阻止下载。

``extension``
    文件扩展名。这个是和可接受的mime类型匹配的。如果这个mime类型
	没在列表中（或者在mimeType参数数组中提出），这个文件就无法
	被下载。

``path``
    目录名字，包括最终的目录分隔符，是绝对路径，但可以在 ``app/webroot`` 目录的相对路径访问到。

``mimeType``
    一个数据，用来添加额外的mime类型，整合进 MediaView 的内置mime类型列表中。

``cache``
	一个布尔值或整数值 - 如果设置为true，它就会允许浏览器缓存
	文件（默认是不允许的）；或者设置成数字，表示缓存将在多少秒
	之后过期。


.. 下一步::

    加入例子说明如何使用媒体视图发送文件。


.. meta::
    :title lang=zh_CN: Media Views
    :keywords lang=zh_CN: array php,true extension,zip name,document path,mimetype,boolean value,binary files,webroot,file extension,mime type,default view,file server,authentication,parameters
