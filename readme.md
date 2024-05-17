









非常喜欢masscan的一个功能如下：继续上次的进度扫描：

masscan.exe --resume paused.conf

Masscan有一个独特的功能是，可以轻松地暂停和恢复扫描。当按 Ctrl+C 时 paused.conf 文件被创建， paused.conf 文件具有扫描的所有设置和进度。

注意！
使用 masscan --resume paused.conf 会将新的扫描结果写入 output.txt 文件并覆盖原有内容。如果你希望追加新的扫描结果而不覆盖原有内容，可以使用 >> 操作符（linux），例如：

sudo masscan --resume paused.conf >> output.txt

这样会将新的扫描结果追加到 output.txt 文件的末尾，而不会影响文件中的现有内容。使用 >> 操作符时，请确保目标文件已存在，否则它将创建一个新文件

