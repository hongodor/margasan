class PhrasePolicy
  attr_reader :user, :phrase

  def initialize(user, phrase)
    @user = user
    @phrase = phrase
  end

  def update?
    user.admin? || user == phrase.chapter.user
  end
end