class ChapterPolicy
  attr_reader :user, :chapter

  def initialize(user, chapter)
    @user = user
    @chapter = chapter
  end

  def destroy?
    user.admin? || chapter.user == user
  end
end