-- Skip open tasks
-- https://techcommunity.microsoft.com/t5/system-center-blog/troubleshooting-workflow-performance-and-delays/ba-p/347510

Declare @maxtransactionid int, @RuleID uniqueidentifier
Set @RuleId = '' -- use for single ruleid
set @MaxTransactionid = (select MAX(Entitytransactionlogid) from entitytransactionlog)

update cmdbinstancesubscriptionstate
set state = @Maxtransactionid
where ruleid  in (

select distinct r.ruleid from rules R
LEFT OUTER JOIN LocalizedText AS LT On R.RuleId = LT.MPElementId 
where ltvalue like '%<RuleName>%'  -- use for using Rule Name
AND LT.LTStringType = 1 
and lt.languagecode = 'ENU'
and r.ruleenabled <> 0
)