class MoController < ApplicationController
  def create
    if params[:BODY].start_with?("VERIFY ")
      user = User.where(:verification_code => params[:BODY].split(' ')[1]).first
      user.trans_id = params[:TRANSID]
      user.save!
    elsif params[:BODY].start_with?("COMPLETED ")
      errand_request = ErrandRequest.find(params[:BODY].split(' ')[1])
      errand_request.finished = true
      errand_request.save!
    elsif params[:BODY].start_with?("YES ")
      errand = Errand.find(params[:BODY].split(' ')[1])
      errand.finished = true
      errand.save!
    elsif params[:BODY].start_with?("NO ")
      errand = Errand.find(params[:BODY].split(' ')[1])
      errand_request = ErrandRequest.where(:errand_id => errand.id, :finished => true).first
      errand_request.finished = false
      errand_request.save!
    end
    render json: {"STATUS" => "OK"}
  end
end
