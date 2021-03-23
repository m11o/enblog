module Aws
  class S3DeleteService
    extend CommonHelper

    def self.call!(path)
      s3_client.delete_object(
        bucket: s3_bucket_name,
        key: path
      )
    end
  end
end
