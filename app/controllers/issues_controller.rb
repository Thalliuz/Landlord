class IssuesController < ActionController::Base
  layout "application"
  require 'twilio-ruby'
  
  def index
    @issues = Issue.all
  end

  def show
    id = params[:id]
    @issue = Issue.find(id)  
  end
  
  def new
    @user = User.find(session[:id])
    p @user
    @issue = Issue.new
  end

  def create
    @user = User.find(session[:id])
    @issue = Issue.new(issue_params)
    if @issue.save
      twilio_call
      redirect_to "/users/#{@user.id}"
    else
      render "new"
    end
  end
  
  def edit 
  end 

  def update 
    id = params[:issue][:id]
    @issue = Issue.find(id)
    @issue.update_attributes issue_params
    redirect_to "/owners/#{@issue.owner_id}"
  end 

  def destroy
    id = params[:id]
    @issue = Issue.find(id)
    @user = User.find(@issue.user_id)
    @issue.destroy
    redirect_to "/users/#{@user.id}"
  end
end


private

def twilio_call
  account_sid = ENV['ACCOUNT_SID']
  auth_token = ENV['AUTH_TOKEN']

  @client = Twilio::REST::Client.new account_sid, auth_token
  if @user 
    id = @user.owner_id
    @owner_number = Owner.find(id).phonenumber
    @client.api.account.messages.create(
      from: '+18566662318',
      to: "+1#{@owner_number}",
      body: "Home Sweet Home #{@user.address} #{@issue.detail}"
    )
  else
    # When I have more time come back and make it so that Owners can make issues as well
    # id = @owner.user_id
    # @owner_number = Owner.find(id).phonenumber
    # @client.api.account.messages.create(
    #   from: '+18566662318',
    #   to: "+1#{@owner_number}",
    #   body: "Home Sweet Home #{@user.address} #{@issue.detail}"
    # )
  end 
end
def issue_params
  params.require(:issue).permit(:name, :address, :detail, :user_id, :owner_id, :status, :id)
end
