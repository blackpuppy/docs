ACL Shell
#########

AclShell在管理和监督你的Acl数据库记录上很有用。它比每次都要在你的控制器中
修改更方便。

大多数 acl shell 命令涉及引用 aco/aro 节点。
这里有这些节点的引用的两种形式，在shell中是这样表示的 ::

    # 一个模型 + 外键引用
    ./Console/cake acl view aro Model.1

    # 一个别名路径引用
    ./Console/cake acl view aco root/controllers

使用 ``.`` 表示你要使用一个绑定记录的类型的引用。
使用 ``/`` 表示是别名路径。

安装数据库表
==============================

在使用ACL数据库之前，你需要设置表。你可以运行命令 ::

    ./Console/cake acl initdb

创建和删除节点
=======================

创建和删除节点的命令用法 ::

    ./Console/cake acl create aco controllers Posts
    ./Console/cake acl create aco Posts index

你也可以通过这个指令来为 id = 1  的组创建一个 aro 节点 ::

    ./Console/cake acl create aro Group.1

授权和拒绝访问
=====================

使用grant命令授权ACL权限。一旦执行，指定的 ARO  （包括其子
节点，如果有的话）将被允许访问指定的 ACO 动作（包括其子
节点，如果有的话） ::

    ./Console/cake acl grant Group.1 controllers/Posts 

上面的命令将会授予任何权限。你可以执行如下命令只允许读权限 ::

    ./Console/cake acl grant Group.1 controllers/Posts read

拒绝权限也是一样的方式，只需将  'grant' 替换为 'deny'  。

检查权限
=================

授权ACL权限，一旦执行，指定的ARO将被允许访问指定的ACO动作 ::

    ./Console/cake acl check Group.1 controllers/Posts read

结果会是  ``success``  或者  ``not allowed`` 。

查看节点树
===================

view 命令会返回 ARO 或者 ACO 树。可选的节点参数可以只返回请求
的树的部分节点 ::

    ./Console/cake acl view

.. meta::
    :title lang=zh_CN: ACL Shell
    :keywords lang=zh_CN: record style,style reference,acl,database tables,group id,notations,alias,privilege,node,privileges,shell,databases
