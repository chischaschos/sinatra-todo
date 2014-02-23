require 'rack/contrib'

module Todo
  class Api < Application

    use Rack::PostBodyContentTypeParser

    before '/api/*' do
      content_type :json
    end

    set(:auth_required) do |required|
      if required
        condition do
          @session = Models::Session.first(access_token: request.cookies['access_token'])
          unless @session
            halt 501, { errors: { default: 'Invalid access token' } }.to_json
          end
        end
      end
    end

    post '/api/users', auth_required: false do
      user = Models::User.new(params[:user])

      if user.valid?
        user.save!
        user.to_json

      else
        status 404
        user.h_errors.to_json
      end
    end

    post '/api/session', auth_required: false do
      session = Services::SessionCreator.new(params[:user])

      if session.valid?
        cookie_params = {
          value: session.access_token,
          httponly: true
        }
        response.set_cookie 'access_token', cookie_params
        {}.to_json

      else
        status 404
        session.h_errors.to_json
      end
    end

    post '/api/session', auth_required: false do
      session = Services::SessionCreator.new(params[:user])

      if session.valid?
        cookie_params = {
          value: session.access_token,
          httponly: true,
          secure: true
        }
        response.set_cookie 'access_token', cookie_params

      else
        status 404
        session.h_errors.to_json
      end
    end

    delete '/api/session', auth_required: true do
      if !@session || @session && !@session.destroy
        status 404
        @session.h_errors.to_json
      end
    end

    get '/api/list_item', auth_required: true do
      scope = @session.user.list_items

      if params[:sort_by]
        if params[:ord]
          scope.all(order: params[:sort_by].to_sym.send(params[:ord])).to_json
        else
          scope.all(order: params[:sort_by].to_sym.desc).to_json
        end
      else
        scope.all.to_json
      end
    end

    post '/api/list_item', auth_required: true do
      list_item = @session.user.list_items.create(params[:list_item])

      if list_item.saved?
        list_item.to_json
      else
        status 404
        list_item.h_errors.to_json
      end
    end

    put '/api/list_item/:list_item_id', auth_required: true do |list_item_id|
      list_item = @session.user.list_items.get(list_item_id)
      list_item.attributes = list_item.attributes.merge(params[:list_item])

      if list_item.save
        list_item.to_json
      else
        status 404
        list_item.h_errors.to_json
      end
    end

    delete '/api/list_item/:list_item_id', auth_required: true do |list_item_id|
      list_item = @session.user.list_items.get(list_item_id)

      if !list_item || !list_item.destroy
        status 404
        list_item.h_errors.to_json
      end

    end

  end
end
