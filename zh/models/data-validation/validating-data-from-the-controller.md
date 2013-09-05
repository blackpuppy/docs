从控制器验证数据
Validating Data from the Controller
###################################

虽然通常你会只用模型的 save 方法, 但有时你会想要验证数据而不保存。例如, 你也许在真地保存数据到数据库之前, 想要给用户显示一些额外的信息。验证数据要求的过程与仅仅保存数据略有差别。
While normally you would just use the save method of the model,
there may be times where you wish to validate the data without
saving it. For example, you may wish to display some additional
information to the user before actually saving the data to the
database. Validating data requires a slightly different process
than just saving the data.

首先, 将数据赋值给模型::
First, set the data to the model::

    $this->ModelName->set($this->request->data);

然后，要检查数据是否正确，使用模型的 validates 方法，如果正确它就会返回 true，否则就返回 false::
Then, to check if the data validates, use the validates method of
the model, which will return true if it validates and false if it
doesn't::

    if ($this->ModelName->validates()) {
        // it validated logic
    } else {
        // didn't validate logic
        $errors = $this->ModelName->validationErrors;
    }

也许你更愿意用模型中定义的验证规则的子集来验证模型。比方说你有一个 User 模型，有 first\_name，last\_name，email and
password 字段。在这个例子中，当创建或者编辑一个用户时你会要使用所有4个字段的规则来验证。然而当用户登录时你会只用电子邮件和密码的规则来验证。要做到这点，你可以传入一个选项数组指定要验证的字段::
It may be desirable to validate your model only using a subset of
the validations specified in your model. For example say you had a
User model with fields for first\_name, last\_name, email and
password. In this instance when creating or editing a user you
would want to validate all 4 field rules. Yet when a user logs in
you would validate just email and password rules. To do this you
can pass an options array specifying the fields to validate::

    if ($this->User->validates(array('fieldList' => array('email', 'password')))) {
        // valid
    } else {
        // invalid
    }

validates 方法调用 invalidFields 方法，后者填入模型的 validationErrors 属性。 invalidFields 方法也把这个属性作为结果返回::
The validates method invokes the invalidFields method which
populates the validationErrors property of the model. The
invalidFields method also returns that data as the result::

    $errors = $this->ModelName->invalidFields(); // 包含 validationErrors 数组 contains validationErrors array

在连续对 ``invalidFields()`` 的调用之间，验证错误列表不会清除。所以，如果你在一个循环内验证，并且要分开每组错误，就别用 ``invalidFields()``。而是使用 ``validates()`` 方法，再读取 ``validationErrors`` 模型属性。
The validation errors list is not cleared between successive calls to ``invalidFields()``
So if you are validating in a loop and want each set of errors separately
don't use ``invalidFields()``. Instead use ``validates()``
and access the ``validationErrors`` model property.

重要的是要记住，在验证数据前，数据必须赋值给模型。这不同于 save 方法，可以允许数据作为参数传入。另外，记住调用 save 方法之前并没有必要一定要调用 validates 方法，因为 save 方法在真地保存数据之前会自动验证数据。
It is important to note that the data must be set to the model
before the data can be validated. This is different from the save
method which allows the data to be passed in as a parameter. Also,
keep in mind that it is not required to call validates prior to
calling save as save will automatically validate the data before
actually saving.

要验证多个模型，应当使用下面的方法::
To validate multiple models, the lfollowing approach should be
used::

    if ($this->ModelName->saveAll($this->request->data, array('validate' => 'only'))) {
      // validates
    } else {
      // does not validate
    }

如果你在保存之前验证了数据，那么你可以关闭验证以避免第二次验证::
If you have validated data before save, you can turn off validation
to avoid second check::

    if ($this->ModelName->saveAll($this->request->data, array('validate' => false))) {
        // saving without validation
    } 


.. meta::
    :title lang=en: Validating Data from the Controller
    :keywords lang=en: password rules,validations,subset,array,logs,logic,email,first name last name,models,options,data model