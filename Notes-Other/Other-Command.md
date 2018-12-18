# CMD

## 解除端口占用

```powershell
# 查看端口占用
netstat -aon|findstr "8080"
# 查看 PID 对应的进程
tasklist|findstr "16780"
# 结束进程
taskkill /f /t /im java.exe
```

