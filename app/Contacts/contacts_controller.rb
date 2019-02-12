require 'rho/rhocontroller'
require 'helpers/browser_helper'

class ContactsController < Rho::RhoController
  include BrowserHelper

  # GET /Contacts
  def index
    @contacts = Contacts.find(:all)
    render :back => '/app'
  end


end
