class ChaptersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chapters:#{params[:chapter_id]}"
    logger.add_tags "ActionCable", params[:chapter_id]
    #ActionCable.server.broadcast "chapters:#{params[:chapter_id]}", {test: "Hello from subscribed method"}
  end

  #def send_chapter(data)
  #  ActionCable.server.broadcast "chapters:#{params[:chapter_id]}", {data: data}
  #end
end
