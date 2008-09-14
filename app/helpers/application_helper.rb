module ApplicationHelper
  def time_to_finish_in_words(time, to_now = Time.now)
    res = ""
    seconds = time - to_now + 1.minute # + 1.minute compensa el truncate :S
    
    [["día", (60 * 60 * 24.0)], ["hora", (60 * 60.0)], ["minuto", 60.0]].each do |text, number|
      if (result = seconds / number) > 1
        res += pluralize(result.truncate, text) + ' '
        seconds = seconds - (result.truncate * number)
      end
    end
    
    res
  end
end
