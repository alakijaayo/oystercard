require './lib/oystercard'

describe Oystercard do

  let(:mock_station) {double :this_means_nothing_ignore_it}
  let(:exit_station) {double :this_means_nothing_ignore_it}
  # allow(mock_station).to receive(:name).and_return('aldgate')


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

    it 'raises an error if oyster card is currently in journey' do
      subject.top_up(1)
      subject.touch_in(mock_station)
      expect{subject.touch_in(mock_station)}.to raise_error "card is already in use"
    end

    it 'changes in_journey status to true' do
      subject.top_up(1)
      expect(subject.touch_in(mock_station)).to eq true
    end
    it 'raises an error if balance is less than 1 when touching in' do
      expect{ subject.touch_in(mock_station) }.to raise_error "Sorry, the minimum balance needed is £1"
    end
    it 'saves the station of entry' do
      subject.top_up(1)
      subject.touch_in(mock_station)
      expect(subject.station).to eq ['aldgate']
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
      expect(subject.touch_out(exit_station)).to eq false
    end
    it 'sets station back to an empty array' do
      subject.top_up(5)
      subject.touch_in(mock_station)
      subject.touch_out(exit_station)
      expect(subject.station).to eq []
    end

    it 'informs you which station you left from' do
      subject.top_up(5)
      subject.touch_in(mock_station)
      expect{ subject.touch_out(exit_station) }.not_to raise_error
    end

    it 'allows to see journey history' do
      subject.top_up(5)
      subject.touch_in(mock_station)
      subject.touch_out(exit_station)
      expect(subject.history).to eq [{in: mock_station.name, out: exit_station.name}]
    end
  end
end
