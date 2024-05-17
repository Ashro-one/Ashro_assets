# "自动化资产梳理工具"
# "Version: 2.0"
# "Author: Ashro"
# "Date: 2024-5-15
import sys
from datetime import datetime
from TOols.url_Deal import match_and_append_data
from TOols.nmap import *

def url_handle():
    f = open(file='./output/ip_result.txt', mode='w')

    with open("./output/nmap_port.txt") as ips:
        for ip in ips:
            ip = ip.strip()
            if "443" in ip:
                print("https://" + ip)
                f.write("https://" + ip + "\n")
            else:
                print("http://" + ip)
                f.write("https://" + ip + "\n")


def masscan_scan():
    # 打开 Masscan 输出文件
    with open('.//output/masscan_ip.txt', 'r') as f:
        # 创建一个新的文本文件来保存转换后的结果
        with open('.//output/ip.txt', 'w') as fw:
            # 逐行读取文件内容
            for line in f:
                # 检查行是否以 "open" 开头
                if line.startswith('open'):
                    # 分割行并提取 IP 地址和端口号
                    parts = line.split()
                    ip = parts[3]
                    port = parts[2]
                    # 将 IP:端口 格式写入新文件
                    fw.write(f"{ip}:{port}\n")



if __name__ == '__main__':
    try:
        execute_afrog = "-afrog" in sys.argv

        masscan = [".//TOols//masscan.exe", "-iL", ".//ip.txt", "-p", "1-65535", "--rate","20000", "-oL", ".//output/masscan_ip.txt"]  # 进行全端口扫描
        subprocess.run(masscan, check=True)

        #masscan结果处理
        masscan_scan()

        print("开始nmap端口验证")
        nmap()  # 利用nmap针对单独端口进行验证获取端口开放服务信息

        url_handle() # 对nmap验证过的端口的txt文本进行处理

        print("开始url地址访问，搜索web资产")
        # httpx = [".//TOols//httpx.exe", "-l", ".//output//ip_result.txt", "-o", ".//output//url_result.txt"]  # 获取web资产
        # subprocess.run(httpx, check=True)
        #内网还可以外网可能由于个别网站证书校验关系不太好用，特别是金融网站 反爬机制有点恶心
        Ashro_url_alive = ["python", "./TOols/Ashro_url_alive.py", "-f", ".//output//ip_result.txt", "-o", ".//output//url_result.csv"]
        subprocess.run(Ashro_url_alive, check=True)

        #进行资产合并
        match_and_append_data('./output/url_result.csv', './output/scan_results.csv', './output//result.csv')


        # 如果需要漏扫可访问的web资产 可获取目录下的.//output//url_result.txt文件
        if execute_afrog:
            current_time = datetime.now().strftime("%Y%m%d%H%M%S")
            output_file = f"./output/{current_time}.html"
            print("开启漏洞扫描,内网不明web访问地址需谨慎，需要注意存在一些未授权的可操作的网站，因为有些扫描器是主动爬取：比如awvs，他会每个链接点可能会造成业务损坏或者脏数据")
            # 构建并执行系统命令
            command = [".//TOols//afrog.exe", "-T", ".\\output\\url_result.txt", "-output", output_file]
            subprocess.run(command, check=True)




        # 删除无关文件
        files_to_delete = [".//output//ip.txt", ".//output//ip_result.txt",",//output//masscan_ip.txt"]
        for file_path in files_to_delete:
            os.remove(file_path)

        # command = [".\\Nmap\\nmap.exe", "-T", ".\\output\\high.txt", "-output", output_file]
        # subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"发生了一个错误：{e}")



