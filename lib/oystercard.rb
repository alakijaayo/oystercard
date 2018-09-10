
class Oystercard
  CARD_LIMIT = 90
  MINIMUM_BALANCE = 1
  attr_reader :balance
  attr_reader :in_journey

  def initialize
    @balance = 0
    @in_journey = false
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

  def touch_in
    fail "Sorry, the minimum balance needed is £1" if @balance < MINIMUM_BALANCE
    @in_journey = true
  end

  def touch_out
    deduct(MINIMUM_BALANCE)
    @in_journey = false
  end
end
