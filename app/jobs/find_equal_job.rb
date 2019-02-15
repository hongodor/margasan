class FindEqualJob < ApplicationJob
  queue_as :default
  def perform(chapter)
    ch = chapter.phrases

    ch.where(original: ch.group(:original).having("count(original) > 1").count.keys).select([:id, :original])
  end

  end