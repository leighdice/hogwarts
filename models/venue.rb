class Venue

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  include Mongoid::Search

  field :name,            type: String
  field :address_line_1,  type: String
  field :address_line_2,  type: String, default: ->{ "" }
  field :address_line_3,  type: String, default: ->{ "" }
  field :city,            type: String
  field :county,          type: String, default: ->{ "" }
  field :country,         type: String
  field :postcode,        type: String

  search_in :name, :address_line_1, :city

  validates_each :name, :address_line_1, :city, :country, :postcode do |record, attr, value|
    record.errors.add attr, "#{attr} cannot be empty" if value.blank?
    record.errors.add attr, "#{attr} cannot have trailing white space" if has_trailing_space?(value)
  end

  private

  def self.has_trailing_space?(value)
    split = value.split(//)
    return split.first.eql?(" ") || split.last.eql?(" ") ? true : false
  end

  def self.update_keywords
    if Mongoid::Search.classes.blank?
        Mongoid::Search::Log.log "No model to index keywords.\n"
      else
        Mongoid::Search.classes.each do |klass|
          Mongoid::Search::Log.silent = ENV['SILENT']
          Mongoid::Search::Log.log "\nIndexing documents for #{klass.name}:\n"
          klass.index_keywords!
        end
      Mongoid::Search::Log.log "\n\nDone.\n"
    end
  end
end
