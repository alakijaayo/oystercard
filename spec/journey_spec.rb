require './lib/journey'
describe Journey do

  let(:mock_station) {double :this_means_nothing_ignore_it}
  let(:exit_station) {double :this_means_nothing_ignore_it}
  let(:card)         {double :Card }

  describe '#in_journey?' do
    it 'returns false if card is not in use' do
      expect(subject.in_journey?).to eq false
    end
  end

  describe '#touch_in' do

    before(:each) do
      allow(mock_station).to receive(:name).and_return('aldgate')
      allow(card).to receive(:top_up).and_return(1)
      allow(card).to receive(:balance).and_return(1)
    end

    it 'raises an error if oyster card is currently in journey' do
      card.top_up(1)
      card.balance(1)
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
