module Aws
  module CommonHelper
    def aws_credentials
      {
        region: Rails.application.credentials.aws[:region],
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key]
      }
    end

    def cloudfront_client
      Aws::CloudFront::Client.new aws_credentials
    end

    def s3_client
      Aws::S3::Client.new aws_credentials
    end

    def s3_bucket_name
      Rails.application.credentials.aws[:s3][:default_bucket_name]
    end
  end
end
