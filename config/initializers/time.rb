class Time
  def to_json(options={})
    self
  end
  def as_json(options = {})
    self
  end
  def encode_json(encoder)
    "new Date(#{year}, #{month-1}, #{day}, #{hour}, #{min}, #{sec})"
  end #:nodoc:

end
