# frozen_string_literal: true

require 'csv'
require 'net/ping/tcp'

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
    unless csv.headers.include?(HEADER)
      raise UnableToFindHeader, "File #{input_file} does not contain header #{HEADER.inspect}"
    end

    csv.each do |row|
      results << { host: row[HEADER], result: check(row[HEADER]) }
    end
    results
  end

  private

  def normilize_host(host)
    return URI.parse(host).host if host.match?(%r{^https?://})

    host
  end

  def check(host)
    Net::Ping::TCP.new(normilize_host(host), 'http').ping?
  end
end
