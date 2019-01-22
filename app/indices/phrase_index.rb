ThinkingSphinx::Index.define :phrase, with: :active_record do
  indexes original, sortable: true
  has chapter_id
end