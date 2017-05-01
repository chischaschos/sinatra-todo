# frozen_string_literal: true
# frozen_string_literal: true require 'spec_helper'

describe 'Todos API', api: true do
  let(:user_params) { { email: 'test@test.com', password: '123test123' } }

  let!(:user) { Todo::Models::User.create user_params }

  let!(:access_token) do
    session_creator = Todo::Services::SessionCreator.new(user_params)
    expect(session_creator).to be_valid
    session_creator.access_token
  end

  let(:list_item) do
    list_item = user.list_items.create(default_list_params)
    expect(list_item).to be_saved
    list_item
  end

  let(:default_list_params) do
    {
      description: 'Buy beer',
      priority: 1,
      completed: false,
      due_date: '2014-01-01',
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
      post '/api/list_item', list_item: default_list_params

      expect(last_response).to be_json
      expect(last_response).not_to have_cookie 'access_token'
      expect(last_response.body).to have_json_path 'errors/default'
      expect(last_response.status).to eq 501
    end

    it 'should not allow to edit' do
      put "/api/list_item/#{list_item.id}", list_item: { description: 'Buy wine bottles' }

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

    context 'when retrieving a list of my items' do
      before do
        [
          { due_date: '2014-01-02', description: 'BB2', priority: 3 },
          { due_date: '2013-01-03', description: 'BB3', priority: 8 },
          { due_date: '2014-01-04', description: 'BB4', priority: 10 },
        ].each do |args|
          user.list_items.create(default_list_params.merge(args))
        end

        expect(user.list_items).to have(3).items
      end

      it 'should retrieve them' do
        list_item

        get '/api/list_item'

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(last_response.body).to have_json_size(4).at_path '/'
        expect(last_response.status).to eq 200
      end

      it 'should retrieve them sorted by priority' do
        get '/api/list_item', sort_by: 'priority', ord: :desc

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(JSON.parse(last_response.body).map { |e| e['priority'] }).to eq([
                                                                                 10, 8, 3
                                                                               ])
        expect(last_response.status).to eq 200
      end

      it 'should retrieve them sorted by due_date' do
        get '/api/list_item', sort_by: 'due_date', ord: :asc

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(JSON.parse(last_response.body).map { |e| e['description'] }).to eq(%w(
                                                                                    BB3 BB2 BB4
                                                                                  ))
        expect(last_response.status).to eq 200
      end
    end

    context 'when creating list items' do
      it 'should create return lits fields' do
        post '/api/list_item', list_item: default_list_params

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

      it 'should create a list item with defaults' do
        post '/api/list_item', list_item: { description: 'some' }

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

      it 'should return errors' do
        post '/api/list_item'

        expect(last_response).to be_json
        expect(last_response).not_to have_cookie 'access_token'
        expect(last_response.body).to have_json_path('errors/description')
        expect(last_response.status).to eq 404
      end
    end

    it 'should edit a list item owned by you' do
      put "/api/list_item/#{list_item.id}", list_item: { description: 'Buy wine bottles' }

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
