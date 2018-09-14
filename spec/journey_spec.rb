require 'journey'

describe Journey do

  let(:aldgate) { double :aldgate }

  it 'can touch in' do
    subject.touch_in(aldgate)
    expect(subject.check_in).to eq aldgate
  end

  it "should touch out" do
    subject.touch_out(aldgate)
    expect(subject.check_out).to eq aldgate
  end

  it "should calculate the correct fare" do
    subject.touch_in(aldgate)
    subject.touch_out(aldgate)
    expect(subject.fare).to eq 1
  end

  it "should apply penalty fares" do
    subject.touch_in(aldgate)
    expect(subject.fare).to eq 6
  end

  it "should apply penalty fares" do
    subject.touch_out(aldgate)
    expect(subject.fare).to eq 6
  end

  it "knows when we are in journey" do
    subject.touch_in(aldgate)
    expect(subject.in_journey?).to eq true
  end

end
