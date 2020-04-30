# frozen_string_literal: true

require 'csv'
require 'net/ping/tcp'

# Checks host for availablity using `Net::Ping` from CSV file with `URL` header
class WebsiteChecker
  attr_reader :input_file

  def initialize(input_file)
    @input_file = File.absolute_path(input_file)
  end

  def run
    results = []
    CSV.foreach(input_file, headers: true, header_converters: :symbol) do |row|
      results << { host: row[:url], result: check(row[:url]) }
    end
    results
  end

  private

  def check(host)
    Net::Ping::TCP.new(host, 'http').ping?
  end
end
