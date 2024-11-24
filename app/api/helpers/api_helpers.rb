module APIHelpers
  extend Grape::API::Helpers

  def render_jsonapi(resource, serializer, options = {})
    serializer.new(resource, options).serializable_hash.to_json
  end
end
