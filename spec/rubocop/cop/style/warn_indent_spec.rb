# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Style::WarnIndent do
  let(:config) { RuboCop::Config.new }
  subject(:cop) { described_class.new(config) }

  it 'accepts an empty source' do
    inspect_source(cop, '')

    expect(cop.offenses).to be_empty
  end

  it 'accepts a source with no tokens' do
    inspect_source(cop, ' ')

    expect(cop.offenses).to be_empty
  end
end
