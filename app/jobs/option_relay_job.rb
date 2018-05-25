class OptionRelayJob < ApplicationJob
  queue_as :default

  def perform(option)
    ActionCable.server.broadcast "chapters:#{option.phrase.chapter.id}",
                                 option: OptionsController.render(json: option)
  end
end
