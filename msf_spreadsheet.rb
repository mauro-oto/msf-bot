require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'pry'

class MSF
  class Spreadsheet
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
    APPLICATION_NAME = 'API Project'.freeze
    CLIENT_SECRETS_PATH = 'client_secret.json'.freeze
    CREDENTIALS_PATH = 'token.yaml'.freeze
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

    SPREADSHEET_ID = '1KVszr7KRYr8B7wrMioBAxNKXt-2RarYpK8np9Zielfs'.freeze
    RANGE = 'Character 2.0!A5:J5'.freeze

    def initialize
      @service = Google::Apis::SheetsV4::SheetsService.new
      @service.client_options.application_name = APPLICATION_NAME
      @service.authorization = authorize
    end

    def call
      response = @service.get_spreadsheet_values(SPREADSHEET_ID, RANGE)
      response.values.flatten
    end

    private

    ##
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    #
    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def authorize
      client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        url = authorizer.get_authorization_url(base_url: OOB_URI)
        puts 'Open the following URL in the browser and enter the ' \
             "resulting code after authorization:\n" + url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
        )
      end
      credentials
    end
  end
end
