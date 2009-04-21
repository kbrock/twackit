class Date
  def to_json(options = {})
    "new Date(#{year}, #{month}, #{day})"
  end
end
