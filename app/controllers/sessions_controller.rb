class SessionsController < Devise::SessionsController
  before_action :authenticate_user!
  #after_sign_in_path_for is called by devise
  def after_sign_in_path_for(user)
    "/signedinuserprofile" #here we provide
    #the path for the user's profile end
  end
end # End Module