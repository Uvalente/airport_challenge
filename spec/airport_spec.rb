require 'airport'

describe Airport do
  let(:plane) { double(:plane, :landed? => false, :landing => true) }
  let(:plane_second) { double(:plane, :landed? => false, :landing => true) }
  let(:weather) { double(:weather, :stormy? => true) }

  before(:each) do
    subject.storm = false
  end

  it { is_expected.to respond_to(:land).with(1).argument }

  it { is_expected.to respond_to(:takeoff).with(1).argument }

  describe '#initialize' do
    it 'Creating an Airport should set the default capacity' do
      expect(subject.capacity).to eq Airport::DEFAULT_CAPACITY
    end

    it 'It should be possible to update an Airport capacity' do
      subject.capacity = 5
      expect(subject.capacity).to eq 5
    end
  end

  describe '#land' do
    it 'A landed plane should be visible' do
      subject.land(plane)
      expect(subject.apron).to include plane
    end

    it 'Raise an error if the apron is full' do
      Airport::DEFAULT_CAPACITY.times { subject.land(plane) }
      expect { subject.land(plane) }.to raise_error('The airport is full!')
    end

    it 'In stormy weather raise an error' do
      subject.storm = true
      expect { subject.land(plane) }.to raise_error('The storm prevent the landing!')
    end

    it "A landed plane can't land again" do
      allow(plane).to receive(:landed?) { true }
      expect { subject.land(plane) }.to raise_error('This plane is currently landed!')
    end
  end

  describe '#takeoff' do
    it 'After takeoff the plane should not be in the apron' do
      subject.land(plane)
      subject.takeoff(plane)
      expect(subject.apron).to be_empty
    end

    it 'After takeoff the other planes in the apron should still exist' do
      subject.land(plane)
      subject.land(plane_second)
      subject.takeoff(plane)
      expect(subject.apron).to be_any
    end

    it 'Raise an error if the desired plane is not in the apron' do
      expect { subject.takeoff(plane) }.to raise_error('This plane is not in the apron!')
    end

    it 'In stormy weather raise an error' do
      subject.land(plane)
      subject.storm = true
      expect { subject.takeoff(plane) }.to raise_error('The storm prevent the takeoff!')
    end
  end
end