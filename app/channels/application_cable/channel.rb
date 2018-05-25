module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def follow(data)
      stop_all_streams
      stream_from "chapters:#{data['chapter_id'].to_i}:phrases"
    end

    def unfollow
      stop_all_streams
    end
  end
end
