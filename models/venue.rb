class Venue

  include Mongoid::Document

  field :name,            type: String
  field :address_line_1,  type: String
  field :address_line_2,  type: String, default: ->{ "" }
  field :address_line_3,  type: String, default: ->{ "" }
  field :city,            type: String
  field :county,          type: String, default: ->{ "" }
  field :country,         type: String
  field :postcode,        type: String

  validates_presence_of :name, :address_line_1, :city, :country, :postcode
end
