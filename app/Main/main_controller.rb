require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'net/http'


class MainController < Rho::RhoController
  include BrowserHelper

  def index
    @contacts = Main.find(:all)
    render :back => '/app'
  end

  def auth
    @login = @params['login']
    @password = @params['password']
    uri = URI.parse("http://calm-brook-51137.herokuapp.com/sport/")

    # header = {'Content-Type'=> 'text/json'}



    user = {:user=> {
        :login=> @login,
        :password=> @password
    }
    }

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = user.to_json
    response = http.request(request)
    puts "CASHA♥♥" + response.body

    # Shortcut
    # response = Net::HTTP.get_response(uri)

    # Will print response.body
    # Net::HTTP.get_print(uri)

    # Full
    # http = Net::HTTP.new(uri.host, uri.port)
    # response = http.request(Net::HTTP::Get.new(uri.request_uri))


    Rho::Notification.showPopup({
                                  :title => "Error",
                                  :message => "send",
                                  :buttons => ["Continue"]})
    redirect :action => :index
  end
end
