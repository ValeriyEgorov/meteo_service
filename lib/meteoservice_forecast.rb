require 'date'

class MeteoserviceForecast

  CLOUDINESS = { "-1" => "туман", "0" => "ясно", "1" => "малооблачно", "2" => "облачно", "3" => "пасмурно" }

  TOD = %w(ночь утро день вечер)

  def self.from_xml(params)

    @day = params.attributes['day']
    @month = params.attributes['month']
    @year = params.attributes['year']
    new(
      date: Date.parse("#{@day}.#{@month}.#{@year}"),
      temperature_max: params.elements["TEMPERATURE"].attributes["max"],
      temperature_min: params.elements["TEMPERATURE"].attributes["min"],
      wind_max: params.elements["WIND"].attributes["max"],
      cloudiness: params.elements["PHENOMENA"].attributes["cloudiness"],
      time_of_day: params.attributes["tod"]
    )

  end

  def initialize(params)
    @date = params[:date]
    @temperature_max = params[:temperature_max]
    @temperature_min = params[:temperature_min]
    @wind_max = params[:wind_max]
    @cloudiness = params[:cloudiness]
    @time_of_day = params[:time_of_day].to_i
  end

  def today?
    @date == Date.today
  end

  def to_s
    result = today? ? "Сегодня" : @date.strftime("%d.%m.%Y")
    result << ", #{TOD[@time_of_day]}\n"
    result << "от #{@temperature_min} до #{@temperature_max}"
    result << ", ветер #{@wind_max} м/c, #{CLOUDINESS[@cloudiness]}"
    return result
  end
end