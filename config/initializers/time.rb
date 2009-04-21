class Time
  def to_json(options = {})
    "new Date(#{year}, #{month}, #{day}, #{hour}, #{min}, #{sec})"
  end
end
