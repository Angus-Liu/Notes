文件批量重命名脚本

```bat
@echo off
for /f "delims=" %%i in ('dir/b/a-d _')do (set f=%%i
echo.%%i
call set f=%%f:_=-%%
call ren "%%i" "%%f%%")
pause
```

