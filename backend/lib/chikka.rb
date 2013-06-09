require 'openssl'
require 'open-uri'
require 'base64'
require 'httparty'

class Chikka
  include HTTParty
  debug_output $stdout
end

def sign(payload)
  puts payload
  puts
  digest = OpenSSL::Digest::SHA512.new
  pkey = OpenSSL::PKey::RSA.new File.read 'config/angelhack_private_key.pem'
  signature = pkey.sign(digest, payload)
end

def create_payload(http_params)
  URI.encode_www_form(http_params)
end

def sms(number, trans_id, message, new=false)
  $stdout.sync = true
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

#  payload = to_sign.to_a.collect{|k,v| k + '=' + v}.join('&')

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

def test()

  to_sign = {"URI" => "/request", "USERNAME" => "jeodn", "PASSWORD" => "DnBJvXym", "MSISDN" => "639083543480", "MESSAGE_TYPE" => "PULL", "ENCODING" => "SMS", "SUB_TYPE" => "FREE", "SERVICE" => "DEMO", "SUFFIX" => "8823", "BODY" => "Invalid keywords entered.", "TRANSID" => "5048303030534D415254303030303731313430303031303030303030303036363030303036333930383335343334383030303030313330363039303830353039", "MESSAGE_ID" => "1370736313"}

  puts to_sign

  puts 

#  payload = create_payload(to_sign)
  payload = to_sign.to_a.collect{|k,v| k + '=' + v}.join('&')

  puts

  puts payload

  signature = sign(payload)

  puts

  puts signature

  puts

  encoded_signature = Base64.encode64(signature).gsub(/\n/, '')

  puts

  puts encoded_signature
end
