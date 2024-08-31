# 使用 hospital 資料庫
USE hospital;

# 備份 appointment table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/appointment.txt' FROM appointment;
# 備份 basic_partial_burden table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/basic_partial_burden.txt' FROM basic_partial_burden;
# 備份 clinic table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clinic.txt' FROM clinic;
# 備份 department table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/department.txt' FROM department;
# 備份 doctor table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/doctor.txt' FROM doctor;
# 備份 expense_items table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/expense_items.txt' FROM expense_items;
# 備份 expense_items_detail table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/expense_items_detail.txt' FROM expense_items_detail;
# 備份 medicine table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicine.txt' FROM medicine;
# 備份 medicine_detail table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicine_detail.txt' FROM medicine_detail;
# 備份 medicine_suppliers table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicine_suppliers.txt' FROM medicine_suppliers;
# 備份 medicines_partial_burden table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicines_partial_burden.txt' FROM medicines_partial_burden;
# 備份 patient table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/patient.txt' FROM patient;
# 備份 preferential_identity table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/preferential_identity.txt' FROM preferential_identity;
# 備份 registration_fee table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/registration_fee.txt' FROM registration_fee;
# 備份 service_class table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/service_class.txt' FROM service_class;
# 備份 sessions table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sessions.txt' FROM sessions;
# 備份 symptom table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/symptom.txt' FROM symptom;
# 備份 symptom_recommend table
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/symptom_recommend.txt' FROM symptom_recommend;

SET FOREIGN_KEY_CHECKS = 0; # 關閉外部鍵限制

# 移除資料表中的所有資料列，但會保留資料表結構及其欄位、條件約束、索引等。
truncate table appointment; 
truncate table basic_partial_burden; 
truncate table clinic; 
truncate table department; 
truncate table doctor; 
truncate table expense_items; 
truncate table expense_items_detail; 
truncate table medicine; 
truncate table medicine_detail; 
truncate table medicine_suppliers; 
truncate table medicines_partial_burden; 
truncate table patient; 
truncate table preferential_identity; 
truncate table registration_fee; 
truncate table service_class; 
truncate table sessions; 
truncate table symptom; 
truncate table symptom_recommend; 

SET FOREIGN_KEY_CHECKS = 1; # 開啟外部鍵限制

USE hospital;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/appointment.txt' INTO TABLE appointment;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/basic_partial_burden.txt' INTO TABLE basic_partial_burden;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clinic.txt' INTO TABLE clinic;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/department.txt' INTO TABLE department;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/doctor.txt' INTO TABLE doctor;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/expense_items.txt' INTO TABLE expense_items;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/expense_items_detail.txt' INTO TABLE expense_items_detail;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicine.txt' INTO TABLE medicine;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicine_detail.txt' INTO TABLE medicine_detail;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicine_suppliers.txt' INTO TABLE medicine_suppliers;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicines_partial_burden.txt' INTO TABLE medicines_partial_burden;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/patient.txt' INTO TABLE patient;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/preferential_identity.txt' INTO TABLE preferential_identity;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/registration_fee.txt' INTO TABLE registration_fee;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/service_class.txt' INTO TABLE service_class;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sessions.txt' INTO TABLE sessions;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/symptom.txt' INTO TABLE symptom;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/symptom_recommend.txt' INTO TABLE symptom_recommend;