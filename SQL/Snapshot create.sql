CREATE DATABASE AxDB_ss ON  
( 
	NAME = AxDB, 
	FILENAME = 'H:\MSSQL_SNAPSHOT\AxDB.ss' 
)  
AS SNAPSHOT OF AxDB;  
GO