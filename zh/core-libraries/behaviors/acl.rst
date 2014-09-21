访问控制列表(*ACL*)助件
#########################

.. php:class:: AclBehavior()

Acl 行为提供了一种方式，将一个模型与你的访问控制列表(*ACL*)系统无缝地集成在一起。
它可以透明地创建 ARO 或者 ACO 对象。

要使用新的行为，你可以把它加到模型的 $actsAs 属性中。在添加到 actsAs 数组时，你
可以选择把相关的 Acl 项作为 ARO 或 ACO。缺省的是 ACO::

    class User extends AppModel {
        public $actsAs = array('Acl' => array('type' => 'requester'));
    }

这会把 Acl 行为以 ARO 模式附加(到模型上)。要把 ACL 行为以 ACO 模式加入，使用::

    class Post extends AppModel {
        public $actsAs = array('Acl' => array('type' => 'controlled'));
    }

对 User 和 Group 模型，通常需要 ACO 和 ARO 两种节点，为此请使用::

    class User extends AppModel {
        public $actsAs = array('Acl' => array('type' => 'both'));
    }

你也可以象这样随时附加行为::

    $this->Post->Behaviors->load('Acl', array('type' => 'controlled'));

.. versionchanged:: 2.1

    你现在可以放心地把 AclBehavior 行为附加到 AppModel 上了。 Aco、Aro 和 
    AclNode 现在继承于 Model，而不是(之前的) AppModel，而那会导致死循环。如果你
    的应用程序出于某些原因需要这些模型继承 AppModel，那就把 AclNode 拷贝到你的
    应用程序，再重新让它继承 AppModel。


使用 AclBehavior 行为
=====================

AclBehavior 行为的大部分透明地起作用于模型的 afterSave()回调。不过，这要求你的
模型定义一个 parentNode() 方法，才可以使用它。这被 AclBehavior 行为用来判断父
子(parent->child)关系。模型的 parentNode() 方法必须返回 null 或者返回一个父模
型引用::

    public function parentNode() {
        return null;
    }

如果你要设置一个 ACO 或 ARO 节点为模型的父节点，parentNode()方法必须返回 ACO 
或 ARO 节点的别名::

    public function parentNode() {
        return 'root_node';
    }

下面是一个更完整使用 User 模型的例子，这里 User 模型 belongsTo Group 模型::

    public function parentNode() {
        if (!$this->id && empty($this->data)) {
            return null;
        }
        $data = $this->data;
        if (empty($this->data)) {
            $data = $this->read();
        }
        if (!$data['User']['group_id']) {
            return null;
        } else {
            return array('Group' => array('id' => $data['User']['group_id']));
        }
    }

在上面的例子中，返回值是一个类似模型查找结果的数组。重要的是设置 id 的值，否则 
parentNode 关系就会失败。 AclBehavior 行为使用该数据来构建其树形结构。

node()
======

AclBehavior 行为也让你获取与一条模型记录相关联的 Acl 节点。在设置了 $model->id 
之后，你可以 $model->node() 来获取相关联的 Acl 节点。

你也可以获取任何数据记录的 Acl 节点，只要传入一个数据数组::

    $this->User->id = 1;
    $node = $this->User->node();

    $user = array('User' => array(
        'id' => 1
    ));
    $node = $this->User->node($user);

都会返回相同的 Acl 节点信息。

如果你设置 AclBehavior 行为来创建 ACO 和 ARO 节点，你需要指明你需要的节点类型::

    $this->User->id = 1;
    $node = $this->User->node(null, 'Aro');

    $user = array('User' => array(
        'id' => 1
    ));
    $node = $this->User->node($user, 'Aro');

.. meta::
    :title lang=zh_CN: ACL
    :keywords lang=zh_CN: group node,array type,root node,acl system,acl entry,parent child relationships,model reference,php class,aros,group id,aco,aro,user group,alias,fly