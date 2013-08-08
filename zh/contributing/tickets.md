问题跟踪系统
############

在CakePHP的开发过程中，以问题跟踪系统的形式从社区获得反馈和帮助是极为重要的一部分。
所有CakePHP的问题跟踪都托管在`lighthouse <http://cakephp.lighthouseapp.com>`_上。

报告瑕疵
========

写得好的瑕疵报告都非常有用。下面的步骤可以帮助创建尽可能好的瑕疵报告：

* **请**`搜索 <http://cakephp.lighthouseapp.com/projects/42648-cakephp/tickets?q=ITS+BROKEN>`_
  类似的已有问题，并保证别人没有报告你的问题，或者在源代码仓库中还没有得到修复。
* **请**包括**如何重现瑕疵**的详细说明。这可以是测试用例或代码片段，来展示所
  报告的问题。如果没有办法重现问题，则意味着它不太容易被修复。
* **请**尽可能详尽地提供关于你的(运行)环境的细节(操作系统，PHP的版本，CakePHP的版本)。
* **请不要**使用问题跟踪系统来询问技术支持的问题。寻求技术支持，请使用
  `谷歌讨论组 <http://groups.google.com/group/cake-php>`_或#cakephp的IRC渠道。


报告安全问题
============

如果你发现了CakePHP的安全问题，请使用以下过程，而不要使用平常的错误报告系统,
比如问题跟踪系统、邮件列表或IRC。请发送电子邮件至**security [at] cakephp.org**。
发送到这个地址的电子邮件会进入一个CakePHP核心团队所在的内部邮件列表中。

对于每一份报告，我们首先尝试确认该漏洞。一经确认，CakePHP团队将采取以下措施：

* 向报告者确认我们已经收到了该问题报告，并正着手修复。
  我们请求报告者对该问题保密，直到我们对外宣布。
* 准备一个更正/补丁。
* 准备一份帖子，描述该漏洞以及可能的利用方式。
* 针对所有受影响的版本发布新版本。
* 在版本发布公告中明确地说明该问题。





.. meta::
    :title lang=en: Tickets
    :keywords lang=en: bug reporting system,code snippet,reporting security,private mailing,release announcement,google,ticket system,core team,security issue,bug tracker,irc channel,test cases,support questions,bug report,security issues,bug reports,exploits,lighthouse,vulnerability,repository
