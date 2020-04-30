# frozen_string_literal: true

require_relative 'spec_helper'
require 'website_checker'

RSpec.describe WebsiteChecker do
  subject(:checker) { described_class.new(input_file) }

  describe '#run' do
    context 'when CSV file given' do
      let(:input_file) { 'spec/fixtures/websites_to_check.csv' }
      let(:results) do
        [
          { host: 'google.com', result: true },
          { host: 'raketaapp.com', result: true },
          { host: '42istheansweryouneed.com', result: false }
        ]
      end

      it 'returns list with results' do
        expect(checker.run).to eq(results)
      end
    end

    context 'when input file not exists' do
      let(:input_file) { 'not_existed_file.csv' }

      it 'raises Errno::ENOENT' do
        expect { checker.run }.to raise_error(Errno::ENOENT)
      end
    end

    context 'when CSV file has not URL header' do
      let(:input_file) { 'spec/fixtures/without_url_header.csv' }

      it 'raises WebsiteChecker::UnableToFindHeader' do
        expect { checker.run }.to raise_error(WebsiteChecker::UnableToFindHeader)
      end
    end
  end
end
