class Time
  def to_json(options = {})
    "new Date(#{year}, #{month-1}, #{day}, #{hour}, #{min}, #{sec})"
  end
end
