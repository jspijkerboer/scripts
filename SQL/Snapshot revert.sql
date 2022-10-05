USE master;  
-- Reverting AxDB to AxDB_ss
RESTORE DATABASE AxDB from   
DATABASE_SNAPSHOT = 'AxDB_ss';  
GO