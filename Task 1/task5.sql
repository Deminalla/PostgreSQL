-- Kiekvienam duomenų tipui - domenų, sukurtų naudojant tą duomenų tipą, skaičius.
SELECT Data_Type, COUNT(Data_Type)
FROM Information_schema.Columns 
GROUP BY Data_Type;


-- will show the list of all schemas in here
SELECT SCHEMA_NAME 
FROM INFORMATION_SCHEMA.SCHEMATA;


-- kiekvienam stulpelio tipui bendras visu tokio tipo stulpeliu, visu lenteliu skaicius (dar ir kiek schemose jie yra)
SELECT Data_Type, COUNT(Data_Type) AS "data_type_count", COUNT(DISTINCT Table_schema || '.' || Table_name) AS "distinct_tables", COUNT(DISTINCT Table_schema) AS "schema_count"
FROM Information_schema.Columns 
GROUP BY Data_Type;

-- column names that are in 2nd position
SELECT Table_name, Column_Name 
FROM Information_schema.Columns 
WHERE ordinal_position = 2 AND Table_schema = 'stud';

------------
SELECT DISTINCT (Table_schema || '.' || Table_name) as "tables_with_pk" 
FROM Information_Schema.key_column_usage 
WHERE position_in_unique_constraint IS NULL;
----------------



----------------
-- lenteles kurios neturi isoriniu raktu 
--(prints with foreign key).......
SELECT DISTINCT (Table_schema || '.' || Table_name) AS "tables with foreign" 
FROM Information_Schema.key_column_usage
WHERE position_in_unique_constraint IS NOT NULL;


SELECT (Table_schema || '.' || Table_name) AS "tables without fk" 
FROM Information_Schema.key_column_usage
WHERE Table_schema || '.' || Table_name NOT IN (
	SELECT DISTINCT (Table_schema || '.' || Table_name)
	FROM Information_Schema.key_column_usage
	WHERE position_in_unique_constraint IS NOT NULL);
         
-- kiek virtualiu lenteliu, ir nevirtualiu
WITH t2 AS(
	SELECT COUNT(Table_name) AS Virtual
	FROM Information_schema.Tables
	WHERE table_type = 'VIEW'
	)
SELECT COUNT(Table_name) AS "Base", t2.Virtual
FROM Information_schema.Tables, t2
WHERE table_type = 'BASE TABLE'
GROUP BY t2.Virtual; 



-- kiek virtualiu lenteliu, ir nevirtualiu
SELECT COUNT(Table_name) AS "Base", (
	SELECT COUNT(Table_name) AS "Virtual"
	FROM Information_schema.Tables
	WHERE table_type = 'VIEW'
	) AS "Virtual"
FROM Information_schema.Tables
WHERE table_type = 'BASE TABLE';






         
