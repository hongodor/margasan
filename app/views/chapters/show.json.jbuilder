json.array! @chapter.phrases do |phrase|
    json.id phrase.id
    json.original phrase.original
    json.translated phrase.translated
    json.created_at phrase.created_at
    json.options do
      json.array! phrase.options do |option|
        json.id option.id
        json.content option.content
        json.check option.check
        json.author option.author
        json.user_id option.user_id
      end
    end
end