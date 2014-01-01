module Corner::LogsHelper
  Date::DATE_FORMATS[:calendar_date] = lambda do |date|
    date.strftime("#{Date::DAYS_INTO_WEEK.key(date.days_to_week_start).to_s.capitalize}, \
    %B %e %Y");
  end
  
  def generate_log_path(log)
    # if log.present?
    log_params = { year: log.log_date.year.to_s, 
                 month: log.log_date.month.to_s,
                 day: log.log_date.day.to_s }
    corner_logs_path(log_params) 
    # else
    #   log_path = new_corner_log_path
    # end
    # log_path
  end
  
  def generate_log_path_with_date(date=Time.zone.today)
    # log = Corner::Log.find_by(log_date: date)
    # generate_log_path(log)
    log_params = { year: date.year.to_s, month: date.month.to_s, day: date.day.to_s }
    corner_logs_path(log_params)
  end
  
  def generate_tags_string(log)
    log.tags.map { |tag| tag.name }.to_sentence(last_word_connector: ", ")
  end
end
