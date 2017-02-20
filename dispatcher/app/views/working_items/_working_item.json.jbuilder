json.extract! working_item, :id, :work_type, :content, :version, :status, :created_at, :updated_at
json.url working_item_url(working_item, format: :json)
