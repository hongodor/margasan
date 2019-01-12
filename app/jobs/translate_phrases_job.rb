class TranslatePhrasesJob < ApplicationJob
  queue_as :default

  def perform(chapter)
    path = ActiveStorage::Blob.service.send(:path_for, chapter.chapter_file.key)
    trans = []
    chapter.phrases.each do |phrase|
      if phrase.translated == ""
        trans << phrase.original
      else
        trans << phrase.translated
      end
    end
    text = JSON.parse(IO.read(path, encoding: "UTF-8"))
    indexer = 0
      text['events'].each do |event|
        unless event.nil?
          event['pages'].each do |page|
            page['list'].each do |i|
              if [401, 405].include?(i['code'])
                i['parameters'][0] = trans[indexer]
                indexer += 1
              elsif i['code'] == 102
                i['parameters'][0].each do |str|
                  str = trans[indexer]
                  indexer += 1
                end
              elsif i['code'] == 402
                i['parameters'][1] = trans[indexer]
                indexer += 1
              end
            end
          end
        end
      end
    File.open(path, "w", encoding: "UTF-8") do |file|
      file << JSON.pretty_generate(text)
    end
  end
end
