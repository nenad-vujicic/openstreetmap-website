module Api
  class CapabilitiesController < ApiController
    skip_before_action :check_api_readable

    authorize_resource :class => false

    before_action :set_request_formats

    # External apps that use the api are able to query the api to find out some
    # parameters of the API. It currently returns:
    # * minimum and maximum API versions that can be used.
    # * maximum area that can be requested in a bbox request in square degrees
    # * number of tracepoints that are returned in each tracepoints page
    def show
      @database_status = database_status
      @api_status = api_status
      @gpx_status = gpx_status
    end
  end
end
