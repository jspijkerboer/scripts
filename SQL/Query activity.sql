SELECT sqltext.TEXT,
    req.session_id,
    req.blocking_session_id,
    req.status,
    req.start_time,
    req.command,
    req.cpu_time,
    req.total_elapsed_time,
    req.wait_type,
    req.wait_time,
    req.wait_resource
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext