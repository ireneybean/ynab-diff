class SessionsController < ApplicationController
  def new
    redirect_to '/auth/ynab'
  end

  def create
    reset_session
    session[:auth] = request.env["omniauth.auth"]
    redirect_to root_url, :notice => 'YNAB Auth Successful!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end
end
