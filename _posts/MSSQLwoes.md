Select top 10
	N'playerSessionId' as playerSessionId, N'ServerTimestamp', N'ClientTimeStamp', N'userid', 
	N'contextDZ', N'contextRogue', isHeadshot, killerLevel, N'killerName', N'killerType'
FROM [DW_TCTD_ALPHA_POSTLAUNCH].[event].[playerDeath]
where killerType <> 'NPC'
	and ServerTimestamp > convert(Datetime, '2015-12-09 09:00:00', 120)

write N'columnname' makes it utf8, rather than the MS-specific utf32;
have all columns as nvarchar(), rather than varchar()

http://stackoverflow.com/questions/22643372/embedded-nul-in-string-error-when-importing-huge-csv-with-fread