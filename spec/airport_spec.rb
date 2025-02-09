require 'airport'

describe Airport do
  let(:plane) { Plane.new} # everytime we call plane, Plane.new will be called (can refactor the below to replace all Plane.new)
  it { is_expected.to respond_to(:land).with(1).argument } # is this test redundant now because i have tested this via the 'lands a plane test'
  it { is_expected.to respond_to(:depart).with(1).argument } # also redundant?

  it 'lands a plane' do
    allow_any_instance_of(Weather).to receive(:stormy?).and_return(false)
    expect(subject.land(plane)).to eq [plane] # tests that land method on an airport instance will 'store' the plane instance, add it to the planes array and return the plane so that we can see its been landed at teh airport
  end

  describe 'departing planes' # set context of departing 
  it 'departs a plane' do
    allow_any_instance_of(Weather).to receive(:stormy?).and_return(false)
    subject.land(plane)
    expect(subject.depart(plane)).to eq [] # tests that depart method will work on aiport and will confirm that this particular plane has left the airport after departed
  end

  describe '#lands a plane' do
    it 'raises an error if airport is full' do
      allow_any_instance_of(Weather).to receive(:stormy?).and_return(false)
      subject.capacity.times { subject.land(plane) }
      expect { subject.land(plane) }.to raise_error "Airport is full! No planes can land here." # tries to land 31st plane, and should get error
    end
  end

  describe '#departs a plane' do
    it 'raises an error if this plane is not in the airport' do
      allow_any_instance_of(Weather).to receive(:stormy?).and_return(false)
      expect { subject.depart(plane) }.to raise_error "This plane is not in the airport!" # should get error if attempting to depart a plane which is not in the airport
    end
  end

  describe 'initialisation' do
    it 'defaults capacity' do
      allow_any_instance_of(Weather).to receive(:stormy?).and_return(false)
      described_class::DEFAULT_CAPACITY.times do
        subject.land(plane) # tests that default capacity has been correctly set via the initialize method
      end # and in the line below that it's not possible to exceed capacity when landing planes 
      expect { subject.land(plane) }.to raise_error "Airport is full! No planes can land here." 
    end
  end

  it 'stormy weather means planes cannot land' do
    allow_any_instance_of(Weather).to receive(:stormy?).and_return(true)
    expect { subject.land(plane) }.to raise_error "It's stormy. Planes cannot land at this time."
  end

  it 'stormy weather means planes cannot depart' do
    allow_any_instance_of(Weather).to receive(:stormy?).and_return(true)
    expect { subject.depart(plane) }.to raise_error "It's stormy. Planes cannot depart at this time."
  end

end
