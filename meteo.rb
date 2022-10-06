# программа прогноз погоды
# данные берем из метеосервиса https://www.meteoservice.ru/content/export.html

#  подключаем необходимые библиотеки
require 'net/http'
require 'uri'
require 'rexml/document'
require_relative './lib/meteoservice_forecast'

# encoding: UTF-8
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
cities =[
  {"Москва" => 37},
  {"Рязань" => 65},
  {"Санкт-Петербург" => 65},
  {"Саратов" => 149}
]
puts "Погоду для какого города Вы хотите узнать?"
cities.each_with_index do |item, index|
  item.each do |key, value|
    puts "#{index + 1}: #{key}"
  end
end

choice = 0

while choice < 1 || choice > cities.size
  choice = STDIN.gets.to_i
end

id_city = nil
id = cities[choice-1].each {|key, value| id_city = value}

uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{id_city}.xml")
response = Net::HTTP.get_response(uri)

doc = REXML::Document.new(response.body)

city_name = URI.decode_www_form_component(doc.root.elements["REPORT/TOWN"].attributes['sname'])

puts city_name

doc.elements.each("MMWEATHER/REPORT/TOWN/FORECAST") do |element|
  element = MeteoserviceForecast.from_xml(element)
  puts element
end

gets