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

  def expected_venue_record
    return {
      "_id" => "56e402521338596b67000030",
      "address_line_1" => "Richmond Building",
      "address_line_2" => "University of Bristol Students' Union",
      "address_line_3" => "105 Queens Rd",
      "city" => "Bristol",
      "country" => "United Kingdom",
      "county" => "",
      "created_at" => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d/,
      "name" => "Anson Rooms",
      "postcode" => "BS8 1LN",
      "updated_at" => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d/
      }
  end

  def expected_no_redis_venue_record
    return {
      "_id" => "56e9ecd8b9fcc9f549a1981a",
      "address_line_1" => "Millbay Rd",
      "address_line_2" => "",
      "address_line_3" => "",
      "city" => "Plymouth",
      "country" => "United Kingdom",
      "county" => "",
      "created_at" => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d/,
      "name" => "Plymouth Pavillions",
      "postcode" => "PL1 3LF",
      "updated_at" => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d/
      }
  end

  def updated_name_json
    return {
      "name" => "Rspec Test"
    }
  end

  def updated_invalid_name_json
    return {
      "name" => ""
    }
  end

  def venue_with_empty_param(p)
    j = standard_venue_json
    j[p] = ""
    return j
  end

  def add_pre_white_space(p)
    return " " + p
  end

  def add_post_white_space(p)
    return p + " "
  end

  def add_pre_and_post_white_space(p)
    s = add_pre_white_space(p)
    s = add_post_white_space(s)
    return s
  end

  # Headers

  def standard_header
    return { "CONTENT_TYPE" => "application/json" }
  end

  def no_redis_header
    { "CONTENT_TYPE" => "application/json", "X_NO_REDIS" => true }
  end

  # Error Responses

  def empty_param_error(p)
    return { :error => "Validation Error",
      :code  => 400,
      :description => "Bad Request",
      :messages => { "#{p}":["#{p} cannot be empty"]}}.to_json
  end

  def trailing_white_space_error(p)
    return { :error => "Validation Error",
      :code  => 400,
      :description => "Bad Request",
      :messages => { "#{p}":["#{p} cannot have trailing white space"]}}.to_json
  end

  def not_found_with_id_error(id)
    return { :error => "Unable to find venue",
      :code  => 404,
      :description => "Not found",
      :messages => ["Unable to find venue by id: #{id}"]}.to_json
  end

  def default_invalid_url_error
    return { :error => "These are not the links you're looking for",
      :code => 404,
      :description => "Not found",
      :messages => ["The url you requested is invalid"]}.to_json
  end
end
