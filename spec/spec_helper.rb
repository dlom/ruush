require "rspec"
require "webmock/rspec"
require "ruush"

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true
end

def mock_password_auth(email, password, key, is_premium, usage_bytes)
  body = "#{is_premium ? 1 : 0},#{key},,#{usage_bytes}"
  stub_request(:post, Ruush::endpoint("/api/auth")).with(:body => {:e => email, :p => password, :z => "poop"}).to_return :body => body
end

def mock_key_auth(key, is_premium, usage_bytes)
  body = "#{is_premium ? 1 : 0},#{key},,#{usage_bytes}"
  stub_request(:post, Ruush::endpoint("/api/auth")).with(:body => {:k => key, :z => "poop"}).to_return :body => body
end

def mock_history(key)
  things = []
  10.times do |i|
    things.push "#{i},1970-#{i}-1 12:34:56,http://puu.sh/#{i}.png,#{i}.gif,#{i}"
  end
  body = "0\n#{things.join(",0\n")},0\n"
  stub_request(:post, Ruush::endpoint("/api/hist")).with(:body => {:k => key}).to_return :body => body
end

def mock_delete(key, id)
  things = []
  10.times do |i|
    things.push "#{i},1970-#{i}-1 12:34:56,http://puu.sh/#{i}.png,#{i}.gif,#{i}"
  end
  body = "0\n#{things.join(",0\n")},0\n"
  stub_request(:post, Ruush::endpoint("/api/del")).with(:body => {:k => key, :i => id, :z => "poop"}).to_return :body => body
end
