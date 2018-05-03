json.extract! note, :id, :user, :text, :created_at, :updated_at
json.url note_url(note, format: :json)
