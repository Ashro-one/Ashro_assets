import subprocess
import re
import csv

def run_nmap_scan(ports_file):
    open_ports = []

    with open(ports_file, 'r',encoding='utf-8-sig') as port_f:

        for line in port_f:
            ip_address, port = line.strip().split(':')
            nmap_scan = [".\\TOols\\Nmap\\nmap.exe", "-p", port, "-sV", ip_address]
            result = subprocess.run(nmap_scan, capture_output=True, text=True, check=True)

            # 使用正则表达式匹配端口状态为 open 的行
            pattern = r"(\d+)/tcp\s+open\s+(\S+)\s+(.*)"
            matches = re.findall(pattern, result.stdout)
            for match in matches:
                port = match[0]
                service = match[1]
                version = match[2]
                open_ports.append({
                    'ipaddress': ip_address,
                    'port': port,
                    'status': 'open',
                    'servers': service,
                    'bios': version,
                    'ip:port': f"{ip_address}:{port}"
                })

    # 将结果写入 CSV 文件
    with open('.\\output\\open_ports.csv', 'w', newline='',encoding='latin-1') as csvfile:
        fieldnames = ['ipaddress', 'port', 'status', 'servers', 'bios', 'ip:port']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for port_info in open_ports:
            writer.writerow({
                'ipaddress': port_info['ipaddress'],
                'port': port_info['port'],
                'status': port_info['status'],
                'servers': port_info['servers'],
                'bios': port_info['bios'],
                'ip:port': port_info['ip:port']
            })
