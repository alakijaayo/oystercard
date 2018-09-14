require './lib/station'
require './lib/journey'

class Oystercard
  CARD_LIMIT = 90
  MINIMUM_BALANCE = 1
  attr_reader :balance, :history, :current_journey

  def initialize(journey_class = Journey)
    @balance = 0
    @journey_class = journey_class
    @current_journey = @journey_class.new
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
    @current_journey.in_journey?
  end

  def touch_in(start_point)
    deduct(@current_journey.fare) if in_journey?
    @history << @current_journey if in_journey?
    @current_journey = @journey_class.new
    fail "Sorry, the minimum balance needed is £1" if @balance < MINIMUM_BALANCE
    @current_journey.touch_in(start_point)
  end

  def touch_out(end_point)
    @current_journey.touch_out(end_point)
    deduct(@current_journey.fare)
    @history.push(@current_journey)
    @current_journey = @journey_class.new
  end
  
end
