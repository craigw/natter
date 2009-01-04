$:.unshift File.dirname(__FILE__)
local_doodle = File.dirname(__FILE__) + '/../vendor/gems/doodle/lib'
if File.exists?(local_doodle)
  $:.unshift local_doodle
end

require 'rubygems'
require 'doodle'
require 'natter/contact'
require 'natter/message'
require 'natter/bot'
require '/usr/local/lib/ruby/gems/1.8/gems/xmpp4r-simple-0.8.8/lib/xmpp4r-simple'

if !"".respond_to?(:classify)
  class String
    def classify
      string = self.dup
      string.gsub!(/(\_[a-zA-Z])/) { |c| c[-1,1].upcase }
      string[0,1].upcase + string[1..string.length].to_s
    end
  end
end