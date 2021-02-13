#!/usr/bin/bash
echo 'Removing existent metadata folder...'
rm metadata-folder -r

echo 'Converting Source format to metadata...'
sfdx force:source:convert -r ./force-app -d metadata-folder -n 'Shared Bills'

echo 'Deploying to Packaging org...'
sfdx force:source:deploy -x ./metadata-folder/package.xml -u CuentasDevHub

echo 'Generating new package version...'
sfdx force:package1:version:create -u CuentasDevHub -i 0333j000000KPTnAAO -n "1.4" -d "MVP Extended Shared Bills" -k password1