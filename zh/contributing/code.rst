����
####

��������ȡ������ΪCakePHP���״�����õķ�ʽ���������Ը���`lighthouse
<http://cakephp.lighthouseapp.com>`_�ϵ����ⱨ���С���ȡ���������github�д�����
ͨ���ǹ��״�����õķ�ʽ��

��ʼ����
========

�ڿ�ʼΪCakePHP��������֮ǰ������Ȱ���Ļ������úá�����Ҫ���������

* Git
* PHP 5.2.8����߰汾
* PHPUnit 3.5.10����߰汾

��������û���Ϣ�������������/�˺ź͵����ʼ�::

    git config --global user.name 'Bob Barker'
    git config --global user.email 'bob.barker@example.com'

.. note::

    ������Git��ȫİ��������ǿ�ҽ������Ķ���������ѵ�
    `ProGit<http://progit.org>`_�Ȿ�顣

��github���һ��CakePHPԴ����Ŀ�¡(*clone*)��

* �����û��`github <http://github.com>`_���˺ţ�����һ����
* ���**Fork**����������(*fork*)һ��
  `CakePHP repository <http://github.com/cakephp/cakephp>`_��Դ�롣

��ĸ�����ɺ󣬴���ĸ��Ʋֿ�(*repository*)��¡(*clone*)����ı��ػ���::

    git clone git@github.com:����˺�/cakephp.git

��ԭʼ��CakePHP�ֿ����ΪԶ�ֿ̲�(*remote repository*)��
�Ժ����ʹ������ץȡCakePHP�ֿ�ĸĶ���������CakePHP�ֿ�һ��::

    cd cakephp
    git remote add upstream git://github.com/cakephp/cakephp.git

�������Ѿ������CakePHP�Ļ�������Ӧ���ܹ�����һ��``$test``
:ref:`���ݿ����� <database-configuration>`������
:ref:`�������еĲ��� <running-tests>`��

��������
========

ÿ�ε���Ҫ�޸�һ������(*bug*)������һ�����Ի���һ���Ľ�ʱ������һ�������֧
(*topic branch*)��

�㴴���ķ�֧��Ӧ��������޸�/�Ľ������õİ汾�����磬����������޸�``2.3``�汾��
��һ�����棬��ô���Ӧ����``2.3``�ķ�֧Ϊ������������ķ�֧����������ĸĶ��Ƕ�
��ǰ���ȶ��汾��һ��������޸������Ӧ��ʹ��``master``��֧�������Ժ�ϲ��Ķ�ʱ
�ͻ�򵥶���::

    # fixing a bug on 2.3
    git fetch upstream
    git checkout -b ticket-1234 upstream/2.3

.. tip::

    ��Ϊһ�����õ�ϰ�ߣ�Ϊ��ķ�֧��һ�������Ե����ƣ���������������ٱ��������
    ���ơ�����ticket-1234������������

�������������������(CakePHP)2.3��֧��һ�����ط�֧��������ĳ����޸�������
���������Ҫ�������ε��ύ(*commit*)��������Ҫ�μ����¼���:

* ��ѭ:doc:`/contributing/cakephp-coding-conventions`��
* ���һ������������˵�������޸����ˣ������������ܹ�������
* ʹ����ύ�����߼��ԣ��ύ��ϢӦ����������ࡣ


�ύ��ȡ����
============

һ����ĸĶ�����ˣ����ҿ��Ժϲ���CakePHP��ȥ�ˣ����Ӧ��������ķ�֧::

    git checkout 2.3
    git fetch upstream
    git merge upstream/2.3
    git checkout <branch_name>
    git rebase 2.3

�⽫ץȡ+�ϲ��Դ��㿪ʼ֮��CakePHP�е��κθĶ���Ȼ�������ܺ�(*rebase*)
- ����˵���ڵ�ǰ����Ļ���������Ӧ����ĸĶ����ڡ��ܺ�``����������ܻ�������ͻ��
����ܺϹ����˳��������ʹ��``git status``�������鿴��Щ�ļ�������ͻ/û�кϲ���
���ÿ����ͻ��Ȼ������ܺ�::

    git add <filename> # ���ÿһ��������ͻ���ļ���
    git rebase --continue

������еĲ�����Ȼͨ����Ȼ�����ķ�֧����(*push*)����ĸ���
(*fork*)�ֿ���::

    git push origin <branch-name>

һ����ķ�֧��github�ϣ���Ϳ�����
`cakephp-core <http://groups.google.com/group/cakephp-core>`_�ʼ��б��Ͻ�������
����github���ύ��ȡ����

ѡ����ĸĶ��ᱻ�ϲ�������
--------------------------

���ύ��ȡ����ʱ����Ӧ��ȷ����ѡ������ȷ�ķ�֧��Ϊ��������Ϊ��ȡ����һ��������
�޷����ġ�

* �����ĸĶ���һ��**��������**�����������¹��ܣ�ֻ�Ǿ�����ǰ�汾�����е���Ϊ��
  ����ѡ��**master**Ϊ�ϲ�Ŀ�ꡣ
* �����ĸĶ���һ��**������**����Ϊ��������Ĺ��ܣ���ô��Ӧѡ����һ���汾�Ŷ�Ӧ
  �ķ�֧�����磬���Ŀǰ���ȶ��汾��``2.2.2``������������Եķ�֧����``2.3``��
* �����ĸĶ�����(*breaks*)�����еĹ��ܻ�API����ô���Ӧ��ѡ������һ��
  ��Ҫ�汾�����磬�����ǰ�İ汾��``2.2.2``����ô��һ�����еĹ��ܿ��Ա�����(*
  broken*)������``3.0``�汾�ˣ�������Ӧ�������һ��֧��


.. note::

    ���ס�������㹱�׸�CakePHP�Ĵ��뽫������MIT���֮�£�
    `Cake Software Foundation <http://cakefoundation.org/pages/about>`_�����Ϊ
    �κι��׵Ĵ���������ߣ��������й��׵Ĵ��뽫��`���������Э��
    <http://cakefoundation.org/pages/cla>`_��Լ����

���кϲ���ά����֧�еĳ����޸���Ҳ���������ŶӶ��ڵغϲ���������������һ���汾��


.. meta::
    :title lang=en: Code
    :keywords lang=en: cakephp source code,code patches,test ref,descriptive name,bob barker,initial setup,global user,database connection,clone,lighthouse,repository,user information,enhancement,back patches,checkout
