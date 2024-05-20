用于企业资产梳理的自动化脚本。 速度很快，体验飞一般的感觉。

Script logic<br>
  1.调用fscan针对ip.txt内的目标进行全端口扫描<br>
  2.调用nmap针对开放端口进行验证以及服务信息识别<br>
  3.进行nmap结果与web资产结果做资产聚合<br>
  4.调用afrog工具进行资产漏扫。<br>
  5.windows弱口令检查-请使用超级弱口令检查工具    /TOols/超级弱口令检查工具<br>
  6.linux弱口令检查-shaow文件爆破工具       /TOols/shadow文件弱口令


最后生成文件如下：

  /output//nmap_result.csv          ：调用nmap进行服务探测生成的资产梳理结果文件<br>
  /output/{current_time}.html       ：漏洞扫描文件结果<br>
  

Usge： 
  将目标放入同目录下的ip.txt下，支持c段扫描。

  python -m pip install -r requirements.txt
  
  python Ashro_assets.py  -afrog   -nmap   #-afrog 进行漏洞扫描，默认不开启  -nmap 调用nmap进行端口服务识别  默认不开启，开启后会很慢，但是结果会很清晰

  具体结果如下：
  <img width="796" alt="image" src="https://github.com/Ashro-one/Ashro_assets/assets/49979071/cc10656c-2b86-417e-9c43-ee004d725c90">
  <img width="1271" alt="image" src="https://github.com/Ashro-one/Ashro_assets/assets/49979071/b03c3f8f-15fa-43de-9afe-44d6d0b3c688">

  <img width="970" alt="image" src="https://github.com/Ashro-one/Ashro_assets/assets/49979071/c9522e81-1e8d-4804-9946-15fc8ec644e0">

  精简快速扫描：
  <img width="782" alt="image" src="https://github.com/Ashro-one/Ashro_assets/assets/49979071/1ab35771-400d-48c2-bc36-e1a2d7a6cca5">


  最后输出文件解释：<br>
  ip.txt                  fscan端口扫描结果<br>
  nmap_result.csv         调用nmap扫描服务探测资产汇总文件<br>
  nonmap_result.csv       不调用nmap扫描服务探测资产汇总文件<br>
  open_ports.csv          端口开放汇总文件<br>
  url_result.csv          web网站存活结果文件<br>
  
  
















PS
非常喜欢masscan的一个功能如下：继续上次的进度扫描<br>
masscan.exe --resume paused.conf<br>
Masscan有一个独特的功能是，可以轻松地暂停和恢复扫描。当按 Ctrl+C 时 paused.conf 文件被创建， paused.conf 文件具有扫描的所有设置和进度。<br>
注意！

使用 masscan --resume paused.conf 会将新的扫描结果写入 output.txt 文件并覆盖原有内容。如果你希望追加新的扫描结果而不覆盖原有内容，可以使用 >> 操作符（linux），例如：

sudo masscan --resume paused.conf >> output.txt

这样会将新的扫描结果追加到 output.txt 文件的末尾，而不会影响文件中的现有内容。使用 >> 操作符时，请确保目标文件已存在，否则它将创建一个新文件

