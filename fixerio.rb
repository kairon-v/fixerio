require 'date'
require 'json'
require 'net/http'

class FixerIo

  END_POINT = "https://api.fixer.io/".freeze
  IGNORE_DAYS = [0, 6].freeze

  attr_reader :minimum, :maximum, :base_from, :base_to, :amount, :days_to_average

  attr_accessor :date_from, :date_to

  def initialize
    @base_from = 'USD'
    @base_to = 'BRL'
    @amount = 0
    @days_to_average = 0
  end

  # Calculates the average exchange rate
  def average
    (@amount / @days_to_average).round(4) if @days_to_average > 0
  end

  # Gets the exchange rate for each day of the date range
  # calls other methods to calculate minimum, maximum
  # and amount (used to calculate the average) rates
  def calculate!
    range.each do |date|
      rate = exchange_rate_by_date(date)
      self.amount = rate
      self.minimum = rate
      self.maximum = rate
    end
  end

  private

  # Calculates the amount for the date rage
  def amount=(rate)
    # Ignores the first and the last dates
    unless [@date_from, @date_to].include? rate[:date]
      @amount += rate[:rate]
      @days_to_average += 1
    end
  end

  # Sets the minimum exchange rate of the date range.
  # returns a hash with the rate and date
  def minimum=(rate)
    if rate[:date] == @date_from
      @minimum = rate
    else
      @minimum = rate if rate[:rate] < @minimum[:rate]
    end
  end

  # Sets the maximum exchange rate of the date range.
  # returns a hash with the rate and date
  def maximum=(rate)
    if rate[:date] == @date_from
      @maximum = rate
    else
      @maximum = rate if rate[:rate] > @maximum[:rate]
    end
  end

  # Gets all dates between (inclusive) two dates, ignoring the weekend days
  # returns an array of dates
  def range
    from = Date.parse(@date_from)
    to   = Date.parse(@date_to)
    (from..to).to_a.select { |date| !(IGNORE_DAYS.include? date.wday) }
  end

  # Gets the exchange rate for a specific date
  # returns a hash containing the date and the exchange rate
  def exchange_rate_by_date(date)
    puts "Fetching data for the date #{date}"
    uri = URI("#{END_POINT}#{date}?symbols=#{@base_to}&base=#{@base_from}")
    fixer_response = Net::HTTP.get(uri)
    json = JSON.parse(fixer_response)
    {
      date: json['date'],
      rate: json['rates'][@base_to]
    }
  end
end

fixer = FixerIo.new
fixer.date_from = '2009-08-07'
fixer.date_to = '2011-11-17'
fixer.calculate!

puts "Min Rate: #{fixer.minimum[:rate]} (#{fixer.minimum[:date]})"
puts "Max Rate: #{fixer.maximum[:rate]} (#{fixer.maximum[:date]})"
puts "Avg Rate: #{fixer.average} (ignoring #{fixer.date_from} and #{fixer.date_to})"
