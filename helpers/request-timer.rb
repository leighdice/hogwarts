class Time
  def to_ms
    (self.to_f * 1000.0).to_i
  end
end

module RequestTimer

  def request_timer_start
    Time.now
  end

  def request_timer_calculate(t)
    Time.now.to_ms - t.to_ms
  end

  def request_timer_format(t)
    request_timer_calculate(t).to_s
  end
end
