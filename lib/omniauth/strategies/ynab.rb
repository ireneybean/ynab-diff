module OmniAuth
  module Strategies
    class Ynab < OmniAuth::Strategies::OAuth2
      option :name, :ynab

      option  :client_options,
              site: ENV['YNAB_APP_URL'],
              authorize_path: "/oauth/authorize"

      uid do
        raw_info["id"]
      end

      info do
        {
          email: raw_info["email"]
        }
      end

      def raw_info
        @raw_info ||= access_token#.get("/api/v1/me.json").parsed
      end
    end
  end
end


# The Authorization Code Grant type, also informally known as the "server-side flow", is intended for server-side applications, where the application Secret can be protected. If you are requesting an access token from a server application that is private and under your control, this grant type can be used. This grant type supports refresh tokens so once the access token expires 2 hours after it was granted, the application can request a new access token without having to prompt the user to authorize again.
#
# Here is the flow to obtain an access token:
#
# Send user to the authorization URL: https://app.youneedabudget.com/oauth/authorize?client_id=[CLIENT_ID]&redirect_uri=[REDIRECT_URI]&response_type=code, replacing [CLIENT_ID] and [REDIRECT_URI] with the values configured when creating the OAuth Application. The user will be given the option to approve your request for access:Authorizing an OAuth Application
# Upon approval, the user's browser will be redirected to the [REDIRECT_URI] with a new authorization code sent as a query parameter named code. For example, if your Redirect URI is configured as https://myawesomeapp.com, upon the user authorizing your application, they would be redirected to https://myawesomeapp.com/?code=8bc63e42-1105-11e8-b642-0ed5f89f718b.
# Now that your application has an authorization code, you need to request an access token by sending a POST request to https://app.youneedabudget.com/oauth/token?client_id=[CLIENT_ID]&client_secret=[CLIENT_SECRET]&redirect_uri=[REDIRECT_URI]&grant_type=authorization_code&code=[AUTHORIZATION_CODE]. Here are the values that should be passed as form data fields:
# client_id - The same [CLIENT_ID] sent with the original authorization code in Step 1 above and provided when setting up the OAuth Application.
# client_secret - The client secret provided when setting up the OAuth Application.
# redirect_uri - The same [REDIRECT_URI] sent with the original authorization code request in Step 1 above and specified when setting up the OAuth Application.
# grant_type - The value authorization_code should be provided for this field, which will indicate that you are supplying an authorization code and requesting an access token.
# code - The authorization code received as code query param in Step 2 above.
# The access_token, which can be used to authenticate through the API, will be included in the token response which will look like this:
#
# {
#   "access_token": "0cd3d1c4-1107-11e8-b642-0ed5f89f718b",
#   "token_type": "bearer",
#   "expires_in": 7200,
#   "refresh_token": "13ae9632-1107-11e8-b642-0ed5f89f718b"
# }
# The access token has an expiration, indicated by the "expires_in" value. To obtain a new access token without requiring the user to manually authorize again, you should store the "refresh_token" and then send a POST request to https://app.youneedabudget.com/oauth/token?client_id=[CLIENT_ID]&client_secret=[CLIENT_SECRET]&grant_type=refresh_token&refresh_token=[REFRESH_TOKEN]. If successful, the response will contain a new access token and a new refresh token in the original token response format. A refresh token can only be used once to obtain a new access token, and will be revoked the first time you use the new access token.
# Authorization Parameters
# READ-ONLY SCOPE
# When an OAuth application is requesting authorization, a scope parameter with a value of read-only can be passed to request read-only access to a budget. For example: https://app.youneedabudget.com/oauth/authorize?client_id=[CLIENT_ID]&redirect_uri=[REDIRECT_URI]&response_type=token&scope=read-only. If an access token issued with the read-only scope is used when requesting an endpoint that modifies the budget (POST, PATCH, etc.) a 403 Forbidden response will be issued. If you do not need write access to a budget, please use the read-only scope.
#
# STATE PARAMETER
# An optional, but recommended, state parameter can also be supplied to prevent Cross Site Request Forgery (XRSF) attacks. If specified, the same value will be returned to the [REDIRECT_URI] as a state parameter. For example: if you included parameter state=4cac8f43 in the authorization URI, when the user is redirected to [REDIRECT_URI], the URL would contain that same value in astate parameter. The value of state should be unique for each request.
#
# Default Budget Selection
# An OAuth application can optionally have 'default budget selection' enabled.
#
# OAuth Default Budget Setting
# When default budget selection is enabled, a user will be asked to select a default budget when authorizating your application:
#
# OAuth Default Budget Selection
# You can then pass in the value 'default' in lieu of a budget_id in endpoint calls. For example, to get a list of accounts on the default budget you could use this endpoint: https://api.youneedabudget.com/v1/budgets/default/accounts.
#
# Access Token Usage
# Once you have obtained an access token, you must use HTTP Bearer Authentication, as defined in RFC6750, to authenticate when sending requests to the API. We support Authorization Request Header and URI Query Parameter as means to pass an access token.
#
# Authorization Request Header
# The recommended method for sending an access token is by using an Authorization Request Header where the access token is sent in the HTTP request header.