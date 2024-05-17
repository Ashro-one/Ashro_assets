import os
import csv
import subprocess
import re

def scan_ip(ip_address, port):

    command = ["./Tools/Nmap/nmap.exe", "-p", f"{port}", "-sV", f"{ip_address}"]
    print(f"正在执行扫描： {command}")
    try:
        result = subprocess.check_output(command, shell=True, text=True)
        print(result)
        if 'open' in result:
            # 提取服务名称
            service_match = re.search(rf'{port}/tcp\s+open\s+\S+\s+(\S+)', result)
            print(service_match)
            if service_match:
                service_name = service_match.group(1)
                print(service_name)
            else:
                service_name = 'Unknown'
            return True, service_name
        else:
            return False, None
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")
        return False, None

def nmap():
    input_file = './output/ip.txt'
    output_csv_file = './output/scan_results.csv'   #保存nmap验证过的端口结果，获取其服务信息
    output_txt_file = './output/nmap_port.txt'      #保存nmap验证过的端口号结果txt文件用作下一步处理

    with open(input_file, 'r') as f:
        ip_list = f.readlines()

    with open(output_csv_file, 'w', newline='') as csvfile:
        fieldnames = ['IP地址', '端口号', '服务名称', '是否开放']
        writer_csv = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer_csv.writeheader()

        with open(output_txt_file, 'w') as txtfile:
            for ip_address_port in ip_list:
                ip_address, port = ip_address_port.strip().split(':')
                port = int(port)
                is_open, service_name = scan_ip(ip_address, port)
                if is_open:
                    ip_port_format = f"{ip_address}:{port}"
                    writer_csv.writerow({'IP地址': ip_address, '端口号': port, '服务名称': service_name, '是否开放': '开放','IP地址和端口': ip_port_format})
                    txtfile.write(f"{ip_address}:{port}\n")  # 写入 IP 地址和端口到 TXT 文件
