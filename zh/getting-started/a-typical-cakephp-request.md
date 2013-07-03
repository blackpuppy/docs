一个典型的 CakePHP 请求
#########################

我们已经在 CakePHP 中覆盖了基本的要素, 让我们看看各个对象如何共同协作完成一个基本的请求。继续讲我们之前的例子, 想象一下我们的朋友Ricardo刚刚在一个CakePHP应用的首页上点击了“立刻买一个自定义的蛋糕!”这个链接。

.. figure:: /finley/cakephp_zh/blob/master/zh/_static/img/typical-cake-request.png
   :align: center
   :alt: Flow diagram showing a typical CakePHP request
   
   Flow diagram showing a typical CakePHP request

Figure: 2. 典型的Cake请求。

黑色 = 必备的元素, 灰色 = 可选的元素, 蓝色 = 回调


#. Ricardo 点击了指向http://www.example.com/cakes/buy的链接,然后他的浏览器向web服务器发起了一个请求。

#. 路由解析这个URL,并获得下面的参数控制器，动作和以及其他在这次请求中影响到业务逻辑的所有参数。

#. 使用路由，请求 URL映射到一个控制器动作（具体的控制器类的一个方法）。在本例中，是 CakesController 的 buy() 方法。此控制器的 beforeFilter 回调方法将在其全部逻辑动作（action）执行之前被调用。

#. 控制器可能会使用模型获取应用程序的数据本例中, 控制器调用模型从数据库中获取 Ricardo 最后的订单。 所有的可用模型回调、行为和数据源将在此操作中应用。模型不是必须的，但所有的 CakePHP 控制器初始化包含至少一个模型。

#. 当模型获取到数据，就将其返回给控制器，模型的回调方法可能会被实施。

#. 控制器可能会调用组件以进一步完善数据或执行其它操作（例如session会话处理、权限控制或者发送电子邮件）。

#. 一旦控制器使用了模型和组件以有效地准备数据，就可以使用控制器的set()方法把数据传送到视图(view)。在数据送到视图前，控制器的回调方法可能会被实施。视图逻辑会被执行，可能包括了各种元素及(或者)助手方法。默认情况下，视图会在一个布局(layout)里被渲染。

#. 附加的控制器回调函数（例如 afterFilter）可能会被应用。一切都完成之后，渲染完的视图代码被传送到 Ricardo 的浏览器。


.. meta::
    :title lang=en: A Typical CakePHP Request
    :keywords lang=en: optional element,model usage,controller class,custom cake,business logic,request example,request url,flow diagram,basic ingredients,datasources,sending emails,callback,cakes,manipulation,authentication,router,web server,parameters,cakephp,models
