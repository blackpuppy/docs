从控制器验证数据
###################################

虽然通常你会只使用模型的 save 方法，但也许有时你会想要验证数据而不保存。例如，你也许在真地把数据保存到数据库之前，想要给用户显示一些额外的信息。验证数据要求的过程，与仅仅保存数据相比，有少许的差别。

首先，将数据赋值给模型::

    $this->ModelName->set($this->request->data);

然后，要检查数据是否正确，使用模型的 validates 方法，如果正确它就会返回 true，否则就返回 false::

    if ($this->ModelName->validates()) {
        // 验证通过时的逻辑
    } else {
        // 验证未通过时的逻辑
        $errors = $this->ModelName->validationErrors;
    }

也许你更愿意用模型中定义的验证规则的子集来验证模型。比方说你有一个 User 模型，含有 first\_name，last\_name，email and
password 字段。在这个例子中，当创建或者编辑一个用户时你会要使用所有4个字段的规则来验证。然而当用户登录时你会只用电子邮件和密码的规则来验证。要做到这点，你可以传入一个选项数组指定要验证的字段::

    if ($this->User->validates(array('fieldList' => array('email', 'password')))) {
        // 正确
    } else {
        // 不正确
    }

validates 方法调用 invalidFields 方法，后者填入模型的 validationErrors 属性。 invalidFields 方法也把这个属性作为结果返回::

    $errors = $this->ModelName->invalidFields(); // 包含 validationErrors 数组

在对 ``invalidFields()`` 的连续调用之间，验证错误列表不会清除。所以，如果你在一个循环内验证，并且要分开每组错误，就别用 ``invalidFields()``。而是使用 ``validates()`` 方法，再读取 ``validationErrors`` 模型属性。

重要的是要记住，在验证数据前，数据必须赋值给模型。这不同于 save 方法，可以允许数据作为参数传入。另外，记住调用 save 方法之前并没有必要调用 validates 方法，因为 save 方法在真地保存数据之前会自动验证数据。

要验证多个模型，应当使用下面的方法::

    if ($this->ModelName->saveAll($this->request->data, array('validate' => 'only'))) {
      // 验证通过
    } else {
      // 验证未通过
    }

如果你在保存之前验证了数据，那么你可以关闭验证以避免第二次验证::

    if ($this->ModelName->saveAll($this->request->data, array('validate' => false))) {
        // 不验证就保存
    } 


.. meta::
    :title lang=zh_CN: Validating Data from the Controller
    :keywords lang=zh_CN: password rules,validations,subset,array,logs,logic,email,first name last name,models,options,data model