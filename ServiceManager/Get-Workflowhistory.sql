
USE ServiceManager;
SELECT TOP 1000 LT.[LTValue] AS 'Workflow Name' ,
Wflw.[RuleName] AS 'Workflow InternalName' ,
JobDetail.[ErrorCode] JobDetail.[ErrorMessage] ,
JobDetail.[LastModified] ,
JobDetail.[Output] AS 'Workflow Actions Log (XML)' ,
JobDetail.[TimeStarted] ,
JobDetail.[TimeScheduled] ,
JobDetail.[TimeFinished]
FROM [dbo].[WindowsWorkflowTaskJobStatus] WinWorkflow (nolock)
JOIN [dbo].[Rules] Wflw (nolock) ON Wflw.RuleId = WinWorkflow.[RuleId]
JOIN [dbo].[LocalizedText] LT (nolock) ON Wflw.[RuleId] = LT.[MPElementId]
AND LT.LTStringType=1 AND LT.LanguageCode = 'ENU'
JOIN [dbo].[JobStatus] JobDetail (nolock) ON JobDetail.[BatchId] = WinWorkflow.[BatchId]
JOIN [dbo].[MT_System$WorkItem$Incident] IR (nolock) ON WinWorkflow.[BaseManagedEntityId] = IR.[BaseManagedEntityId]
--WHERE WinWorkflow.[BaseManagedEntityId] LIKE 'F2647B28-71D7-486F-FBC0-80B498A8F9D0' WHERE IR.[Id_9A505725_E2F2_447F_271B_9B9F4F0D190C] LIKE 'IR708644'
