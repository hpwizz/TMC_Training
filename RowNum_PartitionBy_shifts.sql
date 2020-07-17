----------------------------------------------------
-- 1. CREATE TABLE OF NON-1-ON-1 SHIFTS COMPLETED --
----------------------------------------------------

drop table if exists michigan.non1on1;

create table michigan.non1on1 as

select 
    a.vanid,
	  b.eventcalendarname as event_type,
  	a.datetimeoffsetbegin as event_date
  
from ot2020_vansync.tsm_csi_eventsignups a 

left join ot2020_vansync.tsm_csi_events b
	on a.eventid = b.eventid

left join ot2020_vansync.tsm_csi_EventSignupsStatuses c
	on a.CurrentEventSignupsEventStatusID = c.eventsignupseventstatusid

where a.statecode = 'MI'
  and b.eventcalendarid <> 387065 -- not a 1-on-1
  and c.eventstatusid = 2 -- completed




---------------------------------------------------------
-- CREATE TABLE OF NON-1-ON-1 SHIFTS COMPLETED, RANKED --
---------------------------------------------------------

-- recreates table of folks' most recent non-1-on-1 shift completed

drop table if exists michigan.non1on1_recent;

create table michigan.non1on1_recent as

select 
    a.vanid,
	  b.eventcalendarname as event_type,
  	a.datetimeoffsetbegin as event_date,
  	row_number() over(
   		partition by a.vanid
   		order by a.datetimeoffsetbegin desc
    		) as row_number -- 1 = most recent event
from ot2020_vansync.tsm_csi_eventsignups a 

left join ot2020_vansync.tsm_csi_events b
	on a.eventid = b.eventid

left join ot2020_vansync.tsm_csi_EventSignupsStatuses c
	on a.CurrentEventSignupsEventStatusID = c.eventsignupseventstatusid

where a.statecode = 'MI'
  and b.eventcalendarid <> 387065 -- not a 1-on-1
  and c.eventstatusid = 2 -- completed
 -- and row_number = 1 -- most recent event
