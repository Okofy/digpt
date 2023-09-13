require 'discordrb'
require_relative 'gpt.rb'
require_relative 'chat.rb'
require 'net/http'
require 'json'
require 'dotenv/load'


bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']

MAX_MESSAGE_LENGTH = 2000

bot.message(with_text: /^\/ask (.+)/) do |event|
  user_input = event.message.content.sub('/ask', '').strip
  bot_response = ChatGptBot.send_message(user_input)

  if bot_response.nil?
    event.respond "The api is down!"
  else
    # Split the bot_response into chunks of 2000 characters or less
    while bot_response.length > 0
      chunk = bot_response.slice!(0, MAX_MESSAGE_LENGTH)
      event.respond chunk
    end
  end
end
bot.message(with_text: /^\/chat (.+)/) do |event|
  user_input = event.message.content.sub('/chat', '').strip
  repofy = send_chatbot_request(user_input, event.user.id, 'Okofy', 'okofycd')
  if repofy.nil?
    event.respond "The api is down!"
  else
    pic = ["https://telegra.ph/file/191d2e0b18ae97554b1b7.jpg", "https://telegra.ph/file/36e2689f399b4eb54c189.jpg", "https://telegra.ph/file/1c38e39c234374bfb6d0f.jpg", "https://telegra.ph/file/d6ace81bec79559b33df6.jpg", "https://telegra.ph/file/96388da6900f083e020ce.jpg"]
    picr = pic.sample
    # Split the bot_response into chunks of 2000 characters or less
      embed = Discordrb::Webhooks::Embed.new
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'Lotus AI', url: 'https://okofy.vercel.app/', icon_url: picr)
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: repofy, icon_url: 'https://telegra.ph/file/914ca51d8f76822b5f684.jpg')
      event.send_embed('', embed)
  end
end

bot.run

