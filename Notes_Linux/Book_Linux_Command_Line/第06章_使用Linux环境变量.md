### 6.1 什么是环境变量

bash shell用一个叫作环境变量 （environment variable）的特性来存储有关shell会话和工作环境的信息。这项特性允许你在内存中存储数据，以便程序或shell中运行的脚本能够轻松访问到它们。这也是存储持久数据的一种简便方法。

在bash shell中，环境变量分为两类：

+ 全局变量
+ 局部变量

#### 6.1.1 全局环境变量

全局环境变量对于shell会话和所有生成的子shell都是可见的。局部变量则只对创建它们的shell可见。

要查看全局变量，可以使用env 或printenv 命令。

显示个别环境变量的值，可以使用printenv 命令或echo 显示变量的值：

```bash
$ printenv HOME
/home/Christine
$
$ echo $HOME
/home/Christine
$
```

#### 6.1.2 局部环境变量

顾名思义，局部环境变量只能在定义它们的进程中可见。尽管它们是局部的，但是和全局环境变量一样重要。

set 命令会显示为某个特定进程设置的所有环境变量，包括局部变量、全局变量以及用户定义变量。

### 6.2 设置用户定义变量

#### 6.2.2 设置全局环境变量

在设定全局环境变量的进程所创建的子进程中，该变量都是可见的。创建全局环境变量的方法是先创建一个局部环境变量，然后再把它导出到全局环境中。

这个过程通过export 命令来完成，变量名前面不需要加$ 。

```bash
$ my_variable="I am Global now"
$
$ export my_variable
$
$ echo $my_variable
I am Global now
$
$ bash
$
$ echo $my_variable
I am Global now
```

### 6.6 定为系统环境变量

在你登入Linux系统启动一个bash shell时，默认情况下bash会在几个文件中查找命令。这些文件叫作启动文件 或环境文件 。bash检查的启动文件取决于你启动bash shell的方式。启动bash shell有3种方式：

+ 登录时作为默认登录shell
+ 作为非登录shell的交互式shell
+ 作为运行脚本的非交互shell

#### 6.6.1 登录shell

