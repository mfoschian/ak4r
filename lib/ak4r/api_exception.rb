class Ak4r::ApiException < Exception
  attr_accessor :code
  attr_accessor :response

  def initialize(code, response)
    @code = code
    @response = response
  end
end 
