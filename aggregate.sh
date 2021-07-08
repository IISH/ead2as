#!/bin/bash

echo 'ARCHIEF,cxx_unittitle,lb_in_unittitle,count_physdesc_extent_item_encodinganalog_300a,count_physdesc_extent_bytes_encodinganalog_300a,cxx_geen_atribuut_level,physdesc_extent_kommagetal,odd_in_odd,langusage_language,dsc_head_note,dsc_note_type,dsc_odd_type,note_unitdate,physdesc_genreform,physdesc_language,physdesc_origination,bytes_meter_item,extent_ca,cxx_zonder_unittitle_unitdate'

for xml in example/out/*.txt
do
  f=$(basename "$xml") && echo -n "${f:0:9}"
	echo -n "," && cat "${xml}" && echo ""
done
