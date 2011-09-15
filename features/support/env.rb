# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

#
# features/support/env.rb
#

# :firefox requires MozillaFirefox 3.7 or later !!

$: << File.join(File.dirname(__FILE__), "..", "..", "lib")

browser = ( ENV['BROWSER'] ? ENV['BROWSER'].to_sym : nil ) || :firefox #:htmlunit #:chrome #:firefox
host = ENV['TESTHOST'] || 'andromeda.suse.de'

# basic support for rebranding of strings in the UI
BRANDING = ENV['BRANDING'] || 'suse'

def debrand_string(str)
  case BRANDING
    when 'suse'
      case str
        # do not replace
        when "Update Kickstart" then str
        when "Kickstart Snippets" then str
        when "Create a New Kickstart Profile" then str
        when "Step 1: Create Kickstart Profile" then str
        when "Test Erratum" then str
        # replacement exceptions
        when "Create Kickstart Distribution" then "Create Autoinstallable Distribution"
        when "upload new kickstart file" then "upload new kickstart/autoyast file"
        when "Upload a New Kickstart File" then "Upload a New Kickstart/AutoYaST File"
        when "RHN Reference Guide" then "Reference Guide"
        when "Create Errata" then "Create Patch"
        # generic regex replace
        when /.*kickstartable.*/ then str.gsub(/kickstartable/, 'autoinstallable')
        when /.*Kickstartable.*/ then str.gsub(/Kickstartable/, 'Autoinstallable')
        when /.*Kickstart.*/ then str.gsub(/Kickstart/, 'Autoinstallation')
        when /Errata .* created./ then str.sub(/Errata/, 'Patch')
        when /.*errata update.*/ then str.gsub(/errata update/, 'patch update')
        when /.*Erratum.*/ then str.gsub(/Erratum/, 'Patch')
        when /.*erratum.*/ then str.gsub(/erratum/, 'patch')
        when /.*Errata.*/ then str.gsub(/Errata/, 'Patches')
        when /.*errata.*/ then str.gsub(/errata/, 'patches')
        else str
      end
    else str
  end
end

# may be non url was given
if host.include?("//")
  raise "TESTHOST must be the FQDN only"
end
host = "https://#{host}"

$myhostname = `hostname -f`
$myhostname.chomp!

ENV['LANG'] = "en_US.UTF-8"
ENV['IGNORECERT'] = "1"

require 'rubygems'
require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'capybara-webkit'

require File.join(File.dirname(__FILE__), '/cobbler_test.rb')

require 'culerity' if browser == :htmlunit

#Capybara.app = Galaxy
Capybara.default_wait_time = 5
Capybara.default_wait_time = 30

# Register different browsers
Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end

# capybara-webkit does not need registration, it is done by
# the require 'capybara-webkit' part

case browser
when :htmlunit
  Capybara.default_driver = :culerity
  Capybara.use_default_driver
else
  Capybara.default_driver = "selenium_#{browser}".to_sym
  #Capybara.default_driver = :webkit
  #Capybara.javascript_driver = :webkit
  
  Capybara.app_host = host
end

# don't run own server on a random port
Capybara.run_server = false

if Capybara.javascript_driver == :webkit
  def screen_shot_and_save_page
    require 'capybara/util/save_and_open_page'
    path = "/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}"
    Capybara.save_page body, File.join(Dir.tmpdir, "#{path}.html")
    page.driver.render File.join(File.dirname(__FILE__), '..', '..', "#{path}.png")
    #"#{Capybara.save_and_open_page_path}" 
  end

  begin
    After do |scenario|
      screen_shot_and_save_page if scenario.failed?
    end
  rescue Exception => e
    STDERR.puts "Snapshots not available for this environment.Have you got gem 'capybara-webkit' in your Gemfile and have you enabled the javascript driver?"
  end
end
