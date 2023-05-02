usage_plan_name=
new_usage_plan_name=
usage_plan_id=$(aws apigateway get-usage-plans --query "items[?name=='$usage_plan_name'].id" --output text)

echo "Old name: $usage_plan_name"
echo "Id: $usage_plan_id"
echo "New name: $new_usage_plan_name"

if [ -z "$usage_plan_id" ]; then
  echo "Error: Usage plan not found."
  exit 1
fi

aws apigateway update-usage-plan --usage-plan-id "$usage_plan_id" --patch-operations op=replace,path=/name,value="${new_usage_plan_name}"
echo "Usage plan $usage_plan_name has been renamed to $new_usage_plan_name."
