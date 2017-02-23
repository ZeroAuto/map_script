require 'net/http'
require 'json'

class PlaceSearch
  # I decided on keyword arguments over an options hash because it involves less boilerplate code
  def initialize(lat: nil, long: nil, key: "AIzaSyA15ierbUD2StNKxSQ7EUlhkB20vC5ehAw", type: "")
    @lat = lat
    @long = long
    @key = key
    @type = type
    validate_params
    build_hash
  end

  def response_hash
    @body
  end

  private

  def build_hash
    # Since it is already possible to sort the results by distance in the URL request using the 'rankby=distance' param it wasn't necessary to write any code that sorts by distance
    uri = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@lat},#{@long}&rankby=distance&#{@set_type}&key=#{@key}")

    if @errors.length >= 1
      @body = { :status => "301", :message => @errors }
    else
      @body = { :status => "200", :message => [] }
      @type == "all" ? t = 10 : t = 5
      res = Net::HTTP.get_response(uri)
      idx = 0
      body = JSON.parse(res.body)['results']

      t.times do
        # This conditional probably isn't necessary with the test lat and long but for other locations (the middle of the ocean for instance) it is necessary to avoid erroring out
        if idx < body.length
          @body[:message] << { :name => body[idx]['name'], :lat => body[idx]['geometry']['location']['lat'], :long => body[idx]['geometry']['location']['lng'] }
        end

        idx += 1
      end
    end
  end

  def validate_type
    # I could probably replace this with a case expression
    if @type == "bank" || @type == "atm"
      @set_type = "type=#{@type}"
    elsif @type == "all"
      @set_type = "types=atm|bank"
    elsif @type == ""
      @errors << "type is missing"
    else
      @errors << "invalid type"
    end
  end

  def validate_long
    if @long == nil
      @errors << "longitude is missing"
    else
      if @long <= -180 || @long >= 180
        @errors << "invalid longitude"
      end
    end
  end

  def validate_lat
    if @lat == nil
      @errors << "lattitude is missing"
    else
      if @lat <= -90 || @lat >= 90
        @errors << "invalid lattitude"
      end
    end
  end

  def validate_params
    @errors = Array.new
    validate_long
    validate_lat
    validate_type
  end
end
