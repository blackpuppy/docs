定期运行Shells
##########################

一个常见的事情是使用shell运行cronjob，每隔一段时间清理一次数据库或发送简讯。然而，当你已经在 ``~/.profile`` 中将终端的路径添加到PATH变量时，它将会不能够做为定期作业运行。

下面的Bash脚本将调用shell命令并将必要的路径添加到 $PATH 。复制和保存到你的终端目录，命名为 'cakeshell' ，别忘记加上可执行权限(``chmod +x cakeshell``) ::

    #!/bin/bash
    TERM=dumb
    export TERM
    cmd="cake"
    while [ $# -ne 0 ]; do
        if [ "$1" = "-cli" ] || [ "$1" = "-console" ]; then
            PATH=$PATH:$2
            shift
        else
            cmd="${cmd} $1"
        fi
        shift
    done
    $cmd

你可以这样调用 ::

    $ ./Console/cakeshell myshell myparam -cli /usr/bin -console /cakes/2.x.x/lib/Cake/Console

``-cli`` 参数需要一个指向php的可执行cli的路径， ``-console`` 参数指向CakePHP的终端路径。

一个定期作业的书写格式 ::

    # m h dom mon dow command
    */5 *   *   *   * /full/path/to/cakeshell myshell myparam -cli /usr/bin -console /cakes/2.x.x/lib/Cake/Console -app /full/path/to/app

一个调试crontab的小技巧是将它设置为将它的输出重定向到日志文件，你可以这样做 ::

    # m h dom mon dow command
    */5 *   *   *   * /full/path/to/cakeshell myshell myparam -cli /usr/bin -console /cakes/2.x.x/lib/Cake/Console -app /full/path/to/app >> /path/to/log/file.log 2>&1


.. meta::
    :title lang=zh: Running Shells as cronjobs
    :keywords lang=zh: cronjob,bash script,path path,crontab,logfile,cakes,shells,dow,shell,cakephp,fi,running
