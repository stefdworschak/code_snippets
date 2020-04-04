json.extract! profile, :id, :firstname, :lastname, :address, :display_name, :github_name, :stackoverflow_name,
 :user_id, :created_at, :updated_at, :stackoverflow_userid, :avatar_url_source
json.url profile_url(profile, format: :json)
