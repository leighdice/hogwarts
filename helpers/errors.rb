module Errors

  def error_not_found(id)
    {:status => 404, :message => "Unable to find venue by id: #{id}"}.to_json
  end

  def error_invalid(venue)
    {:status => 400, :message => venue.errors}.to_json
  end
end
