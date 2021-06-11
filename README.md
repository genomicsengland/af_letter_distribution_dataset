# README

[The scripts in this repo](https://github.com/genomicsengland/af_letter_distribution_dataset) generate the distribution list for the AF letter and run various QC checks on the data.

The criteria for a participant being excluded from the letter are:

* they are not matched by the DBS process (they do not have a 20, 30, 33, or 40 response code);

* they are withdrawn in PMI (which pulls data from both DAMS and Jira);

* they are deceased in PMI (which pulls data from both DAMS and DBS);

* they are in a cohort (using either the clinic sample LDP ODS code or the registered at LDP ODS code, and [the list of cohort ODS codes at on Confluence](https://cnfl.extge.co.uk/pages/viewpage.action?spaceKey=COH&title=Categories+of+Consent+for+Cohorts+-+100K+systems));

* they are in the epilepsy cohort (having 'epilepsy' in either the consent form or information sheet fields);

* they are from a devolved nation's programme (having a participant ID with the matching prefix);

* they are part of the advance NT cohort (given by [Tim's spreadsheet](https://genomicsenglandltd.sharepoint.com/:x:/r/sites/cd/Additional_finding/AF%20Letter%20Distribution%20List%20Jun%202021/210525%20NT%20AF%20Batch%201%20v6.xlsx?d=wd066cb87e52d403a9671c32cffe7f8cc&csf=1&web=1&e=7hvV1L));

* they have been blacklisted for some other reason (either they have filled a deceased consent form but are not deceased in PMI, or they are a dubious match on DBS);

* they lack a postcode in the DBS return;

Where we have duplicate registrations (two participant_ids assigned to the same NHS number), if either participant_id has been excluded the other participant_id will be exclude also.

Valid participants will then be included if they are deemed valid for AFs by [Tim's line by line audit.](https://genomicsenglandltd.sharepoint.com/:x:/r/sites/cd/Additional_finding/AF%20Letter%20Distribution%20List%20Jun%202021/210429%20AF%20Database%20v1.xlsx?d=w800a40de84084a0390c1d81b891e0a26&csf=1&web=1&e=ov6gHo)

The final dataset provides data on 75,374 participants.
