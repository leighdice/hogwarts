module TestHelper

  # JSONs

  def standard_venue_json
    return {
      "address_line_1" => "Richmond Building",
      "address_line_2" => "University of Bristol Students' Union",
      "address_line_3" => "105 Queens Rd",
      "city" => "Bristol",
      "country" => "United Kingdom",
      "county" => "",
      "name" => "Anson Rooms",
      "postcode" => "BS8 1LN"
    }
  end

  def venue_with_empty_param(p)
    j = standard_venue_json
    j[p] = ""
    return j
  end

  # Error Responses

  def empty_param_error(p)
    return { :error => "Validation Error",
      :code  => 400,
      :description => "Bad Request",
      :messages => { "#{p}":["#{p} cannot be empty"]}}.to_json
  end
end
