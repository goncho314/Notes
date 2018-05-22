json.extract! note, :id, :user_id, :text, :created_at, :updated_at
json.url note_url(note, format: :json)