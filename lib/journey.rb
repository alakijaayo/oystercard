require './lib/oystercard'
class Journey

  attr_reader :in_journey

  def initialize(card = Oystercard.new)
    @in_journey = false
    @card = card
  end

  def in_journey?
    @in_journey
  end

  def touch_in(start_point)
    if @in_journey == true
      fail "card is already in use"
    else
      fail "Sorry, the minimum balance needed is £1" if @card.balance < Oystercard::MINIMUM_BALANCE
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
