class Date
  def as_json(options = {})
    self
  end
  def encode_json(encoder)
    "new Date(#{year}, #{month-1}, #{day})"
  end #:nodoc:
end
