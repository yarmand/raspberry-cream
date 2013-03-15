require "uri"
require "net/http"

class PitaAdapter
  def display(url)
    params = {'url' => url}
    puts "########## DISPLAY #{url} ############"
    begin
      Net::HTTP.post_form(URI.parse('http://localhost:8000/browse/url'), params)
    rescue
      # ignore failure
    end
  end
end
