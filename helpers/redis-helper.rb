module RedisHelper

  def get_all_from_redis
    if $redis.exists("venues")
      if $redis.hlen("venues") < Venue.count
        venues = Venue.all
        add_all_to_redis(venues)
      else
        redis_response = $redis.hgetall("venues")
        venues = []
        redis_response.values.each {|r| venues.push(JSON.parse(r))}
      end
    else
      venues = Venue.all
      add_all_to_redis(venues)
    end

    return venues
  end

  def add_all_to_redis(venues)
    venues.each {|v| $redis.hset("venues", v.id, v.to_json)}
  end

  def get_from_redis(id)
    if $redis.hexists("venues", id)
      return JSON.parse($redis.hget("venues", id))
    else
      venue = Venue.find(id)
      add_to_redis(id, venue)
      return venue
    end
  end

  def add_to_redis(id, venue)
    $redis.hset("venues", id, venue.to_json)
  end

  def del_from_redis(id)
    $redis.hdel("venues", params[:id])
  end

  def can_use_redis?(request)
    if request.env["HTTP_X_NO_REDIS"] || ENV['USE_REDIS'] == false
      return false
    else
      return true
    end
  end
end
