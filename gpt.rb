module ChatGptBot
    API_ENDPOINT = 'https://api.safone.me/chatgpt' # Replace with the actual API endpoint
  
    def self.send_message(message)
      uri = URI(API_ENDPOINT)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
  
      headers = {
        'Content-Type' => 'application/json'
      }
  
      payload = {
        'message' => message,
        'version' => 3,
        'chat_mode' => 'assistant',
        'dialog_messages' => '[{"bot": "", "user": ""}]'
      }
  
      begin
        response = http.post(uri.path, payload.to_json, headers)
  
        if response.is_a?(Net::HTTPSuccess)
          response_body = JSON.parse(response.body)
          # Extract and return the bot's response from the API response
          return response_body['message']
        else
          puts "API Request Failed. Status Code: #{response.code}"
          return nil
        end
      rescue StandardError => e
        puts "Error while sending the message: #{e.message}"
        return nil
      end
    end
  end