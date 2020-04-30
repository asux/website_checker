# frozen_string_literal: true

require_relative 'spec_helper'
require 'website_checker'

RSpec.describe WebsiteChecker do
  subject { described_class.new(input_file) }

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

      it 'returns list with URL and result' do
        expect(subject.run).to eq(results)
      end
    end
  end
end
