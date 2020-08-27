将下面的的代码（可以按自己需求更改）保存到一个批处理文件，例如gl.bat中，再将该文件所在的路径添加到path环境变量下。之后就可以通过cmd或运行窗口输入"gl"直接调用该脚本，很方面地提交代码。

```bash
echo 执行cd命令：进入本地指定仓库

cd /d E:\Data_Learning\Notes

git status

echo 按任意键继续

pause

echo 执行git命令：添加以N开头的文件或文件夹

git add N* 

echo 执行git命令：添加README

git add README.md

echo 执行git命令：添加描述

git commit -m ":memo: Update notes at %Date:~0,4%/%Date:~5,2%/%Date:~8,2% %Time:~0,2%:%Time:~3,2%"

echo 执行git命令：push到仓库  

git push

pause


// ==============================
cd /d D:\Data\Notes
git pull
git status
pause
git add assets/
git add N*
git add LICENSE
git add README.md
git commit -m ":memo: Update notes at %Date:~0,4%/%Date:~5,2%/%Date:~8,2% %Time:~0,2%:%Time:~3,2%"
git push
```

```shell
#!/bin/bash

echo "git pull"
git pull

echo "git status"
git status

get_char(){
 SAVEDSTTY=`stty -g`
 stty -echo
 stty cbreak
 dd if=/dev/tty bs=1 count=1 2> /dev/null
 stty -raw
 stty echo
 stty $SAVEDSTTY
}
echo "Press any key to continue!"
char=`get_char`

echo "git add"
git add assets/
git add N*
git add LICENSE
git add README.md

echo "git commit -m :memo: Update notes at `date '+%Y/%m/%d %H:%M'`"
git commit -m ":memo: Update notes at `date '+%Y/%m/%d %H:%M'`"

echo "git push"
git push
```





### 常用命令：

+ 以图形化方式显示 log：`git log --graph`

