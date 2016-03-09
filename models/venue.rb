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

  validate :name_cannot_be_empty
  validates_presence_of :address_line_1, :city, :country, :postcode

  def name_cannot_be_empty
    errors.add(:name, 'name cannot be empty') if name.blank?
  end
end
