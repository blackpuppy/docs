目录和文件 Folder & File
########################

目录及文件工具是帮助你读、写、追加文件、列出目录中的文件及其他目录相关任务的一个方便的类库。
The Folder and File utilities are convenience classes to help you read, write,
and append to files; list files within a folder and other common directory
related tasks.

基本用法 Basic usage
=====================

先确保使用 :php:meth:`App::uses()` 将类库加载进来。 ::
Ensure the classes are loaded using :php:meth:`App::uses()`::

    <?php
    App::uses('Folder', 'Utility');
    App::uses('File', 'Utility');

然后创建一新的文件夹。::
Then we can setup a new folder instance::

    <?php
    $dir = new Folder('/path/to/folder');

使用正则搜索匹配该目录下所有*.ctp*文件。 ::
and search for all *.ctp* files within that folder using regex::

    <?php
    $files = $dir->find('.*\.ctp');

使用循环来读、写、追加内容或简答的删除文件。::
Now we can loop through the files and read, write or append to the contents or
simply delete the file::

    <?php
    foreach ($files as $file) {
        $file = new File($dir->pwd() . DS . $file);
        $contents = $file->read();
        // $file->write('I am overwriting the contents of this file');
        // $file->append('I am adding to the bottom of this file.');
        // $file->delete(); // I am deleting this file
        $file->close(); // Be sure to close the file when you're done
    }

目录API Folder API
==================

.. php:class:: Folder(string $path = false, boolean $create = false, mixed $mode = false)

::

    <?php
    // 创建一个权限为0755的目录
    // Create a new folder with 0755 permissions
    $dir = new Folder('/path/to/folder', true, 0755);

.. php:attr:: path

    当前目录的路径与 :php:meth:`Folder::pwd()` 反正同样的内容。
    Current path to the folder. :php:meth:`Folder::pwd()` will return the same
    information.

.. php:attr:: sort

    是否按文件名排序
    Whether or not the list results should be sorted by name.

.. php:attr:: mode

    创建目录时是否，默认 ``0755``。在windows操作系统机器下无效。
    Mode to be used when creating folders. Defaults to ``0755``. Does nothing on
    windows machines.

.. php:staticmethod:: addPathElement( $path, $element )

    :rtype: string

    返回带$element的$path，目录之间使用正确的反斜杠。::
    Returns $path with $element added, with correct slash in-between::

        <?php
        $path = Folder::addPathElement('/a/path/for', 'testing');
        // $path 等价 /a/path/for/testing


.. php:method:: cd( $path )

    :rtype: string

    切换目录到$path指定的路径。失败返回false。::
    Change directory to $path. Returns false on failure::

        <?php
        $folder = new Folder('/foo');
        echo $folder->path; // Prints /foo
        $folder->cd('/bar');
        echo $folder->path; // Prints /bar
        $false = $folder->cd('/non-existent-folder');


.. php:method:: chmod( $path, $mode = false, $recursive = true, $exceptions = array ( ) )

    :rtype: boolean

    递归改变目录的权限，同时作用于目录下的文件。::
    Change the mode on a directory structure recursively. This includes
    changing the mode on files as well::

        <?php
        $dir = new Folder();
        $dir->chmod('/path/to/folder', 0755, true, array('skip_me.php'));


.. php:method:: copy( $options = array ( ) )

    :rtype: boolean

    递归的拷贝一个目录。$options参数可以是目的路径或包含选项数组。::
    Recursively copy a directory. The only parameter $options can either
    be a path into copy to or an array of options::

        <?php
        $folder1 = new Folder('/path/to/folder1');
        $folder1->copy('/path/to/folder2');
        // 将folder1及他下面的所有内容拷贝到folder2
        // Will put folder1 and all its contents into folder2

        $folder = new Folder('/path/to/folder');
        $folder->copy(array(
            'to' => '/path/to/new/folder',
            'from' => '/path/to/copy/from', // will cause a cd() to occur // 会发生cd()切换目录
            'mode' => 0755,
            'skip' => array('skip-me.php', '.git'),
            'scheme' => Folder::SKIP  // Skip directories/files that already exist.
            // 跳过已经存在的directories/files
        ));

    There are 3 supported schemes:

    * ``Folder::SKIP`` skip copying/moving files & directories that exist in the
      destination directory.
    * ``Folder::MERGE`` merge the source/destination directories. Files in the
      source directory will replace files in the target directory.  Directory
      contents will be merged.
    * ``Folder::OVERWRITE`` overwrite existing files & directories in the target
      directory with those in the source directory.  If both the target and
      destination contain the same subdirectory, the target directory's contents
      will be removed and replaced with the source's.

    .. versionchanged:: 2.3
        The merge, skip and overwrite schemes were added to ``copy()``

.. php:staticmethod:: correctSlashFor( $path )

    :rtype: string

    Returns a correct set of slashes for given $path. (\\ for
    Windows paths and / for other paths.)


.. php:method:: create( $pathname, $mode = false )

    :rtype: boolean

    递归创建目录结构，可以创建类似 `/foo/bar/baz/shoe/horn` 多级目录。::
    Create a directory structure recursively. Can be used to create
    deep path structures like `/foo/bar/baz/shoe/horn`::

        <?php
        $folder = new Folder();
        if ($folder->create('foo' . DS . 'bar' . DS . 'baz' . DS . 'shoe' . DS . 'horn')) {
            // Successfully created the nested folders
        }

.. php:method:: delete( $path = NULL )

    :rtype: boolean

    递归删除系统允许的目录。::
    Recursively remove directories if the system allows::

        <?php
        $folder = new Folder('foo');
        if ($folder->delete()) {
            // Successfully deleted foo its nested folders
        }

.. php:method:: dirsize( )

    :rtype: integer

    以字节为单位返回整个目录内容的大小。
    Returns the size in bytes of this Folder and its contents.


.. php:method:: errors( )

    :rtype: array

    获得最后一个方法的错误信息。
    Get error from latest method.


.. php:method:: find( $regexpPattern = '.*', $sort = false )

    :rtype: array

    返回当前目录中所有匹配的文件的数组。::
    Returns an array of all matching files in current directory::

        <?php
        // 在 app/webroot/img/ 文件夹中查询所有的.png文件并排序。
        // Find all .png in your app/webroot/img/ folder and sort the results
        $dir = new Folder(WWW_ROOT . 'img');
        $files = $dir->find('.*\.png', true);
        /*
        Array
        (
            [0] => cake.icon.png
            [1] => test-error-icon.png
            [2] => test-fail-icon.png
            [3] => test-pass-icon.png
            [4] => test-skip-icon.png
        )
        */

.. note::

    The folder find and findRecursive methods will only find files. If you
    would like to get folders and files see :php:meth:`Folder::read()` or
    :php:meth:`Folder::tree()`


.. php:method:: findRecursive( $pattern = '.*', $sort = false )

    :rtype: array

    Returns an array of all matching files in and below current directory::

        <?php
        // Recursively find files beginning with test or index
        $dir = new Folder(WWW_ROOT);
        $files = $dir->findRecursive('(test|index).*');
        /*
        Array
        (
            [0] => /var/www/cake/app/webroot/index.php
            [1] => /var/www/cake/app/webroot/test.php
            [2] => /var/www/cake/app/webroot/img/test-skip-icon.png
            [3] => /var/www/cake/app/webroot/img/test-fail-icon.png
            [4] => /var/www/cake/app/webroot/img/test-error-icon.png
            [5] => /var/www/cake/app/webroot/img/test-pass-icon.png
        )
        */


.. php:method:: inCakePath( $path = '' )

    :rtype: boolean

    Returns true if the File is in a given CakePath.


.. php:method:: inPath( $path = '', $reverse = false )

    :rtype: boolean

    Returns true if the File is in given path::

        <?php
        $Folder = new Folder(WWW_ROOT);
        $result = $Folder->inPath(APP);
        // $result = true, /var/www/example/app/ is in /var/www/example/app/webroot/

        $result = $Folder->inPath(WWW_ROOT . 'img' . DS, true);
        // $result = true, /var/www/example/app/webroot/ is in /var/www/example/app/webroot/img/


.. php:staticmethod:: isAbsolute( $path )

    :rtype: boolean

    Returns true if given $path is an absolute path.


.. php:staticmethod:: isSlashTerm( $path )

    :rtype: boolean

    Returns true if given $path ends in a slash (i.e. is slash-terminated)::

        <?php
        $result = Folder::isSlashTerm('/my/test/path');
        // $result = false
        $result = Folder::isSlashTerm('/my/test/path/');
        // $result = true


.. php:staticmethod:: isWindowsPath( $path )

    :rtype: boolean

    Returns true if given $path is a Windows path.


.. php:method:: messages( )

    :rtype: array

    Get messages from latest method.


.. php:method:: move( $options )

    :rtype: boolean

    Recursive directory move.


.. php:staticmethod:: normalizePath( $path )

    :rtype: string

    Returns a correct set of slashes for given $path. (\\ for
    Windows paths and / for other paths.)


.. php:method:: pwd( )

    :rtype: string

    Return current path.


.. php:method:: read( $sort = true, $exceptions = false, $fullPath = false )

    :rtype: mixed

    :param boolean $sort: If true will sort results.
    :param mixed $exceptions: An array of files and folder names to ignore. If
        true or '.' this method will ignore hidden or dot files.
    :param boolean $fullPath: If true will return results using absolute paths.

    Returns an array of the contents of the current directory. The
    returned array holds two arrays: One of directories and one of files::

        <?php
        $dir = new Folder(WWW_ROOT);
        $files = $dir->read(true, array('files', 'index.php'));
        /*
        Array
        (
            [0] => Array
                (
                    [0] => css
                    [1] => img
                    [2] => js
                )
            [1] => Array
                (
                    [0] => .htaccess
                    [1] => favicon.ico
                    [2] => test.php
                )
        )
        */


.. php:method:: realpath( $path )

    :rtype: string

    Get the real path (taking ".." and such into account).


.. php:staticmethod:: slashTerm( $path )

    :rtype: string

    Returns $path with added terminating slash (corrected for
    Windows or other OS).


.. php:method:: tree( $path = NULL, $exceptions = true, $type = NULL )

    :rtype: mixed

    Returns an array of nested directories and files in each directory.


文件API File API
================

.. php:class:: File(string $path, boolean $create = false, integer $mode = 493)

::

    <?php
    // Create a new file with 0644 permissions
    $file = new File('/path/to/file.php', true, 0644);

.. php:attr:: Folder

    The Folder object of the file.

.. php:attr:: name

    The name of the file with the extension. Differs from
    :php:meth:`File::name()` which returns the name without the extension.

.. php:attr:: info

    An array of file info. Use :php:meth:`File::info()` instead.

.. php:attr:: handle

    Holds the file handler resource if the file is opened.

.. php:attr:: lock

    Enable locking for file reading and writing.

.. php:attr:: path

    Current file's absolute path.

.. php:method:: append( $data, $force = false )

    :rtype: boolean

    Append given data string to this File.


.. php:method:: close( )

    :rtype: boolean

    Closes the current file if it is opened.


.. php:method:: copy( $dest, $overwrite = true )

    :rtype: boolean

    Copy the File to $dest


.. php:method:: create( )

    :rtype: boolean

    Creates the File.


.. php:method:: delete( )

    :rtype: boolean

    Deletes the File.


.. php:method:: executable( )

    :rtype: boolean

    Returns true if the File is executable.


.. php:method:: exists( )

    :rtype: boolean

    Returns true if the File exists.


.. php:method:: ext( )

    :rtype: string

    Returns the File extension.


.. php:method:: Folder( )

    :rtype: Folder

    Returns the current folder.


.. php:method:: group( )

    :rtype: integer

    Returns the File's group.


.. php:method:: info( )

    :rtype: string

    Returns the File info.

    .. versionchanged:: 2.1
        ``File::info()`` now includes filesize & mimetype information.

.. php:method:: lastAccess( )

    :rtype: integer

    Returns last access time.


.. php:method:: lastChange( )

    :rtype: integer

    Returns last modified time.


.. php:method:: md5( $maxsize = 5 )

    :rtype: string

    Get md5 Checksum of file with previous check of Filesize


.. php:method:: name( )

    :rtype: string

    Returns the File name without extension.


.. php:method:: offset( $offset = false, $seek = 0 )

    :rtype: mixed

    Sets or gets the offset for the currently opened file.


.. php:method:: open( $mode = 'r', $force = false )

    :rtype: boolean

    Opens the current file with a given $mode

.. php:method:: owner( )

    :rtype: integer

    Returns the File's owner.


.. php:method:: perms( )

    :rtype: string

    Returns the "chmod" (permissions) of the File.


.. php:staticmethod:: prepare( $data, $forceWindows = false )

    :rtype: string

    Prepares a ascii string for writing. Converts line endings to the
    correct terminator for the current platform. If windows "\r\n"
    will be used all other platforms will use "\n"


.. php:method:: pwd( )

    :rtype: string

    Returns the full path of the File.


.. php:method:: read( $bytes = false, $mode = 'rb', $force = false )

    :rtype: mixed

    Return the contents of this File as a string or return false on failure.


.. php:method:: readable( )

    :rtype: boolean

    Returns true if the File is readable.


.. php:method:: safe( $name = NULL, $ext = NULL )

    :rtype: string

    Makes filename safe for saving.


.. php:method:: size( )

    :rtype: integer

    Returns the Filesize.


.. php:method:: writable( )

    :rtype: boolean

    Returns true if the File is writable.


.. php:method:: write( $data, $mode = 'w', $force = false )

    :rtype: boolean

    Write given data to this File.

.. versionadded:: 2.1 ``File::mime()``

.. php:method:: mime()

    :rtype: mixed

    Get the file's mimetype, returns false on failure.


.. todo::

    Better explain how to use each method with both classes.

.. meta::
    :title lang=zh_CN: Folder & File
    :description lang=zh_CN: The Folder and File utilities are convenience classes to help you read, write, and append to files; list files within a folder and other common directory related tasks.
    :keywords lang=zh_CN: file,folder,cakephp utility,read file,write file,append file,recursively copy,copy options,folder path,class folder,file php,php files,change directory,file utilities,new folder,directory structure,delete file
