module V1
  module Admin
    class Courts < Grape::API
      before { authenticate! }
      before { authorize_admin! }

      resource :admin do
        resource :courts do
          # POST /admin/courts
          desc 'Create a new court'
          params do
            requires :name, type: String, desc: 'Court name'
            requires :category, type: String, desc: 'Court category'
            requires :price, type: Integer, desc: 'Court price in cents'
            requires :max_players, type: Integer, desc: 'Court max players'
            optional :status, type: String, desc: 'Court status'
            optional :description, type: String, desc: 'Court description'
          end

          post do
            court = Court::Create.call(declared(params))
            CourtSerializer.new(court)
          end

          # PUT /court/:id
          desc 'Update a related court'
          params do
            requires :id, type: Integer, desc: 'Court id'
            optional :category, type: String, values: %w[soccer padel ], desc: 'Court category'
            optional :name, type: String, desc: 'Court name'
            optional :description, type: String, desc: 'Court description'
            optional :max_players, type: Integer, desc: 'Court max players'
            optional :status, type: String, values: %w[open closed], desc: 'Court status'
            optional :price, type: Integer, desc: 'Court price'
          end

          put ':id' do
            court = Court::Update.call(declared(params))
            CourtSerializer.new(court)
          end
        end
      end
    end
  end
end
