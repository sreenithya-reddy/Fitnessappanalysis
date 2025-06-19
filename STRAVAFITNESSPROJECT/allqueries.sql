
  /*queries for dailyActivity_merged*/

PRAGMA table_info(dailyActivity_merged);

SELECT * FROM dailyActivity_merged LIMIT 10;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN ActivityDate IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(ActivityDate) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN TotalSteps IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(TotalSteps) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN Calories IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(Calories) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN TotalDistance IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(TotalDistance) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN SedentaryMinutes IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(SedentaryMinutes) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN FairlyActiveMinutes IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(FairlyActiveMinutes) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;



SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN VeryActiveMinutes IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(VeryActiveMinutes) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN VeryActiveDistance IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(VeryActiveDistance) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN SedentaryActiveDistance IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(SedentaryActiveDistance) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN LightActiveDistance IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(LightActiveDistance) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN ModeratelyActiveDistance IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(ModeratelyActiveDistance) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN TrackerDistance IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(TrackerDistance) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN LoggedActivitiesDistance IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(LoggedActivitiesDistance) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN LightlyActiveMinutes IS NULL THEN 1 ELSE 0 END) AS nulls,
  SUM(CASE WHEN TRIM(LightlyActiveMinutes) = '' THEN 1 ELSE 0 END) AS empty_strings
FROM dailyActivity_merged;



SELECT ActivityDate, COUNT(*) as count
FROM dailyActivity_merged
GROUP BY ActivityDate
HAVING count > 1;

SELECT id, ActivityDate, COUNT(*) as count
FROM dailyActivity_merged
GROUP BY id, ActivityDate
HAVING count > 1;

SELECT * FROM dailyActivity_merged WHERE TotalSteps < 0;
SELECT * FROM dailyActivity_merged WHERE Calories< 0;
SELECT * FROM dailyActivity_merged WHERE TotalDistance < 0;

SELECT *, COUNT(*) as count
FROM dailyActivity_merged
GROUP BY Id, ActivityDate, SedentaryActiveDistance, SedentaryMinutes, TotalSteps, Calories, TotalDistance, FairlyActiveMinutes, LightlyActiveMinutes,LightActiveDistance,VeryActiveMinutes,VeryActiveDistance,ModeratelyActiveDistance,TrackerDistance,LoggedActivitiesDistance
HAVING COUNT(*) > 1;

SELECT id, COUNT(*) as count
FROM dailyActivity_merged
GROUP BY id
HAVING count > 1;

/* queires for heartrate_seconds_merged */

PRAGMA table_info(heartrate_seconds_merged);

SELECT * FROM heartrate_seconds_merged LIMIT 10;

SELECT 
  SUM(CASE WHEN Id IS NULL THEN 1 ELSE 0 END) AS null_ids,
  SUM(CASE WHEN Time IS NULL THEN 1 ELSE 0 END) AS null_time,
  SUM(CASE WHEN Value IS NULL THEN 1 ELSE 0 END) AS null_value
FROM heartrate_seconds_merged;

SELECT * 
FROM heartrate_seconds_merged
WHERE Value < 0;

-- for faster querying we are using indexing

CREATE INDEX idx_id ON heartrate_seconds(Id);
CREATE INDEX idx_time ON heartrate_seconds_merged(Time);

DROP TABLE IF EXISTS heartrate_daily;


CREATE TABLE heartrate_daily AS
SELECT 
  Id,
  -- Just grab the first 10 characters if format is always MM/DD/YYYY or M/D/YYYY
  substr(Time, 1, instr(Time, ' ') - 1) AS RawDate,
  AVG(Value) AS Avg_HeartRate,
  MIN(Value) AS Min_HeartRate,
  MAX(Value) AS Max_HeartRate,
  COUNT(*) AS Total_Readings
FROM heartrate_seconds_merged
GROUP BY Id, RawDate;

SELECT * FROM heartrate_daily LIMIT 10;

/* hourlyCalories_merged dataset cleaning part */

SELECT 
  SUM(CASE WHEN Id IS NULL THEN 1 ELSE 0 END) AS Null_Id,
  SUM(CASE WHEN ActivityHour IS NULL THEN 1 ELSE 0 END) AS Null_Time,
  SUM(CASE WHEN Calories IS NULL OR Calories = '' THEN 1 ELSE 0 END) AS Null_Calories,
  SUM(CASE WHEN Calories < 0 THEN 1 ELSE 0 END) AS Negative_Calories
FROM hourlyCalories_merged;

SELECT Id, ActivityHour, COUNT(*) 
FROM hourlyCalories_merged 
GROUP BY Id, ActivityHour 
HAVING COUNT(*) > 1;

CREATE TABLE hourlyCalories_cleaned AS
SELECT 
  Id,
  substr(ActivityHour, 1, instr(ActivityHour, ' ') - 1) AS Date,
  CASE
    WHEN instr(ActivityHour, 'AM') > 0 THEN 
         CAST(substr(ActivityHour, instr(ActivityHour, ' ') + 1, 2) AS INT)
    ELSE 
         CAST(substr(ActivityHour, instr(ActivityHour, ' ') + 1, 2) AS INT) + 12
  END AS Hour24,
  Calories
FROM hourlyCalories_merged;

select * from hourlyCalories_cleaned limit 10;

/* Queries on hourlyIntensities_merged */

SELECT 
  SUM(CASE WHEN Id IS NULL THEN 1 ELSE 0 END) AS Null_Id,
  SUM(CASE WHEN ActivityHour IS NULL THEN 1 ELSE 0 END) AS Null_Time,
  SUM(CASE WHEN TotalIntensity IS NULL OR TotalIntensity < 0 THEN 1 ELSE 0 END) AS Invalid_TotalIntensity,
  SUM(CASE WHEN AverageIntensity IS NULL OR AverageIntensity < 0 THEN 1 ELSE 0 END) AS Invalid_AvgIntensity
FROM hourlyIntensities_merged;

SELECT Id, ActivityHour, COUNT(*) 
FROM hourlyIntensities_merged
GROUP BY Id, ActivityHour
HAVING COUNT(*) > 1;

CREATE TABLE hourlyIntensities_cleaned AS
SELECT 
  Id,
  substr(ActivityHour, 1, instr(ActivityHour, ' ') - 1) AS Date,
  CAST(substr(ActivityHour, instr(ActivityHour, ' ') + 1, 2) AS INT) +
    CASE WHEN ActivityHour LIKE '%PM%' AND substr(ActivityHour, instr(ActivityHour, ' ') + 1, 2) != '12' THEN 12 ELSE 0 END AS Hour24,
  TotalIntensity,
  AverageIntensity
FROM hourlyIntensities_merged;

select * from hourlyIntensities_cleaned limit 10; 

/* queries on hourlySteps_merged */

SELECT 
  SUM(CASE WHEN Id IS NULL THEN 1 ELSE 0 END) AS Null_Id,
  SUM(CASE WHEN ActivityHour IS NULL THEN 1 ELSE 0 END) AS Null_Time,
  SUM(CASE WHEN StepTotal IS NULL OR StepTotal < 0 THEN 1 ELSE 0 END) AS Invalid_Steps
FROM hourlySteps_merged;

SELECT Id, ActivityHour, COUNT(*) 
FROM hourlySteps_merged
GROUP BY Id, ActivityHour
HAVING COUNT(*) > 1;

CREATE TABLE hourlySteps_cleaned AS
SELECT 
  Id,
  substr(ActivityHour, 1, instr(ActivityHour, ' ') - 1) AS Date,
  CAST(substr(ActivityHour, instr(ActivityHour, ' ') + 1, 2) AS INT) +
    CASE WHEN ActivityHour LIKE '%PM%' AND substr(ActivityHour, instr(ActivityHour, ' ') + 1, 2) != '12' THEN 12 ELSE 0 END AS Hour24,
  StepTotal
FROM hourlySteps_merged;

select * from hourlySteps_cleaned limit 10;

/* queries on METsNarrow_merged.csv */

SELECT * FROM minuteMETsNarrow_merged
WHERE Id IS NULL OR ActivityMinute IS NULL OR METs IS NULL;

SELECT Id, ActivityMinute, COUNT(*) as count
FROM minuteMETsNarrow_merged
GROUP BY Id, ActivityMinute
HAVING count > 1;

SELECT 
  Id,
  substr(ActivityMinute, 1, instr(ActivityMinute, ' ') - 1) AS Date,
  METs AS Metabolic_Equality_of_Task
FROM minuteMETsNarrow_merged
GROUP BY Id, Date;


select * from minuteMETsNarrow_merged limit 10;

/* queries on minuteSleep_merged */

SELECT 
  SUM(CASE WHEN Id IS NULL THEN 1 ELSE 0 END) AS Null_Id,
  SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS Null_Date,
  SUM(CASE WHEN value IS NULL OR value NOT IN (1,2,3) THEN 1 ELSE 0 END) AS Invalid_Value,
  SUM(CASE WHEN logId IS NULL THEN 1 ELSE 0 END) AS Null_logId
FROM minuteSleep_merged;

SELECT Id, date, logId, COUNT(*)
FROM minuteSleep_merged
GROUP BY Id, date, logId
HAVING COUNT(*) > 1;

CREATE TABLE minuteSleep_deduplicated AS
SELECT DISTINCT *
FROM minuteSleep_merged;

CREATE TABLE minuteSleep_cleaned AS
SELECT 
  Id,
  substr(date, 1, instr(date, ' ') - 1) AS SleepDate,
  CAST(substr(date, instr(date, ' ') + 1, 2) AS INT) +
    CASE WHEN date LIKE '%PM%' AND substr(date, instr(date, ' ') + 1, 2) != '12' THEN 12 ELSE 0 END AS Hour24,
  value AS SleepState,
  logId
FROM minuteSleep_deduplicated;

select * from minuteSleep_cleaned limit 10;

/* queries on sleepDay_merged */

SELECT 
  SUM(CASE WHEN Id IS NULL THEN 1 ELSE 0 END) AS Null_Id,
  SUM(CASE WHEN SleepDay IS NULL THEN 1 ELSE 0 END) AS Null_SleepDay,
  SUM(CASE WHEN TotalMinutesAsleep < 0 OR TotalTimeInBed < 0 THEN 1 ELSE 0 END) AS Negative_Values
FROM sleepDay_merged;

SELECT Id, SleepDay, COUNT(*) 
FROM sleepDay_merged
GROUP BY Id, SleepDay
HAVING COUNT(*) > 1;

CREATE TABLE sleepDay_deduplicated AS
SELECT DISTINCT *
FROM sleepDay_merged;

CREATE TABLE sleepDay_cleaned AS
SELECT 
  Id,
  substr(SleepDay, 1, instr(SleepDay, ' ') - 1) AS SleepDate,
  TotalSleepRecords,
  TotalMinutesAsleep,
  TotalTimeInBed
FROM sleepDay_deduplicated;

select * from sleepDay_cleaned limit 10;

/* queries on weightLoginfo_merged.csv */

SELECT 
  SUM(CASE WHEN Id IS NULL THEN 1 ELSE 0 END) AS Null_Id,
  SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Null_Date,
  SUM(CASE WHEN WeightKg IS NULL OR WeightKg <= 0 THEN 1 ELSE 0 END) AS Invalid_Weight,
  SUM(CASE WHEN BMI IS NULL OR BMI <= 0 THEN 1 ELSE 0 END) AS Invalid_BMI,
  SUM(CASE WHEN Fat < 0 OR Fat > 100 THEN 1 ELSE 0 END) AS Invalid_Fat
FROM weightLogInfo_merged;

SELECT Id, Date, COUNT(*) 
FROM weightLogInfo_merged
GROUP BY Id, Date
HAVING COUNT(*) > 1;

DROP TABLE IF EXISTS weightLog_cleaned;

DROP TABLE IF EXISTS weightLog_dates_fixed;

CREATE TABLE weightLog_dates_fixed AS
SELECT 
  Id,
  printf('%04d-%02d-%02d',
    CAST(substr(year_part, 1, 4) AS INT),
    CAST(substr(month_part, 1, 2) AS INT),
    CAST(substr(day_part, 1, 2) AS INT)
  ) AS LogDate,
  WeightKg,
  BMI,
  CASE 
    WHEN Fat BETWEEN 0 AND 100 THEN Fat 
    ELSE NULL 
  END AS Fat,
  IsManualReport,
  LogId
FROM (
  SELECT *,
    -- Replace dashes with slashes for consistency
    REPLACE(substr(Date, 1, instr(Date, ' ') - 1), '-', '/') AS clean_date,
    
    -- Split into parts manually
    substr(REPLACE(substr(Date, 1, instr(Date, ' ') - 1), '-', '/'), 1, instr(REPLACE(substr(Date, 1, instr(Date, ' ') - 1), '-', '/'), '/') - 1) AS month_part,
    
    substr(
      REPLACE(substr(Date, 1, instr(Date, ' ') - 1), '-', '/'),
      instr(REPLACE(substr(Date, 1, instr(Date, ' ') - 1), '-', '/'), '/') + 1,
      instr(
        substr(REPLACE(substr(Date, 1, instr(Date, ' ') - 1), '-', '/'),
               instr(REPLACE(substr(Date, 1, instr(Date, ' ') - 1), '-', '/'), '/') + 1),
        '/'
      ) - 1
    ) AS day_part,
    
    substr(
      REPLACE(substr(Date, 1, instr(Date, ' ') - 1), '-', '/'),
      length(REPLACE(substr(Date, 1, instr(Date, ' ') - 1), '-', '/')) - 3,
      4
    ) AS year_part

  FROM weightLogInfo_merged
);


select * from weightLog_dates_fixed limit 10;