require 'chikka'

class MoController < ApplicationController
  def create
    if params[:body].start_with?("VERIFY ")
      user = User.where(:verification_code => params[:body].split(' ')[1]).first
      user.trans_id = params[:transid]
      user.phone_number = params[:msisdn]
      #verified is verification_code.nil?
      user.verification_code = nil
      user.save!
      sms(user.phone_number, user.trans_id, "Congratulations! Registration successful!", true)
    elsif params[:body].start_with?("COMPLETED ")
      errand_request = ErrandRequest.find(params[:body].split(' ')[1])
      errand_request.finished = true
      errand_request.save!
      errand = errand_request.errand
      requestor = errand.user
      runner = errand_request.user
      sms(runner.phone_number, runner.trans_id, "#{requestor.first_name} #{requestor.last_name} is being notified that the task was completed.")
      sms(requestor.phone_number, requestor.phone_number, "#{runner.first_name} #{runner.last_name} said he has finished the task. Is this true? Reply YES #{errand.id} or NO #{errand.id}")
    elsif params[:body].start_with?("YES ")
      errand = Errand.find(params[:body].split(' ')[1])
      errand.finished = true
      errand.save!
      errand_request = ErrandRequest.where(:errand_id => errand.id, :finished => true).first
      requestor = errand.user
      runner = errand_request.user
      sms(runner.phone_number, runner.trans_id, "Congratulations, the payment will be transferred shortly.")
      sms(requestor.phone_number, requestor.phone_number, "#{runner.first_name} #{runner.last_name} will receive the payment shortly.")
    elsif params[:body].start_with?("NO ")
      errand = Errand.find(params[:body].split(' ')[1])
      errand_request = ErrandRequest.where(:errand_id => errand.id, :finished => true).first
      errand_request.finished = false
      errand_request.save!
      requestor = errand.user
      runner = errand_request.user
      sms(runner.phone_number, runner.trans_id, "Sorry but #{requestor.first_name} #{requestor.last_name} found your job unsatisfactory.")
    else
      sms(params[:msisdn], params[:transid], "Invalid keywords entered.")
#      sms(requestor.phone_number, requestor.phone_number, "#{runner.first_name} #{runner.last_name} will receive the payment shortly.")
    end
    render json: {"STATUS" => "OK"}
  end
end

