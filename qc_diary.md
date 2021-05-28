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

#TODO:

* participant ID prefixes which don't necessarily match to a GMC, are these excluded by cohorts?
