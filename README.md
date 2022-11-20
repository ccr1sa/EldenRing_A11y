**打包 exe 方法**

1. 使用 AHK 将 ER_A11y.ahk 打包为 ER_A11y.exe
2. 将 ER_A11y_GUI.ahk 中的代码 `Run ER_A11y.ahk,,, PID` 修改为 `Run ER_A11y.exe,,, PID`
3. 使用 AHK 将 ER_A11y_GUI.ahk 打包为 ER_A11y_GUI.exe
4. 将 PaddleOCR 中的 DLL 目录复制到 ER_A11y_GUI.exe 的同级目录下
5. 运行 ER_A11y_GUI.ahk
