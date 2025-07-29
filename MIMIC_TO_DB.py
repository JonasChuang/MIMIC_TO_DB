# MIMIC-IV v3.1
import pandas as pd
from sqlalchemy import create_engine, text,inspect
from tqdm import tqdm
import pymysql
pymysql.install_as_MySQLdb()

DB_CONN="mysql+pymysql://test:test@127.0.0.1:3306/mimic3_1" #資料庫連線
FILE_PATH="E:\\mimic-iv-3.1\\hosp\\"#檔案路徑
engine = create_engine(DB_CONN)# 連接設定

#批次大小
chunksize = 100000  # 每批匯入10萬筆，可調整



table_list=[
        # "admissions",
        # "d_hcpcs",
        # "d_icd_diagnoses",
        # "d_icd_procedures",
        # "diagnoses_icd",
        # "drgcodes",
        # "emar",
        "emar_detail",
        "hcpcsevents",
        "labevents",
        "microbiologyevents",
        "omr",
        "patients",
        "pharmacy",
        "poe",
        "poe_detail",
        "prescriptions",
        "procedures_icd",
        "provider",
        "services",
        "transfers",
        "caregivers",
        "chartevents",
        "d_items",
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

            if table_name=="emar_detail":
                low_memory_flg=False #
            else:
                low_memory_flg=True
         
            for chunk in tqdm(pd.read_csv(csv_file, chunksize=chunksize,low_memory=low_memory_flg)):
                
                chunk.to_sql(table_name, con=engine, if_exists='append', index=False, method='multi')
                if low_memory_flg==False:
                    print("小階段完成")
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
                table_exists = inspector.has_table(table_name)
                
                try:
                    if table_exists == True:
                        SQL=f"drop table {table_name};"
                        conn.execute(text( SQL))
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
        print(Error)
if __name__ == '__main__':
    CREAT_TBL()#建立資料表
    CSV_TO_DB()#轉檔