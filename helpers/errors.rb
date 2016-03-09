module Errors

  def error_not_found(venue)
    {:status => 404, :message => venue.errors}.to_json
  end

  def error_invalid(venue)
    {:status => 400, :message => venue.errors}.to_json
  end
end
