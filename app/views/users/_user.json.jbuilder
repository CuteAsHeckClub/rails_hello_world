json.extract! user, :id, :name, :cute, :created_at, :updated_at
json.url user_url(user, format: :json)
