json.array!(@events) do |event|
  json.extract! event, :id, :name, :start_date_time, :end_date_time, :event_type, :location, :user_id
  json.url event_url(event, format: :json)
end
