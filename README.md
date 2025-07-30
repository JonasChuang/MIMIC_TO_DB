這個專案提供了一個完整流程，將 **MIMIC-IV v3.1** 的 CSV 檔案載入至 MySQL 資料庫。  
主要分成兩個部分：
1. `CREAT_TBL.sql` – 建立資料表結構。
2. `MIMIC_TO_DB.py` – 讀取 CSV 並批次匯入 MySQL。

---

## 📂 專案檔案

- **`CREAT_TBL.sql`**  
  定義了所有 MIMIC-IV v3.1 所需的 MySQL 資料表，包含：
  - 使用 `InnoDB` 引擎，支援 UTF8MB4 編碼。
  - 設有 `PRIMARY KEY` 與 `INDEX`，利於查詢效能。

- **`MIMIC_TO_DB.py`**  
  使用 Python + Pandas + SQLAlchemy 批次匯入 CSV：
  - 預設批次大小 `chunksize=100000`（一次 10 萬筆）。
  - 使用 `dtype=str` 避免 Pandas 自動推斷錯誤。
  - 支援自動刪除並重建資料表。
  - 匯入進度顯示透過 `tqdm` 進度條。

---



##  使用方法
編輯 MIMIC_TO_DB.py：

1.安裝套件 pipenv install

2.設定資料庫連線
engine = create_engine("mysql+pymysql://user:password@host:3306/mimic3_1")  
3.設定CSV檔案路徑
FILE_PATH="D:\\JONAS\\mimic-iv-3.1\\mimic-iv-3.1\\hosp\\"  

- **`4.執行 python MIMIC_TO_DB.py`**   
  程式會先執行 CREAT_TBL() → 依 CREAT_TBL.sql 建立所有資料表。

  批次匯入 CSV
  執行 CSV_TO_DB()，程式會自動讀取 table_list 裡的表格名稱，依序將 CSV 寫入 MySQL。

  若 MySQL 已有資料表，程式會先 DROP TABLE 再重建。

---

##  ⚡ 注意事項
效能最佳化

建議將 MySQL 設定 innodb_buffer_pool_size 提高以支援大檔匯入。

匯入大檔建議分批（已使用 chunksize）。

資料型態處理

所有 CSV 匯入時均以字串讀取（dtype=str），避免 Pandas 自動判斷錯誤。

MySQL 端已定義數值/日期型別，若匯入錯誤可檢查來源 CSV 是否含 ___ 或文字。

硬碟需求

MIMIC-IV v3.1 全部表格超過 300GB，需預留足夠儲存空間。

---

##  📊 資料表摘要
已在 CREAT_TBL.sql 定義的主要資料表：

住院與病人資訊：admissions, patients, services, transfers

診斷與處置：d_icd_diagnoses, diagnoses_icd, procedures_icd, d_icd_procedures

藥物相關：pharmacy, prescriptions, emar, emar_detail

檢驗與監測：labevents, microbiologyevents, chartevents, d_items, d_labitems

ICU 資料：icustays, inputevents, outputevents, procedureevents, ingredientevents, datetimeevents

對照表：d_hcpcs, provider, caregiver
