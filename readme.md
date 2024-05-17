用于企业资产梳理的自动化脚本。 目前速率单一C段资产内不多的情况下，大约3-4小时可以搞完一个C。实际工作量应适当延长。

Script logic<br>
  1.调用masscan针对ip.txt内的目标进行全端口扫描<br>
  2.调用nmap对masscan的开放端口进行验证以及服务信息识别<br>
  3.调用Ashro_url_alive.py进行web资产识别<br>
  4.进行nmap结果与web资产结果做资产聚合<br>
  5.调用afrog工具进行资产漏扫。<br>
  6.windows弱口令检查-请使用超级弱口令检查工具
  7.linux弱口令检查-shaow文件爆破工具 我没放-😉

最后生成文件如下：

  /output//result.csv          ：资产梳理结果文件<br>
  /output/{current_time}.html  ：漏洞扫描文件结果<br>
  

Usge： 
  将目标放入同目录下的ip.txt下，支持c段扫描。

  python -m pip install -r requirements.txt
  
  python Ashro_assets.py  -afrog      #-afrog 进行漏洞扫描，默认不开启

  <img width="689" alt="image" src="https://github.com/Ashro-one/Ashro_assets/assets/49979071/9e246301-c8ff-4b6e-8439-f85f56cf3eac">















PS
非常喜欢masscan的一个功能如下：继续上次的进度扫描<br>
masscan.exe --resume paused.conf<br>
Masscan有一个独特的功能是，可以轻松地暂停和恢复扫描。当按 Ctrl+C 时 paused.conf 文件被创建， paused.conf 文件具有扫描的所有设置和进度。<br>
注意！

使用 masscan --resume paused.conf 会将新的扫描结果写入 output.txt 文件并覆盖原有内容。如果你希望追加新的扫描结果而不覆盖原有内容，可以使用 >> 操作符（linux），例如：

sudo masscan --resume paused.conf >> output.txt

这样会将新的扫描结果追加到 output.txt 文件的末尾，而不会影响文件中的现有内容。使用 >> 操作符时，请确保目标文件已存在，否则它将创建一个新文件

