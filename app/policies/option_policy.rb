class OptionPolicy
  attr_reader :user, :option

  def initialize(user, option)
    @user = user
    @option = option
  end

  def destroy?
    user.admin? || option.user == user
  end

end