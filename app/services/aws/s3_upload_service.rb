module Aws
  class S3UploadService
    extend CommonHelper

    def self.call!(body, path, public: true)
      s3_client.put_object(
        body: body,
        bucket: s3_bucket_name,
        key: path,
        acl: public ? 'public-read' : 'private-read'
      )
    end
  end
end
