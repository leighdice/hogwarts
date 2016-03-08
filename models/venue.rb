# init venue file

class Venue

  include MongoMapper::Document

  key :name, String, :required => true
  key :address_line_1, String, :required => true
  key :address_line_2, String
  key :address_line_3, String
  key :city, String, :required => true
  key :county, String
  key :country, String, :required => true
  key :postcode, String, :required => true
end

class Venue

  attr_accessor :_id,
                :name,
                :address_line_1,
                :address_line_2,
                :address_line_3,
                :city,
                :county,
                :country,
                :postcode

  def initialize(params = {})
    @_id              = "new object id"
    @name             = params[:name]
    @address_line_1   = params[:address_line_1]
    @address_line_2   = params[:address_line_2] || ""
    @address_line_3   = params[:address_line_3] || ""
    @city             = params[:city]
    @county           = params[:county] || ""
    @country          = params[:country]
    @postcode         = params[:postcode]
  end
end
