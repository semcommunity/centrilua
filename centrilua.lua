local json = require("cjson")
local http = require("resty.http")
local hmac = require("api-gateway.resty.hmac")

local Centrilua = {}

Centrilua.__index = Centrilua

setmetatable(Centrilua, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Centrilua.new(centrifugo_url, secret)
  local self = setmetatable({}, Centrilua)
  self.url = centrifugo_url
  self.secret = secret
  return self
end

function Centrilua:_generate_api_sign(encoded_data)
  return hmac:new():digest("sha256", self.secret, encoded_data)
end

function Centrilua:publish(channel, payload)
  local httpc = http:new()
  local reqbody = json.encode({
    method = 'publish',
    params = {
      channel = channel,
      data = payload
    }
  })
  local sign = self:_generate_api_sign(reqbody)
  local res, err = httpc:request_uri(self.url, {
    method = "POST",
    body = reqbody,
    headers = {
      ["Content-Type"] = "application/json",
      ["X-API-Sign"] = sign
    }
  })
  if not res then
    ngx.say('failed to request: ', err)
  end
  ngx.status = res.status
end

return Centrilua