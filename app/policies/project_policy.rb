class ProjectPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def edit?
    user.admin? or project.user == user
  end

  def update?
    user.admin? or project.user == user
  end

  def destroy?
    user.admin? or project.user == user
  end
end