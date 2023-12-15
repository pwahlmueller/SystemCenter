

select SubmittedBy, RunningAs, Status, convert(xml,Output), ErrorCode,ErrorMessage, TimeScheduled, TimeStarted, TimeFinished
from JobStatus
order by TimeFinished desc
