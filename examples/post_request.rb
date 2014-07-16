module Rikuesuto
  class Processor
    def self.run(method=nil, params={}, options={})
      request(params).run(options)
    end
  end

  class Request
  end
  class Response
  end
end

# ChargeProcessor # ChargeRikuesuto # ChargeRunner # ChargeResource # ChargeService
# # ChargeRequest < Rikuesuto::Request # ChargeController
class ChargeProcessor < Rikuesuto::Processor
  endpoints       url:"/api/charges", queue:"charges" # , class:self||ChargeProcessor
  request_methods :get, :post, :put, :delete, post: :charge, any:[:uncharge]
  rest_options    resource_method: :id, runner: :json||:http||:run
  before_request  :authorize
  rack_runner     HttpClient.runner
  json_runner     ->(request) { MessageQueue.runner(request) }

  def authorize(request)
    if request.authorization[:api_key] == User.find_api_key(request.authorization[:from])
      return true
    else
      respond :not_authorized
    end
  end

  def post(request)
    charge = Charge.find(request[:id])
    if charge.charge!
      respond :ok, "Charged", charge:charge
    else
      param_errors charge.errors.messages
    end
  end

  # Called by request method: self.send(request.method, request)
  def self.methodname(request)
    request.pagination     #=> {page:1, pagesize:20,...}
    request.authorization  #=> {from:"email?", api_key:"", password:""}
    request.meta           #=> {request_id:"uuid", ...}

    # ... magic happens here ...
    ChargeProcessor.find(request[:id]).charge!

    request.param_error(field:"Message")
    request.respond(:ok, "Charged", payment:self.payment)
    request.ok(payment:self.payment)
    request.error(:not_authorized, "Optional Message")
  end
end

ChargeProcessor.run_options().run(:get, id:123) #=> Response
ChargeProcessor.run_options().run_json(:get, id:123).body

class PostResource < Rikuesuto::Resource
  def request; end
  def response; end
  def get; end
  def post; end
  def delete; end
  def put; end
  def collection; end
  def resource; end
  def custom_action; end
end

class Blog < Rikuesuto::Service

end

# Integration of ActionController & Rekuesuto
class PostController < Rekuesuto::Controller
end
