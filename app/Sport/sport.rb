require 'json'
require 'rest_client'

class Sport < Rhoconnect::Model::Base
  include Rhom::PropertyBag
  # Uncomment the following line to enable sync with Sport.
  enable :sync

  def initialize(source)
    @base = 'http://0.0.0.0:9292/sport'
    super(source)
  end


  def query(params=nil)
    rest_result = RestClient.get("#{@base}.json").body

    if rest_result.code != 200
      raise Rhoconnect::Model::Exception.new("Error connecting!")
    end
    parsed = JSON.parse(rest_result)

    @result={}
    parsed.each do |item|
      @result[item["sport"]["id"].to_s] = item["sport"]
    end if parsed
  end

  def create(create_hash)
    res = RestClient.post(@base,:product => create_hash)

    # After create we are redirected to the new record.
    # We need to get the id of that record and return
    # it as part of create so rhoconnect can establish a link
    # from its temporary object on the client to this newly
    # created object on the server
    JSON.parse(
        RestClient.get("#{res.headers[:location]}.json").body
    )["sport"]["id"]
  end

  def update(update_hash)
    obj_id = update_hash['id']
    update_hash.delete('id')
    RestClient.put("#{@base}/#{obj_id}",:sport => update_hash)
  end

  def delete(delete_hash)
    RestClient.delete("#{@base}/#{delete_hash['id']}")
  end


  #add model specific code here
end
