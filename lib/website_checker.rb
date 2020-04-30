# frozen_string_literal: true

require 'csv'
require 'net/ping/tcp'
require 'pry'

# Checks host for availablity using `Net::Ping` from CSV file with `URL` header
class WebsiteChecker
  class UnableToFindHeader < StandardError; end

  HEADER = 'URL'

  attr_reader :input_file

  def initialize(input_file)
    @input_file = File.absolute_path(input_file)
  end

  def run
    results = []
    csv = CSV.open(input_file, headers: true).read
    raise UnableToFindHeader unless csv.headers.include?(HEADER)

    csv.each do |row|
      results << { host: row[HEADER], result: check(row[HEADER]) }
    end
    results
  end

  private

  def check(host)
    Net::Ping::TCP.new(host, 'http').ping?
  end
end
