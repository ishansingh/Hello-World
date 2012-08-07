require 'net/http'

class ServicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :signin, :signup, :newaccount, :failure]
  protect_from_forgery :except => :create     

def facebook_redirect

	@redirect_url = 'https://www.facebook.com/dialog/oauth?client_id=326431650744493&redirect_uri=http://www.life-tyme.com:3000/services/facebook_getCode/&scope=read_stream,manage_notifications,user_photos,manage_pages,publish_stream&state=' + rand(36**8).to_s(36)
	redirect_to @redirect_url

	#@x = Net::HTTP.get(uri)
end


def facebook_getCode
	@endUrl = request.request_uri
	if @endUrl.include? "&code=" and !(@endUrl.include? "client_secret")
		stateInd = @endUrl.index('code=') + 5
		urlLen = @endUrl.length
		@code = @endUrl[stateInd,urlLen]
		@redirect_url_token = 'https://graph.facebook.com/oauth/access_token?client_id=326431650744493&redirect_uri=http://www.life-tyme.com:3000/services/facebook_getCode/&client_secret=fbe84127d87c02dbe654aa2f90d320bb&code='+@code
		


		uri = URI.parse(@redirect_url_token)

		@token_string = uri.read

		startInd = @token_string.index('access_token=') + 13
		stopInd = @token_string.length

		@y = @token_string[startInd, stopInd] 
		nextstartInd = @y.index('&')
		@access_token = @y[0, nextstartInd]

		session["facebook_token"] = @access_token
		@a = Atokens.new()
		@a.a_token =  @access_token
		@a.user_id = session[:user_id]
		@a.provider = "facebook"
		@a.save()


		redirect_to services_path



		#open( @redirect_url_token )	
		#url = URI.parse(@redirect_url_token)
		#req = Net::HTTP::Get.new(url.path)
		#@res = Net::HTTP.start(url.host, url.port) {|http|
		#  http.request(req)
		#}
	end
end

def post
	if(params[:post][:fb].include?("1"))
		@api = Koala::Facebook::GraphAPI.new(session["facebook_token"])
		@api.put_wall_post(params[:post][:text])	
	end
	if(params[:post][:twit].include?("1"))
		Twitter.configure do |config|
                	config.consumer_key = '4lAKFHIlvPuYWkHQZXGlg'
                        config.consumer_secret = 'FfVTgOnHHIXsd7LMfAtfUvA6cXsVRQjAtjAqSj3Kq0s'
                        config.oauth_token = session['twitter_token'] #'549918712-NNIxCOlwI7wFkKvsCp6cuvs4JinHdJGVFbWecxLj' #'539297038-F3oni2AgmObm367GOz6Zm1VhG4Dts2gMc2hAhvrd'
                        config.oauth_token_secret = session['twitter_secret'] #'5MQQiJR3EJYSTn6eih1MzZH81nscNNtpLHtM9tJc' #'P8IiObz0V71qa79s3GNLqGpbF9ccQXw9Jz8kIxvV58'
                end
		Twitter.update(params[:post][:text])
	end
	redirect_to services_test_path
end

def test
 @services = current_user.services.order('provider asc')

        begin
                @services = current_user.services.order('provider asc')
                @services.each do |service|
                        if ['facebook'].index(service.provider)
                                if (session["facebook_token"] == nil)
					@allAtokens = Atokens.all()
					@allAtokens.each do | atoken |
						if (atoken.user_id == session[:user_id] && atoken.provider == "facebook")
							session["facebook_token"] = atoken.a_token
						end
					end
				end

				@api = Koala::Facebook::GraphAPI.new(session["facebook_token"])
                             #   @friends = @api.get_connections("me", "friends")
                             #   @statuses = @api.get_connections("me", "statuses") #object("/me/statuses", "fields"=>"message")
                             #   @messages = @api.get_object("me/inbox")
                                @notifications = @api.get_connections("me", "notifications")
                             #   @likes = @api.get_connections("me", "likes")
                                @wallfeed = @api.get_connections("me", "feed")
                             #   @groups = @api.get_connections("me","groups")
                             #   @events = @api.get_connections("me", "events")
                                @newsfeed = @api.get_connections("me","home")
                        end

                        if ['twitter'].index(service.provider)
				if (session["twitter_token"] == nil) 
					@allAtokens1 = Atokens.all()
					@allAtokens1.each do | atoken1 |
						if (atoken1.user_id == session[:user_id] && atoken1.provider == "twitter_token")
							session["twitter_token"] = atoken1.a_token
						end
					end



				end
				if (session["twitter_secret"] == nil )

					@allAtokens2 = Atokens.all()
					@allAtokens2.each do | atoken2 |
						if (atoken2.user_id == session[:user_id] && atoken2.provider == "twitter_secret")
							session["twitter_secret"] = atoken2.a_token
						end
					end

				end


				Twitter.configure do |config|
                			config.consumer_key = '4lAKFHIlvPuYWkHQZXGlg'
                			config.consumer_secret = 'FfVTgOnHHIXsd7LMfAtfUvA6cXsVRQjAtjAqSj3Kq0s'
            	    			config.oauth_token = session['twitter_token'] #'549918712-NNIxCOlwI7wFkKvsCp6cuvs4JinHdJGVFbWecxLj' #'539297038-F3oni2AgmObm367GOz6Zm1VhG4Dts2gMc2hAhvrd'
                			config.oauth_token_secret = session['twitter_secret'] #'5MQQiJR3EJYSTn6eih1MzZH81nscNNtpLHtM9tJc' #'P8IiObz0V71qa79s3GNLqGpbF9ccQXw9Jz8kIxvV58'
        			end

				@twitterFeed = Twitter.home_timeline(:count => 11)
				x = session['authhash']

        ex = URI.parse("https://api.twitter.com/1/statuses/home_timeline.json?include_entities=true ")
                http = Net::HTTP.new(ex.host, ex.port)
                http.use_ssl = true
                res = http.get("https://api.twitter.com/1/statuses/home_timeline.json?include_entities=true", nil)
                @dxx = res.body
				@all = OldTwit.all

				@all.each do | entry  |

					if entry.name == current_user.name
						entry.delete
					end


				end
				
				@old = OldTwit.new
				@old.name = current_user.name #session['authhash']['name']  #'name22' 
				@old.tdata = ActiveSupport::JSON.encode(@twitterFeed)
				@old.save
			end
               		if ['instagram'].index(service.provider)
	    	    	        #@recent_feed = open(URI.parse("http://www.google.com"))
				if (session["i_token"] == nil)
					Atokens.all.each do |atok|
						if (atok.user_id = session[:user_id] && atok.provider == "instagram")
							session["i_token"] = atok.a_token
						end
						

					end
				end


	                	ex = URI.parse("https://api.instagram.com/v1/users/self/feed?access_token=" + session["i_token"])
		                http = Net::HTTP.new(ex.host, ex.port)
		                http.use_ssl = true
		                res = http.get("https://api.instagram.com/v1/users/self/feed?access_token=" + session["i_token"], nil)
		                @sup = res.body
		                @rsup = JSON.parse(@sup)
		                @rsup = @rsup["data"]
	
			end
		 end
        rescue Exception=>ex
                puts ex.message
	        env
        
	end



end



  # GET all authentication services assigned to the current user
  def index
    @services = current_user.services.order('provider asc')
  end

  # POST to remove an authentication service
  def destroy
    # remove an authentication service linked to the current user
    @service = current_user.services.find(params[:id])
    
    if session[:service_id] == @service.id
      flash[:error] = 'You are currently signed in with this account!'
    else
      @service.destroy
    end
    
    redirect_to services_path
  end

  # POST from signup view
  def newaccount
    if params[:commit] == "Cancel"
      session[:authhash] = nil
      session.delete :authhash
      redirect_to root_url
    else  # create account
      @newuser = User.new
      @newuser.name = session[:authhash][:name]
      @newuser.email = session[:authhash][:email]
      @newuser.services.build(:provider => session[:authhash][:provider], :uid => session[:authhash][:uid], :uname => session[:authhash][:name], :uemail => session[:authhash][:email])
      
      if @newuser.save!
        # signin existing user
        # in the session his user id and the service id used for signing in is stored
        session[:user_id] = @newuser.id
        session[:service_id] = @newuser.services.first.id
        
        flash[:notice] = 'Your account has been created and you have been signed in!'
	if session[:authhash][:provider] == 'facebook'
		redirect_to services_facebook_redirect_path
	else
        	redirect_to services_path
	end
      else
        flash[:error] = 'This is embarrassing! There was an error while creating your account from which we were not able to recover.'
        redirect_to root_url
      end  
    end
  end  
  
  # Sign out current user
  def signout 
    if current_user
      session[:user_id] = nil
      session[:service_id] = nil
      session.delete :user_id
      session.delete :service_id
      flash[:notice] = 'You have been signed out!'
    end  
    redirect_to root_url
  end
  
  # callback: success
  # This handles signing in and adding an authentication service to existing accounts itself
  # It renders a separate view if there is a new user to create
  def create
    # get the service parameter from the Rails router
    params[:service] ? service_route = params[:service] : service_route = 'No service recognized (invalid callback)'

    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']
    
    # continue only if hash and parameter exist
    if omniauth and params[:service]

      # map the returned hashes to our variables first - the hashes differs for every service
      
      # create a new hash
      @authhash = Hash.new
      
      if service_route == 'facebook'
        omniauth['extra']['user_hash']['email'] ? @authhash[:email] =  omniauth['extra']['user_hash']['email'] : @authhash[:email] = ''
        omniauth['extra']['user_hash']['name'] ? @authhash[:name] =  omniauth['extra']['user_hash']['name'] : @authhash[:name] = ''
        omniauth['extra']['user_hash']['id'] ?  @authhash[:uid] =  omniauth['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
      elsif service_route == 'github'
        omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
        omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
        omniauth['extra']['user_hash']['id'] ? @authhash[:uid] =  omniauth['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] =  omniauth['provider'] : @authhash[:provider] = ''  
      elsif ['google', 'yahoo', 'twitter', 'myopenid', 'open_id'].index(service_route) != nil
        omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
        omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
        omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''

#CHANGE THIS!

	session['yahoo'] = 'sessoin_yahoo'
	if service_route == 'yahoo'
		session['yahoo'] = omniauth #['credentials']
	end


      else        
        # debug to output the hash that has been returned when adding new services
        render :text => omniauth.to_yaml
        return
      end 
      
      if @authhash[:uid] != '' and @authhash[:provider] != ''
        
        auth = Service.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])

        # if the user is currently signed in, he/she might want to add another account to signin
        if user_signed_in?
          if auth
            flash[:notice] = 'Your account at ' + @authhash[:provider].capitalize + ' is already connected with this site.'
            redirect_to services_path
          else
            current_user.services.create!(:provider => @authhash[:provider], :uid => @authhash[:uid], :uname => @authhash[:name], :uemail => @authhash[:email])
            flash[:notice] = 'Your ' + @authhash[:provider].capitalize + ' account has been added for signing in at this site.'
		if service_route == 'facebook'

			redirect_to services_facebook_redirect_path
		else
            		redirect_to services_path


		end


          end
        else
          if auth
            # signin existing user
            # in the session his user id and the service id used for signing in is stored
            session[:user_id] = auth.user.id
            session[:service_id] = auth.id
	if service_route == 'twitter'

		session['twitter_token'] = omniauth['credentials']['token']
		session['twitter_secret'] = omniauth['credentials']['secret']
		b = Atokens.new()
		b.user_id = session[:user_id]
		b.a_token = session["twitter_token"]
		b.provider = "twitter_token"
		b.save()
		c = Atokens.new()
		c.user_id = session[:user_id]
		c.a_token = session["twitter_secret"]
		c.provider = "twitter_secret"
		c.save()

		Twitter.configure do |config|
        	        config.consumer_key = '4lAKFHIlvPuYWkHQZXGlg'
                	config.consumer_secret = 'FfVTgOnHHIXsd7LMfAtfUvA6cXsVRQjAtjAqSj3Kq0s'
	                config.oauth_token = session['twitter_token'] #'549918712-NNIxCOlwI7wFkKvsCp6cuvs4JinHdJGVFbWecxLj' #'539297038-F3oni2AgmObm367GOz6Zm1VhG4Dts2gMc2hAhvrd'
        	        config.oauth_token_secret = session['twitter_secret'] #'5MQQiJR3EJYSTn6eih1MzZH81nscNNtpLHtM9tJc' #'P8IiObz0V71qa79s3GNLqGpbF9ccQXw9Jz8kIxvV58'
        	end
		@twitterFeed = Twitter.home_timeline(:count => 11)
				@old = OldTwit.new
                                @old.name = current_user.name #session['authhash']['name']  #'name22' 
                                @old.tdata = ActiveSupport::JSON.encode(@twitterFeed)
                                @old.save

	end
          
            flash[:notice] = 'Signed in successfully via ' + @authhash[:provider].capitalize + '.'
		if service_route == 'facebook' #session[:authhash][:provider] == 'facebook'
			redirect_to services_facebook_redirect_path
		else
        		redirect_to services_test_path
		end
          else
            # this is a new user; show signup; @authhash is available to the view and stored in the sesssion for creation of a new user
            session[:authhash] = @authhash
            render signup_services_path
          end
        end
      else
        flash[:error] =  'Error while authenticating via ' + service_route + '/' + @authhash[:provider].capitalize + '. The service returned invalid data for the user id.'
        redirect_to signin_path
      end
    else
      flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '. The service did not return valid data.'
      redirect_to signin_path
    end
  end
  
  # callback: failure
  def failure
    flash[:error] = 'There was an error at the remote authentication service. You have not been signed in.'
    redirect_to root_url
  end


  def insta_index
                @c_id = "3af663731521497aadec8e0f2eacdb02"
                @c_secret = "70951e5ea14345cebcce2fa027045d70"
                @i_url = "https://api.instagram.com/oauth/authorize/?client_id=" + @c_id
                @i_url = @i_url + "&redirect_uri=" + "http://www.life-tyme.com:3000/in/icallback"
                @i_url = @i_url + "&response_type=code"
                redirect_to (@i_url)
        end

  def icallback
                @i_code = params[:code]
                uri_ = URI.parse("https://api.instagram.com/oauth/access_token")
                @req = "https://api.instagram.com/oauth/access_token/?client_id=" +  "3af663731521497aadec8e0f2eacdb02"
                @req = @req + "&client_secret=" +   "70951e5ea14345cebcce2fa027045d70"
                @req = @req + "&grant_type=" +   "authorization_code"
                @req = @req + "&redirect_uri=" +   "http://www.life-tyme.com:3000/in/icallback"
                @req = @req + "&code=" + params[:code]
                uri = URI.parse(@req)
                uri = URI.parse 'https://api.instagram.com/oauth/access_token'
                http = Net::HTTP.new(uri.host, uri.port)
                http.use_ssl = true
                request = Net::HTTP::Post.new(uri.request_uri, {'User-agent' => 'Instagram Ruby client 0.5.0'})
                request.set_form_data({
                        :client_id => '3af663731521497aadec8e0f2eacdb02',
                        :client_secret => '70951e5ea14345cebcce2fa027045d70',
                        :grant_type => 'authorization_code',
                        :redirect_uri => 'http://www.life-tyme.com:3000/in/icallback',
                        :code => params[:code]
                })
                response = http.request(request)
                @response = response.body
                @x = JSON.parse(response.body)
                @y = @x["access_token"]
		@uname = @x["user"]["username"]
		@instid = @x["user"]["id"]
                z  = @x["access_token"]
                session["i_token"] = z


		i = Atokens.new()
		i.a_token = session["i_token"]
		i.user_id = session[:user_id]
		i.provider = "instagram"
		i.save()


                #@recent_feed = open(URI.parse("http://www.google.com"))
                ex = URI.parse("https://api.instagram.com/v1/users/self/feed?access_token=" + z)
                http = Net::HTTP.new(ex.host, ex.port)
                http.use_ssl = true
                res = http.get("https://api.instagram.com/v1/users/self/feed?access_token=" + z, nil)
                @sup = res.body
                @rsup = JSON.parse(@sup)
                @rsup = @rsup["data"]

		current_user.services.create!(:provider => "instagram", :uid => @instid, :uname => @uname, :uemail => "")
		redirect_to services_path
        end
end
