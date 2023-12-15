DECLARE @MaxState INT, @MaxStateDate Datetime, @Delta INT, @Language nvarchar(3) 
SET @Delta = 0
SET @Language = 'ENU' 
SET @MaxState = ( SELECT MAX(EntityTransactionLogId) FROM EntityChangeLog WITH(NOLOCK) )
SET @MaxStateDate = ( SELECT TimeAdded FROM EntityTransactionLog WERE EntityTransactionLogld = @MaxState )

SELECT  LT.LTValue AS 'Display Name', 
        S.State AS 'Current Workflow Watermark', 
        @MaxState AS 'Current Transaction Log Watermark', 
        DATEDIFF(mi,(SELECT TimeAdded FROM EntityTransactionLog WITH(NOLOCK) WHERE EntityTransactionLogId = S.State), @MaxStateDate) AS 'Minutes Behind', 
        S. EventCount, S. LastNonZeroEventCount, R.RuleName AS 'MP Rule Name', 
        MT.TypeName AS 'Source Class Name', 
        S.LastModified AS 'Rule Last Modified', 
        S.IsPeriodicQueryEvent AS 'Is Periodic Query Subscription' --Note: 1 means it is a periodic query subscription R.RuleEnabled AS 'Rule Enabled', -- Note: 4 means the rule is enabled R.RuleID 
FROM CmdbInstanceSubscriptionState AS S WITH(NOLOCK) 
LEFT OUTER JOIN Rules AS R ON S.RuleId = R.RuleId 
LEFT OUTER JOIN ManagedType AS MT ON S.Typeld = MT.ManagedTypeId 
LEFT OUTER JOIN LocalizedText AS LT On R.RuleId = LT.MPElementId 

WHERE S.State <= @MaxState - @Delta 
AND R.RuleEnabled <> 0 
AND LT.LTStringType = 1 
AND LT.LanguageCode = @Language 
AND S.IsPeriodicQueryEvent = 0 
--AND LT.LTValue LIKE '%Test%' -- for workflowname

ORDER BY S.State Asc 