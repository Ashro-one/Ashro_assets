import pandas as pd

def match_and_append_data(input_csv1, input_csv2, output_csv):
    # 读取第一个CSV文件，假设A列数据在其中
    df1 = pd.read_csv(input_csv1)
    # 读取第二个CSV文件，假设D列数据在其中
    df2 = pd.read_csv(input_csv2)

    # 将A列数据与D列数据进行匹配
    merged_df = pd.merge(df1, df2, left_on='B', right_on='E', how='left')

    # 追加匹配到的数据
    for index, row in merged_df.iterrows():
        if not pd.isna(row['E']):  # 如果匹配到了数据
            # 将第二个CSV文件中匹配到的整行数据追加到第一个CSV文件的对应行后面
            df1.loc[index, df1.columns] = df1.loc[index, df1.columns].append(row[df2.columns])

    # 保存结果到输出CSV文件
    df1.to_csv(output_csv, index=False)

# 调用函数并传入文件路径
# match_and_append_data('.//output//url_result.csv', './/output//scan_results.csv', './/output//result.csv')
