require 'basic_auth_http'
require 'singleton'
class ExternalUserInfoAdapter
    attr_reader :github_api_user, :github_api_token, :stackoverflow_key
    include Singleton

    def set_settings settings
        @github_api_user = settings['github_api_user']
        @github_api_token = settings['github_api_token']
        @stackoverflow_key = settings['stackoverflow_key']
    end

    def get_settings
        return {
            "github_api_user" => @github_api_user,
            "github_api_token" => @github_api_token,
            "stackoverflow_key" => @stackoverflow_key
        }
    end

    def get_user_avatar_url user_id
        profile = Profile.find_by_user_id(user_id)
        if profile.nil?
            return nil
        elsif profile['avatar_url_source'].to_s.empty?
            return nil
        elsif profile.avatar_url_source == "GitHub"
            github = get_github_data(profile.github_name)
            if github['status'] != "200"
                return nil
            else
                return github['message'].fetch('avatar_url', nil)
            end
        else 
            stackoverflow = get_stack_overflow_data(profile.stackoverflow_name)
            if stackoverflow['status'] != "200"
                return nil
            else
                stackoverflow_results = stackoverflow['message'].fetch('items',[])
                # Neeeded because therer could be multiple partial matches as well
                stackoverflow_results.each do |user|
                    if profile.stackoverflow_name.to_s.empty?
                        return nil
                    elsif user['display_name'].to_s.downcase == profile.stackoverflow_name.to_s.downcase
                        return user['profile_image']
                    end
                end
            end
        end
    end

    def get_user_reputation user_id
        stackoverflow_rep = nil
        github_rep = nil
        if user_id.nil? 
            return {"status" => "404", "message" => "User data not found", "data" => []}
        else
            profile = Profile.find_by_user_id(user_id)
            user = User.find(user_id)
            github = get_github_data(profile.github_name)
            github_rep = {
                "followers" => github['message'].fetch('followers', 0),
                "following" => github['message'].fetch('following', 0),
                "public_repos" => github['message'].fetch('public_repos', 0),
                "public_gists" => github['message'].fetch('public_gists', 0),
                "avatar_url" => github['message'].fetch('avatar_url', nil),
            }

            stackoverflow = get_stack_overflow_data(profile.stackoverflow_name)
            default_items = {
                    "badge_counts" => {
                        "gold" => 0,
                        "silver" => 0,
                        "bronze" => 0
                    },
                    "reputation" => 0,
                    "display_name" => nil,
                    "profile_image" => github['message'].fetch('profile_image', nil),
                }
            stackoverflow_results = stackoverflow['message'].fetch('items',[default_items])
            # Neeeded because therer could be multiple partial matches as well
            stackoverflow_results.each do |user|
                if profile.stackoverflow_name.to_s.empty?
                    stackoverflow_rep = default_items
                elsif user['display_name'].to_s.downcase == profile.stackoverflow_name.to_s.downcase
                    stackoverflow_rep = {
                        "badge_counts" => user.fetch('badge_counts', default_items['badge_counts']),
                        "reputation" => user.fetch('reputation', 0)
                    }
                end
            end
            return {"status" => "200", "github" => github_rep, "stackoverflow" => stackoverflow_rep}
        end
    end

    def get_github_data username=nil
        if username.nil? or username.empty?
            puts "no data"
            return {"status" => "404", "message" => {}}
        else
            preview_header = [{"field" => "Accept", "field_value" => "application/vnd.github.cloak-preview"}]
            github_api_url = "https://api.github.com/users/#{username}"
            client = BasicAuthHTTP.new(@github_api_user, @github_api_token)
            response = client.get_request(github_api_url, preview_header)
            return handle_response(response)
        end
    end

    def get_stack_overflow_data username=nil
        if username.nil? or username.empty?
            puts "no data"
            return {"status" => "404", "message" => {}}
        else
            stackoverflow_base_url = "https://api.stackexchange.com/2.2/users"
            stackoverflow_api_params = "?key=#{@stackoverflow_key}&site=stackoverflow" \
                                       "&order=desc&sort=reputation&inname=#{username}" \
                                       "&filter=default"
            client = BasicAuthHTTP.new(auth=false)
            response = client.get_request(stackoverflow_base_url + stackoverflow_api_params)
            return handle_response(response)
        end
    end

    def handle_response response
        if response.nil? 
            error = {"status" => "505", "message" => "No url entered"}
            return error
        elsif response.code != "200"
            error = {"status" => response.code, "message" => response.message}
            return error
        end
        contents = {"status" => response.code, "message" => JSON.parse(response.body)}
        return contents
    end

end # Module End