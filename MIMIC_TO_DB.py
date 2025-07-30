# MIMIC-IV v3.1
import pandas as pd
from sqlalchemy import create_engine, text,inspect
from tqdm import tqdm
import pymysql
pymysql.install_as_MySQLdb()
engine = create_engine("mysql+pymysql://test:test@10.2.163.201:3306/mimic3_1")# 連接設定

FILE_PATH="D:\\JONAS\\mimic-iv-3.1\\mimic-iv-3.1\\hosp\\"#檔案路徑

#批次大小
chunksize = 100000  # 每批匯入10萬筆，可調整

# table_list:資料表名稱 = CSV 檔案名稱
table_list=[
        "admissions",
        "d_hcpcs",
        "d_icd_diagnoses",
        "d_icd_procedures",
        
        "diagnoses_icd",
        "drgcodes",
        "emar",#6G
        "emar_detail",#8G
        "hcpcsevents",
        "labevents", #17G
        "microbiologyevents",
        "omr",
        "patients",
        "pharmacy",
        "poe",#4G
        "poe_detail",
        "prescriptions",
        "procedures_icd",
        "provider",
        "services",
        "transfers",
        "caregiver",
        "chartevents",#40G
        "d_items",
        "d_labitems",
        "datetimeevents",
        "icustays",
        "ingredientevents",
        "inputevents",
        "outputevents",
        "procedureevents",
      
        ]



def CSV_TO_DB():#轉檔
    try:
        
        for table_name in table_list:
            print("轉檔資料表:"+table_name)
            csv_file=FILE_PATH+table_name+".csv"
          
            for chunk in tqdm(pd.read_csv(csv_file, chunksize=chunksize,low_memory=True,dtype=str)):
                
                chunk.to_sql(table_name, con=engine, if_exists='append', index=False, method='multi')
                
            print(table_name+",完成")
        print("轉檔完成")
    except Exception as Error:
        print("CSV_TO_DB 錯誤!!!!!!! \n"+Error)

def CREAT_TBL():#建立資料表
    try:
        inspector = inspect(engine)
        with engine.connect() as conn:
            #1.先刪除資料表
            for table_name in table_list:
                table_exists = inspector.has_table(table_name)#判斷資料表有沒有存在
                
                try:
                    if table_exists == True:
                        SQL=f"drop table {table_name};"
                        conn.execute(text( SQL))#刪除資料表
                except Exception as ERROR:
                    print("Error:",ERROR)
                    pass
       
            with open('CREAT_TBL.sql', 'r', encoding='utf-8') as f:
                sql_script = f.read()

            #2.建立資料表
            for statement in sql_script.split(';'):
                stmt = statement.strip()
                if stmt:
                    try:
                        SQL=stmt + ';'
                        conn.execute(text( SQL))
                        
                    except Exception as e:
                        print("Error:", e, "\nStatement:", stmt[:100])
        print("建立資料表完成")
    except Exception as Error:
        print("建立資料表 錯誤!!!!!!!!!!\n"+Error)

if __name__ == '__main__':
    CREAT_TBL()#刪除現有資料表，再建立資料表
    CSV_TO_DB()#轉檔