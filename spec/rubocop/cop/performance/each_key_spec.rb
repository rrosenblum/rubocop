# encoding: utf-8

require 'spec_helper'
require 'pry'

describe RuboCop::Cop::Performance::EachKey do
  subject(:cop) { described_class.new }

  it 'registers an offense for keys.each with a block' do
    inspect_source(cop, '{a: 1, b: 2, c:3}.keys.each { |k| puts k }')

    expect(cop.messages).to eq(['Use `each_key` instead of `keys.each`.'])
  end

  it 'registers an offense for keys.each without a block' do
    inspect_source(cop, '{a: 1, b: 2, c:3}.keys.each')

    expect(cop.messages).to eq(['Use `each_key` instead of `keys.each`.'])
  end

  it 'registers an offense for keys.each on an assigned variable' do
    inspect_source(cop, ['foo = {a: 1, b: 2, c:3}',
                         'foo.keys.each'].join("\n"))

    expect(cop.messages).to eq(['Use `each_key` instead of `keys.each`.'])
  end

  it 'does not register an offense for keys without each' do
    inspect_source(cop, '{a: 1, b: 2, c:3}.keys')

    expect(cop.messages).to be_empty
  end

  it 'does not register an offense for keys.map' do
    inspect_source(cop, '{a: 1, b: 2, c:3}.keys.map(&:to_s)')

    expect(cop.messages).to be_empty
  end

  it 'does not register and offense for each without keys' do
    inspect_source(cop, '{a: 1, b: 2, c:3}.each')

    expect(cop.messages).to be_empty
  end

  it 'does not register and offense for each with a block without keys' do
    inspect_source(cop, '{a: 1, b: 2, c:3}.each { |e| puts e }')

    expect(cop.messages).to be_empty
  end

  it 'does not register and offense for calling each on ' \
     'a variable named keys' do
    inspect_source(cop, ['keys = {a: 1, b: 2, c:3}.keys',
                         'keys.each { |e| puts e }'].join("\n"))

    expect(cop.messages).to be_empty
  end

  describe 'autocorrect' do
    it 'correct keys.each to each_key with a block' do
      source = '{a: 1, b: 2, c: 3}.keys.each { |k| puts k }'
      new_source = autocorrect_source(cop, source)

      expect(new_source).to eq('{a: 1, b: 2, c: 3}.each_key { |k| puts k }')
    end

    it 'correct keys.each to each_key without a block' do
      new_source = autocorrect_source(cop, '{a: 1, b: 2, c: 3}.keys.each')

      expect(new_source).to eq('{a: 1, b: 2, c: 3}.each_key')
    end
  end
end
