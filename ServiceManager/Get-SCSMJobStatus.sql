-- Get long running SCSM Workflows

select SubmittedBy, RunningAs, Status, convert(xml,Output), ErrorCode,ErrorMessage, TimeScheduled, TimeStarted, TimeFinished,
DATEDIFF(minute, TimeScheduled,TimeFinished) AS ScheduleToFinish,
DATEDIFF(minute, TimeScheduled,TimeStarted) AS ScheduleToStart,
DATEDIFF(minute, TimeStarted,TimeFinished) AS Starttofinish


    from JobStatus with (nolock)
	where TimeStarted > '2023-12-18 14:00:00'
	and (DATEDIFF(minute, TimeScheduled,TimeFinished)) > 10

    order by TimeFinished desc