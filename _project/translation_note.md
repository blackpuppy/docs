翻译注释
########

`cakephp_zh\zh\contributing <http://git.oschina.net/finley/cakephp_zh/tree/master/zh/contributing>`_
目录下的文件，至今翻译了2页，一些需斟酌之处列在下面。我的中文表达能力不是很强，有些词汇就是一时想不起来，或者一下子找不到最恰当的表达方式。

`cakephp_zh\zh\contributing\documentation <http://git.oschina.net/finley/cakephp_zh/blob/master/zh/contributing/documentation.md>`_
===================================================================================================================================

    #. free (as in "Feel free to fork the repo.")
       随意？自由？“随意”似乎更接近一些。
    #. fork
       分支显然不行，因为branch就是分支，而fork和branch显然是不同的，不能混淆。
       查了Git的中文手册5.1 分布式 Git - 分布式工作流程，见图5-2下面的文字第一行，“复制（fork 亦即克隆）”。
       故译成“复制”。
    #. role
       多处出现，比如“Other pages in the documentation can be linked to using the :doc: role“和"The following roles refer to php objects and ..."。
    #. role在词霸中翻译为“作用； 地位； 角色”。“角色”觉得很别扭，“作用”的意思还可以接受，但放在文中却不如“角色”通顺。还有一种办法，就是干脆省略。
       暂时译为“角色”。
    #. property/attribute
       这两个应该是指不同的东西，但是在中文里怎么区别？
       暂时都译为“属性”。
    #. Admonition
       暂译“告诫”，似乎略微严厉了一些，但尚未找到更合适的词。


`cakephp_zh\zh\contributing\tickets <http://git.oschina.net/finley/cakephp_zh/blob/master/zh/contributing/tickets.md>`_
=======================================================================================================================

    #. ticket
       究竟翻译成什么好？票据很不合适，票号又显得太随意，问题又离字面意思相差较远，错误跟踪系统？在找到更合适的词汇之前，先采用如下的译法：
       * 当用它来指一项交互活动的方式或者一种获取帮助的方式时，翻译成“问题跟踪系统”。
       * 当用它来指上述活动中采用的文档媒介时，翻译成“问题”、“问题跟踪”或者“问题报告”。
    #. bug
       bug是软件行业中对代码中发现的问题的通常叫法，可以翻译成臭虫。在软件工程中对此的正式名称是defect，对应的中文是瑕疵。在手册中，臭虫也是可以的，只是显得不够正式，故此采用瑕疵。


`cakephp_zh\zh\contributing\code <http://git.oschina.net/finley/cakephp_zh/blob/master/zh/contributing/code.md>`_
=======================================================================================================================

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


`cakephp_zh\zh\contributing\cakephp-coding-conventions <http://git.oschina.net/finley/cakephp_zh/blob/master/zh/contributing/cakephp-coding-conventions.md>`_
=======================================================================================================================

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


`cakephp_zh\zh\controllers <http://git.oschina.net/finley/cakephp_zh/blob/master/zh/controllers.md>`_
=====================================================================================================

    #. thin/fat
       出现在“keep your controllers thin, and your models fat”中。
       thin译成“瘦”、“薄”，fat译成“胖”?

`cakephp_zh\zh\models\data-validation <http://git.oschina.net/finley/cakephp_zh/blob/master/zh/models/data-validation.md>`_
================================================================================================================

    #. insensitive
       大小写无关? 大小写不敏感?
    #. associated array
       关联数组? 映射数组?
    #. heavy lifting
       `词霸 <http://www.iciba.com/heavy+lifting/>`_的解释“举足轻重”完全不对，
       而“difficult work”比较正确。
