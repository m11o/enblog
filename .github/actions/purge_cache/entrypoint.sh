#!/bin/bash

# aws configure
aws configure <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

# aws CloudFront cache purge
CFID=$(aws cloudfront list-distributions --query "DistributionList.Items[].{Id:Id,Origin:Origins.Items[0].DomainName}[?contains(Origin,'${S3_BUCKET_NAME}')] | [0]" | awk '{print $1}')
if [ "${CFID}" != "" ]; then
  echo "aws cloudfront create-invalidation ${CFID}"
  aws cloudfront create-invalidation --distribution-id ${CFID} --paths ${AWS_PURGE_PATHS}
fi
