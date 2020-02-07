OUTPUT=/tmp/output.txt
rm $OUTPUT
snowsql -f /var/task/get-property-value.sql -o output_file=$OUTPUT -o output_format=plain
if test -f $OUTPUT; then
	echo -e "\e[32m$OUTPUT exists\e[0m"
	export FIRSTLINE=$(cat $OUTPUT | head -1)
	if [ "$FIRSTLINE" == "Statement executed successfully." ]; then
		SNOWFLAKE_IAM_USER=$(cat $OUTPUT | head -2 | tail -1)
		##echo -e "\e[32mSNOWFLAKE_IAM_USER: $SNOWFLAKE_IAM_USER\e[0m"
		echo -e "\e[32mSNOWFLAKE_IAM_USER written successfully\e[0m"
		AWS_EXTERNAL_ID=$(cat $OUTPUT | head -3 | tail -1)
		##echo -e "\e[32mAWS_EXTERNAL_ID: $AWS_EXTERNAL_ID\e[0m"
		echo -e "\e[32mAWS_EXTERNAL_ID written successfully\e[0m"
	fi		
else 
	echo -e "\e[31m$OUTPUT does not exist\e[0m"
fi
JSON_SECRET='{"snowflake-storage-aws-iam-user-arn":"'"$SNOWFLAKE_IAM_USER"'","snowflake-storage-aws-external-id":"'"$AWS_EXTERNAL_ID"'"}'
aws secretsmanager update-secret --secret-id tfgm_da_snowflake_landing_integration --secret-string $JSON_SECRET

export RETURN_CODE=$?
if [ "$RETURN_CODE" == 0 ]; then	
	echo -e "\e[32mSecrets manager update completed successfully\e[0m"
else
	echo -e "\e[31mSecrets manager update failed: $RETURN_CODE\e[0m"	 	
fi	