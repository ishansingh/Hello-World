Rails.application.config.middleware.use OmniAuth::Builder  do
  provider :facebook, '326431650744493', 'fbe84127d87c02dbe654aa2f90d320bb',
     {:client_options => {:ssl => {:ca_path => "/usr/lib/ssl"}}}  # Modify this with your SSL certificates path
end

