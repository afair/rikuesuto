module Rikuesuto
  class Request
    attr_reader   :meta, :body, :files
    attr_accessor :method

    def initialize(method=:get, body=nil, meta={})
      @method = method
      @body   = body || meta.delete(:params) || {}
      @meta   = meta
      @files  = []
    end

    ############################################################################
    # Meta:
    #   :from          = 'user'
    #   :authorization = {method: :key, value:"key"}
    #   :pagination    = {records:0, page:0, pagesize:0, limit:0, offset:0}
    #   :execution     = {requested:0, priority:0, run_at:0, run_before:0}
    ############################################################################

    def authorization; meta[:authorization] || {}; end
    def authorization=(values)
      set_meta(:authorization, values)
    end

    def execution; meta[:execution] || {}; end
    def execution=(values)
      set_meta(:execution, values)
    end

    def pagination; meta[:pagination] || {}; end
    def pagination=(values)
      set_meta(:pagination, values)
    end

    ############################################################################
    # Body: a Hash-like object for params, or other payload
    ############################################################################

    def body=(payload)
      @body = payload
    end

    # Returns the body if it is hash-like, otherwise a frozen emtpy hash
    def params
      body.is_a?(Hash) ? body : {}.freeze
    end

    def [](key)
      params[key]
    end

    def []=(key,value)
      params[key] = value
    end

    ############################################################################
    # Files: Attachments
    ############################################################################

    ############################################################################
    # Transformation: to Rack-Env, Hash (then to JSON, XML, etc.)
    ############################################################################

    def to_hash
      hash = {meta: meta.merge(method:method) }
      hash[:attachments] = files unless files.empty?
      if body.is_a?(Hash)
        hash.merge!(body)
      else
        hash[:body] = body
      end

      hash
    end

    def to_json
      to_hash.to_json
    end

    # => To Rikuesuto::HttpRequest
    def to_http
      #=> [{request}, {headers}, [payload bodies]]
      [{"HTTP_PROTOCOL" => "https", # Correct?
        "HTTP_HOST" => "",
        "SERVER_PORT" => "",
        "REQUEST_METHOD" => method,
        "REQUEST_PATH" => "",
        "QUERY_STRING" => ""},
       {"X-Meta-Authorization" => meta[:authorization].to_json,
        "X-Meta-Request-Id" => meta[:id],
        "From" => meta[:from]},
        [body, *files]]
    end

    ############################################################################
    private

    def set_meta(name, value)
      if meta[name].is_a?(Hash) && value.is_a?(Hash)
        meta[name].merge!(value)
      else
        meta[name] = value
      end
    end

  end
end
