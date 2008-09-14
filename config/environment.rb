RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'Madrid'

  config.action_controller.session = {
    :session_key => '_ebaymovil_session',
    :secret      => '91442d20d831687555d13fc7a0225c127d433904d18c586c2f10755e00eea4db6cc863da7c423087090cd8f0d8148882e4c54aced0baa6b0398f2381ee951a30'
  } 

end

TIME_MIN_TO_SMS = 5.minutes
TIME_REFRESH = 1.minute
SITE_URL = RAILS_ENV == "development" ? "localhost:3000" : "ebay.flowersinspace.com"
$tz = TZInfo::Timezone.get('Europe/Madrid')