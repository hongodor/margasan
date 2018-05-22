class PhrasePolicy
  attr_reader :user, :phrase

  def initialize(user, phrase)
    @user = user
    @phrase = phrase
  end

  def update?
    phrase.chapter.user == user
  end
end