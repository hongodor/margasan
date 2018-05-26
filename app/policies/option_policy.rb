class OptionPolicy
  attr_reader :user, :option

  def initialize(user, option)
    @user = user
    @option = option
  end

  def destroy?
    option.user == user
  end

end