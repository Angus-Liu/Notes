## Git 使用规范

1. 规范内容
   - 提交代码必须按规范书写 Log，Log 由提交类型 + why + how 组成。
   - 提交类型分为：
     - [add] 添加新功能
     - [modify] 表示对代码的整理或者改善
     - [delete] 删除代码
     - [bug] #Mantis号，修复bugs
     - [merge] 合并其他分支或代理商代码
     - [others]  其他，如编译脚本的修改等等
   - add 必须带上 how 字段，modify、delete、bug 必须带上 why 和 how
   - 修改一个问题，提交一个问题
   - 鼓励使用英文进行准确描述，重要问题需使用中文明确描述
2. 注意事项
   - 提交之前必须更新代码
   - 不能编译通过的代码不能commit
   - 本地库提交力度要小，及时提交但是不要上传到远程分支
   - 每天下班前或者一个功能完成且确定没有问题上传到本地分支并提交到远程分支归档
   - properties等配置文件信息在没有增加新属性的情况不能commit
   - 格式：[add/bugfix/modify] \[what\]: xxxxxx;

## Git 工作流

