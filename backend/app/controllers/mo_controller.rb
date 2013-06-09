require 'chikka'

class MoController < ApplicationController
  def create
    puts 'Please please plase san ka dumaan?????'
    if params[:body].start_with?("verify ")
      user = User.where(:verification_code => params[:body].split(' ')[1]).first
      user.trans_id = params[:transid]
      user.phone_number = params[:msisdn]
      #verified is verification_code.nil?
      user.verification_code = nil
      user.save!
      sms(user.phone_number, user.trans_id, "Congratulations, registration was successful.", true)
    elsif params[:body].start_with?("completed ")
      errand_request = ErrandRequest.find(params[:body].split(' ')[1])
      errand_request.finished = true
      errand_request.save!
      errand = errand_request.errand
      requestor = errand.user
      runner = errand_request.user
      sms(runner.phone_number, runner.trans_id, "#{requestor.first_name} #{requestor.last_name} is being notified that the task was completed.")
      sms(requestor.phone_number, requestor.phone_number, "#{runner.first_name} #{runner.last_name} said he has finished the task. Is this true? Reply yes #{errand.id} or yes #{errand.id}")
    elsif params[:body].start_with?("yes ")
      errand = Errand.find(params[:body].split(' ')[1])
      errand.finished = true
      errand.save!
      errand_request = ErrandRequest.where(:errand_id => errand.id, :finished => true).first
      requestor = errand.user
      runner = errand_request.user
      sms(runner.phone_number, runner.trans_id, "Congratulations the payment will be transferred shortly")
      sms(requestor.phone_number, requestor.phone_number, "#{runner.first_name} #{runner.last_name} will receive the payment shortly.")
    elsif params[:body].start_with?("no ")
      errand = Errand.find(params[:body].split(' ')[1])
      errand_request = ErrandRequest.where(:errand_id => errand.id, :finished => true).first
      errand_request.finished = false
      errand_request.save!
      requestor = errand.user
      runner = errand_request.user
      sms(runner.phone_number, runner.trans_id, "Sorry but #{requestor.first_name} #{requestor.last_name} found your job unsatisfactory.")
    elsif params[:body].start_with?("search ")
      location = params[:body].split(' ', 2)[1]
      found = Errand.near(location)
      if (!found)
        found = []
      end

      fs = found.collect { |e| "#{e.id} / #{e.title} / #{e.price}" }

      message = fs.take(3).join("\n") + "\n Text grab <id> to bid for task."

      puts message

      sms(params[:msisdn], params[:transid], message, true)

    elsif params[:body].start_with?("grab ")
      user = User.where(:trans_id => params[:transid]).first
      errand = Errand.find(params[:body].split(' ')[1])
      if user and errand
        ErrandRequest.new(:user_id => user.id, :errand_id => errand.id).save!
        sms(user.phone_number, user.trans_id, "You have submitted a bid")
      end
    else
      puts 'sana di nageerrorrrrrrr'
      sms(params[:msisdn], params[:transid], "Invalid keywords entered.", true)
      puts 'aba at hindi sana tama na?'
#      sms(requestor.phone_number, requestor.phone_number, "#{runner.first_name} #{runner.last_name} will receive the payment shortly.")
    end
    render json: {"STATUS" => "OK"}
  end
end

