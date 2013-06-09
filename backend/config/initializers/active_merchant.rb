require 'rubygems'
require 'active_merchant'

ActiveMerchant::Billing::Base.mode = :test
$gateway = ActiveMerchant::Billing::PayflowGateway.new(
  :login => 'test',
  :password => 'password',
)
