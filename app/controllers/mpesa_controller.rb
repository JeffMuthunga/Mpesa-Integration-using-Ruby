class MpesaController < ApplicationController
    def generate_access_token
          consumer_key = "5qci9v2zeb71CL4JYZ6RDefYkuoHWkdt"
          consumer_secret = "UkQCLFwug7QfYlce"
      
          url = "https://sandbox.safaricom.co.ke/oauth/v1/generate"
          uri = URI(url)

          uri.query = URI.encode_www_form({grant_type: "client_credentials"})


          begin
            encoded_credentials = Base64.strict_encode64("#{consumer_key}:#{consumer_secret}")
      
            headers = {
              "Authorization" => "Basic #{encoded_credentials}",
              "Content-Type" => "application/json"
            }
      
           

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
      
            request = Net::HTTP::Get.new(uri.request_uri, headers)
            response = http.request(request)
            byebug
      
            if response.is_a?(Net::HTTPSuccess)
              response_body = JSON.parse(response.body)
              if response_body.key?("access_token")
                return response_body["access_token"]
              else
                error_description = response_body["error_description"]
                raise "Failed to get access token: #{error_description}"
              end
            else
              raise "Failed to get access token. Response code: #{response.code}, Response body: #{response.body}"
            end
          rescue => e
            raise "Failed to get access token: #{e.message}"
          end
        end

    def send_stk_push
        token = generate_access_token
        timestamp = Time.now.strftime('%Y%m%d%H%M%S')
        short_code = "174379" #sandbox -174379
        passkey = "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919"
        stk_password = Base64.strict_encode64("#{short_code}#{passkey}#{timestamp}")
    
        # Choose one URL depending on your development environment
        # Sandbox
        url = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest"
        
    
        headers = {
          'Authorization' => 'Bearer ' + token,
          'Content-Type' => 'application/json'
        }
    
        request_body = {
          "BusinessShortCode" => short_code,
          "Password" => stk_password,
          "Timestamp" => timestamp,
          "TransactionType" => "CustomerPayBillOnline", # "CustomerBuyGoodsOnline" for Till
          "Amount" => "1",
          "PartyA" => "254708374149",
          "PartyB" => short_code,
          "PhoneNumber" => "254759403177",
          "CallBackURL" => "https://yourwebsite.co.ke/callbackurl",
          "AccountReference" => "account",
          "TransactionDesc" => "test"
        }
    
        begin
          uri = URI(url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
    
          request = Net::HTTP::Post.new(uri.path, headers)
          request.body = request_body.to_json
    
          response = http.request(request)
    
          response_body = JSON.parse(response.body)
          puts response_body
          return response_body
        rescue => e
          puts "Error: #{e.message}"
        end
      end
  end