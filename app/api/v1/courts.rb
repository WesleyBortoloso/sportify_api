module V1
  class Courts < Grape::API
    before { authenticate! }

    resource :courts do
      # POST /courts
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

      # GET /courts
      desc 'Return a list of courts'
      params do
        optional :filter, type: Hash, desc: "JSON API filtering params"
        optional :page, type: Integer, default: 1, desc: 'Page number'
        optional :per_page, type: Integer, default: 6, desc: 'Items per page'
      end

      get do
        courts = Court.ransack(params[:filter]).result.page(params[:page]).per(params[:per_page])
        CourtSerializer.new(
          courts,
          meta: {
            current_page: courts.current_page,
            total_pages: courts.total_pages,
            total_count: courts.total_count
          }
        )
      end
    end
  end
end
