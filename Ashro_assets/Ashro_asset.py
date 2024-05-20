# "自动化资产梳理工具"
# "Version: 2.0"
# "Author: Ashro"
# "Date: 2024-5-15
import sys
from datetime import datetime

from TOols.nmapscan import *
import pandas as pd
import os


import pandas as pd


#使用nmap进行服务探测后结果合并
def match_and_append_data(input_csv1, input_csv2, output_csv):
    # 读取第一个CSV文件，假设第1列数据在其中
    df1 = pd.read_csv(input_csv1, encoding='latin-1')
    # 读取第二个CSV文件，假设第6列数据在其中
    df2 = pd.read_csv(input_csv2, encoding='latin-1')

    # 使用merge将两个DataFrame按照第一列进行匹配
    merged_df = pd.merge(df1, df2, left_on=df1.columns[5], right_on=df2.columns[0], how='outer')

    # 将匹配到的行追加到第一个CSV文件匹配到数据的对应行的后面
    df1_cols = df1.columns.tolist()
    df1_cols.extend([col for col in df2.columns if col not in df1.columns])  # 添加第二个CSV文件中新增的列
    df1 = merged_df[df1_cols]

    # 保存结果到输出CSV文件
    df1.to_csv(output_csv, index=False)

#不使用nmap进行服务探测进行结果探测


def match_and_append_txt(input_txt1, input_csv2, output_csv):
    # 从txt文件中读取数据并转换为DataFrame，假设数据以逗号分隔
    with open(input_txt1, 'r', encoding='utf-8') as file:
        lines = file.readlines()
        # 假设数据中的每行都是用逗号分隔的
        data = [line.strip().split(',') for line in lines]
        df1 = pd.DataFrame(data)

    # 读取第二个CSV文件，假设第6列数据在其中
    df2 = pd.read_csv(input_csv2, encoding='latin-1')

    # 使用merge将两个DataFrame按照第一列进行匹配
    merged_df = pd.merge(df1, df2, left_on=df1.columns[0], right_on=df2.columns[0], how='outer')

    # 将匹配到的行追加到第一个CSV文件匹配到数据的对应行的后面
    df1_cols = df1.columns.tolist()
    df1_cols.extend([col for col in df2.columns if col not in df1.columns])  # 添加第二个CSV文件中新增的列
    df1 = merged_df[df1_cols]

    # 保存结果到输出CSV文件
    df1.to_csv(output_csv, index=False)


#t提取fscn结果的开放端口
def fscan_scan():
    try:
        # 打开 fscan 输出文件
        with open('.//output/fscan.txt', 'r', encoding='utf-8-sig') as f:
            # 创建一个新的文本文件来保存转换后的结果
            with open('.//output/ip.txt', 'w', encoding='utf-8-sig') as fw:
                # 逐行读取文件内容
                for line in f:
                    # 检查行是否包含IP地址和端口信息以及端口是否为开放状态
                    if "open" in line:
                        parts = line.split()
                        if len(parts) >= 2:  # 确保行的长度足够长
                            # 提取IP地址和端口号
                            ip_port = parts[0]
                            # 写入新文件
                            fw.write(f"{ip_port}\n")
    except FileNotFoundError:
        print("Error: 文件未找到")
    except Exception as e:
        print("Error:", e)

#提取开放的url
def fscan_web():
    # 读取文件内容
    with open('.\\output\\fscan.txt', 'r') as file:
        lines = file.readlines()

    # 提取包含 WebTitle 的行
    web_title_lines = [line.strip() for line in lines if 'WebTitle' in line]

    # 解析每一行并将结果保存到列表中
    data = []
    # pattern = r'WebTitle (https?://\S+)\s+code:(\d+)\s+len:(\d+)\s+title:(.+)'
    pattern = r'WebTitle\s+(https?://\S+)\s+code:(\d+)\s+len:(\d+)\s+title:(.+)'

    # 遍历每行字符串
    for line in web_title_lines:
        # 在每行中搜索匹配项
        match = re.search(pattern, line)
        if match:
            # 如果找到匹配项，则提取信息

            url = match.group(1)
            url_pattern = r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$'
            if re.search(url_pattern, url):
                url += ":80"
            ip_port = url.replace('http://','').replace('https://','')
            status_code = match.group(2)
            content_length = match.group(3)
            title = match.group(4)
            data.append((ip_port, url, status_code, content_length, title))

    # 写入 CSV 文件
    with open('.\\output\\url_result.csv', 'w', newline='') as csvfile:
        fieldnames = ["ip:port", "url", "status_code", "content_length", "title"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for item in data:
            writer.writerow(
                {"ip:port": item[0], "url": item[1], "status_code": item[2], "content_length": item[3], "title": item[4]})

    # 写入文本文件
    with open('.\\output\\url_result.txt', 'w') as txtfile:
        for url in data:
            txtfile.write(f"{url}\n")




if __name__ == '__main__':

    try:
        execute_afrog = "-afrog" in sys.argv    #开启afrog漏扫
        execute_nmap = "-nmap" in sys.argv      #开启nmap扫描识别具体服务

        fscan_port = [".\\TOols\\fscan.exe", "-hf", "ip.txt", "-o", ".\\output\\fscan.txt", "-nobr", "-nopoc", "-p", "1-65535"]
        subprocess.run(fscan_port, check=True)

        fscan_scan()    #t提取fscn结果的开放端口
        fscan_web()     #提取fscan结果的开放的url
        if execute_nmap:
            print("开始nmap端口服务验证")
            run_nmap_scan(".\\output\\ip.txt")  # 利用nmap针对单独端口进行验证获取端口开放服务信息
            #     #进行资产合并
            match_and_append_data('.\\output\\open_ports.csv', '.\\output\\url_result.csv', '.\\output\\nmap_result.csv')
        else:
            match_and_append_txt('.\\output\\ip.txt', '.\\output\\url_result.csv', '.\\output\\nonmap_result.csv')

        #
        # 如果需要漏扫可访问的web资产 可获取目录下的.//output//url_result.txt文件
        if execute_afrog:
            current_time = datetime.now().strftime("%Y%m%d%H%M%S")
            output_file = f".\\output\\{current_time}.html"
            print("开启漏洞扫描,内网不明web访问地址需谨慎，需要注意存在一些未授权的可操作的网站，因为有些扫描器是主动爬取：比如awvs，他会每个链接点可能会造成业务损坏或者脏数据")
            # 构建并执行系统命令
            command = [".\\TOols\\afrog.exe", "-T", ".\\output\\url_result.txt", "-output", output_file]
            subprocess.run(command, check=True)
    #
        # 删除无关文件
        files_to_delete = [".\\output\\fscan.txt", ".\\output\\url_result.txt"]
        for file_path in files_to_delete:
            os.remove(file_path)
    except subprocess.CalledProcessError as e:
        print(f"发生了一个错误：{e}")