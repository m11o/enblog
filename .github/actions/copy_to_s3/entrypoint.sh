#!/bin/bash

# aws configure
aws configure <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

# aws s3 cp
echo "aws s3 cp ${UPLOAD_FILE_PATH} s3://${S3_BUCKET_NAME}/${S3_UPLOAD_PATH} --acl public-read ${UPLOAD_OPTIONS}"
aws s3 cp ${UPLOAD_FILE_PATH} s3://${S3_BUCKET_NAME}/${S3_UPLOAD_PATH} --acl public-read ${UPLOAD_OPTIONS}
