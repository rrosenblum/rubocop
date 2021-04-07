# frozen_string_literal: true

foo = { 'top_first' =>
{ 'foo' => 'foo',
  'bar' => %w[one two three],
  'baz' => 'baz' },
        'to_second' =>
{ 'foo' => 'foobar',
  'bar' => %w[four five six],
  'baz' => 'foobaz' } }

is_expected.to eq({ 'top_first' =>
{ 'foo' => 'foo',
  'bar' => %w[one two three],
  'baz' => 'baz' },
                    'to_second' =>
{ 'foo' => 'foobar',
  'bar' => %w[four five six],
  'baz' => 'foobaz' } })

is_expected.to eq({ 'first_byte_time_ms' =>
{ 'category' => 'Performance Timings',
  'measurements' => %w[runs pages responses],
  'unit' => 'milliseconds',
  'data_format' => 'milliseconds',
  'friendly' => 'First Byte Time',
  'helper' => 'Time until we receive the first byte of the base HTML document',
  'page_history' => 'server_time' },
                    'dns_time_ms' =>
{ 'category' => 'Performance Timings',
  'measurements' => %w[runs pages responses],
  'unit' => 'milliseconds',
  'data_format' => 'milliseconds',
  'friendly' => 'DNS Time',
  'helper' => 'Time until we receive a response to a DNS query',
  'page_history' => 'dns_time' } })

puts foo
