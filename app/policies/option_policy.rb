class OptionPolicy
  attr_reader :user, :option

  def initialize(user, option)
    @user = user
    @option = option
  end

  def update?
    user.admin? || option.user == user
  end

  def destroy?
    user.admin? || option.user == user || @option.phrase.chapter.user == user
  end
end