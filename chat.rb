def send_chatbot_request(query, user_id, bot_name, bot_master)
    # Set the API endpoint URL
    api_url = URI.parse('https://api.safone.me/chatbot')
  
    # Create a hash of the query parameters
    params = {
      'query' => query,
      'user_id' => user_id,
      'bot_name' => bot_name,
      'bot_master' => bot_master
    }
  
    # Create a HTTP GET request with the query parameters
    request = Net::HTTP::Get.new("#{api_url.path}?#{URI.encode_www_form(params)}")
  
    # Make the HTTP request
    response = Net::HTTP.start(api_url.host, api_url.port, use_ssl: true) do |http|
      http.request(request)
    end
  
    # Check the response
    if response.code == '200'
      # Parse and return the response JSON
      data = JSON.parse(response.body)
      return data['response']
    else
      return "Error: #{response.code} - #{response.message}"
    end
  end
