require 'discordrb'
require_relative 'gpt.rb'
require 'net/http'
require 'json'
require 'dotenv/load'


bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']

MAX_MESSAGE_LENGTH = 2000

bot.message(with_text: /^\/ask (.+)/) do |event|
  user_input = event.message.content.sub('/ask', '').strip
  bot_response = ChatGptBot.send_message(user_input)

  if bot_response.nil?
    event.respond "An error occurred while processing your request."
  else
    # Split the bot_response into chunks of 2000 characters or less
    while bot_response.length > 0
      chunk = bot_response.slice!(0, MAX_MESSAGE_LENGTH)
      event.respond chunk
    end
  end
end

bot.run

