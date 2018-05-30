将下面的的代码保存到一个批处理文件，例如gl.bat中，再将该文件所在的路径添加到path环境变量下。之后就可以通过cmd或运行窗口输入"gl"直接调用改脚本，很方面地提交代码。

```bash
cd /d E:\Data_Learning\Notes

echo 执行git命令：更新笔记仓库

git add N*

git add README.md

echo 执行git命令：添加描述

git commit -m "⏫ ✍️ 📄 Update notes at %Date:~0,4%/%Date:~5,2%/%Date:~8,2% %Time:~0,2%:%Time:~3,2%"

echo 执行git命令：push到仓库  

git push

```

