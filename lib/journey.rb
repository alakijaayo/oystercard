class Journey

  attr_reader :check_in, :check_out, :paid_fare

  def initialize
    @check_in = nil
    @check_out = nil
    @paid_fare = 0
  end

  def touch_in(station)
    @check_in = station if @check_in == nil
  end

  def touch_out(station)
    @check_out = station if @check_out == nil
  end

  def fare
    return @paid_fare = 1 if (@check_in != nil) && (@check_out != nil)
    return @paid_fare = 6 if (@check_in != nil) || (@check_out != nil)
    return @paid_fare = 0 if (@check_in == nil) && (@check_out == nil)
  end

  def in_journey?
    @check_in != nil
  end

end
