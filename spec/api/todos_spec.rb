require 'spec_helper'

describe 'Todos API', api: true do
  let(:user_params) { { email: 'test@test.com', password: '123test123' } }

  let!(:user) { Todo::Models::User.create user_params }

  let!(:access_token) do
    session_creator = Todo::Services::SessionCreator.new(user_params)
    expect(session_creator).to be_valid
    session_creator.access_token
  end

  let(:list_item) do
    list_item = user.list_items.create(list_item_params)
    expect(list_item).to be_saved
    list_item
  end

  context 'when creating a list item' do
    let(:list_item_params) do
      {
        description: 'Buy beer',
        priority: 1,
        completed: false,
        due_date: '2014-01-01'
      }
    end

    context 'when passing an invalid access token' do

      it 'should not allow retrieving a list of my items' do
        get '/api/list_item'

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(last_response.body).to have_json_path 'errors/default'
        expect(last_response.status).to eq 501
      end

      it 'should not allow to create' do
        post '/api/list_item', { list_item: list_item_params }

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(last_response.body).to have_json_path 'errors/default'
        expect(last_response.status).to eq 501
      end

      it 'should not allow to edit' do
        edit_params = { list_item: { description: 'Buy wine bottles' } }
        put "/api/list_item/#{list_item.id}", edit_params

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(last_response.body).to have_json_path 'errors/default'
        expect(last_response.status).to eq 501
      end

      it 'should not allow to destroy' do
        delete "/api/list_item/#{list_item.id}"

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(last_response.body).to have_json_path 'errors/default'
        expect(last_response.status).to eq 501
      end
    end

    context 'when passing a valid access token' do
      before do
        set_cookie "access_token=#{access_token}"
      end

      it 'should retrieve a list of my items' do
        list_item

        get '/api/list_item'

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(last_response.body).to have_json_size(1).at_path '/'
        expect(last_response.status).to eq 200
      end

      it 'should create a list item' do
        post '/api/list_item', { list_item: list_item_params }

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        last_response.body.tap do |body|
          expect(body).to have_json_path 'id'
          expect(body).to have_json_path 'description'
          expect(body).to have_json_path 'priority'
          expect(body).to have_json_path 'due_date'
          expect(body).to have_json_path 'completed'
        end
        expect(last_response.status).to eq 200
      end

      it 'should edit a list item owned by you' do
        edit_params = { list_item: { description: 'Buy wine bottles' } }
        put "/api/list_item/#{list_item.id}", edit_params

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        last_response.body.tap do |body|
          expect(body).to have_json_path 'id'
          expect(body).to have_json_path 'description'
          expect(body).to have_json_path 'priority'
          expect(body).to have_json_path 'due_date'
          expect(body).to have_json_path 'completed'
          expect(JSON.parse(body)['description']).to eq 'Buy wine bottles'
        end

        expect(last_response.status).to eq 200
      end

      it 'should destroy a list item owned by you' do
        delete "/api/list_item/#{list_item.id}"

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(last_response.body).to eq ''
        expect(last_response.status).to eq 200
      end
    end
  end
end
