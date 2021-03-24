module Aws
  class PurgeCacheService
    extend CommonHelper

    class << self
      def call!(*paths)
        return if paths.blank?

        response = create_invalidation! paths
        return if response.present? && response.invalidation.present? && (response.invalidation.status == 'InProgress')

        Rails.logger.warn "Fail to delete cache of #{paths.join(', ')}"
        Rails.logger.warn "Response from CloudFront: #{response.inspect}"
        raise 'キャッシュの削除に失敗しました。'
      end

      private

      def create_invalidation!(paths)
        cloudfront_client.create_invalidation(
          {
            distribution_id: ENV['AWS_CLOUD_FRONT_DISTRIBUTION_ID'],
            invalidation_batch: {
              paths: { quantity: paths.size, items: paths },
              # @see http://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CreateInvalidation.html#API_CreateInvalidation_RequestSyntax
              caller_reference: Time.now.to_s
            }
          }
        )
      end
    end
  end
end
