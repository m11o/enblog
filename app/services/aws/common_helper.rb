module Aws
  module CommonHelper
    def aws_credentials
      aws_credentials = {}
      aws_credentials[:region] = ENV['AWS_REGION']
      aws_credentials[:access_key_id] = ENV['AWS_ACCESS_KEY_ID']
      aws_credentials[:secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
      aws_credentials
    end

    def cloudfront_client
      Aws::CloudFront::Client.new aws_credentials
    end

    def s3_client
      Aws::S3::Client.new aws_credentials
    end

    def s3_bucket_name
      ENV['AWS_DEFAULT_BUCKET']
    end
  end
end
