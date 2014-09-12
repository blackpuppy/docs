翻译注释
########

`14. CakePHP_zh\zh\contributing <http://git.oschina.net/finley/CakePHP_zh/tree/master/zh/contributing>`_
目录下的文件，至今翻译了2页，一些需斟酌之处列在下面。我的中文表达能力不是很强，有些词汇就是一时想不起来，或者一下子找不到最恰当的表达方式。

`CakePHP_zh\zh\contributing\documentation <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/contributing/documentation.rst>`_
===================================================================================================================================

    #. free (as in "Feel free to fork the repo.")
       随意？自由？“随意”似乎更接近一些。希望找到更好的翻译。采用“自行”似乎更好。
    #. fork
       分支显然不行，因为branch就是分支，而fork和branch显然是不同的，不能混淆。
       查了Git的中文手册5.1 分布式 Git - 分布式工作流程，见图5-2下面的文字第一行，“复制（fork 亦即克隆）”。
       故译成“复制”。
    #. role
       多处出现，比如“Other pages in the documentation can be linked to using the :doc: role“和"The following roles refer to php objects and ..."。
    #. role在词霸中翻译为“作用； 地位； 角色”。“角色”觉得很别扭，“作用”的意思还可以接受，但放在文中却不如“角色”通顺。还有一种办法，就是干脆省略。
       很明显是个术语，不能省略。暂时译为“角色”。
    #. property/attribute
       这两个应该是指不同的东西，但是在中文里怎么区别？
       暂时都译为“属性”。
    #. Admonition
       暂译“告诫”，似乎略微严厉了一些，但尚未找到更合适的词。“警告”则与现有词汇(warning 警告、警示、注意)重复了。


`CakePHP_zh\zh\contributing\tickets <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/contributing/tickets.rst>`_
=======================================================================================================================

    #. ticket
       究竟翻译成什么好？票据很不合适，票号又显得太随意，问题又离字面意思相差较远，错误跟踪系统？在找到更合适的词汇之前，先采用如下的译法：
       * 当用它来指一项交互活动的方式或者一种获取帮助的方式时，翻译成“问题跟踪系统”。
       * 当用它来指上述活动中采用的文档媒介时，翻译成“问题”、“问题跟踪”或者“问题报告”。
    #. bug
       bug是软件行业中对代码中发现的问题的通常叫法，可以翻译成臭虫。在软件工程中对此的正式名称是defect，对应的中文是瑕疵。在手册中，臭虫也是可以的，只是显得不够正式，故此采用瑕疵。


`CakePHP_zh\zh\contributing\code <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/contributing/code.rst>`_
=================================================================================================================

    #. feature
       我认为是“特性”，这有可能比功能要小一些。但`谷歌翻译 <http://translate.google.com/#en/zh-CN/>`_
       给出的却是“功能”，甚至都没有选择其他词的余地。
    #. rebase
       译为“衍合”，参看Git手册`分支的衍合 <http://git-scm.com/book/zh/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%9A%84%E8%A1%8D%E5%90%88>`_一节。
       TortoiseGit的中文翻译是“变基”，这个词是照字面意思来翻译的，但显得怪异了一些。
    #. breaking (change/functionality)
       感觉很不容易找到恰当的翻译。
       “重大”改动？那么用major就可以了，不能显示出破坏了现有的功能或API。
       “破坏性的”改动？这又过分了些，还以为连正常的功能都给破坏了呢。
       “突破性的”？这又显得太好了。
       “突破”则太不准确了。
       这应该不是破坏性的，功能还是可以工作的，而且通常可能会更好，但是又打破了现有的一些东西。
       实际上是改变，而不是破坏。
       暂译“打破”。


`CakePHP_zh\zh\contributing\cakephp-coding-conventions <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/contributing/cakephp-coding-conventions.rst>`_
=============================================================================================================================================================

    #. Including files
       “引用”?
       `谷歌翻译 <http://translate.google.com/#en/zh-CN/>`_给的是“包括”。
       为了避免和“quote引用”混淆，还是采用“包括”为宜。
    #. camelBack和CamelCase
       不需翻译？
    #. private，protected和public
       毫无疑问，private为“私有”。
       但，protected翻译成什么？“受保护的”？
       public为“公有”、“公共”？
    #. Method Chaining
       “链式方法调用”？
       `谷歌翻译 <http://translate.google.com/#en/zh-CN/>`_给的是“方法链”、“方法链接”。
       采用“方法链接”。


`CakePHP_zh\zh\controllers <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/controllers.rst>`_
=====================================================================================================

    #. thin/fat
       出现在“keep your controllers thin, and your models fat”中。
       thin译成“瘦”、“薄”，fat译成“胖”?

`CakePHP_zh\zh\models\data-validation <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/models/data-validation.rst>`_
===========================================================================================================================

    #. insensitive
       大小写无关? 大小写不敏感?
    #. associated array
       关联数组? 映射数组?
    #. oft-used
       = often-used? 常用的？Yes!
    #. heavy lifting
       `词霸 <http://www.iciba.com/heavy+lifting/>`_的解释“举足轻重”，这完全不对，
       而“difficult work”比较正确。
       帮你完成繁重的工作，不用你自己做了。
       文中译为“(承担)麻烦的部分”。

`7. CakePHP_zh\zh\models <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/models.rst>`_
===========================================================================================

    #. (data's) validity
       (数据的)合法性? 正确性? 采用"合法性"
    #. domain of work
       工作领域?
    #. (model) association
       (模型的)关联? 联系? 采用"关联"

`7.6 CakePHP_zh\zh\models\callback-methods <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/models/callback-methods.rst>`_
============================================================================================================================

    #. sneak in
       触及? 切入？插入。

`7.7 CakePHP_zh\zh\models\behaviors <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/models/behaviors.rst>`_
===============================================================================================================

    #. (method) singnature
       (方法)签名？原型？“签名”较好。
    #. munge (the method name)
       massage? 修饰？
    #. splice (in additional behavior)
       增加(额外的行为)？

`5. CakePHP_zh\zh\controllers <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/controllers.rst>`_
=====================================================================================================

    #. boiler-plate (code)
       重复性(代码)？仍太宽泛，不够准确。
    #. inflected
       ？
    #. inflect
       `词霸 <http://www.iciba.com/inflect>`_ 的解释是“使（词）屈折变化”。这些对英文单词或词组的变化包括：(首)字母的大小写变化、词组的词汇之间添加下划线、名词单复数的转化。
    #. render
       渲染？显示？采用“渲染”。
    #. request/response body
       请求/响应体？ 请求/响应主体？请求/响应文件体？采用最后一种翻译。
    #. session
       会话。
    #. 301 (page) moved permanently
       301 页面永久性移动
    #. 303 see other
       303 参见其他页面
    #. scaffolded actions
       脚手架动作？
    #. referring URL (for the current request)
       跳转网址？引用网址？
    #. undesirable
       不好？但太客观，没有表达出不愿意采用的主观倾向性。
    #. named parameter
       命名参数？
    #. passed parameter
       传入参数？传递参数？暂时采用“传入参数”。
    #. request header
       请求头部？请求头？文中译为“请求文件头”。
    #. but saves
       假如不？需查字典确定。
    #. helper
       帮助？帮助组件？文中译为“助件”。
       
`5.1 CakePHP_zh\zh\controllers\request-response <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/controllers/request-response.rst>`_
=====================================================================================================

    #. introspection
       内省？自我反省？审视？查询？文中译为“查询”。
    #. in an error free manner
       以无错的方式？有没有更好的中文表达方式？
    #. query string
       查询参数
    #. BC accessor
       BC 访问？这是指什么？
    #. sugar daddy
       谷歌翻译给出“傍大款”，很可笑。文中译为“语法糖”，也不知是否准确？。
    #. mocked/stubbed
       模拟/嵌入？这两个词汇所指的东西，都可以用在测试中，但却是有明显区别的。
    #. stub out
       覆盖？嵌入？替换？
    #. response entity tag
       响应体标签

`6. CakePHP_zh\zh\views <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/views.rst>`_
=====================================================================================================

    #. (view) block
       代码块？块？代码段？文中译为“代码块”。
       讨论见 `tower.im 上的[术语] view block 
       <https://tower.im/projects/a96a1492d1cd4ef6a35c7a01dad4a683/messages/d960c2dcb7484642ab2574e54fe11d31/`_
    #. callout
       真不知道翻译成什么？
       讨论见 `tower.im 上的[术语] callout 
       <https://tower.im/projects/a96a1492d1cd4ef6a35c7a01dad4a683/messages/4a0bdeb566e64a55aa90fb64107e3f39/`_

`8.2.1 CakePHP_zh\zh\core-libraries\behaviors\acl <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/core-libraries/behaviors/acl.rst>`_
=====================================================================================================

    #. on the fly
       随时？在需要时？实时？文中译为“及时”。
9/`_

`8.4.3 CakePHP_zh\zh\core-libraries\helpers\html <http://git.oschina.net/finley/CakePHP_zh/blob/master/zh/core-libraries/helpers/html.rst>`_
=====================================================================================================

    #. well formed (html markup)
       完好格式的(HTMML标记)。
    #. HTML Entities
       HTML 字符实体。参考:
       * http://www.w3schools.com/html/html_entities.asp
       * http://www.w3school.com.cn/html/html_entities.asp
    #. (RSS/Atom) feed
       (RSS/Atom)推送
    #. robots noindex
       参考:
       * http://en.wikipedia.org/wiki/Noindex
       * http://baike.baidu.com/link?url=wZMV3V5BOO9BrKxVaSp2jEUO2ICTI-cFhFOkcOkQ5FzxcTa0_1s9yQFib06vigYuC1RHYETpkwLHPnVS4qqd5_
