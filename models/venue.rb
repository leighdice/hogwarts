class Venue

  include Mongoid::Document

  field :name, type: String
  field :address_line_1, type: String
  field :address_line_2, type: String
  field :address_line_3, type: String
  field :city, type: String
  field :county, type: String
  field :country, type: String
  field :postcode, type: String
end
