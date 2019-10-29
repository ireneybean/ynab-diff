class HomeController < ApplicationController
  def index
    ynab_api = YNAB::API.new(session[:auth]['credentials']['token'])

    budget_response = ynab_api.budgets.get_budgets
    @budgets = budget_response.data.budgets
  end
end
