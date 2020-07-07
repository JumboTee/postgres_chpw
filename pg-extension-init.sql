ALTER SYSTEM SET log_statement = 'all';
ALTER SYSTEM SET log_directory = 'pg_log';
ALTER SYSTEM SET log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log';
ALTER SYSTEM SET logging_collector = 'on';
ALTER SYSTEM SET log_min_error_statement = 'debug5';
ALTER SYSTEM SET log_line_prefix = '%m %d %u [%p] %h ; %%';
