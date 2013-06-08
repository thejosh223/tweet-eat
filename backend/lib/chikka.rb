require 'openssl'
require 'open-uri'
require 'base64'
require 'httparty'

class Chikka
  include HTTParty
  debug_output $stderr
end

def sign(payload)
  digest = OpenSSL::Digest::SHA512.new
  pkey = OpenSSL::PKey::RSA.new File.read 'config/angelhack_private_key.pem'
  signature = pkey.sign(digest, payload)
end

def create_payload(http_params)
  URI.encode_www_form(http_params)
end

def sms(number, trans_id, message, new=false)
  uri = '/request'
  username = 'jeodn'
  password = 'DnBJvXym'
  message_id = Time.now.to_i.to_s
  transaction_id = trans_id
  message_type = 'PULL'
  if new
    sub_type = 'START'
  else
    sub_type = 'FREE'
  end
  encoding = 'SMS'
  service = 'DEMO'
  suffix = '8823'
  msisdn = number
  body = message

  to_sign = {'URI' => uri, 
    'USERNAME' => username,
    'PASSWORD' => password,
    'MSISDN' => msisdn,
    'MESSAGE_TYPE' => message_type,
    'ENCODING' => 'SMS',
    'SUB_TYPE' => sub_type,
    'SERVICE' => service,
    'SUFFIX' => suffix,
    'BODY' => body,
    'TRANSID' => transaction_id,
    'MESSAGE_ID' => message_id, }

  puts to_sign

  payload = create_payload(to_sign)
  signature = sign(payload)
  encoded_signature = Base64.encode64(signature).gsub(/\n/, '')

#  HTTParty.debug_output($stdout)

  Chikka.post('https://angelhack-smsgw.chikka.com/request', 
                :body => to_sign,
                :headers => {'SIG' => encoded_signature,
                'Content-Type' => 'application/x-www-form-urlencoded'})
#  HTTParty.post('http://127.0.0.1:9000/request', 
#                :query => to_sign,
#                :headers => {'SIG' => encoded_signature,
#                'Content-Type' => 'application/x-www-form-urlencoded'})
end

