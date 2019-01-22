class TranslationPolicy
  attr_reader :user, :chapter

  def initialize(user, chapter)
    @user = user
    @chapter = chapter
  end

  def create?
    true
  end
end