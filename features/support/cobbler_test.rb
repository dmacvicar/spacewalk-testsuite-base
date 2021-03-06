#!/usr/bin/ruby
# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

require "xmlrpc/client"
require "pp"


# ct = CobblerTest.new( "taylor.suse.de" )
# bool = ct.is_running()
# bool = ct.system_exists( "bla" )
# any  = ct.system_get_key( "vbox-ug", "uid" )
# list = ct.get_list( "systems" )


class CobblerTest
    def initialize(serverAddress=ENV['TESTHOST'], serverPort=80, serverPath="/cobbler_api")
        @serverAddress = serverAddress
        @serverPort = serverPort
        @serverPath = serverPath
        @server = XMLRPC::Client.new(serverAddress, serverPath, serverPort)
        if ! is_running()
            raise "No running server at found at "+serverAddress
        end
    end

    def login( user, pass )
        begin
            @token = @server.call("login", user,pass)
        rescue
            raise "login to cobbler failed" + $!
        end
    end

    def is_running()
        result = true
        begin
            @server.call("get_profiles")
        rescue
            result = false
        end
        result
    end

    def get_list( what )
        result = []
        if ! ["systems", "profiles", "distros"].include?( what )
            raise "unknown get_list parameter '#{what}'"
        end
        ret = @server.call( "get_"+what )
        ret.each { |a| result << a["name"] }
        result
    end

    def profile_create( name, distro, location )
        begin
            profile_id = @server.call("new_profile", @token)
        rescue
            raise "creating profile failed." + $!
        end
        begin
            @server.call("modify_profile",profile_id, 'name',      name,     @token)
            @server.call("modify_profile",profile_id, 'distro',    distro,   @token)
            @server.call("modify_profile",profile_id, 'kickstart', location, @token)
        rescue
            raise "modify profile failed." + $!
        end
        begin
            @server.call("save_profile",profile_id,                     @token)
        rescue
            raise "saving profile failed." + $!
        end
        profile_id
    end

    def profile_exists( name )
         exists("profiles", "name", name)
    end

    def profile_get_key( name, key )
        result = nil
        if profile_exists( name )
            result = get( "profiles", name, key )
        else
            raise "Profile "+name+" does not exists"
        end
        result
    end

    def system_exists( name )
        exists( "systems", "name", name )
    end

    def system_get_key( name, key )
        result = nil
        if system_exists( name )
            result = get( "systems", name, key )
        else
            raise "System "+name+" does not exists"
        end
        result
    end

    def distro_exists( name )
        exists( "distros", "name", name )
    end

    def distro_get_key( name, key )
        result = nil
        if distro_exists( name )
            result = get( "distros", name, key )
        else
            raise "Distro "+name+" does not exists"
        end
        result
    end

    def distro_create( name, kernel, initrd, breed="suse" )
        begin
            distro_id = @server.call("new_distro", @token)
            @server.call("modify_distro",distro_id, 'name',   name,   @token)
            @server.call("modify_distro",distro_id, 'kernel', kernel, @token)
            @server.call("modify_distro",distro_id, 'initrd', initrd, @token)
            @server.call("modify_distro",distro_id, 'breed',  breed,  @token)
            @server.call("save_distro",distro_id,                     @token)
        rescue
            raise "creating distribution failed." + $!
        end
        distro_id
    end

    def repo_exists( name )
        exists( "repos", "name", name )
    end

    def repo_get_key( name, key )
        result = nil
        if repo_exists( name )
            result = get( "repo", name, key )
        else
            raise "Repo "+name+" does not exists"
        end
        result
    end


protected

    def exists( what, key, value )
        result = false
        ret = @server.call( "get_"+what )
        ret.each { |a|
                    if a[key] == value
                        result = true
                    end
                 }
        result
    end

    def get( what, name, key )
        result = nil
        ret = @server.call( "get_"+what )
        ret.each { |a|
                   if a["name"] == name
                       result = a[key]
                   end
        }
        result
    end


end


