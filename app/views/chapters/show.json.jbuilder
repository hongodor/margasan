json.array! @chapter.phrases do |phrase|
  json.extract! phrase, :id, :original, :translated, :created_at
end