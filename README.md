用于艾尔登法环(EldenRing)的 AutoHotKey 脚本，提供了分离奔跑与翻滚按键、为每个法术和消耗品单独设置选择按键等功能。 

**运行方法**

1. 下载并安装 AHK (https://www.autohotkey.com/)
2. 使用 AHK 运行 ER_A11y_GUI.ahk

**打包方法**

1. 使用 AHK 将 ER_A11y.ahk 打包为 ER_A11y.exe
2. 将 ER_A11y_GUI.ahk 中的代码 `Run ER_A11y.ahk,,, PID` 修改为 `Run ER_A11y.exe,,, PID`
3. 使用 AHK 将 ER_A11y_GUI.ahk 打包为 ER_A11y_GUI.exe
4. 将 PaddleOCR 中的 DLL 目录复制到 ER_A11y_GUI.exe 的同级目录下
5. 运行 ER_A11y_GUI.exe
