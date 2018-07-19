#!/usr/bin/env ruby
require 'rbnacl/libsodium'
require 'discordrb'
require 'dotenv'
require_relative 'msf_spreadsheet'

Dotenv.load

bot = Discordrb::Commands::CommandBot.new(token: ENV['DISCORD_TOKEN'], client_id: ENV['DISCORD_CLIENT_ID'], prefix: '!')

puts "Para invitar al bot al server:"
puts "#{bot.invite_url}."

bot.command :ultimoasalto do |event|
  response = MSF::Spreadsheet.new.call

  event << "_Estadisticas del ultimo asalto:_"
  event << ""
  event << "- Personaje: **#{response[0]}**"
  event << "- Fecha de finalizacion: **#{response[1]}**"
  event << "- Puesto #1: **#{response[2]}**"
  event << "- Puntos del #1: **#{response[3]}**"
  event << "- Corte top 15: **#{response[4]}**"
  event << "- Corte top 100: **#{response[5]}**"
  event << "- Corte top 1500: **#{response[6]}**"
  event << "- Corte 1-10%: **#{response[7]}**"
  event << "- Corte 11-25%: **#{response[8]}**"
  event << "- Participantes: **#{response[9]}**"
end

bot.run
