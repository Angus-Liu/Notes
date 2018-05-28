cd /d E:\Data_Learning\Notes

echo 执行git命令：更新笔记仓库
git add N*
git add README.md

echo 执行git命令：添加描述
git commit -m ":arrow_double_up: :writing_hand: :page_facing_up: Update notes at %Date:~0,4%/%Date:~5,2%/%Date:~8,2% %Time:~0,2%:%Time:~3,2%"

echo 执行git命令：push到仓库  
git push