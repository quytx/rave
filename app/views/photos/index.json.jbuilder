json.array!(@photos) do |photo|
  json.extract! photo, :id, :link
  json.url photo_url(photo, format: :json)
end
