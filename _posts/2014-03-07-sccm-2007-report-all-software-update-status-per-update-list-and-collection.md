---
layout: post
title: SCCM 2007 - Report all Software Update status per Update List and Collection
permalink: /2014/03/07/sccm-2007-report-all-software-update-status-per-update-list-and-collection/
---

SCCM 2007 report to show patch status details per Update List and Collection.  You can get here by drilling down 4 reports deep, individually, for hundreds or thousands of your servers, or you can just run this, throw it into Excel, and filter and munge at will.  Much faster.

<!--excerpt-->

{% highlight sql %}


-- Shows all patch status details, given an Update List and a Collection. Export it to Excel and monkey with it there.
-- Based off of the stock "Compliance 1 - Overall Compliance" report.

DECLARE @AuthListLocalID AS INT
SELECT @AuthListLocalID=CI_ID
 FROM v_AuthListInfo
 WHERE CI_UniqueID=@AuthListID

SELECT
 fcm.Name,
 ps.UpdateID,
 ps.ID,
 ps.Title,
 ps.QNumbers,
 ps.LastStatusMessageIDName,
 ps.LastStateName,
 ps.AgentInstallDate,
 v_UpdateInfo.DatePosted As UpdateDateReleased,
 v_UpdateInfo.DateRevised AS UpdateDateRevised,
 v_UpdateInfo.InfoURL AS UpdateInfoURL,
 v_UpdateInfo.Description AS UpdateDescription

FROM v_UpdateInfo

 INNER JOIN v_GS_PatchStatusEx AS ps ON v_UpdateInfo.CI_UniqueID = ps.UniqueUpdateID
 INNER JOIN v_FullCollectionMembership AS fcm ON ps.ResourceID = fcm.ResourceID
 INNER JOIN v_CIRelation cir ON cir.ToCIID= v_UpdateInfo.CI_ID
 INNER JOIN (v_CICategories_All
 INNER JOIN v_CategoryInfo
 ON v_CICategories_All.CategoryInstance_UniqueID = v_CategoryInfo.CategoryInstance_UniqueID
 AND v_CategoryInfo.CategoryTypeName = 'Company')
 ON v_CICategories_All.CI_ID = v_UpdateInfo.CI_ID

WHERE fcm.CollectionID = @CollID
 AND ps.AgentInstallDate IS NULL --this shows errors only. Comment it out for reports on installed updates.
 AND cir.FromCIID = @AuthListLocalID
 AND cir.RelationType = 1

ORDER BY fcm.Name

-----------
-- Create two prompts, for Update List, and Collection
--
--
-- AuthListID
-- Update List ID (Required)
begin
if (@__filterwildcard = '')
 select distinct CI_UniqueID as AuthListID, Title as Title from v_AuthListInfo order by Title
else
 select distinct CI_UniqueID as AuthListID, Title as Title from v_AuthListInfo
 where ((CI_UniqueID like @__filterwildcard) or
 (Title like @__filterwildcard))
 order by Title
end
-------
-- CollID
-- Collection ID (Required)

begin
 if (@__filterwildcard = '')
 select CollectionID as CollectionID, Name as CollectionName from v_Collection order by Name
 else
 select CollectionID as CollectionID, Name as CollectionName from v_Collection
 WHERE CollectionID like @__filterwildcard or Name like @__filterwildcard
 order by Name
end
 ---

 {% endhighlight %}
 
 

