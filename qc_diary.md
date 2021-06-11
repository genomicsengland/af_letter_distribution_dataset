# QC Diary

## Participant Duplications

Using `accessory_scripts/duplicate_participant_xref_w_dbs.r` can see that there are 8 participants who we thought were duplicate participants but are being returned with different NHS numbers by DBS.

## Foetal Names

Using `accessory_scripts/check_foetus_names_dbs.r` see that a wide-ranging set of words that are looked for in forename only returns either plausible forenames or suspect names which have been given to deceased participants.
Also, that any participants identified as having a foetal name in the original newsletter investigation in Mar 2019 are not returned by DBS.

## Protected Addresses

Using `accessory_scripts/protected_addresses.r` search for suspect-looking addresses returned by DBS.
No type of address has been found that would not be included in the mailout.

## Pilot participants

Using `accessory_scripts/check_pilot_not_in_dbs.r` can see that all participant IDs are length of 9 in DBS and that their prefixes are consistent with 100K participant IDs (though there are some strange ones which may be linked to cohorts).

## Line by line

Using `accessory_scripts/check_tim_line_by_line.r` establish that any duplicated rows for a participant have the same outcome status which is what is used to include participants.

## Deceased

Using `accessory_scripts/check_deceased_form_types.r` see that there are a few participants who were recruited on deceased consent forms but have not come through as deceased from DBS. Elect to include these in a blacklist of participants who will be excluded from the mailout.

## Absent addresses

There are a number of participants returned from DBS who are eligible to receive the letter, however their address from DBS is not complete or otherwise corrupted. Elect to remove any individual who doesn't have a postcode from the final mailout, removes around 40 participants.

## Withdrawals

Using `accessory_scripts/check_withdrawals.r` can check whether all of the withdrawals in [Arjumand's tracker](https://genomicsenglandltd.sharepoint.com/:x:/r/teams/GE-ParticipationWithdrawalProcesses/Shared%20Documents/General/Withdrawals%20Action%20Tracker/100K%20Withdrawal%20Requests%20_%20Action%20Tracker.xlsx?d=w33bc9dfebcc443bbad489d05a1f16fe5&csf=1&web=1&e=S2oAmi) are being returned by the query run on PMI.
All withdrawals in the tracker are in the PMI, but there are withdrawals in PMI not present in the tracker though these are either test participant_ids or non-100k ones.

## DBS Matches

Using `accessory_scripts/check_record_type_dbs.r` checked whether there are any participants who have been matched by DBS without the use of their NHS number i.e. using record_type 20, 40, 33:

|response_code|nhs_number_supplied|trace_results|data_returned|
|---|---|---|---|
|20|N|Successful: Single exact match (Alphanumeric Trace) |Traced details |
|40|Y|NHS number not valid but replacement traced and verified|Traced details and replacement NHS number|
|33|Y|Successful: Failed cross check. Alphanumeric trace initiated. Single exact match|Traced details. May return a different NHS number|

Gives 198 records, 166 of which are exact matches on full name and data of birth. From the remaining 32 records the vast majority had matching dates of birth but only slight changes to name (either extended surname or the addition of middles names). Only 3 participants had significantly different name or date of birth and were added `sql_scripts/excl_blacklist_participants.sql`.
