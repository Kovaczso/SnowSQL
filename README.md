# SnowSQL Scripts

This repository showcases a collection of SQL scripts authored by me, encompassing both original creations and utilized resources. It serves as a reference point linked to my portfolio website, highlighting my expertise and contributions in database management and querying.

## Helper

This section of the repository contains SQL codes that will help you with bit of a Data Engineering rather than Analysis. Examples presented in this sections are from real projects. 

### Creat Tasks
A task can execute any one of the following types of SQL code:

-**Single**: SQL statement

-**Call**: to a stored procedure

-**Procedural**: logic using Snowflake Scripting

Tasks can be combined with table streams for continuous ELT workflows to process recently changed table rows. Streams ensure exactly once semantics for new or changed data in a table. Tasks can also be used independently to generate periodic reports by inserting or merging rows into a report table or perform other periodic work

In the following example we presume that there is a VIEW called **FAC_INVENTORY_RESULTS_V**. If this view is storing SQL from the source tables, then upon calling the view it would always return fresh data. Let's also say that we want to keep daily history of some of the records. In this case we would create a table **FAC_INVENTORY_RESULTS** by queriing **FAC_INVENTORY_RESULTS_V** for the columns that we want to keep track of and we would also add additional column **SNAPSHOT_DATE** that would represent the current date of the query. After we create a task to insert new rows each day into a table. This way we can keep track of the data on daily bases
```
create table FAC_INVENTORY_RESULTS as (
SELECT
  CURRENT_DATE() AS SNAPSHOT_DATE,
	PART,
	SITE_KEY,
FROM
  FAC_INVENTORY_RESULTS_V
);


create or replace task DAILY_INVENTORY_RESULTS_INSERT
	warehouse= TEST_WH
	schedule='USING CRON 0 6 * * * UTC'
	as INSERT INTO FAC_INVENTORY_RESULTS
(   
    SNAPSHOT_DATE,
	PART,
	SITE_KEY,
) 
SELECT
  CURRENT_DATE() AS SNAPSHOT_DATE,
	PART,
	SITE_KEY,
    FROM FAC_INVENTORY_RESULTS_V;
```
Results after two days would look like this:

| SNAPSHOT_DATE |  PART  | SITE_KEY |
|:-----|:--------:|------:|
| 1/12/24   | 1 | DE |
| 1/12/24   | 2 | DE |
| 1/13/24   |  1  |   DE |
| 1/13/24   |  4  |   DE |
| 1/14/24   | 1 |    DE |


