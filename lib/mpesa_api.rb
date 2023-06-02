require "byebug"
class MpesaApi

    def generate_access_token 
        consumer_key = "5qci9v2zeb71CL4JYZ6RDefYkuoHWkdt"
        consumer_secret = "UkQCLFwug7QfYlce"

        encoded_credentials = ActiveSupport::Base64.encode64("${consumer_key} : ${consumer_secret}")

        byebug
    end




end

