#!/bin/bash

## User Input##
#  Ticket Number
#  Service name separated by space
#  Permision like read write list separated by space
#  ARN separated by space which is optional however you will not get write permission if you not put ARN
############## example ################ 
# bash generatepolicy.sh "RITM0575698" "ec2 s3" "write" "arn:aws:s3:::aaps3pd01/*" 
############## End example ############

# Generate policy template
#policy_sentry create-template --output-file $1-crud.yml --template-type crud

#Format service name as per template prerequesite
without_arn ()
{
 policy_sentry create-template --output-file "${Ticket_ID}-crud.yml" --template-type crud
 if [ "$Permission_Name" == "list" ]
then
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>sname.txt
sed -i '/service-list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-list/ r sname.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf sname.txt  ${Ticket_ID}-crud.yml
fi

if [ "$Permission_Name" == "read" ]
then
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>rname.txt
sed -i '/service-read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-read/ r rname.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf rname.txt ${Ticket_ID}-crud.yml
fi

if [ "$Permission_Name" == "write" ]
then
snc=`echo "$Service_Name"|tr '  ' ' ' | wc -w`
for i in `seq $snc`
do
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Create*\"}"|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Delete*\"}"|sed 's/^/- /' >> action1.txt
done
echo 'organizations:*'|sed 's/^/- /' >> action1.txt
echo 'iam:Create*'|sed 's/^/- /' >> action1.txt
echo 'iam:Delete*'|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>wname.txt
sed -i '/service-write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-write/ r wname.txt" "${Ticket_ID}-crud.yml"
sed -i '/exclude-actions/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/exclude-actions/ r action1.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf wname.txt ${Ticket_ID}-crud.yml action1.txt
fi

if [ "$Permission_Name" == "read write" ]
then
snc=`echo "$Service_Name"|tr '  ' ' ' | wc -w`
for i in `seq $snc`
do
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Create*\"}"|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Delete*\"}"|sed 's/^/- /' >> action1.txt
done
echo 'organizations:*'|sed 's/^/- /' >> action1.txt
echo 'iam:Create*'|sed 's/^/- /' >> action1.txt
echo 'iam:Delete*'|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>rwname.txt
sed -i '/service-read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-read/ r rwname.txt" "${Ticket_ID}-crud.yml"
sed -i '/service-write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-write/ r rwname.txt" "${Ticket_ID}-crud.yml"
sed -i '/exclude-actions/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/exclude-actions/ r action1.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf rwname.txt ${Ticket_ID}-crud.yml action1.txt
fi

if [ "$Permission_Name" == "read list" ]
then
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>rlname.txt
sed -i '/service-read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-read/ r rlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/service-list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-list/ r rlname.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf rlname.txt ${Ticket_ID}-crud.yml
fi

if [ "$Permission_Name" == "write list" ]
then
snc=`echo "$Service_Name"|tr '  ' ' ' | wc -w`
for i in `seq $snc`
do
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Create*\"}"|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Delete*\"}"|sed 's/^/- /' >> action1.txt
done
echo 'organizations:*'|sed 's/^/- /' >> action1.txt
echo 'iam:Create*'|sed 's/^/- /' >> action1.txt
echo 'iam:Delete*'|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>wlname.txt
sed -i '/service-write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-write/ r wlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/service-list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-list/ r wlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/exclude-actions/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/exclude-actions/ r action1.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf wlname.txt ${Ticket_ID}-crud.yml action1.txt
fi

if [ "$Permission_Name" == "read write list" ]
then
snc=`echo "$Service_Name"|tr '  ' ' ' | wc -w`
for i in `seq $snc`
do
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Create*\"}"|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Delete*\"}"|sed 's/^/- /' >> action1.txt
done
echo 'organizations:*'|sed 's/^/- /' >> action1.txt
echo 'iam:Create*'|sed 's/^/- /' >> action1.txt
echo 'iam:Delete*'|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>rwlname.txt
sed -i '/service-read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-read/ r rwlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/service-list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-list/ r rwlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/service-write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-write/ r rwlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/exclude-actions/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/exclude-actions/ r action1.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf rwlname.txt ${Ticket_ID}-crud.yml action1.txt
fi
}

with_arn ()
{
policy_sentry create-template --output-file "${Ticket_ID}-crud.yml" --template-type crud
if [ "$Permission_Name" == "list" ]
then
echo "$ARN_Name"|tr " " "\n"|sed 's/^/- /'>laname.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>lname.txt
sed -i '/service-list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-list/ r lname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^list/ r laname.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf laname.txt lname.txt ${Ticket_ID}-crud.yml

fi

if [ "$Permission_Name" == "read" ]
then
echo "$ARN_Name"|tr " " "\n"|sed 's/^/- /'>raname.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>rname.txt
sed -i '/service-read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-read/ r rname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^read/ r raname.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf raname.txt rname.txt ${Ticket_ID}-crud.yml
fi

if [ "$Permission_Name" == "write" ]
then
snc=`echo "$Service_Name"|tr '  ' ' ' | wc -w`
for i in `seq $snc`
do
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Create*\"}"|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Delete*\"}"|sed 's/^/- /' >> action1.txt
done
echo 'organizations:*'|sed 's/^/- /' >> action1.txt
echo 'iam:Create*'|sed 's/^/- /' >> action1.txt
echo 'iam:Delete*'|sed 's/^/- /' >> action1.txt
echo "$ARN_Name"|tr " " "\n"|sed 's/^/- /'>waname.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>wname.txt
sed -i '/service-write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-write/ r wname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^write/ r waname.txt" "${Ticket_ID}-crud.yml"
sed -i '/exclude-actions/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/exclude-actions/ r action1.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf waname.txt wname.txt action1.txt ${Ticket_ID}-crud.yml
fi

if [ "$Permission_Name" == "read write" ]
then
snc=`echo "$Service_Name"|tr '  ' ' ' | wc -w`
for i in `seq $snc`
do
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Create*\"}"|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Delete*\"}"|sed 's/^/- /' >> action1.txt
done
echo 'organizations:*'|sed 's/^/- /' >> action1.txt
echo 'iam:Create*'|sed 's/^/- /' >> action1.txt
echo 'iam:Delete*'|sed 's/^/- /' >> action1.txt
echo "$ARN_Name"|tr " " "\n"|sed 's/^/- /'>rwaname.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>rwname.txt
sed -i '/service-read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-read/ r rwname.txt" "${Ticket_ID}-crud.yml"
sed -i '/service-write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-write/ r rwname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^read/ r rwaname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^write/ r rwaname.txt" "${Ticket_ID}-crud.yml"
sed -i '/exclude-actions/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/exclude-actions/ r action1.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy  --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf rwaname.txt rwname.txt action1.txt ${Ticket_ID}-crud.yml
fi

if [ "$Permission_Name" == "read list" ]
then
echo "$ARN_Name"|tr " " "\n"|sed 's/^/- /'>rlaname.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>rlname.txt
sed -i '/service-read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-read/ r rlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/service-list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-list/ r rlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^read/ r rlaname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^list/ r rlaname.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf rlaname.txt rlname.txt ${Ticket_ID}-crud.yml
fi

if [ "$Permission_Name" == "write list" ]
then
snc=`echo "$Service_Name"|tr '  ' ' ' | wc -w`
for i in `seq $snc`
do
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Create*\"}"|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Delete*\"}"|sed 's/^/- /' >> action1.txt
done
echo 'organizations:*'|sed 's/^/- /' >> action1.txt
echo 'iam:Create*'|sed 's/^/- /' >> action1.txt
echo 'iam:Delete*'|sed 's/^/- /' >> action1.txt
echo "$ARN_Name"|tr " " "\n"|sed 's/^/- /'>wlaname.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>wlname.txt
sed -i '/service-write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-write/ r wlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/service-list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-list/r wlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^write/ r wlaname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^list/ r wlaname.txt" "${Ticket_ID}-crud.yml"
sed -i '/exclude-actions/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/exclude-actions/ r action1.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf wlaname.txt wlname.txt action1.txt ${Ticket_ID}-crud.yml
fi

if [ "$Permission_Name" == "read write list" ]
then
snc=`echo "$Service_Name"|tr '  ' ' ' | wc -w`
for i in `seq $snc`
do
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Create*\"}"|sed 's/^/- /' >> action1.txt
echo "$Service_Name"|awk -F ' ' "{print \$$i\":Delete*\"}"|sed 's/^/- /' >> action1.txt
done
echo 'organizations:*'|sed 's/^/- /' >> action1.txt
echo 'iam:Create*'|sed 's/^/- /' >> action1.txt
echo 'iam:Delete*'|sed 's/^/- /' >> action1.txt
echo "$ARN_Name"|tr " " "\n"|sed 's/^/- /'>rwlaname.txt
echo "$Service_Name"|tr " " "\n"|sed 's/^/  - /'>rwlname.txt
sed -i '/service-read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-read/ r rwlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/service-list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-list/ r rwlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/service-write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/service-write/ r rwlname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^read/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^read/ r  rwlaname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^list/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^list/ r rwlaname.txt" "${Ticket_ID}-crud.yml"
sed -i '/^write/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/^write/ r rwlaname.txt" "${Ticket_ID}-crud.yml"
sed -i '/exclude-actions/{n;d}' "${Ticket_ID}-crud.yml"
sed -i -e "/exclude-actions/ r action1.txt" "${Ticket_ID}-crud.yml"
policy_sentry write-policy --input-file "${Ticket_ID}-crud.yml" > "${Ticket_ID}-policy.json"
rm -rf rwlaname.txt rwlname.txt action1.txt ${Ticket_ID}-crud.yml
fi
}

Ticket_ID=$1
Service_Name=$2
Permission_Name=$3
ARN_Name=$4


if [ -z "$ARN_Name" ] || [ "$ARN_Name" == "*" ]
then
without_arn
else
with_arn
fi
