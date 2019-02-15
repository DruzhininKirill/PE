require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'net/http'
require 'json'


class MainController < Rho::RhoController
  include BrowserHelper

  def index
    uri = URI.parse("http://calm-brook-51137.herokuapp.com/sport/schedule/")
    user = {:user=> {
        :login=> $session[:login],
        :password=> $session[:password]
    }
    }
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = user.to_json
    response = http.request(request)
    puts "CASHA♥♥" + response.body
    obj = eval(response.body.to_s)
    data = obj[:sch].to_s
    $session[:lessons] = obj[:sch]
    @lessons = obj[:sch]

    puts "!!!!array: "
    render :back => '/app'
  end

  def adminpage
    uri = URI.parse("http://calm-brook-51137.herokuapp.com/sport/schedule/")
    user = {:user=> {
        :login=> $session[:login],
        :password=> $session[:password]
    }
    }
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = user.to_json
    response = http.request(request)
    puts "CASHA♥♥" + response.body
    obj = eval(response.body.to_s)
    data = obj[:sch].to_s
    $session[:lessons] = obj[:sch]
    @alllessons = obj[:sch]

    puts "!!!!array: "
    render :back => '/app'
  end



  def auth
    @login = @params['login']
    @password = @params['password']
    uri = URI.parse("http://calm-brook-51137.herokuapp.com/sport/login/")

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
    data = response.body.to_s
    obj = eval(data)
    mass = obj[:aut]
    puts "massss "+mass.to_s
    if mass[0] == "user"
      puts "WE IN"
      $session[:name] = mass[1][:name]
      $session[:surname] = mass[1][:surname]
      $session[:login] = @login
      $session[:password] = @password

      redirect :action => :index

    elsif data == '{"aut": "admin"}'
      $session[:login] = @login
      $session[:password] = @password
      redirect :action => :adminpage

    else
      Rho::Notification.showPopup({
        :title => "Error",
        :message => "No such user",
        :buttons => ["Try again"]})

      redirect :model => '', :action=> :index
    end
  end

  def newuser
    render :action => :newuser
  end

  def createuser
    @login = $session[:login]
    @password = $session[:password]
    uri = URI.parse("http://calm-brook-51137.herokuapp.com/sport/admin/")


    dataforserver =
        {:user=> {
            :login=> @login,
            :password=> @password},
        :newuser=>{
            :tabnum=> @params['tabnum'],
            :password=> @params['password'],
            :name=> @params['name'],
            :surname=> @params['surname'],
            :email=> @params['email'],
            :group=> @params['group']}
        }

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = dataforserver.to_json
    response = http.request(request)
    puts "CASHA♥♥" + response.body
    data = response.body.to_s

      Rho::Notification.showPopup({
                                      :title => "Message from server",
                                      :message => data,
                                      :buttons => ["Continue"]})

      redirect :model => '', :action=> :index
  end

  def getlesson
    uri = URI.parse("http://calm-brook-51137.herokuapp.com/sport/getlesson/")
    user = {:user=> {
        :login=> $session[:login],
        :password=> $session[:password]
    }
    }
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = user.to_json
    response = http.request(request)
    puts "CASHA♥♥" + response.body
    obj = eval(response.body.to_s)
    data = obj[:gtlsn].to_s
    $session[:lessons] = obj[:gtlsn]
    @schedule = obj[:gtlsn]

    puts "!!!!array: " + @lessons.to_s
    render :back => '/app'
  end

  def joinlesson
    @login = $session[:login]
    @password = $session[:password]
    uri = URI.parse("http://calm-brook-51137.herokuapp.com/sport/dolesson/")
    puts "PARAMS" + @params.to_s
    puts @params['member']
    if @params['member']=='true'
      dom = 'del'
    else
      dom = 'join'
    end

    dataforserver =
        {:user=> {
            :login=> @login,
            :password=> @password},
         :lesson=>{:id=> @params['lessonid'], :do => dom}


        }

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = dataforserver.to_json
    response = http.request(request)
    puts "CASHA♥♥" + response.body
    data = response.body.to_s
    obj = eval(response.body.to_s)
    if obj[:dlsn] == "maxlessons"
      Rho::Notification.showPopup({
                                      :title => "Message from server",
                                      :message => "Превышено количество дисциплин(3)",
                                      :buttons => ["Продолжить"]})
    end
    if obj[:dlsn] == "success"
      Rho::Notification.showPopup({
                                      :title => "Message from server",
                                      :message => "Вы успешно записались на дисциплину",
                                      :buttons => ["Продолжить"]})
    end
    if obj[:dlsn] == "del_success"
      Rho::Notification.showPopup({
                                      :title => "Message from server",
                                      :message => "Вы успешно отписались от дисциплины",
                                      :buttons => ["Продолжить"]})
    end



    redirect :model => :Main, :action=> :index
  end


  end









# Shortcut
# response = Net::HTTP.get_response(uri)

# Will print response.body
# Net::HTTP.get_print(uri)

# Full
# http = Net::HTTP.new(uri.host, uri.port)
# response = http.request(Net::HTTP::Get.new(uri.request_uri))