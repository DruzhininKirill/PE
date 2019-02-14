require 'rho/rhocontroller'
require 'helpers/browser_helper'

class SportController < Rho::RhoController
  include BrowserHelper
  # GET /Sport
  def index
    @sports = Sport.find(:all)
    render :back => '/app'
  end

  # GET /Sport/{1}
  def show
    @sport = Sport.find(@params['id'])
    if @sport
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Sport/new
  def new
    @sport = Sport.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Sport/{1}/edit
  def edit
    @sport = Sport.find(@params['id'])
    if @sport
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Sport/create
  def create
    @sport = Sport.create(@params['sport'])
    redirect :action => :index
  end

  # POST /Sport/{1}/update
  def update
    @sport = Sport.find(@params['id'])
    @sport.update_attributes(@params['sport']) if @sport
    redirect :action => :index
  end

  # POST /Sport/{1}/delete
  def delete
    @sport = Sport.find(@params['id'])
    @sport.destroy if @sport
    redirect :action => :index  
  end
end
