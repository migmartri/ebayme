# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem  
  protect_from_forgery # :secret => '2e49953833a00f3e4515c39ecb2bdb4a'
  filter_parameter_logging :password
end 