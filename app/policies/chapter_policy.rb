class ChapterPolicy
  attr_reader :user, :chapter

  def initialize(user, chapter)
    @user = user
    @chapter = chapter
  end

  def create?
    @chapter.project.user == user
  end

  def destroy?
    user.admin? or chapter.user == user
  end
end