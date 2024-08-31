DROP DATABASE IF EXISTS Hospital;

CREATE DATABASE Hospital CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

USE Hospital;

#3.部別表
CREATE TABLE department(
	部別編號 varchar(6)not null unique primary key,
    部別名稱 varchar(10)
);

#5.服務種類表
CREATE TABLE service_class(
	服務種類編號 varchar(6)not null unique primary key,
    服務種類 varchar(2)
);

#13.基本部分負擔金額表
CREATE TABLE basic_partial_burden(
  基本部分負擔編號 VARCHAR(6) NOT NULL UNIQUE PRIMARY KEY,
  金額 INT,
  備註 varchar(20),
  服務種類編號 varchar(6),
  FOREIGN KEY(服務種類編號) REFERENCES service_class(服務種類編號) ON DELETE CASCADE ON UPDATE CASCADE
);

#15.掛號費用表(更新)
CREATE TABLE registration_fee(
    掛號時段 varchar(4)not null,
    服務種類編號 varchar(6)not null,
    掛號費 int,
    primary key(掛號時段,服務種類編號),
    FOREIGN KEY(服務種類編號) REFERENCES service_class(服務種類編號) ON DELETE CASCADE ON UPDATE CASCADE
);

#4.科別表
CREATE TABLE sessions(
	科別編號 varchar(6)not null unique primary key,
    科別名稱 varchar(20),
    服務種類編號 varchar(6),
    部別編號 varchar(6),
    FOREIGN KEY(服務種類編號) REFERENCES service_class(服務種類編號) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY(部別編號) REFERENCES department(部別編號) ON DELETE SET NULL ON UPDATE CASCADE
);

#2.醫生基本資料表
CREATE TABLE doctor(
	醫生編號 varchar(6)not null unique primary key,
    醫生姓名 varchar(4),
    科別編號 varchar(6),
    FOREIGN KEY(科別編號) REFERENCES sessions(科別編號) ON DELETE SET NULL ON UPDATE CASCADE
);

#6.症狀表
CREATE TABLE symptom(
	症狀編號 varchar(6)not null unique primary key,
    症狀名稱 varchar(10)
);

#7.症狀推薦科別表(更新)
CREATE TABLE symptom_recommend(
    症狀編號 varchar(6) not null,
    科別編號 varchar(6) not null,
    primary key(症狀編號,科別編號),
    FOREIGN KEY(症狀編號) REFERENCES symptom(症狀編號) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(科別編號) REFERENCES sessions(科別編號) ON DELETE CASCADE ON UPDATE CASCADE
);

#1.門診表
CREATE TABLE clinic(
	門診編號 varchar(6)not null unique primary key,
    門診日期 date,
    門診時間 varchar(2),
    門診診間 varchar(4),
    預約上限人數 int,
	醫生編號 varchar(6),
    FOREIGN KEY(醫生編號) REFERENCES doctor(醫生編號) ON DELETE SET NULL ON UPDATE CASCADE
);

#9.優待身分表
CREATE TABLE preferential_identity(
	優待身分編號 varchar(6)not null unique primary key,
    優待身分類別 varchar(20),
    支付掛號費用 varchar(1),
    支付部分負擔費用 varchar(1)
);

#8.病患基本資料表(更新)
CREATE TABLE patient(
	身分證字號 varchar(10)not null unique primary key,
    姓名 varchar(5),
    電話 varchar(12),
    生日 date,
    住址 varchar(20),
    `身高(CM)` float,
    `體重(KG)` float,
    優待身分編號  varchar(6),
    保險類別 VARCHAR(5),
    FOREIGN KEY(優待身分編號) REFERENCES preferential_identity(優待身分編號) ON DELETE SET NULL ON UPDATE CASCADE
);

#10.預約表(更新)
CREATE TABLE appointment(
  就診號碼 VARCHAR(3),
  身分證字號 varchar(10) NOT NULL,
  門診編號 VARCHAR(6)  NOT NULL,
  primary key(身分證字號,門診編號),
  FOREIGN KEY(身分證字號) REFERENCES patient(身分證字號) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(門診編號) REFERENCES clinic(門診編號) ON DELETE CASCADE ON UPDATE CASCADE
);

#12.費用項目表(更新)
CREATE TABLE expense_items(
  費用項目編號 VARCHAR(6) NOT NULL UNIQUE PRIMARY KEY,
  費用項目名稱 VARCHAR(20)
);

#16.費用項目明細表(新增)
CREATE TABLE expense_items_detail(
  費用項目編號 VARCHAR(6) NOT NULL,
  身分證字號 varchar(10) NOT NULL,
  門診編號 VARCHAR(6) NOT NULL,
  金額 INT,
  primary key(費用項目編號,身分證字號,門診編號),
  FOREIGN KEY(費用項目編號) REFERENCES expense_items(費用項目編號) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(身分證字號) REFERENCES appointment(身分證字號) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(門診編號) REFERENCES appointment(門診編號) ON DELETE CASCADE ON UPDATE CASCADE
);

#14.藥品部分負擔金額表
CREATE TABLE medicines_partial_burden(
  藥品部分負擔編號 VARCHAR(6) NOT NULL UNIQUE PRIMARY KEY,
  藥費區間 VARCHAR(10),
  金額 INT
);

#19.藥品廠商表(新增)
CREATE TABLE medicine_suppliers(
  藥商編號 VARCHAR(6)  NOT NULL UNIQUE PRIMARY KEY,
  藥商名稱 VARCHAR(30),
  藥商地址 VARCHAR(20),
  藥商電話 VARCHAR(20)
);

#17.藥品表(新增)
CREATE TABLE medicine(
  藥品許可證字號 VARCHAR(50) NOT NULL UNIQUE PRIMARY KEY,
  `藥品名稱(中文)` VARCHAR(50),
  `藥品名稱(英文)` VARCHAR(100),
  單位劑量  INT,
  單位  VARCHAR(5),
  外觀  VARCHAR(30),
  適應症  VARCHAR(100),
  副作用 VARCHAR(50),
  用法 VARCHAR(20),
  單位藥費 INT,
  藥商編號 VARCHAR(6),
  FOREIGN KEY(藥商編號) REFERENCES medicine_suppliers(藥商編號) ON DELETE CASCADE ON UPDATE CASCADE
);

#18.藥品明細表(新增)
CREATE TABLE medicine_detail(
  藥品許可證字號 VARCHAR(50) NOT NULL,
  身分證字號 varchar(10) NOT NULL,
  門診編號 VARCHAR(6) NOT NULL,
  一次服用量 INT,
  一天服用次數 INT,
  primary key(藥品許可證字號,身分證字號,門診編號),
  FOREIGN KEY(藥品許可證字號) REFERENCES medicine(藥品許可證字號) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(身分證字號) REFERENCES appointment(身分證字號) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(門診編號) REFERENCES appointment(門診編號) ON DELETE CASCADE ON UPDATE CASCADE
);

#3.新增部別資料 department
INSERT INTO department VALUES ('DP0001','內科部');
INSERT INTO department VALUES ('DP0002','外科部');
INSERT INTO department VALUES ('DP0003','小兒部');
INSERT INTO department VALUES ('DP0004','婦產部');
INSERT INTO department VALUES ('DP0005','牙科部');
INSERT INTO department VALUES ('DP0006','其他專部');

#5.新增服務種類資料 service_class
INSERT INTO service_class VALUES ('SC0001','西醫');
INSERT INTO service_class VALUES ('SC0002','牙醫');
INSERT INTO service_class VALUES ('SC0003','中醫');

#13.新增基本部分負擔金額資料 basic_partial_burden
INSERT INTO basic_partial_burden VALUES ('BP0001',170,'經轉診','SC0001');
INSERT INTO basic_partial_burden VALUES ('BP0002',420,'未經轉診','SC0001');
INSERT INTO basic_partial_burden VALUES ('BP0003',50,'無','SC0002');
INSERT INTO basic_partial_burden VALUES ('BP0004',50,'無','SC0003');

#15.新增掛號費用資料 registration_fee(更新)
INSERT INTO registration_fee VALUES ('夜間門診','SC0001',200);
INSERT INTO registration_fee VALUES ('週六門診','SC0001',200);
INSERT INTO registration_fee VALUES ('其它時段','SC0001',150);
INSERT INTO registration_fee VALUES ('夜間門診','SC0002',200);
INSERT INTO registration_fee VALUES ('週六門診','SC0002',200);
INSERT INTO registration_fee VALUES ('其它時段','SC0002',150);
INSERT INTO registration_fee VALUES ('夜間門診','SC0003',200);
INSERT INTO registration_fee VALUES ('週六門診','SC0003',200);
INSERT INTO registration_fee VALUES ('其它時段','SC0003',150);

#4.新增科別資料 sessions
INSERT INTO sessions VALUES ('SS0001','新陳代謝科','SC0001','DP0001');
INSERT INTO sessions VALUES ('SS0002','肝膽腸胃科','SC0001','DP0001');
INSERT INTO sessions VALUES ('SS0003','腎臟內科','SC0001','DP0001');
INSERT INTO sessions VALUES ('SS0004','胸腔內科','SC0001','DP0001');
INSERT INTO sessions VALUES ('SS0005','過敏免疫風濕科','SC0001','DP0001');
INSERT INTO sessions VALUES ('SS0006','感染防疫科','SC0001','DP0001');
INSERT INTO sessions VALUES ('SS0007','一般醫學科','SC0001','DP0001');
INSERT INTO sessions VALUES ('SS0008','神經醫學科','SC0001','DP0001');
INSERT INTO sessions VALUES ('SS0009','一般外科','SC0001','DP0002');
INSERT INTO sessions VALUES ('SS0010','神經外科','SC0001','DP0002');
INSERT INTO sessions VALUES ('SS0011','整型外科','SC0001','DP0002');
INSERT INTO sessions VALUES ('SS0012','重建外科','SC0001','DP0002');
INSERT INTO sessions VALUES ('SS0013','胸腔外科','SC0001','DP0002');
INSERT INTO sessions VALUES ('SS0014','泌尿科','SC0001','DP0002');
INSERT INTO sessions VALUES ('SS0015','大腸直腸外科','SC0001','DP0002');
INSERT INTO sessions VALUES ('SS0016','骨科','SC0001','DP0002');
INSERT INTO sessions VALUES ('SS0017','小兒外科','SC0001','DP0002');
INSERT INTO sessions VALUES ('SS0018','一般兒科','SC0001','DP0003');
INSERT INTO sessions VALUES ('SS0019','新生兒科','SC0001','DP0003');
INSERT INTO sessions VALUES ('SS0020','小兒神經科','SC0001','DP0003');
INSERT INTO sessions VALUES ('SS0021','小兒心臟科','SC0001','DP0003');
INSERT INTO sessions VALUES ('SS0022','小兒腸胃科','SC0001','DP0003');
INSERT INTO sessions VALUES ('SS0023','小兒腫瘤科','SC0001','DP0003');
INSERT INTO sessions VALUES ('SS0024','小兒遺傳內分泌科','SC0001','DP0003');
INSERT INTO sessions VALUES ('SS0025','小兒腎臟內科','SC0001','DP0003');
INSERT INTO sessions VALUES ('SS0026','小兒過敏免疫風濕科','SC0001','DP0003');
INSERT INTO sessions VALUES ('SS0027','婦產科','SC0001','DP0004');
INSERT INTO sessions VALUES ('SS0028','婦癌科','SC0001','DP0004');
INSERT INTO sessions VALUES ('SS0029','不孕症科','SC0001','DP0004');
INSERT INTO sessions VALUES ('SS0030','牙科','SC0002','DP0005');
INSERT INTO sessions VALUES ('SS0031','牙周病科','SC0002','DP0005');
INSERT INTO sessions VALUES ('SS0032','兒童牙科','SC0002','DP0005');
INSERT INTO sessions VALUES ('SS0033','牙髓病科','SC0002','DP0005');
INSERT INTO sessions VALUES ('SS0034','口腔顎面外科','SC0002','DP0005');
INSERT INTO sessions VALUES ('SS0035','齒顎矯正科','SC0002','DP0005');
INSERT INTO sessions VALUES ('SS0036','皮膚科','SC0001','DP0006');
INSERT INTO sessions VALUES ('SS0037','耳鼻喉科暨頭頸外科','SC0001','DP0006');
INSERT INTO sessions VALUES ('SS0038','眼科','SC0001','DP0006');
INSERT INTO sessions VALUES ('SS0039','精神科','SC0001','DP0006');
INSERT INTO sessions VALUES ('SS0040','影像醫學科','SC0001','DP0006');
INSERT INTO sessions VALUES ('SS0041','放射腫瘤科','SC0001','DP0006');
INSERT INTO sessions VALUES ('SS0042','營養科','SC0001','DP0006');
INSERT INTO sessions VALUES ('SS0043','復健科','SC0001','DP0006');
INSERT INTO sessions VALUES ('SS0044','傳統醫學科','SC0003','DP0006');

#2.新增醫生基本資料 doctor
INSERT INTO doctor VALUES ('DC0001','吳俊憲','SS0022');
INSERT INTO doctor VALUES ('DC0002','趙又愛','SS0006');
INSERT INTO doctor VALUES ('DC0003','吳威宇','SS0009');
INSERT INTO doctor VALUES ('DC0004','鄭任火','SS0005');
INSERT INTO doctor VALUES ('DC0005','許佐發','SS0007');
INSERT INTO doctor VALUES ('DC0006','黃祐誠','SS0012');
INSERT INTO doctor VALUES ('DC0007','林哲豪','SS0017');
INSERT INTO doctor VALUES ('DC0008','陳萬華','SS0010');
INSERT INTO doctor VALUES ('DC0009','李為佐','SS0023');
INSERT INTO doctor VALUES ('DC0010','邱睿俊','SS0027');
INSERT INTO doctor VALUES ('DC0011','朱宛梅','SS0020');
INSERT INTO doctor VALUES ('DC0012','楊山珮','SS0029');
INSERT INTO doctor VALUES ('DC0013','賴幸雲','SS0008');
INSERT INTO doctor VALUES ('DC0014','袁柏宏','SS0015');
INSERT INTO doctor VALUES ('DC0015','黃鈺揚','SS0024');
INSERT INTO doctor VALUES ('DC0016','王淑雲','SS0004');
INSERT INTO doctor VALUES ('DC0017','李俊雄','SS0013');
INSERT INTO doctor VALUES ('DC0018','蔡乃城','SS0026');
INSERT INTO doctor VALUES ('DC0019','陳雅芳','SS0030');
INSERT INTO doctor VALUES ('DC0020','陳韋婷','SS0014');
INSERT INTO doctor VALUES ('DC0021','周建志','SS0001');
INSERT INTO doctor VALUES ('DC0022','蔣懿屏','SS0003');
INSERT INTO doctor VALUES ('DC0023','陳姿君','SS0018');
INSERT INTO doctor VALUES ('DC0024','李丹誠','SS0025');
INSERT INTO doctor VALUES ('DC0025','鄭慧君','SS0011');
INSERT INTO doctor VALUES ('DC0026','李彥霖','SS0016');
INSERT INTO doctor VALUES ('DC0027','林瑜銘','SS0019');
INSERT INTO doctor VALUES ('DC0028','蘇萱青','SS0021');
INSERT INTO doctor VALUES ('DC0029','卞郁文','SS0028');
INSERT INTO doctor VALUES ('DC0030','方樂昕','SS0008');

#6.新增症狀資料 symptom
INSERT INTO symptom VALUES ('ST0001','頭痛');
INSERT INTO symptom VALUES ('ST0002','頭暈');
INSERT INTO symptom VALUES ('ST0003','嘔吐');
INSERT INTO symptom VALUES ('ST0004','眼部不適');
INSERT INTO symptom VALUES ('ST0005','口腔不適');
INSERT INTO symptom VALUES ('ST0006','聽力障礙');
INSERT INTO symptom VALUES ('ST0007','頸部不適');
INSERT INTO symptom VALUES ('ST0008','咳嗽');
INSERT INTO symptom VALUES ('ST0009','呼吸困難');
INSERT INTO symptom VALUES ('ST0010','胸痛胸悶');
INSERT INTO symptom VALUES ('ST0011','乳房腫痛');
INSERT INTO symptom VALUES ('ST0012','腹痛腹瀉');
INSERT INTO symptom VALUES ('ST0013','腰背疼痛');
INSERT INTO symptom VALUES ('ST0014','四肢麻木無力');
INSERT INTO symptom VALUES ('ST0015','疲倦');
INSERT INTO symptom VALUES ('ST0016','水腫');
INSERT INTO symptom VALUES ('ST0017','不明瘀青');
INSERT INTO symptom VALUES ('ST0018','肥胖');
INSERT INTO symptom VALUES ('ST0019','黃疸');
INSERT INTO symptom VALUES ('ST0020','狐臭');
INSERT INTO symptom VALUES ('ST0021','關節痛');
INSERT INTO symptom VALUES ('ST0022','尿液異常');
INSERT INTO symptom VALUES ('ST0023','睡眠障礙');
INSERT INTO symptom VALUES ('ST0024','傷口癒合不良');

#7.新增症狀推薦科別資料 symptom_recommend(更新)
INSERT INTO symptom_recommend VALUES ('ST0001','SS0008');
INSERT INTO symptom_recommend VALUES ('ST0001','SS0020');
INSERT INTO symptom_recommend VALUES ('ST0001','SS0039');
INSERT INTO symptom_recommend VALUES ('ST0001','SS0044');
INSERT INTO symptom_recommend VALUES ('ST0002','SS0008');
INSERT INTO symptom_recommend VALUES ('ST0002','SS0020');
INSERT INTO symptom_recommend VALUES ('ST0002','SS0039');
INSERT INTO symptom_recommend VALUES ('ST0002','SS0044');
INSERT INTO symptom_recommend VALUES ('ST0003','SS0007');
INSERT INTO symptom_recommend VALUES ('ST0003','SS0037');
INSERT INTO symptom_recommend VALUES ('ST0003','SS0002');
INSERT INTO symptom_recommend VALUES ('ST0004','SS0038');
INSERT INTO symptom_recommend VALUES ('ST0005','SS0007');
INSERT INTO symptom_recommend VALUES ('ST0005','SS0009');
INSERT INTO symptom_recommend VALUES ('ST0005','SS0011');
INSERT INTO symptom_recommend VALUES ('ST0005','SS0030');
INSERT INTO symptom_recommend VALUES ('ST0005','SS0037');
INSERT INTO symptom_recommend VALUES ('ST0006','SS0037');
INSERT INTO symptom_recommend VALUES ('ST0007','SS0008');
INSERT INTO symptom_recommend VALUES ('ST0007','SS0011');
INSERT INTO symptom_recommend VALUES ('ST0007','SS0016');
INSERT INTO symptom_recommend VALUES ('ST0007','SS0017');
INSERT INTO symptom_recommend VALUES ('ST0007','SS0037');
INSERT INTO symptom_recommend VALUES ('ST0007','SS0043');
INSERT INTO symptom_recommend VALUES ('ST0008','SS0004');
INSERT INTO symptom_recommend VALUES ('ST0008','SS0005');
INSERT INTO symptom_recommend VALUES ('ST0008','SS0007');
INSERT INTO symptom_recommend VALUES ('ST0008','SS0013');
INSERT INTO symptom_recommend VALUES ('ST0008','SS0037');
INSERT INTO symptom_recommend VALUES ('ST0009','SS0004');
INSERT INTO symptom_recommend VALUES ('ST0009','SS0037');
INSERT INTO symptom_recommend VALUES ('ST0010','SS0004');
INSERT INTO symptom_recommend VALUES ('ST0010','SS0013');
INSERT INTO symptom_recommend VALUES ('ST0010','SS0017');
INSERT INTO symptom_recommend VALUES ('ST0010','SS0044');
INSERT INTO symptom_recommend VALUES ('ST0011','SS0009');
INSERT INTO symptom_recommend VALUES ('ST0011','SS0027');
INSERT INTO symptom_recommend VALUES ('ST0011','SS0041');
INSERT INTO symptom_recommend VALUES ('ST0012','SS0002');
INSERT INTO symptom_recommend VALUES ('ST0012','SS0009');
INSERT INTO symptom_recommend VALUES ('ST0012','SS0015');
INSERT INTO symptom_recommend VALUES ('ST0012','SS0027');
INSERT INTO symptom_recommend VALUES ('ST0012','SS0044');
INSERT INTO symptom_recommend VALUES ('ST0013','SS0005');
INSERT INTO symptom_recommend VALUES ('ST0013','SS0008');
INSERT INTO symptom_recommend VALUES ('ST0013','SS0010');
INSERT INTO symptom_recommend VALUES ('ST0013','SS0016');
INSERT INTO symptom_recommend VALUES ('ST0013','SS0043');
INSERT INTO symptom_recommend VALUES ('ST0014','SS0008');
INSERT INTO symptom_recommend VALUES ('ST0014','SS0010');
INSERT INTO symptom_recommend VALUES ('ST0014','SS0016');
INSERT INTO symptom_recommend VALUES ('ST0014','SS0043');
INSERT INTO symptom_recommend VALUES ('ST0015','SS0001');
INSERT INTO symptom_recommend VALUES ('ST0015','SS0002');
INSERT INTO symptom_recommend VALUES ('ST0015','SS0003');
INSERT INTO symptom_recommend VALUES ('ST0015','SS0008');
INSERT INTO symptom_recommend VALUES ('ST0015','SS0039');
INSERT INTO symptom_recommend VALUES ('ST0016','SS0003');
INSERT INTO symptom_recommend VALUES ('ST0016','SS0044');
INSERT INTO symptom_recommend VALUES ('ST0017','SS0007');
INSERT INTO symptom_recommend VALUES ('ST0018','SS0001');
INSERT INTO symptom_recommend VALUES ('ST0018','SS0002');
INSERT INTO symptom_recommend VALUES ('ST0018','SS0018');
INSERT INTO symptom_recommend VALUES ('ST0018','SS0044');
INSERT INTO symptom_recommend VALUES ('ST0019','SS0002');
INSERT INTO symptom_recommend VALUES ('ST0019','SS0009');
INSERT INTO symptom_recommend VALUES ('ST0020','SS0011');
INSERT INTO symptom_recommend VALUES ('ST0020','SS0013');
INSERT INTO symptom_recommend VALUES ('ST0020','SS0036');
INSERT INTO symptom_recommend VALUES ('ST0021','SS0005');
INSERT INTO symptom_recommend VALUES ('ST0021','SS0016');
INSERT INTO symptom_recommend VALUES ('ST0021','SS0043');
INSERT INTO symptom_recommend VALUES ('ST0022','SS0003');
INSERT INTO symptom_recommend VALUES ('ST0022','SS0014');
INSERT INTO symptom_recommend VALUES ('ST0022','SS0027');
INSERT INTO symptom_recommend VALUES ('ST0023','SS0039');
INSERT INTO symptom_recommend VALUES ('ST0023','SS0004');
INSERT INTO symptom_recommend VALUES ('ST0024','SS0006');
INSERT INTO symptom_recommend VALUES ('ST0024','SS0009');
INSERT INTO symptom_recommend VALUES ('ST0024','SS0011');

#1.新增門診資料
INSERT INTO clinic VALUES ('CN0001','2023-3-23','上午','D405',60,'DC0026');
INSERT INTO clinic VALUES ('CN0002','2023-3-23','上午','C304',70,'DC0025');
INSERT INTO clinic VALUES ('CN0003','2023-3-23','上午','D406',60,'DC0016');
INSERT INTO clinic VALUES ('CN0004','2023-3-23','上午','D403',70,'DC0002');
INSERT INTO clinic VALUES ('CN0005','2023-3-23','上午','C303',80,'DC0027');
INSERT INTO clinic VALUES ('CN0006','2023-3-23','上午','C306',60,'DC0028');
INSERT INTO clinic VALUES ('CN0007','2023-3-23','上午','E301',70,'DC0014');
INSERT INTO clinic VALUES ('CN0008','2023-3-23','上午','D407',60,'DC0001');
INSERT INTO clinic VALUES ('CN0009','2023-3-23','上午','A201',90,'DC0005');
INSERT INTO clinic VALUES ('CN0010','2023-3-23','下午','B207',80,'DC0017');
INSERT INTO clinic VALUES ('CN0011','2023-3-23','下午','A203',50,'DC0007');
INSERT INTO clinic VALUES ('CN0012','2023-3-23','下午','B201',40,'DC0006');
INSERT INTO clinic VALUES ('CN0013','2023-3-23','下午','C308',50,'DC0019');
INSERT INTO clinic VALUES ('CN0014','2023-3-24','下午','C305',70,'DC0011');
INSERT INTO clinic VALUES ('CN0015','2023-3-24','下午','D404',30,'DC0018');
INSERT INTO clinic VALUES ('CN0016','2023-3-24','下午','B204',40,'DC0029');
INSERT INTO clinic VALUES ('CN0017','2023-3-24','下午','B202',50,'DC0009');
INSERT INTO clinic VALUES ('CN0018','2023-3-24','下午','D401',60,'DC0013');
INSERT INTO clinic VALUES ('CN0019','2023-3-24','下午','A202',70,'DC0003');
INSERT INTO clinic VALUES ('CN0020','2023-3-24','下午','C302',80,'DC0008');
INSERT INTO clinic VALUES ('CN0021','2023-3-24','下午','B206',90,'DC0012');
INSERT INTO clinic VALUES ('CN0022','2023-3-24','下午','C307',40,'DC0023');
INSERT INTO clinic VALUES ('CN0023','2023-3-24','晚間','A205',50,'DC0020');
INSERT INTO clinic VALUES ('CN0024','2023-3-25','晚間','C301',60,'DC0024');
INSERT INTO clinic VALUES ('CN0025','2023-3-25','晚間','E303',70,'DC0015');
INSERT INTO clinic VALUES ('CN0026','2023-3-25','晚間','A204',80,'DC0010');
INSERT INTO clinic VALUES ('CN0027','2023-3-25','晚間','E302',90,'DC0004');
INSERT INTO clinic VALUES ('CN0028','2023-3-25','晚間','B205',40,'DC0022');
INSERT INTO clinic VALUES ('CN0029','2023-3-25','晚間','D402',50,'DC0030');
INSERT INTO clinic VALUES ('CN0030','2023-3-25','晚間','B203',60,'DC0021');
INSERT INTO clinic VALUES ('CN0031','2023-3-25','晚間','D405',40,'DC0026');

#9.新增優待身分資料 preferential_identity
INSERT INTO preferential_identity VALUES ('PI0001','持慢性病連續處方箋領藥者','無','有');
INSERT INTO preferential_identity VALUES ('PI0002','百歲人瑞','無','無');
INSERT INTO preferential_identity VALUES ('PI0003','重大傷病','有','無');
INSERT INTO preferential_identity VALUES ('PI0004','分娩','有','無');
INSERT INTO preferential_identity VALUES ('PI0005','山地離島地區就醫者','有','無');
INSERT INTO preferential_identity VALUES ('PI0006','榮民','有','無');
INSERT INTO preferential_identity VALUES ('PI0007','榮民遺眷之家戶代表','有','無');
INSERT INTO preferential_identity VALUES ('PI0008','低收入戶','有','無');
INSERT INTO preferential_identity VALUES ('PI0009','3歲以下兒童','有','無');
INSERT INTO preferential_identity VALUES ('PI0010','勞保被保險人因職業傷病就醫','有','無');
INSERT INTO preferential_identity VALUES ('PI0011','服役期間持有役男身分證之替代役役男','有','無');
INSERT INTO preferential_identity VALUES ('PI0012','無','有','有');

#8.新增病患基本資料 patient(更新)
INSERT INTO patient VALUES ('N123450001','林世一','0951-000-001','1987/1/1','桃園市中壢區中北路200號',174.1,65.1,'PI0012','健保');
INSERT INTO patient VALUES ('N123450002','林世二','0951-000-002','1987/1/2','新北市新莊區和平路100號',174.2,65.2,'PI0001','健保');
INSERT INTO patient VALUES ('N123450003','林世三','0951-000-003','1987/1/3','台中市西屯區中北路400號',174.3,65.3,'PI0002','健保');
INSERT INTO patient VALUES ('N123450004','林世四','0951-000-004','1987/1/4','桃園市中壢區西北路200號',174.4,65.4,'PI0003','健保');
INSERT INTO patient VALUES ('N123450005','林世五','0951-000-005','1987/1/5','台北市天下區南北路200號',174.5,65.5,'PI0004','健保');
INSERT INTO patient VALUES ('N123450006','林世六','0951-000-006','1987/1/6','新北市仁義區東北路700號',174.6,65.6,'PI0005','健保');
INSERT INTO patient VALUES ('N123450007','林世七','0951-000-007','1987/1/7','桃園市中壢區中北路201號',174.7,65.7,'PI0012','健保');
INSERT INTO patient VALUES ('N123450008','林世八','0951-000-008','1987/1/8','新北市新莊區和平路101號',174.8,65.8,'PI0006','健保');
INSERT INTO patient VALUES ('N123450009','林世九','0951-000-009','1987/1/9','台中市西屯區中北路401號',174.9,65.9,'PI0012','健保');
INSERT INTO patient VALUES ('N123450010','林一零','0951-000-010','1987/1/10','桃園市中壢區西北路201號',175.0,66.0,'PI0008','健保');
INSERT INTO patient VALUES ('N123450011','林一一','0951-000-011','1987/1/11','台北市天下區南北路201號',175.1,66.1,'PI0009','健保');
INSERT INTO patient VALUES ('N123450012','林一二','0951-000-012','1987/1/12','新北市仁義區東北路701號',175.2,66.2,'PI0010','健保');
INSERT INTO patient VALUES ('N123450013','林一三','0951-000-013','1987/1/13','桃園市中壢區中北路202號',175.3,66.3,'PI0011','健保');
INSERT INTO patient VALUES ('N123450014','林一四','0951-000-014','1987/1/14','新北市新莊區和平路102號',175.4,66.4,'PI0012','健保');
INSERT INTO patient VALUES ('N123450015','林一五','0951-000-015','1987/1/15','台中市西屯區中北路402號',175.5,66.5,'PI0001','健保');
INSERT INTO patient VALUES ('N123450016','林一六','0951-000-016','1987/1/16','桃園市中壢區西北路202號',175.6,66.6,'PI0002','健保');
INSERT INTO patient VALUES ('N123450017','林一七','0951-000-017','1987/1/17','台北市天下區南北路202號',175.7,66.7,'PI0003','健保');
INSERT INTO patient VALUES ('N123450018','林一八','0951-000-018','1987/1/18','新北市仁義區東北路702號',175.8,66.8,'PI0004','健保');
INSERT INTO patient VALUES ('N123450019','林一九','0951-000-019','1987/1/19','桃園市中壢區中北路203號',175.9,66.9,'PI0012','健保');
INSERT INTO patient VALUES ('N123450020','林二零','0951-000-020','1987/1/20','新北市新莊區和平路103號',176.0,67.0,'PI0012','健保');
INSERT INTO patient VALUES ('N123450021','林二一','0951-000-021','1987/1/21','台中市西屯區中北路403號',176.1,67.1,'PI0006','健保');
INSERT INTO patient VALUES ('N123450022','林二二','0951-000-022','1987/1/22','桃園市中壢區西北路203號',176.2,67.2,'PI0007','健保');
INSERT INTO patient VALUES ('N123450023','林二三','0951-000-023','1987/1/23','台北市天下區南北路203號',176.3,67.3,'PI0008','健保');
INSERT INTO patient VALUES ('N123450024','林二四','0951-000-024','1987/1/24','新北市仁義區東北路703號',176.4,67.4,'PI0009','健保');
INSERT INTO patient VALUES ('N123450025','林二五','0951-000-025','1987/1/25','桃園市中壢區中北路204號',176.5,67.5,'PI0010','健保');
INSERT INTO patient VALUES ('N123450026','林二六','0951-000-026','1987/1/26','新北市新莊區和平路104號',176.6,67.6,'PI0011','健保');
INSERT INTO patient VALUES ('N123450027','林二七','0951-000-027','1987/1/27','新北市新莊區和平路105號',176.7,67.7,'PI0009','健保');
INSERT INTO patient VALUES ('N123450028','林二八','0951-000-028','1987/1/28','新北市新莊區和平路106號',176.8,67.8,'PI0012','自費');
INSERT INTO patient VALUES ('N123450029','林二九','0951-000-029','1987/1/29','新北市新莊區和平路107號',176.9,67.9,'PI0012','自費');
INSERT INTO patient VALUES ('N123450030','林三零','0951-000-030','1987/1/30','新北市新莊區和平路108號',176.9,67.9,'PI0012','自費');

#10.新增預約資料 appointment;(更新)
INSERT INTO appointment VALUES (1,'N123450011','CN0029');
INSERT INTO appointment VALUES (1,'N123450028','CN0015');
INSERT INTO appointment VALUES (2,'N123450026','CN0017');
INSERT INTO appointment VALUES (1,'N123450007','CN0018');
INSERT INTO appointment VALUES (1,'N123450017','CN0002');
INSERT INTO appointment VALUES (2,'N123450021','CN0018');
INSERT INTO appointment VALUES (1,'N123450025','CN0020');
INSERT INTO appointment VALUES (1,'N123450002','CN0013');
INSERT INTO appointment VALUES (2,'N123450027','CN0015');
INSERT INTO appointment VALUES (1,'N123450004','CN0023');
INSERT INTO appointment VALUES (1,'N123450015','CN0006');
INSERT INTO appointment VALUES (1,'N123450030','CN0022');
INSERT INTO appointment VALUES (3,'N123450006','CN0015');
INSERT INTO appointment VALUES (1,'N123450029','CN0028');
INSERT INTO appointment VALUES (1,'N123450001','CN0025');
INSERT INTO appointment VALUES (1,'N123450009','CN0024');
INSERT INTO appointment VALUES (3,'N123450012','CN0018');
INSERT INTO appointment VALUES (1,'N123450008','CN0004');
INSERT INTO appointment VALUES (1,'N123450013','CN0007');
INSERT INTO appointment VALUES (4,'N123450023','CN0015');
INSERT INTO appointment VALUES (1,'N123450003','CN0003');
INSERT INTO appointment VALUES (1,'N123450010','CN0026');
INSERT INTO appointment VALUES (1,'N123450014','CN0009');
INSERT INTO appointment VALUES (1,'N123450022','CN0005');
INSERT INTO appointment VALUES (1,'N123450018','CN0008');
INSERT INTO appointment VALUES (2,'N123450020','CN0029');
INSERT INTO appointment VALUES (1,'N123450024','CN0012');
INSERT INTO appointment VALUES (5,'N123450019','CN0015');
INSERT INTO appointment VALUES (1,'N123450005','CN0030');
INSERT INTO appointment VALUES (6,'N123450016','CN0015');

#12.新增費用項目資料 expense_items(更新)
INSERT INTO expense_items VALUES ('EI0001','診察費');
INSERT INTO expense_items VALUES ('EI0002','藥品費');
INSERT INTO expense_items VALUES ('EI0003','X光診斷費');
INSERT INTO expense_items VALUES ('EI0004','材料費');
INSERT INTO expense_items VALUES ('EI0005','證明書費');
INSERT INTO expense_items VALUES ('EI0006','物理治療費');
INSERT INTO expense_items VALUES ('EI0007','處方調劑費');
INSERT INTO expense_items VALUES ('EI0008','處置手術費');
INSERT INTO expense_items VALUES ('EI0009','放射線治療費');
INSERT INTO expense_items VALUES ('EI0010','檢驗檢查費');
INSERT INTO expense_items VALUES ('EI0011','體檢伙食費');
INSERT INTO expense_items VALUES ('EI0012','藥事服務費');
INSERT INTO expense_items VALUES ('EI0013','注射費');
INSERT INTO expense_items VALUES ('EI0014','衛材費');
INSERT INTO expense_items VALUES ('EI0015','差額負擔');
INSERT INTO expense_items VALUES ('EI0016','其他項目');

#16.新增費用項目明細表資料expense_items_detail(新增)
INSERT INTO expense_items_detail VALUES ('EI0001','N123450011','CN0029',100);
INSERT INTO expense_items_detail VALUES ('EI0002','N123450011','CN0029',200);
INSERT INTO expense_items_detail VALUES ('EI0005','N123450011','CN0029',400);
INSERT INTO expense_items_detail VALUES ('EI0001','N123450029','CN0028',300);
INSERT INTO expense_items_detail VALUES ('EI0002','N123450029','CN0028',500);
INSERT INTO expense_items_detail VALUES ('EI0003','N123450029','CN0028',600);
INSERT INTO expense_items_detail VALUES ('EI0004','N123450029','CN0028',100);
INSERT INTO expense_items_detail VALUES ('EI0006','N123450029','CN0028',800);
INSERT INTO expense_items_detail VALUES ('EI0014','N123450029','CN0028',900);

#14.新增藥品部分負擔金額資料 medicines_partial_burden
INSERT INTO medicines_partial_burden VALUES ('MP0001','100元以下',0);
INSERT INTO medicines_partial_burden VALUES ('MP0002','101-200元',20);
INSERT INTO medicines_partial_burden VALUES ('MP0003','201-300元',40);
INSERT INTO medicines_partial_burden VALUES ('MP0004','301-400元',60);
INSERT INTO medicines_partial_burden VALUES ('MP0005','401-500元',80);
INSERT INTO medicines_partial_burden VALUES ('MP0006','501-600元',100);
INSERT INTO medicines_partial_burden VALUES ('MP0007','601-700元',120);
INSERT INTO medicines_partial_burden VALUES ('MP0008','701-800元',140);
INSERT INTO medicines_partial_burden VALUES ('MP0009','801-900元',160);
INSERT INTO medicines_partial_burden VALUES ('MP0010','901-1000元',180);
INSERT INTO medicines_partial_burden VALUES ('MP0011','1001元以上',200);

#19.新增藥品廠商表資料medicine_suppliers(新增)
INSERT INTO medicine_suppliers VALUES ('MS0001','杏輝藥品工業股份有限公司','宜蘭縣冬山鄉中山村中山路８４號','02-12340001');
INSERT INTO medicine_suppliers VALUES ('MS0002','榮民製藥股份有限公司','桃園市中壢區中山東路３段４４７號','02-12340002');
INSERT INTO medicine_suppliers VALUES ('MS0003','健喬信元醫藥生技股份有限公司健喬廠','新竹縣湖口鄉中興村工業一路６號','02-12340003');

#17.新增藥品表資料medicine(新增)
INSERT INTO medicine VALUES ('衛署藥製字第019420號','"杏輝" 痛疏達膜衣錠500毫克（每非那）','PONSTAL F.C. TABLETS 500MG "SINPHAR" (MEFENAMIC ACID)',500,'毫克','黃色長橢圓錠','解除急、慢性之輕、中度疼痛（包括頭痛、牙痛、月經痛、耳痛、外傷性、關節炎性及肌肉性疼痛、手術後及產後之疼痛）','噁心、腹痛、腹瀉','口服',30,'MS0001');
INSERT INTO medicine VALUES ('衛署藥製字第023239號 ','"信東" 安謀黴素膠囊500毫克','AMOXICILLIN CAPSULES 500MG "TBC."',500,'毫克','常圓柱形紅黃膠囊','葡萄球菌、鏈球菌、肺炎雙炎菌、腦膜炎球菌及其他具有感受性細菌引起之感染症','輕微腹瀉、頭痛','口服',40,'MS0002');
INSERT INTO medicine VALUES ('衛署藥製字第045993號','愛克痰發泡錠600毫克','ACTEIN EFFERVESCENT TABLETS 600MG',600,'毫克','白色圓錠，一面帶「SYG」字樣','少呼吸道粘膜分泌的粘稠性、蓄意或偶發之 ACETAMINOPHEN中毒之解毒劑。','偶爾發生胃腸障礙如噁心或嘔吐， 極少出現諸如皮疹或支氣管痙攣等過敏反應','加水溶解服用',50,'MS0003');

#18.新增藥品明細表資料medicine_detail(新增)
INSERT INTO medicine_detail VALUES ('衛署藥製字第019420號','N123450011','CN0029',1,3);
INSERT INTO medicine_detail VALUES ('衛署藥製字第023239號 ','N123450011','CN0029',1,3);
INSERT INTO medicine_detail VALUES ('衛署藥製字第045993號','N123450029','CN0028',1,1);


#病人操作
#(1) 查詢頭痛的症狀屬於哪些科別
delimiter $$
create procedure symptom_for_sessions(symptom_name varchar(10))
begin
	SELECT symptom.症狀名稱, sessions.科別名稱
	FROM symptom_recommend
	INNER JOIN sessions ON symptom_recommend.科別編號 = sessions.科別編號
	INNER JOIN symptom ON symptom_recommend.症狀編號 = symptom.症狀編號
	WHERE symptom.症狀名稱 = symptom_name;
end$$
delimiter ;

call symptom_for_sessions("頭痛");

#(2) 選擇神經醫學科，查詢神經醫學科的所有醫生
delimiter $$
create procedure doctors_in_sessions(sessions_name varchar(20))
begin
	SELECT sessions.科別名稱, doctor.醫生姓名
	FROM doctor
	INNER JOIN sessions ON doctor.科別編號 = sessions.科別編號
	WHERE sessions.科別名稱 = sessions_name;
end$$
delimiter ;

call doctors_in_sessions("神經醫學科");

#(3)選擇方樂昕醫生，查詢方樂昕醫生的門診時間
delimiter $$
create procedure doctors_clinic(doctors_name varchar(4))
begin
	SELECT doctor.醫生姓名, sessions.科別名稱,clinic.門診日期,clinic.門診時間,clinic.門診診間,clinic.預約上限人數
	FROM clinic
	INNER JOIN doctor ON clinic.醫生編號 = doctor.醫生編號
	INNER JOIN sessions ON doctor.科別編號 = sessions.科別編號
	WHERE doctor.醫生姓名 = doctors_name;
end$$
delimiter ;

call doctors_clinic("方樂昕");

#(4)確定預約，查詢身分證字號為N123450011的姓名、預約門診、就診號碼
delimiter $$
create procedure patient_appointment(patientID varchar(10))
begin
	SELECT patient.姓名,doctor.醫生姓名,sessions.科別名稱,appointment.就診號碼,clinic.門診診間,clinic.門診日期,clinic.門診時間
	FROM patient
	INNER JOIN appointment ON appointment.身分證字號 = patient.身分證字號
	INNER JOIN clinic ON clinic.門診編號 = appointment.門診編號
	INNER JOIN doctor ON doctor.醫生編號 = clinic.醫生編號
	INNER JOIN sessions ON sessions.科別編號 = doctor.科別編號
	WHERE patient.身分證字號 = patientID;
end$$
delimiter ;

call patient_appointment("N123450011");

#(5)看診完，醫生開立的藥事單
drop view if exists prescriptions;
create view prescriptions as
select medicine_detail.身分證字號, medicine_detail.門診編號, medicine.`藥品名稱(英文)`, medicine_detail.一次服用量,
medicine_detail.一天服用次數, (medicine_detail.一次服用量 * medicine_detail.一天服用次數) as 總量,
(medicine_detail.一次服用量 * medicine_detail.一天服用次數 * medicine.單位藥費) as 每種藥品藥費
from medicine_detail
join medicine on medicine_detail.藥品許可證字號 = medicine.藥品許可證字號;

#身分證字號為N123450011、門診編號為CN0029，當次看診的藥事單
DELIMITER $$
DROP PROCEDURE IF EXISTS prescriptions_for_clinic; $$
CREATE PROCEDURE prescriptions_for_clinic (IN 身分證字號 varchar(10),IN 門診編號 VARCHAR(6))
BEGIN

    select prescriptions.`藥品名稱(英文)`, prescriptions.一次服用量,
	prescriptions.一天服用次數, prescriptions.總量,
	prescriptions.每種藥品藥費
	from prescriptions
    where 身分證字號 = prescriptions.身分證字號
    and 門診編號=prescriptions.門診編號;
    
END $$
DELIMITER ;

call prescriptions_for_clinic ('N123450011','CN0029');

delimiter $$
create function total_medicine_expense(patientID varchar(10))
returns int
DETERMINISTIC
begin
	declare total_medicine_expense int;
    select sum(每種藥品藥費) into total_medicine_expense
	from prescriptions
	where 身分證字號 = patientID;
    return total_medicine_expense;
end$$
delimiter ;

#判斷藥品部分負擔金額
delimiter $$
create function medicine_expense_sort(expense int) 
returns int
DETERMINISTIC
begin
	declare medicine_partial int;
	case 
    when expense between 0 and 100 then set medicine_partial=0;
    when expense between 101 and 200 then set medicine_partial=20;
    when expense between 201 and 300 then set medicine_partial=40;
    when expense between 301 and 400 then set medicine_partial=60;
    when expense between 401 and 500 then set medicine_partial=80;
    when expense between 501 and 600 then set medicine_partial=100;
    end case;
    return medicine_partial;
end$$
delimiter ;

#select total_medicine_expense("N123450011") as 合計藥費,medicine_expense_sort(total_medicine_expense("N123450011")) as 藥品部分負擔金額 ;


#(6)看診完，拿到醫療費用收據

#部分費用明細
drop view if exists fee_receipt;
create view fee_receipt as
SELECT
patient.姓名,
patient.身分證字號,
clinic.門診編號,
clinic.門診日期,
clinic.門診時間,
sessions.科別名稱,
expense_items.費用項目名稱, 
CASE 
WHEN patient.保險類別 ='健保' 
AND(expense_items.費用項目名稱 ='檢驗檢查費' OR expense_items.費用項目名稱 ='藥品費' OR expense_items.費用項目名稱 ='證明書費'
 OR expense_items.費用項目名稱 ='差額負擔' OR expense_items.費用項目名稱 ='其他項目' OR expense_items.費用項目名稱 ='衛材費')
THEN '自費金額' 
WHEN patient.保險類別 ='自費'
THEN '自費金額' 
ELSE '健保申報點數' END AS `健保/自費`, 
expense_items_detail.金額 as 費用
FROM clinic,sessions,doctor,expense_items,patient,expense_items_detail
WHERE (clinic.門診編號=expense_items_detail.門診編號)
AND (sessions.科別編號=doctor.科別編號) 
AND (doctor.醫生編號=clinic.醫生編號) 
AND (expense_items.費用項目編號=expense_items_detail.費用項目編號) 
AND (patient.身分證字號=expense_items_detail.身分證字號) 
ORDER BY `健保/自費`;

# 身分證字號為N123450011、門診編號為CN0029，當次看診的部分費用明細
DELIMITER $$
DROP PROCEDURE IF EXISTS patient_fee_receipt; $$
CREATE PROCEDURE patient_fee_receipt (IN 身分證字號 varchar(10),IN 門診編號 VARCHAR(6))
BEGIN

    select 費用項目名稱, `健保/自費`, 費用
    from fee_receipt
    where 身分證字號=fee_receipt.身分證字號
    and 門診編號=fee_receipt.門診編號;
    
END $$
DELIMITER ;

CALL patient_fee_receipt('N123450011','CN0029');

#判斷部分費用項目的總健保申報點數
delimiter $$
drop function if exists total_health_insurance_point; $$
create function total_health_insurance_point(身分證字號 varchar(10),門診編號 varchar(6)) 
returns int
DETERMINISTIC
begin
	declare 總健保申報點數 int;
	select sum(fee_receipt.費用)
	as 總健保申報點數
	into 總健保申報點數
	from fee_receipt
    where fee_receipt.`健保/自費`='健保申報點數'
    and 門診編號=fee_receipt.門診編號;
	return 總健保申報點數;
end$$
delimiter ;

#判斷部分費用項目的總自費金額
delimiter $$
drop function if exists total_self_pay; $$
create function total_self_pay(身分證字號 varchar(10),門診編號 varchar(6)) 
returns int
DETERMINISTIC
begin
	declare 總自費金額 int;
	select sum(fee_receipt.費用)
	as 總自費金額
	into 總自費金額
	from fee_receipt
    where fee_receipt.`健保/自費`='自費金額'
    and 門診編號=fee_receipt.門診編號;
	return 總自費金額;
end$$
delimiter ;

#判斷門診屬於哪個掛號時段
delimiter $$
drop function if exists clinic_registration_time; $$
create function clinic_registration_time(門診編號 varchar(6)) 
returns varchar(4)
DETERMINISTIC
begin
	declare 掛號時段 varchar(4);
	select
	case 
	when DATE_FORMAT(clinic.門診日期, '%w')=6 then '週六門診'
	when clinic.門診時間='晚間' then '夜間門診'
	else '其他門診' end
	as 掛號時段
	into 掛號時段
	from clinic
    where 門診編號=clinic.門診編號;
	return 掛號時段;
end$$
delimiter ;

# 查詢身分證字號為N123450011、門診編號為CN0029、經轉診的，當次看診的費用收據
DELIMITER $$
DROP PROCEDURE IF EXISTS patient_fee_information; $$
CREATE PROCEDURE patient_fee_information (IN 身分證字號 varchar(10),IN 門診編號 VARCHAR(6),IN 備註 varchar(20))
BEGIN
    select distinct 姓名,身分證字號,門診編號,門診日期,門診時間,fee_receipt.科別名稱,
    total_medicine_expense("N123450011") as 藥費,total_health_insurance_point(身分證字號,門診編號) as 健保申報點數,
    (total_medicine_expense("N123450011")+total_health_insurance_point(身分證字號,門診編號)) AS 合計健保申報點數,
    registration_fee.掛號費,basic_partial_burden.金額 as 基本部分負擔金額,
    medicine_expense_sort(total_medicine_expense("N123450011")) as 藥品部分負擔金額,
    total_self_pay(身分證字號,門診編號) as 其他自費金額,
    (registration_fee.掛號費+basic_partial_burden.金額+medicine_expense_sort(total_medicine_expense("N123450011"))+total_self_pay(身分證字號,門診編號)) as 應繳金額
    from sessions
    join fee_receipt on sessions.科別名稱 = fee_receipt.科別名稱
    join service_class on sessions.服務種類編號=service_class.服務種類編號
    join registration_fee on service_class.服務種類編號=registration_fee.服務種類編號
    join basic_partial_burden on  service_class.服務種類編號=basic_partial_burden.服務種類編號
    where 身分證字號=fee_receipt.身分證字號
    and 門診編號=fee_receipt.門診編號
    and 備註=basic_partial_burden.備註
    and clinic_registration_time(門診編號)=registration_fee.掛號時段;
END $$
DELIMITER ;

CALL patient_fee_information('N123450011','CN0029','經轉診');


#醫生操作
#(1)目前方樂昕醫生門診預約人數
create view appointment_trial as
select 門診編號, count(*) as 目前門診預約人數
from appointment
group by 門診編號
order by 門診編號 ASC;
select * from appointment_trial;

delimiter $$
create procedure appointment_number(doctor_name varchar(4))
begin
	select appointment_trial.門診編號, appointment_trial.目前門診預約人數, doctor.醫生姓名,
    case
    when appointment_trial.目前門診預約人數 > clinic.預約上限人數 then "否"
    else "是" end as 是否可以現場掛號
    from appointment_trial
    join clinic on appointment_trial.門診編號 = clinic.門診編號
    join doctor on clinic.醫生編號 = doctor.醫生編號
    where doctor.醫生姓名 = doctor_name;
end$$
delimiter ;

call appointment_number("方樂昕");

#(2)門診CN0029詳細資料
delimiter $$
create procedure appointment_detail(clinicID varchar(6))
begin
	select appointment.就診號碼,appointment.門診編號, appointment.身分證字號, patient.姓名
    from appointment
    join patient on patient.身分證字號 = appointment.身分證字號
    where appointment.門診編號 = clinicID
    order by appointment.就診號碼;
end$$
delimiter ;

call appointment_detail("CN0029");







-- #(6)查詢身分證字號為N123450011的姓名、優待身分類別、支付掛號費用、支付部分負擔費用
-- SELECT patient.姓名,preferential_identity.優待身分類別,preferential_identity.支付掛號費用,preferential_identity.支付部分負擔費用,service_class.服務種類
-- FROM patient
-- INNER JOIN preferential_identity ON patient.優待身分編號 = preferential_identity.優待身分編號
-- INNER JOIN appointment ON appointment.身分證字號 = patient.身分證字號
-- INNER JOIN clinic ON clinic.門診編號 = appointment.門診編號
-- INNER JOIN doctor ON doctor.醫生編號 = clinic.醫生編號
-- INNER JOIN sessions ON sessions.科別編號 = doctor.科別編號
-- INNER JOIN service_class ON service_class.服務種類編號 = sessions.服務種類編號
-- WHERE patient.身分證字號 = 'N123450011';






-- #(3) 查詢感染防疫科屬於什麼服務種類、部別、基本部分負擔的金額
-- SELECT sessions.科別名稱,service_class.服務種類, department.部別名稱, basic_partial_burden.金額 AS 基本部分負擔費用,basic_partial_burden.備註
-- FROM sessions
-- INNER JOIN department ON sessions.部別編號 = department.部別編號
-- INNER JOIN service_class ON sessions.服務種類編號 = service_class.服務種類編號
-- LEFT JOIN basic_partial_burden ON sessions.服務種類編號 = basic_partial_burden.服務種類編號
-- WHERE sessions.科別名稱 = '感染防疫科';
