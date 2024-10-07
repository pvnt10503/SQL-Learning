
/* How to create a fake database using WHILE LOOP 
*/
CREATE DATABASE NotRealData;
--create schema marketing;
--drop schema marketing;
create table sales_advertising (
    "Date" Date,
    "Tiktok" float,
    "Youtube" float,
    "Facebook" float,
    "Sales" float,
)
 /*Rename column in SQL Server:
    Syntax: EXEC sp_rename '<schema>.<table>.oldnamme_column', 'newname_column','Column';
 EXEC sp_rename 'dbo.sales_advertising.Youtuber', 'Youtube', 'COLUMN';
 */
INSERT INTO sales_advertising
  ("Date", "Tiktok", "Youtube", "Facebook", "Sales")
VALUES
  ('2023-01-01', '147.429191', '24.291329', '39.317341', '14617.052023');
  
 --Declare variables for WHILE LOOP
declare @day_start int = 0;
declare @date_start date = getdate();

while @day_start >= -5000
BEGIN
    INSERT INTO sales_advertising
  ("Date", "Tiktok", "Youtube", "Facebook", "Sales")
  VALUES
  (
    Cast(DateADD(day,@day_start,@date_start) as date),
    Round(Rand()*(500+1),2),
    Round(Rand()*(400+1),2),
    Round(Rand()*(600+1),2),
    Round(Rand()*(50000-30000+1)+30000,2)
  )
  set @day_start = @day_start - 1;
END;
/*
ì
*/
select * from sales_advertising
/*WHILE LOOP Syntax:
While clear condition
    Begin
Block of code
    End;
*/
