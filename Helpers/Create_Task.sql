--Create a task that inserts new rows into a table each day

create or replace task DAILY__INVENTORY_RESULTS_INSERT
	warehouse= TEST_WH
	schedule='USING CRON 0 6 * * * UTC'
	as INSERT INTO FAC_INVENTORY_RESULTS
(   
    SNAPSHOT_DATE,
	SNAPSHOT_DATE_KEY,
	PT_DOMAIN_SITE_KEY,
) 
SELECT
    SNAPSHOT_DATE,
	SNAPSHOT_DATE_KEY,
	PT_DOMAIN_SITE_KEY,
    FROM FAC_INVENTORY_RESULTS;

--Make the task functional
ALTER TASK DAILY_XPPS_FAC_INVENTORY_RESULTS_TREND_TASK RESUME;

--Create a task that calls an already existing proceedure

create or replace task TABLE_UPDATE_TASK
	warehouse=TEST_WH
	schedule='USING CRON 0 5 * * * UTC'
	COMMENT='THIS TASK REFRESHES DATA TO TABLES IN THE DIMENSION SCHEMA'
as CALL TABLE_UPDATES();
--Make the task functional
ALTER TASK TABLE_UPDATE_TASK RESUME;


-- In case you want to keep the task but not running you can excetu the following query

ALTER TASK TABLE_UPDATE_TASK SUSPEND;
--This will disable the task but not deleting it
