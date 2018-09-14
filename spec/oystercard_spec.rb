require './lib/oystercard'

describe Oystercard do

  let(:mock_station) {double :this_means_nothing_ignore_it}
  let(:exit_station) {double :this_means_nothing_ignore_it}

  let(:journey_class) { double :journey_class, :new => journey }
  let(:journey) { double :journey }
  # allow(mock_station).to receive(:name).and_return('aldgate')

  before(:each) do
    allow(journey).to receive(:in_journey?).and_return(false)
    allow(journey).to receive(:fare).and_return 1
    allow(journey).to receive(:touch_in)
    allow(journey).to receive(:touch_out)
  end

  it 'shows us the balance of a new card' do
    expect(subject.balance).to eq 0
  end
  describe "#top_up" do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    it "adds money to card" do
      expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end

    it 'raises an error when limit exceeded' do
      expect{ subject.top_up(91) }.to raise_error "Maximum limit exceeded!!"
    end
  end

  describe "#deduct" do
    it "takes away a specific amount of money from the balance" do
      expect{ subject.deduct 3 }.to change{ subject.balance }.by -3
    end
  end

  describe '#in_journey?' do
    it 'returns false if card is not in use' do
      expect(subject.in_journey?).to eq false
    end
  end

  describe '#touch_in' do

    before(:each) do
      allow(mock_station).to receive(:name).and_return('aldgate')
    end

    it 'changes in_journey status to true' do
      subject.top_up(1)
      subject.touch_in(mock_station)
      expect(subject.in_journey?).to eq true
    end

    it 'raises an error if balance is less than 1 when touching in' do
      expect{ subject.touch_in(mock_station) }.to raise_error "Sorry, the minimum balance needed is £1"
    end

  end

  describe '#touch_out' do

    before(:each) do
      allow(mock_station).to receive(:name).and_return('aldgate')
      allow(exit_station).to receive(:name).and_return('embankment')
    end

    it 'deducts money from balance when touched out' do
      subject.top_up(1)
      subject.touch_in(mock_station)
      expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by -1
    end
    it 'changes in_use status to false' do
      subject.top_up(1)
      subject.touch_in(mock_station)
      subject.touch_out(exit_station)
      expect(subject.in_journey?).to eq false
    end

    it 'informs you which station you left from' do
      subject.top_up(5)
      subject.touch_in(mock_station)
      expect{ subject.touch_out(exit_station) }.not_to raise_error
    end

    it 'allows to see journey history' do
      oyster = Oystercard.new(journey_class)
      oyster.top_up(5)
      oyster.touch_in(mock_station)
      oyster.touch_out(exit_station)
      expect(oyster.history).to eq [journey]
    end
  end
end
