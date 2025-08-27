# MIMIC-IV v3.1
import pandas as pd
from sqlalchemy import create_engine, text,inspect
from tqdm import tqdm
import re
from pathlib import Path
import pymysql
pymysql.install_as_MySQLdb()
#engine = create_engine("mysql+pymysql://snow:cmu_admin@10.2.130.59:3306/mimic3_1")# 學校
engine = create_engine("mysql+pymysql://test:test@10.2.163.201:3306/test1")# 連接設定
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
        "emar",#6G,3小時
        "emar_detail",#8G,17小時
        "hcpcsevents",
        "labevents", #17G，15小時
        "microbiologyevents",
        "omr",
        "patients",
        "pharmacy",
        "poe",#4G,3小時
        "poe_detail",
        "prescriptions",#2小時
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
          
            reader = pd.read_csv(
                csv_file,
                chunksize=chunksize,
                engine='python',
                sep=',',
                quotechar='"',
                escapechar='\\',
                dtype=str,
                low_memory=True,
                on_bad_lines='warn'  # 或 'skip'
            )
            
            for chunk in tqdm(reader):
                
                chunk.to_sql(table_name, con=engine, if_exists='append', index=False, method='multi')
                
            print(table_name+",完成")
        print("轉檔完成")
    except Exception as Error:
        print("CSV_TO_DB 錯誤!!!!!!! \n"+str(Error))

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
        print("建立資料表 錯誤!!!!!!!!!!\n"+str(Error))

def extract_create_table( table_name):
    try:

        inspector = inspect(engine)
        with engine.connect() as conn:
            table_exists = inspector.has_table(table_name)#判斷資料表有沒有存在
                    
            try:
                if table_exists == True:
                    SQL=f"drop table {table_name};"
                    conn.execute(text( SQL))#刪除資料表
            except Exception as ERROR:
                print("Error:",ERROR)
                pass

        sql_path = Path("CREAT_TBL.sql")
        sql_text = sql_path.read_text(encoding="utf-8", errors="ignore")
        # 正則匹配 CREATE TABLE table_name (...) 結尾到分號
        pattern = re.compile(
            rf"CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?[`\"]?{table_name}[`\"]?\s*\(.*?\);",
            re.IGNORECASE | re.DOTALL
        )
        match = pattern.search(sql_text)
        if match:
            return match.group(0)
        return None
    
    except Exception as ERROR:
        print("Error:",ERROR)
        pass

if __name__ == '__main__':
    #CREAT_TBL()#刪除現有資料表，再建立資料表
    CSV_TO_DB()#轉檔
