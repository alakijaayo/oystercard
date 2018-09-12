require './lib/station'

class Oystercard
  CARD_LIMIT = 90
  MINIMUM_BALANCE = 1
  attr_reader :balance
  attr_reader :in_journey
  attr_reader :station
  attr_reader :history

  def initialize
    @balance = 0
    @in_journey = false
    @station = []
    @history = []
  end

  def top_up(money)
    fail "Maximum limit exceeded!!" if @balance + money > CARD_LIMIT
    @balance += money
  end

  def deduct(money)
    @balance -= money
  end

  def in_journey?
    @in_journey
  end

  def touch_in(start_point)
    if @in_journey == true
      fail "card is already in use"
    else
      fail "Sorry, the minimum balance needed is £1" if @balance < MINIMUM_BALANCE
      @station << start_point.name
      @start_point = start_point
      @in_journey = true
    end
  end

  def touch_out(end_point)
    deduct(MINIMUM_BALANCE)
    @station = []
    @history.push({in: @start_point.name, out: end_point.name})
    @in_journey = false
  end
end
