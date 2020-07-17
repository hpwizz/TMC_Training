------------------------------------
-- LEADERSHIP LADDER SQ RESPONSES --
------------------------------------
-- recreates table of all LL SQ responses, not ranked


drop table if exists michigan.LLsq;

create table michigan.LLsq as

select 
  csr.ContactsSurveyResponseID,
  csr.vanid,
  csr.surveyquestionid,
  csr.surveyresponseid,
  csr.datecanvassed,
  csr.canvassedby,
  csr.contactscontactid
    
from ot2020_vansync.tsm_csi_contactssurveyresponses_myc as csr

where csr.statecode = 'MI'
	and csr.surveyquestionid = 378658 -- Leadership Ladder SQ




--------------------------------------------
-- LEADERSHIP LADDER SQ RESPONSES, RANKED --
--------------------------------------------
-- recreates table of all LL SQ responses with row_number column to identify most recent responses


drop table if exists michigan.LLsq_ranked;

create table michigan.::sq_ranked as

select 
  csr.ContactsSurveyResponseID,
  csr.vanid,
  csr.surveyquestionid,
  csr.surveyresponseid,
  csr.datecanvassed,
  csr.canvassedby,
  csr.contactscontactid,
  row_number() over( -- ranks most recent responses
    partition by vanid
    order by datecanvassed desc
    ) as row_number
    
from ot2020_vansync.tsm_csi_contactssurveyresponses_myc

where csr.statecode = 'MI'
	and csr.surveyquestionid = 378658 -- Leadership Ladder SQ
  -- and row_number = 1
