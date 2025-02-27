---------------------------------------------
USE foo;
GO

DROP TRIGGER IF EXISTS trg_example_15 ON DATABASE;
DROP TABLE IF EXISTS dbo.tbl_example_15;
GO
---------------------------------------------
---------------------------------------------
---------------------------------------------
USE foo;
GO

CREATE TABLE dbo.tbl_example_15
(
EventID INT IDENTITY(1,1) PRIMARY KEY,
EventType VARCHAR(100),
ObjectName VARCHAR(255),
ObjectType VARCHAR(100),
EventDate DATETIME,
LoginName VARCHAR(255),
UserName VARCHAR(255),
CommandText VARCHAR(MAX)
);
GO

CREATE TRIGGER trg_example_15 ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    DECLARE @EventData XML;
    SET @EventData = EVENTDATA();

    INSERT INTO dbo.tbl_example_15 (EventType,ObjectName,ObjectType,EventDate,LoginName,UserName,CommandText)
    VALUES
    (
        @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'), -- Event type (e.g., CREATE, ALTER, DROP)
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(255)'), -- Object name (e.g., table name)
        @EventData.value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(100)'), -- Object type (e.g., TABLE)
        GETDATE(), -- The current date and time
        @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(255)'), -- The login name of the user
        @EventData.value('(/EVENT_INSTANCE/UserName)[1]', 'NVARCHAR(255)'), -- The user name that performed the action
        @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)') -- The executed SQL command
    );
END;
GO

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
USE foo;
GO

DECLARE @vTruncate SMALLINT = 0;
IF @vTruncate = 1
BEGIN
     TRUNCATE TABLE foo.dbo.sql_expression_dependencies;
END;
GO
-------------------------------------------------------
USE foo;
GO

INSERT INTO foo.dbo.sql_expression_dependencies
(example_number, referencing_object_type, referencing_server_name, referencing_database_name, referencing_schema_name, referencing_entity_name, referencing_id, referencing_minor_id, referencing_class, referencing_class_desc, is_schema_bound_reference, referenced_class, referenced_class_desc, referenced_server_name, referenced_database_name, referenced_schema_name, referenced_entity_name, referenced_object_type, referenced_id, referenced_minor_id, is_caller_dependent, is_ambiguous)
SELECT  '15', COALESCE(c.type, d.type, e.type) AS referencing_object_type, @@SERVERNAME, DB_NAME(), SCHEMA_NAME(c.schema_id), COALESCE(c.name, d.name, e.name) AS referencing_entity_name, referencing_id, referencing_minor_id, referencing_class, referencing_class_desc, is_schema_bound_reference, referenced_class, referenced_class_desc, referenced_server_name, referenced_database_name, referenced_schema_name, referenced_entity_name, b.type AS referenced_object_type, referenced_id, referenced_minor_id, is_caller_dependent, is_ambiguous
FROM    sys.sql_expression_dependencies a LEFT OUTER JOIN
        sys.objects b ON a.referenced_id = b.object_id LEFT OUTER JOIN
        sys.objects c ON a.referencing_id = c.object_id LEFT OUTER JOIN
        sys.triggers d ON a.referencing_id = d.object_id LEFT OUTER JOIN
        sys.server_triggers e ON a.referencing_id = e.object_id;
GO

INSERT INTO foo.dbo.system_objects (table_name, object_id, server_name, database_name, schema_name, name, principal_id, schema_id, parent_object_id, type, type_desc, create_date, modify_date, is_ms_shipped, is_published, is_schema_published) 
SELECT 'sys.objects', object_id, @@SERVERNAME, DB_NAME(), SCHEMA_NAME(schema_id), name, principal_id, schema_id, parent_object_id, type, type_desc, create_date, modify_date, is_ms_shipped, is_published, is_schema_published 
FROM   sys.objects
GO

-------------------------------------------------------
SELECT * FROM foo.dbo.sql_expression_dependencies ORDER BY example_number;
GO

---------------------------------------------
USE foo;
GO

DECLARE @vDropObjects SMALLINT = 1;
IF @vDropObjects = 1
BEGIN
     DROP TRIGGER IF EXISTS trg_example_15 ON DATABASE;
     DROP TABLE IF EXISTS dbo.tbl_example_15;
END;
GO