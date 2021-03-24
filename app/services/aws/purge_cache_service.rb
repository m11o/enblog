module Aws
  class PurgeCacheService
    extend CommonHelper

    class << self
      def call!(*paths)
        return if paths.blank?

        response = create_invalidation! paths
        Rails.logger.info "##### purged paths: #{paths.join(', ')}"
        return if response.present? && response.invalidation.present? && (response.invalidation.status == 'InProgress')

        Rails.logger.warn "Response from CloudFront: #{response.inspect}"
        raise 'キャッシュの削除に失敗しました。'
      end

      private

      def create_invalidation!(paths)
        Rails.logger.info '##### begin purging cache'
        response = cloudfront_client.create_invalidation(
          {
            distribution_id: Rails.application.credentials.aws[:cloud_front][:distribution_id],
            invalidation_batch: { paths: { quantity: paths.size, items: paths }, caller_reference: Time.now.to_s }
          }
        )
        Rails.logger.info '##### end purging cache'
        response
      end
    end
  end
end
