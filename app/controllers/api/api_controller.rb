class Api::ApiController < ApplicationController
  include Pundit::Authorization
  include JSONAPI::Deserialization
  include JSONAPI::Fetching
  include JSONAPI::Pagination
  include JSONAPI::Errors

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def jsonapi_pagination(resources)
    return {} unless JSONAPI::Rails.is_collection?(resources)

    super(resources)
  end

  def render_jsonapi_internal_server_error(exception)
    if exception.instance_of? Pundit::NotAuthorizedError
      user_not_authorized
    else
      render(
        json: {
          errors: [{
            status: '500',
            title: 'Internal Server Error',
            detail: 'An unknown error has occurred.'
          }]
        },
        status: :internal_server_error,
        content_type: 'application/vnd.api+json'
      )
    end
  end

  def render_jsonapi_not_found(exception)
    render(
      json: {
        errors: [{
          status: '404',
          title: 'Not Found',
          detail: exception.message
        }]
      },
      status: :not_found,
      content_type: 'applicatoiin/vnd.api+json'
    )
  end

  def user_not_authorized
    render(
      jsonapi_errors: [{
        status: '403',
        title: 'Not Authorized',
        detail: 'User is not allowed to perform the action',
        source: {
          pointer: '/data'
        }
      }], status: :forbidden
    )
  end
end
