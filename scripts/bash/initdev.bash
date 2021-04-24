#!/usr/bin/bash
echo 'Scratch org alias?'
read orgAlias

echo 'Creating Scratch Org'
sfdx force:org:create  -f config/project-scratch-def.json -a $orgAlias -u CuentasDevHub -d 30

echo "Pushing code to scratch org ..."
sfdx force:source:push -u $orgAlias

echo "Adding permission set ..."
sfdx force:user:permset:assign -n Shared_Bills_User -u $orgAlias

echo "Creating data ..."
sfdx force:data:tree:import -u $orgAlias -p data/Sample-plan.json

echo "Opening Scratch Org"
sfdx force:org:open -u $orgAlias

