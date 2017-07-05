alter system set temp_buffers = '128MB';
SELECT pg_reload_conf();