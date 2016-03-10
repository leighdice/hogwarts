class Venue

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :name,            type: String
  field :address_line_1,  type: String
  field :address_line_2,  type: String, default: ->{ "" }
  field :address_line_3,  type: String, default: ->{ "" }
  field :city,            type: String
  field :county,          type: String, default: ->{ "" }
  field :country,         type: String
  field :postcode,        type: String

  validates_each :name, :address_line_1, :city, :country, :postcode do |record, attr, value|
    record.errors.add attr, "#{attr} cannot be empty" if value.blank?
    record.errors.add attr, "#{attr} cannot have trailing white space" if value[-1].eql?(" ") || value[1].eql?(" ")
  end
end
