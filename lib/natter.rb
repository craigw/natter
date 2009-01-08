$:.unshift File.dirname(__FILE__)
local_doodle = File.dirname(__FILE__) + '/../vendor/gems/doodle/lib'
if File.exists?(local_doodle)
  $:.unshift local_doodle
end

require 'rubygems'
require 'doodle'
require 'xmpp4r-simple'
require 'natter/contact'
require 'natter/message'
require 'natter/callback'
require 'natter/bot'

if !"".respond_to?(:classify)
  class String
    def classify
      string = self.dup
      string.gsub!(/(\_[a-zA-Z])/) { |c| c[-1,1].upcase }
      string[0,1].upcase + string[1..string.length].to_s
    end
  end
end