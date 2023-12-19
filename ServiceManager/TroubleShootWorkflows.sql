DECLARE @MaxState INT, @MaxStateDate Datetime, @Delta INT, @Language nvarchar(3) 
SET @Delta = 0
SET @Language = 'ENU' 
SET @MaxState = ( SELECT MAX(EntityTransactionLogId) FROM EntityChangeLog WITH(NOLOCK) )
SET @MaxStateDate = ( SELECT TimeAdded FROM EntityTransactionLog WhERE EntityTransactionLogId = @MaxState )

SELECT  LT.LTValue AS 'Display Name', 
		r.RuleId as 'RuleId',
		r.ManagementPackId as RuleMPID,
        S.State AS 'Current Workflow Watermark', 
        @MaxState AS 'Current Transaction Log Watermark', 
        DATEDIFF(mi,ETL.timeadded, @MaxStateDate) AS 'Minutes Behind', 
		etl.TimeAdded,
        S. EventCount, S. LastNonZeroEventCount, R.RuleName AS 'MP Rule Name', 
        MT.TypeName AS 'Source Class Name', 
        S.LastModified AS 'Rule Last Modified', 
        S.IsPeriodicQueryEvent AS 'Is Periodic Query Subscription' --Note: 1 means it is a periodic query subscription R.RuleEnabled AS 'Rule Enabled', -- Note: 4 means the rule is enabled R.RuleID 
FROM CmdbInstanceSubscriptionState AS S WITH(NOLOCK) 
LEFT OUTER JOIN Rules AS R ON S.RuleId = R.RuleId 
LEFT OUTER JOIN ManagedType AS MT ON S.TypeId = MT.ManagedTypeId 
LEFT OUTER JOIN LocalizedText AS LT On R.RuleId = LT.MPElementId 
left outer join EntityTransactionLog as ETL on etl.EntityTransactionLogId = s.State


WHERE S.State <= @MaxState - @Delta 
AND R.RuleEnabled <> 0 
AND LT.LTStringType = 1 
AND LT.LanguageCode = @Language 
AND S.IsPeriodicQueryEvent = 0 
--and lt.LTValue like '%'  -- Bezeichnung der Rule
--and DATEDIFF(mi,ETL.timeadded, @MaxStateDate) > 20

--where r.ruleid = '0F3D5133-E5AD-D9E0-01CD-8C5A3F122533'
--AND LT.LTValue LIKE '%Test%' -- for workflowname

ORDER BY S.State Asc 
