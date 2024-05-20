import os

txt_dir = './'

for fpathe,dirs,fs in os.walk(txt_dir):
    with open('zero.txt','a+') as w:
        for i in fs:
            file_list = os.path.join(fpathe,i)
            file_list = file_list.replace('\\','/')
            print(file_list)
            if file_list == "./Empty-password-v2.py" or file_list == "./zero.txt":
                continue
            try:
                with open(file_list,'r+') as f:
                    for line in f:
                        l = line.split(':')
                        if l[1] == "":
                            w.write(file_list + '\n')
                            w.write(l[0]+'\n')
                            w.write('\n')
            except:
                continue