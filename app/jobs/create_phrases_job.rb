class CreatePhrasesJob < ApplicationJob
  queue_as :default
# method extract phrases from JSON file and create Phrases as objects
  def perform(chapter)
    path = ActiveStorage::Blob.service.send(:path_for, chapter.chapter_file.key)
    all_strings = []
    f = IO.read(path, encoding: "UTF-8")
    text = JSON.parse(f)
    text['events'].each_with_index do |event, index|
      unless event.nil?
        event_id = index
        event['pages'].each do |page|
          page['list'].each do |i|
            # dialog codes MESSAGE = 401 CHOICE = 102 LOGIC_CHOISE = 402 FLOWING_STRING = 405
            if [401, 405].include?(i['code'])
              all_strings << [event_id, (i['parameters'][0].encode('utf-8').strip)]
            elsif i['code'] == 102
              i['parameters'][0].each do |str|
                all_strings << [event_id, str.encode('utf-8').strip]
              end
            elsif i['code'] == 402
              all_strings << [event_id, i['parameters'][1].encode('utf-8').strip]
            end
          end
        end
      end
    end
    # creating record Phrase.original
    phrases = []
    chapter.update_attribute(:phrases_count, all_strings.count)
    all_strings.each do |phrase|
        phrases << Phrase.new(original: phrase[1], chapter: chapter, event_id: phrase[0])
    end
    Phrase.import phrases
  end
end