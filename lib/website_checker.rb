# frozen_string_literal: true

require 'csv'
require 'net/ping/tcp'

# Checks host for availablity using `Net::Ping::TCP` from CSV file with `URL` header
class WebsiteChecker
  # Exception raised when expected {HEADER} not found in CSV
  class UnableToFindHeader < StandardError; end

  HEADER = 'URL'

  attr_reader :input_file

  # Creates instance with `input_file`
  # @param input_file [String] path to CSV file
  def initialize(input_file)
    @input_file = File.absolute_path(input_file)
  end

  # Runs actual check of hosts loaded from `input_file`
  # @return [Array<Hash>] array of hashes with keys `:host`, `:result`
  # @raise [Errno::ENOENT] if `input_file` not exists
  # @raise [UnableToFindHeader] if expected {HEADER} not found in CSV
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
