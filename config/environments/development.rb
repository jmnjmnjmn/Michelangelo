Depot::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.delivery_method = :test

  config.paperclip_defaults = {
    :storage => :s3,
    :s3_host_name=>'s3-us-west-2.amazonaws.com',
    :s3_credentials => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :bucket => ENV['S3_BUCKET_NAME']
    }
  }
    # Paperclip::Attachment.default_options[:url] = '/assets/users/:id/:style/:basename.:extension'
    # Paperclip::Attachment.default_options[:path] = ':rails_root/public/assets/users/:id/:style/:basename.:extension'

    Paperclip::Attachment.default_options[:storage] = :s3
    Paperclip::Attachment.default_options[:s3_credentials] = '#{Rails.root}/config/aws.yml'
    Paperclip::Attachment.default_options[:path] = '/profile/:id/:style:extension'
    Paperclip::Attachment.default_options[:bucket]= "scalableinternetservices/Michelangelo"

end
