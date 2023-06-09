
--DML Triggers 
--In SQL server there are 3 types of triggers
/*1. DML triggers 
  2. DDL triggers
  3. Logon trigger

In general, a trigger is a special kind of stored procedure that automatically executes when an event occurs in the database server.

DML stands for Data Manipulation Language. INSERT, UPDATE, and DELETE statements are DML statements. DML triggers are fired, when ever data is modified using INSERT, UPDATE, and DELETE events.

DML triggers can be again classified into 2 types.
1. After triggers (Sometimes called as FOR triggers)
2. Instead of triggers

After triggers, as the name says, fires after the triggering action. The INSERT, UPDATE, and DELETE statements, causes an after trigger to fire after the respective statements complete execution.

On ther hand, as the name says, INSTEAD of triggers, fires instead of the triggering action. The INSERT, UPDATE, and DELETE statements, can cause an INSTEAD OF trigger to fire INSTEAD OF the respective statement execution.*/


CREATE TABLE tblEmployee20
(
  Id int Primary Key,
  Name nvarchar(30),
  Salary int,
  Gender nvarchar(10),
  DepartmentId int
)

Insert into tblEmployee20 values (1,'John', 5000, 'Male', 3)
Insert into tblEmployee20 values (2,'Mike', 3400, 'Male', 2)
Insert into tblEmployee20 values (3,'Pam', 6000, 'Female', 1)


CREATE TABLE tblEmployeeAudit
(
  Id int identity(1,1) primary key,
  AuditData nvarchar(1000)
)

--When ever, a new Employee is added, we want to capture the ID and the date and time, the new employee is added in tblEmployeeAudit table. The easiest way to achieve this, is by having an AFTER TRIGGER for INSERT event.

--Example for AFTER TRIGGER for INSERT event on tblEmployee table:
select * from tblEmployee20 
select * from tblEmployeeAudit

Insert into tblEmployee20 values (7,'Tan', 2300, 'Female', 3)

CREATE TRIGGER tr_tblEMployee_ForInsert1
ON tblEmployee20
FOR INSERT
AS
BEGIN
 Declare @Id int
 Select @Id = Id from inserted
 
 insert into tblEmployeeAudit 
 values('New employee with Id  = ' + Cast(@Id as nvarchar(5)) + ' is added at ' + cast(Getdate() as nvarchar(20)))
END

Insert into tblEmployee20 values (8,'ramu', 2500, 'male', 4)

select * from tblEmployeeAudit

--In the trigger, we are getting the id from inserted table. So, what is this inserted table? INSERTED table, is a special table used by DML triggers. When you add a new row into tblEmployee table, a copy of the row will also be made into inserted table, which only a trigger can access. You cannot access this table outside the context of the trigger. The structure of the inserted table will be identical to the structure of tblEmployee table.

--So, now if we execute the following INSERT statement on tblEmployee. Immediately, after inserting the row into tblEmployee table, the trigger gets fired (executed automatically), and a row into tblEmployeeAudit, is also inserted.

Insert into tblEmployee20 values (7,'Tan', 2300, 'Female', 3)

--Along, the same lines, let us now capture audit information, when a row is deleted from the table, tblEmployee.
--Example for AFTER TRIGGER for DELETE event on tblEmployee table:

--Alter Trigger if you want to run again
CREATE TRIGGER tr_tblEMployee_ForDelete
ON tblEmployee20
FOR DELETE
AS
BEGIN
 Declare @Id int
 Select @Id = Id from deleted
 insert into tblEmployeeAudit 
 values('An existing employee with Id  = ' + Cast(@Id as nvarchar(5)) + ' is deleted at ' + Cast(Getdate() as nvarchar(20)))
END

delete from tblEmployee20 where id=7
select * from tblEmployeeAudit
select * from tblEmployee20 
--The only difference here is that, we are specifying, the triggering event as DELETE and retrieving the deleted row ID from DELETED table. DELETED table, is a special table used by DML triggers. 
--When you delete a row from tblEmployee table, a copy of the deleted row will be made available in DELETED table, which only a trigger can access. Just like INSERTED table, DELETED table cannot be accessed, outside the context of the trigger and, the structure of the DELETED table will be identical to the structure of tblEmployee table.

--After update trigger
Triggers make use of 2 special tables, INSERTED and DELETED. The inserted table contains the updated data and the deleted table contains the old data. The After trigger for UPDATE event, makes use of both inserted and deleted tables. 

--Create AFTER UPDATE trigger script:
Alter trigger tr_tblEmployee_ForUpdate
on tblEmployee20
for Update
as
Begin
 Select * from deleted
 Select * from inserted 
End

--Now, execute this query:
Update tblEmployee20 set [Name] = 'Tods', Salary = 2000, 
Gender = 'Female' where Id = 3

select * from tblEmployeeAudit  ---no info of tods 
select * from tblEmployee20 

--Immediately after the UPDATE statement execution, the AFTER UPDATE trigger gets fired, and you should see the contenets of INSERTED and DELETED tables.

--The following AFTER UPDATE trigger, audits employee information upon UPDATE, and stores the audit data in tblEmployeeAudit table.
Update tblEmployee20 set [Name] = 'Tods5', Salary = 4000, 
Gender = 'male' where Id = 2

select * from tblEmployeeAudit  ---now getting info of tods 
select * from tblEmployee20

--------fire trigger, update, select then you will get exact ans
Create trigger tr_tblEmployee_ForUpdate1
on tblEmployee20
for Update
as
Begin
      -- Declare variables to hold old and updated data
      Declare @Id int
      Declare @OldName nvarchar(20), @NewName nvarchar(20)
      Declare @OldSalary int, @NewSalary int
      Declare @OldGender nvarchar(20), @NewGender nvarchar(20)
      Declare @OldDeptId int, @NewDeptId int
     
      -- Variable to build the audit string
      Declare @AuditString nvarchar(1000)
      
      -- Load the updated records into temporary table
      Select *
      into #TempTable
      from inserted
     
      -- Loop thru the records in temp table
      While(Exists(Select Id from #TempTable))
      Begin
            --Initialize the audit string to empty string
            Set @AuditString = ''
           
            -- Select first row data from temp table
            Select Top 1 @Id = Id, @NewName = Name, 
            @NewGender = Gender, @NewSalary = Salary,
            @NewDeptId = DepartmentId
            from #TempTable
           
            -- Select the corresponding row from deleted table
            Select @OldName = Name, @OldGender = Gender, 
            @OldSalary = Salary, @OldDeptId = DepartmentId
            from deleted where Id = @Id
   
     -- Build the audit string dynamically           
            Set @AuditString = 'Employee with Id = ' + Cast(@Id as nvarchar(4)) + ' changed'
            if(@OldName <> @NewName)
                  Set @AuditString = @AuditString + ' NAME from ' + @OldName + ' to ' + @NewName
                 
            if(@OldGender <> @NewGender)
                  Set @AuditString = @AuditString + ' GENDER from ' + @OldGender + ' to ' + @NewGender
                 
            if(@OldSalary <> @NewSalary)
                  Set @AuditString = @AuditString + ' SALARY from ' + Cast(@OldSalary as nvarchar(10))+ ' to ' + Cast(@NewSalary as nvarchar(10))
                  
     if(@OldDeptId <> @NewDeptId)
                  Set @AuditString = @AuditString + ' DepartmentId from ' + Cast(@OldDeptId as nvarchar(10))+ ' to ' + Cast(@NewDeptId as nvarchar(10))
           
            insert into tblEmployeeAudit values(@AuditString)
            
            -- Delete the row from temp table, so we can move to the next row
            Delete from #TempTable where Id = @Id
      End
End

select * from tblEmployeeAudit  ---now getting info of tods 
select * from tblEmployee20 

----------------------
--Instead of insert trigger 
specifically INSTEAD OF INSERT trigger. We know that, AFTER triggers are fired after the triggering event(INSERT, UPDATE or DELETE events), where as, INSTEAD OF triggers are fired instead of the triggering event(INSERT, UPDATE or DELETE events). In general, INSTEAD OF triggers are usually used to correctly update views that are based on multiple tables. 

drop table if exists tblEmployee21;
CREATE TABLE tblEmployee21
(
  Id int Primary Key,
  Name nvarchar(30),
  Gender nvarchar(10),
  DepartmentId int
)

drop table if exists tblDepartment21;
CREATE TABLE tblDepartment21
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)

Insert into tblDepartment21 values (1,'IT')
Insert into tblDepartment21 values (2,'Payroll')
Insert into tblDepartment21 values (3,'HR')
Insert into tblDepartment21 values (4,'Admin')


Insert into tblEmployee21 values (1,'John', 'Male', 3)
Insert into tblEmployee21 values (2,'Mike', 'Male', 2)
Insert into tblEmployee21 values (3,'Pam', 'Female', 1)
Insert into tblEmployee21 values (4,'Todd', 'Male', 4)
Insert into tblEmployee21 values (5,'Sara', 'Female', 1)
Insert into tblEmployee21 values (6,'Ben', 'Male', 3)

--Since, we now have the required tables, let's create a view based on these tables. The view should return Employee Id, Name, Gender and DepartmentName columns. So, the view is obviously based on multiple tables.

Create view vWEmployeeDetails
as
Select Id, [Name], Gender, DeptName
from tblEmployee21 
join tblDepartment21
on tblEmployee21.DepartmentId = tblDepartment21.DeptId

Select * from vWEmployeeDetails
Select * from tblEmployee21

--Now, let's try to insert a row into the view, vWEmployeeDetails, by executing the following query. At this point, an error will be raised stating 'View or function vWEmployeeDetails is not updatable because the modification affects multiple base tables.'

Insert into vWEmployeeDetails values(7, 'Valarie', 'Female', 'IT')--View or function 'vWEmployeeDetails' is not updatable because the modification affects multiple base tables.

Select * from vWEmployeeDetails

Insert into vWEmployeeDetails values(7, 'Valarie', 'Female', 'garbagevalueis')--View or function 'vWEmployeeDetails' is not updatable because the modification affects multiple base tables.

--So, inserting a row into a view that is based on multipe tables, raises an error by default. Now, let's understand, how INSTEAD OF TRIGGERS can help us in this situation. Since, we are getting an error, when we are trying to insert a row into the view, let's create an INSTEAD OF INSERT trigger on the view vWEmployeeDetails.

/*create trigger tr_vWEmployeeDetails_INSTEADINSERT
on tblEmployee21
instead of insert
as
Begin
 Select * from deleted
 Select * from inserted 
End

select * from tr_vWEmployeeDetails_INSTEADINSERT
select * from tblEmployee21
select * from tblDepartment21*/

--Script to create INSTEAD OF INSERT trigger:

Alter trigger tr_vWEmployeeDetails_InsteadOfInsert
on vWEmployeeDetails
Instead Of Insert
as
Begin
 Declare @DeptId int
 
 --Check if there is a valid DepartmentId
 --for the given DepartmentName
 Select @DeptId = DeptId 
 from tblDepartment21 
 join inserted
 on inserted.DeptName = tblDepartment21.DeptName
 
 --If DepartmentId is null throw an error
 --and stop processing
 if(@DeptId is null)
 Begin
  Raiserror('Invalid Department Name. Statement terminated', 16, 1)
  return
 End
 
 --Finally insert into tblEmployee table
 Insert into tblEmployee21(Id, [Name], Gender, DepartmentId)
 Select Id, [Name], Gender, @DeptId
 from inserted
End


--before insert
select * from tblEmployee21 
select * from tblDepartment21
select * from vWEmployeeDetails

Insert into vWEmployeeDetails values(7, 'Valarie', 'Female', 'IT')
--Insert into vWEmployeeDetails values(7, 'Valarie', 'Female', 'garbagevalueis')--Statement terminated

--After Insert

select * from tblEmployee21 
select * from tblDepartment21
select * from vWEmployeeDetails


--The instead of trigger correctly inserts, the record into tblEmployee table. Since, we are inserting a row, the inserted table, contains the newly added row, where as the deleted table will be empty.

--In the trigger, we used Raiserror() function, to raise a custom error, when the DepartmentName provided in the insert query, doesnot exist. We are passing 3 parameters to the Raiserror() method. The first parameter is the error message, the second parameter is the severity level. Severity level 16, indicates general errors that can be corrected by the user. The final parameter is the state. 

------------------------------------------------------------------
https://csharp-video-tutorials.blogspot.com/2012/09/instead-of-update-triggers-part-46.html
 --INSTEAD OF UPDATE trigger. An INSTEAD OF UPDATE triggers gets fired instead of an update event, on a table or a view. For example, let's say we have, an INSTEAD OF UPDATE trigger on a view or a table, and then when you try to update a row with in that view or table, instead of the UPDATE, the trigger gets fired automatically. INSTEAD OF UPDATE TRIGGERS, are of immense help, to correctly update a view, that is based on multiple tables.
use SQLPRACTICE
drop table if exists tblEmployee22
CREATE TABLE tblEmployee22
(
  Id int Primary Key,
  Name nvarchar(30),
  Gender nvarchar(10),
  DepartmentId int
)

drop table if exists tblDepartment22
CREATE TABLE tblDepartment22
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)


Insert into tblDepartment22 values (1,'IT')
Insert into tblDepartment22 values (2,'Payroll')
Insert into tblDepartment22 values (3,'HR')
Insert into tblDepartment22 values (4,'Admin')

Insert into tblEmployee22 values (1,'John', 'Male', 3)
Insert into tblEmployee22 values (2,'Mike', 'Male', 2)
Insert into tblEmployee22 values (3,'Pam', 'Female', 1)
Insert into tblEmployee22 values (4,'Todd', 'Male', 4)
Insert into tblEmployee22 values (5,'Sara', 'Female', 1)
Insert into tblEmployee22 values (6,'Ben', 'Male', 3)

--Since, we now have the required tables, let's create a view based on these tables. The view should return Employee Id, Name, Gender and DepartmentName columns. So, the view is obviously based on multiple tables.

create view vWEmployeeDetails1
as
Select Id, [Name], Gender, DeptName
from tblEmployee22 
join tblDepartment22
on tblEmployee22.DepartmentId = tblDepartment22.DeptId


Select * from vWEmployeeDetails1 
error stating - 'View or function vWEmployeeDetails is not updatable because the modification affects multiple base tables.'

--let's try to update the view, in such a way that, it affects, both the underlying tables, and see, if we get the same error. The following UPDATE statement changes Name column from tblEmployee and DeptName column from tblDepartment. So, when we execute this query, we get the same error.

Update vWEmployeeDetails1 
set Name = 'Johny', DeptName = 'IT' --want to change 2 columns,so error
where Id = 1

Select * from vWEmployeeDetails1 --want to change 2 columns,so error

--let's try to change, just the department of John from HR to IT. The following UPDATE query, affects only one table, tblDepartment. So, the query should succeed. But, before executing the query, please note that, employees JOHN and BEN are in HR department.

Update vWEmployeeDetails1 
set DeptName = 'IT' --tried to chnge one column so wrong changes in ben's dept and 2nd wrong change is in dept table HR converted to IT in dept table also which is wrong
where Id = 1

Select * from vWEmployeeDetails1 
Select * from tblEmployee22 
Select * from tblDepartment22

--After executing the query, select the data from the view, and notice that BEN's DeptName is also changed to IT. We intended to just change JOHN's DeptName. So, the UPDATE didn't work as expected. This is because, the UPDATE query, updated the DeptName from HR to IT, in tblDepartment table. For the UPDATE to work correctly, we should change the DeptId of JOHN from 3 to 1.

--Incorrectly Updated View
--Record with Id = 3,which is ben has the DeptName changed from 'HR' to 'IT'
--We should have actually updated, JOHN's DepartmentId from 3 to 1

--So, the conclusion is that, if a view is based on multiple tables, and if you update the view, the UPDATE may not always work as expected. To correctly update the underlying base tables, thru a view, INSTEAD OF UPDATE TRIGGER can be used.

--Before, we create the trigger, let's update the DeptName to HR for record with Id = 3. just to correct the dept table same as before

Update tblDepartment22 set DeptName = 'HR' where DeptId = 3 
Select * from vWEmployeeDetails1 
Select * from tblEmployee22 
Select * from tblDepartment22

--Script to create INSTEAD OF UPDATE trigger: see trigger on views 
Create Trigger tr_vWEmployeeDetails_InsteadOfUpdate
on vWEmployeeDetails1
instead of update
as
Begin
 -- if EmployeeId is updated
 if(Update(Id))
 Begin
  Raiserror('Id cannot be changed', 16, 1)
  Return
 End
 
 -- If DeptName is updated
 if(Update(DeptName)) --HR 
 Begin
  Declare @DeptId int

  Select @DeptId = DeptId  
  from tblDepartment22
  join inserted
  on inserted.DeptName = tblDepartment22.DeptName --to set new name in dept table
  --first insert HR or any dept into dept table, collect 3 from there and store it into variable
 -- intention to change id in employee table not to change dept id 
  
  if(@DeptId is NULL )--if dept name garbage, no deptid so error
  Begin
   Raiserror('Invalid Department Name', 16, 1)
   Return
  End
  
  Update tblEmployee22 set DepartmentId = @DeptId
  from inserted
  join tblEmployee22
  on tblEmployee22.Id = inserted.id
 End
 
 -- If gender is updated
 if(Update(Gender))
 Begin
  Update tblEmployee22 set Gender = inserted.Gender
  from inserted
  join tblEmployee22
  on tblEmployee22.Id = inserted.id
 End
 
 -- If Name is updated
 if(Update([Name]))
 Begin
  Update tblEmployee22 set [Name] = inserted.[Name]
  from inserted
  join tblEmployee22
  on tblEmployee22.Id = inserted.id
 End
End

--Now, let's try to update JOHN's Department to IT. 


Update vWEmployeeDetails1  set DeptName = 'IT' where Id = 1

Update vWEmployeeDetails1 set DeptName = 'ITyruyrur' where Id = 1 -- throw errror after triggering 


Select * from vWEmployeeDetails1 
Select * from tblEmployee22 
Select * from tblDepartment22

--The UPDATE query works as expected. The INSTEAD OF UPDATE trigger, correctly updates, JOHN's DepartmentId to 1, in tblEmployee table.

--Now, let's try to update Name, Gender and DeptName. The UPDATE query, works as expected, without raising the error - 'View or function vWEmployeeDetails is not updatable because the modification affects multiple base tables.'

Update vWEmployeeDetails1 
set [Name] = 'Johny', Gender = 'Female', DeptName = 'IT'where Id = 1
--no updation even after triggering

Select * from vWEmployeeDetails1 
Select * from tblEmployee22 
Select * from tblDepartment22

--Update() function used in the trigger, returns true, even if you update with the same value. For this reason, I recommend to compare values between inserted and deleted tables, rather than relying on Update() function. The Update() function does not operate on a per row basis, but across all rows.