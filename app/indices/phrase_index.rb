ThinkingSphinx::Index.define :phrase, with: :real_time do
  indexes original, sortable: true
  indexes translated
  has chapter_id,  type: :integer
end