#!/bin/bash
#Block List Tools (http://shorl.com/fovogretopiga)
#From the maintainer of Combined Privacy Block Lists (https://github.com/bongochong/CombinedPrivacyBlockLists)
#License: CPAL-1.0 (https://github.com/bongochong/CombinedPrivacyBlockLists/blob/master/LICENSE.md)
	read -r -p "Are you ready to update your peer-to-peer block list? [y/N] " response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
	then
echo "Cleaning up & Fetching P2P lists..."
mkdir -p ~/BLT/btp2p
cd ~/BLT/btp2p
rm -f level1BT.7z bt_level1.p2p level2BT.7z bt_level2.p2p combined-final.p2p
wget -nv -O level1BT.7z "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=7z"
wget -nv -O level2BT.7z "http://list.iblocklist.com/?list=gyisgnzbhppbvsphucsw&fileformat=p2p&archiveformat=7z"
echo "Downloaded blocklists."
7z e level1BT.7z
sleep 1
7z e level2BT.7z
sleep 1
echo "Extracted blocklists from archives."
find . -name 'ydxerpxkpcfqjaybcssw.txt' -exec mv {} bt_level1.p2p \;
find . -name 'gyisgnzbhppbvsphucsw.txt' -exec mv {} bt_level2.p2p \;
cat *.p2p | sed "s/amp;//g" | sort | uniq -i > combined-final.p2p
sleep 1
perl -pi -e '$_ = "" if ( $. == 1 );' combined-final.p2p
sed -i -e "/^#/d" -e "/^[[:space:]]*$/d" combined-final.p2p
perl -i -pe 'chomp if eof' combined-final.p2p
echo "Appended proper file extension to blocklists. Combined, sorted, and de-duped. Your BitTorrent blocklist has been updated."
rm -f level1BT.7z bt_level1.p2p level2BT.7z bt_level2.p2p
echo "~---_---_---~"
ls -lh ~/BLT/btp2p
echo "~---_---_---~"
p2pCount=$(cat ~/BLT/btp2p/combined-final.p2p | wc -l)
echo "Your current P2P block list contains $p2pCount unique entries..."
echo "~---_---_---~"
exit
	else
	echo "Alright, goodbye!"
	fi
exit
