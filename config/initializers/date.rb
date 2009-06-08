class Date
  def to_json(options = {})
    "new Date(#{year}, #{month-1}, #{day})"
  end
end
