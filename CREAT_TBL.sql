CREATE TABLE admissions (
    subject_id INT NOT NULL,
    hadm_id BIGINT NOT NULL,
    admittime DATETIME,
    dischtime DATETIME,
    deathtime DATETIME,
    admission_type VARCHAR(50),
    admit_provider_id VARCHAR(20),
    admission_location VARCHAR(2000),
    discharge_location VARCHAR(2000),
    insurance VARCHAR(50),
    language VARCHAR(1000),
    marital_status VARCHAR(20),
    race VARCHAR(50),
    edregtime DATETIME,
    edouttime DATETIME,
    hospital_expire_flag TINYINT(1),
    PRIMARY KEY (hadm_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE d_hcpcs  (
    code VARCHAR(10) PRIMARY KEY,
    category VARCHAR(1000),
    long_description TEXT,
    short_description VARCHAR(1000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE d_icd_diagnoses (
    icd_code VARCHAR(10) NOT NULL,
    icd_version TINYINT NOT NULL,
    long_title VARCHAR(255),
    PRIMARY KEY (icd_code, icd_version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE d_icd_procedures (
    icd_code VARCHAR(100) NOT NULL,
    icd_version TINYINT NOT NULL,
    long_title VARCHAR(1000),
    PRIMARY KEY (icd_code, icd_version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE d_labitems (
    itemid INT NOT NULL PRIMARY KEY,
    label VARCHAR(100),
    fluid VARCHAR(50),
    category VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE diagnoses_icd (
    subject_id INT NOT NULL,
    hadm_id BIGINT NOT NULL,
    seq_num INT NOT NULL,
    icd_code VARCHAR(10) NOT NULL,
    icd_version TINYINT NOT NULL,
    PRIMARY KEY (subject_id, hadm_id, seq_num,icd_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE drgcodes (
    subject_id INT NOT NULL,
    hadm_id BIGINT NOT NULL,
    drg_type VARCHAR(10) NOT NULL,
    drg_code VARCHAR(10) NOT NULL,
    description VARCHAR(255),
    drg_severity TINYINT,
    drg_mortality TINYINT,
    PRIMARY KEY (subject_id, hadm_id, drg_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE emar (
    subject_id INT NOT NULL,
    hadm_id BIGINT ,
    emar_id VARCHAR(20) NOT NULL,
    emar_seq INT NOT NULL,
    poe_id VARCHAR(20),
    pharmacy_id BIGINT,
    enter_provider_id VARCHAR(20),
    charttime DATETIME,
    medication VARCHAR(255),
    event_txt VARCHAR(100),
    scheduletime DATETIME,
    storetime DATETIME,
    PRIMARY KEY (emar_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE emar_detail (
    row_id                     BIGINT AUTO_INCREMENT PRIMARY KEY,  -- 自動流水號
    
    subject_id                 INT NOT NULL,
    emar_id                    VARCHAR(50) NOT NULL,
    emar_seq                   INT NOT NULL,
    parent_field_ordinal       VARCHAR(20) NULL,
    administration_type        VARCHAR(255) NULL,
    pharmacy_id                BIGINT NULL,
    barcode_type               VARCHAR(50) NULL,
    reason_for_no_barcode      VARCHAR(255) NULL,
    complete_dose_not_given    VARCHAR(10) NULL,
    dose_due                   VARCHAR(255) NULL,
    dose_due_unit              VARCHAR(50) NULL,
    dose_given                 VARCHAR(255) NULL,
    dose_given_unit            VARCHAR(50) NULL,
    will_remainder_of_dose_be_given VARCHAR(10) NULL,
    product_amount_given       VARCHAR(255) NULL,
    product_unit               VARCHAR(50) NULL,
    product_code               VARCHAR(50) NULL,
    product_description        VARCHAR(255) NULL,
    product_description_other  VARCHAR(255) NULL,
    prior_infusion_rate        VARCHAR(255) NULL,
    infusion_rate              VARCHAR(255) NULL,
    infusion_rate_adjustment   VARCHAR(255) NULL,
    infusion_rate_adjustment_amount VARCHAR(255) NULL,
    infusion_rate_unit         VARCHAR(50) NULL,
    route                      VARCHAR(50) NULL,
    infusion_complete          VARCHAR(10) NULL,
    completion_interval        VARCHAR(50) NULL,
    new_iv_bag_hung            VARCHAR(10) NULL,
    continued_infusion_in_other_location VARCHAR(10) NULL,
    restart_interval           VARCHAR(50) NULL,
    side                       VARCHAR(50) NULL,
    site                       VARCHAR(50) NULL,
    non_formulary_visual_verification VARCHAR(10) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



CREATE TABLE hcpcsevents (
    subject_id INT NOT NULL,
    hadm_id BIGINT NOT NULL,
    chartdate DATE,
    hcpcs_cd VARCHAR(10) NOT NULL,
    seq_num INT,
    short_description VARCHAR(255),
    PRIMARY KEY (subject_id, hadm_id, hcpcs_cd, seq_num)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE labevents (
    row_id BIGINT AUTO_INCREMENT PRIMARY KEY,  -- 自動流水號
    labevent_id INT ,
    subject_id INT NOT NULL,
    hadm_id BIGINT,
    specimen_id BIGINT,
    itemid INT NOT NULL,
    order_provider_id VARCHAR(20),
    charttime DATETIME,
    storetime DATETIME,
    value VARCHAR(255),
    valuenum FLOAT,
    valueuom VARCHAR(50),
    ref_range_lower FLOAT,
    ref_range_upper FLOAT,
    flag VARCHAR(50),
    priority VARCHAR(50),
    comments TEXT,

    INDEX idx_labevent_id (labevent_id),
    INDEX idx_subject_id (subject_id),
    INDEX idx_specimen_id(specimen_id),
    INDEX idx_itemid (itemid),
    INDEX idx_row_id(row_id)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE microbiologyevents (
    microevent_id INT PRIMARY KEY,
    subject_id INT NOT NULL,
    hadm_id BIGINT,
    micro_specimen_id BIGINT,
    order_provider_id VARCHAR(20),
    chartdate DATE,
    charttime DATETIME,
    spec_itemid INT,
    spec_type_desc VARCHAR(100),
    test_seq INT,
    storedate DATE,
    storetime DATETIME,
    test_itemid INT,
    test_name VARCHAR(255),
    org_itemid INT,
    org_name VARCHAR(255),
    isolate_num INT,
    quantity VARCHAR(50),
    ab_itemid INT,
    ab_name VARCHAR(255),
    dilution_text VARCHAR(50),
    dilution_comparison VARCHAR(10),
    dilution_value VARCHAR(50),
    interpretation VARCHAR(255),
    comments TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE omr (
    subject_id INT NOT NULL,
    chartdate DATE NOT NULL,
    seq_num INT NOT NULL,
    result_name VARCHAR(100) NOT NULL,
    result_value VARCHAR(50),
    PRIMARY KEY (subject_id, chartdate, seq_num, result_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE patients (
    subject_id INT PRIMARY KEY,
    gender CHAR(1) NOT NULL,
    anchor_age INT,
    anchor_year INT,
    anchor_year_group VARCHAR(20),
    dod DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pharmacy (
    subject_id INT NOT NULL,
    hadm_id BIGINT,
    pharmacy_id BIGINT PRIMARY KEY,
    poe_id VARCHAR(50),
    starttime DATETIME,
    stoptime DATETIME,
    medication VARCHAR(255),
    proc_type VARCHAR(50),
    status VARCHAR(100),
    entertime DATETIME,
    verifiedtime DATETIME,
    route VARCHAR(50),
    frequency VARCHAR(50),
    disp_sched VARCHAR(100),
    infusion_type VARCHAR(50),
    sliding_scale VARCHAR(20),
    lockout_interval VARCHAR(50),
    basal_rate VARCHAR(50),
    one_hr_max VARCHAR(50),
    doses_per_24_hrs VARCHAR(50),
    duration VARCHAR(50),
    duration_interval VARCHAR(50),
    expiration_value VARCHAR(50),
    expiration_unit VARCHAR(20),
    expirationdate DATE,
    dispensation VARCHAR(50),
    fill_quantity VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE poe (
    poe_id VARCHAR(50) PRIMARY KEY,
    poe_seq INT,
    subject_id INT NOT NULL,
    hadm_id BIGINT,
    ordertime DATETIME,
    order_type VARCHAR(100),
    order_subtype VARCHAR(100),
    transaction_type VARCHAR(100),
    discontinue_of_poe_id VARCHAR(50),
    discontinued_by_poe_id VARCHAR(50),
    order_provider_id VARCHAR(50),
    order_status VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE poe_detail (
    poe_id VARCHAR(50),
    poe_seq INT,
    subject_id INT NOT NULL,
    field_name VARCHAR(100),
    field_value VARCHAR(255),
    PRIMARY KEY (poe_id, field_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE prescriptions (
    row_id     BIGINT AUTO_INCREMENT PRIMARY KEY,  -- 自動流水號
    subject_id VARCHAR(500),
    hadm_id VARCHAR(500),
    pharmacy_id VARCHAR(500),
    poe_id VARCHAR(500),
    poe_seq VARCHAR(500),
    order_provider_id VARCHAR(500),
    starttime DATETIME,
    stoptime DATETIME,
    drug_type VARCHAR(500),
    drug VARCHAR(500),
    formulary_drug_cd VARCHAR(500),
    gsn VARCHAR(500),
    ndc VARCHAR(50),
    prod_strength VARCHAR(100),
    form_rx VARCHAR(50),
    dose_val_rx VARCHAR(500),
    dose_unit_rx VARCHAR(500),
    form_val_disp VARCHAR(500),
    form_unit_disp VARCHAR(500),
    doses_per_24_hrs VARCHAR(500),
    route VARCHAR(500)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE procedures_icd (
    subject_id INT NOT NULL,
    hadm_id BIGINT NOT NULL,
    seq_num INT,
    chartdate DATE,
    icd_code VARCHAR(20),
    icd_version TINYINT,
    PRIMARY KEY (subject_id, hadm_id, seq_num)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE provider (
    provider_id VARCHAR(10) NOT NULL PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE services (
    row_id     BIGINT AUTO_INCREMENT PRIMARY KEY,  -- 自動流水號
    subject_id      INT NOT NULL,
    hadm_id         INT,
    transfertime    DATETIME,
    prev_service    VARCHAR(10),
    curr_service    VARCHAR(10)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE transfers (
    subject_id     INT NOT NULL,
    hadm_id        INT,
    transfer_id    BIGINT NOT NULL,
    eventtype      VARCHAR(20),
    careunit       VARCHAR(50),
    intime         DATETIME,
    outtime        DATETIME,
    PRIMARY KEY (transfer_id),
    KEY idx_subject_hadm (subject_id, hadm_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE caregiver (
    caregiver_id INT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE chartevents (
    row_id     BIGINT AUTO_INCREMENT PRIMARY KEY,  -- 自動流水號
    subject_id      INT NOT NULL,
    hadm_id         INT,
    stay_id         BIGINT,
    caregiver_id    INT,
    charttime       DATETIME,
    storetime       DATETIME,
    itemid          INT,
    value           VARCHAR(3000),
    valuenum        DECIMAL(10,2),
    valueuom        VARCHAR(32),
    warning         TINYINT,

    INDEX idx_subject_id (subject_id),
    INDEX idx_itemid (itemid),
    INDEX idx_charttime (charttime)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE d_items (
    itemid             INT PRIMARY KEY,
    label              VARCHAR(255),
    abbreviation       VARCHAR(255),
    linksto            VARCHAR(64),
    category           VARCHAR(128),
    unitname           VARCHAR(64),
    param_type         VARCHAR(64),
    lownormalvalue     DECIMAL(10,2),
    highnormalvalue    DECIMAL(10,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE datetimeevents (
    row_id     BIGINT AUTO_INCREMENT PRIMARY KEY,  -- 自動流水號
    subject_id     INT,
    hadm_id        INT,
    stay_id        INT,
    caregiver_id   INT,
    charttime      DATETIME,
    storetime      DATETIME,
    itemid         INT,
    value          DATETIME,
    valueuom       VARCHAR(64),
    warning         VARCHAR(255)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE icustays (
    subject_id      INT,
    hadm_id         INT,
    stay_id         INT PRIMARY KEY,
    first_careunit  VARCHAR(128),
    last_careunit   VARCHAR(128),
    intime          DATETIME,
    outtime         DATETIME,
    los             FLOAT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE ingredientevents (
    subject_id         INT,
    hadm_id            INT,
    stay_id            INT,
    caregiver_id       INT,
    starttime          DATETIME,
    endtime            DATETIME,
    storetime          DATETIME,
    itemid             INT,
    amount             DECIMAL(10,4),
    amountuom          VARCHAR(16),
    rate               VARCHAR(200),
    rateuom            VARCHAR(16),
    orderid            BIGINT,
    linkorderid        BIGINT,
    statusdescription  VARCHAR(32),
    originalamount     DECIMAL(10,4),
    originalrate       DECIMAL(10,4)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE inputevents (
    subject_id                    INT,
    hadm_id                       INT,
    stay_id                       INT,
    caregiver_id                  INT,
    starttime                     DATETIME,
    endtime                       DATETIME,
    storetime                     DATETIME,
    itemid                        INT,
    amount                        DECIMAL(10,4),
    amountuom                     VARCHAR(200),
    rate                          DECIMAL(10,4),
    rateuom                       VARCHAR(16),
    orderid                       BIGINT,
    linkorderid                   BIGINT,
    ordercategoryname             VARCHAR(200),
    secondaryordercategoryname    VARCHAR(200),
    ordercomponenttypedescription VARCHAR(200),
    ordercategorydescription      VARCHAR(200),
    patientweight                 DECIMAL(5,2),
    totalamount                   DECIMAL(10,4),
    totalamountuom                VARCHAR(200),
    isopenbag                     BOOLEAN,
    continueinnextdept            BOOLEAN,
    statusdescription             VARCHAR(200),
    originalamount                DECIMAL(10,4),
    originalrate                  DECIMAL(10,4)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE outputevents (
    subject_id     INT,             -- 病人 ID
    hadm_id        INT,             -- 住院 ID
    stay_id        INT,             -- ICU stay ID
    caregiver_id   INT,             -- 護理人員 ID
    charttime      DATETIME,        -- 紀錄時間
    storetime      DATETIME,        -- 儲存時間
    itemid         INT,             -- 項目 ID（對應 d_items 表）
    value          DECIMAL(10,4),   -- 數值
    valueuom       VARCHAR(16)      -- 單位（如 mL）
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE procedureevents (
    subject_id                INT,              -- 病人 ID
    hadm_id                   INT,              -- 住院 ID
    stay_id                   INT,              -- ICU stay ID
    caregiver_id              INT,              -- 護理人員 ID，可為 NULL
    starttime                 DATETIME,         -- 開始時間
    endtime                   DATETIME,         -- 結束時間
    storetime                 DATETIME,         -- 紀錄儲存時間
    itemid                    INT,              -- 項目 ID（對應 d_items 表）
    value                     DECIMAL(10,4),    -- 值（如執行次數、持續分鐘數等）
    valueuom                  VARCHAR(16),      -- 單位（如 min、None）
    location                  VARCHAR(64),      -- 位置（如 RL Ant Forearm Medial）
    locationcategory          VARCHAR(64),      -- 位置分類（如 Peripheral - old）
    orderid                   INT,              -- 訂單 ID
    linkorderid               INT,              -- 連結訂單 ID
    ordercategoryname         VARCHAR(64),      -- 訂單分類名稱（如 Procedures）
    ordercategorydescription  VARCHAR(64),      -- 訂單細項描述（如 Task）
    patientweight             DECIMAL(10,4),    -- 體重（kg）
    isopenbag                 TINYINT,          -- 是否開袋（布林）
    continueinnextdept        TINYINT,          -- 是否持續到下一科別
    statusdescription         VARCHAR(32),      -- 執行狀態（如 FinishedRunning）
    originalamount            DECIMAL(10,4),    -- 原始下單數量
    originalrate              DECIMAL(10,4)     -- 原始速率
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

