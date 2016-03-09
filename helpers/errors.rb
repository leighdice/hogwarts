module Errors

  def error_not_found(id)

    (status 404 ; body 
    { :error => "Unable to find venue",
      :code  => 404,
      :description => "Not found",
      :messages => ["Unable to find venue by id: #{id}"]}.to_json)
  end

  def error_invalid(venue)

    (status 400 ; body
    { :error => "Validation Error",
      :code  => 400,
      :description => "Bad Request",
      :messages => venue.errors}.to_json)
  end
end
