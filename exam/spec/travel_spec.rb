require 'simplecov'
SimpleCov.start

require 'travel_supporter'

describe TimeGetter do
  let(:timeGetter) { TimeGetter.new }
  before(:example) do
    @time = Time.new
  end
  describe '.day_getter' do
    context 'when executed' do
      it { expect { subject.class.day_getter('2') }.not_to raise_error }
    end
    context 'when got the empty string' do
      it { expect(subject.class.day_getter('')).to eq(@time.day) }
    end
  end
  describe '.month_getter' do
    context 'when executed' do
      it { expect { subject.class.month_getter('2') }.not_to raise_error }
    end
    context 'when got the empty string' do
      it { expect(subject.class.month_getter('')).to eq(@time.month) }
    end
  end
  describe '.year_getter' do
    context 'when executed' do
      it { expect { subject.class.year_getter('2') }.not_to raise_error }
    end
    context 'when got the empty string' do
      it { expect(subject.class.year_getter('')).to eq(@time.year) }
    end
  end
  describe '#weekday_name' do
    context 'when executed' do
      it { expect { timeGetter.weekday_name(2015, 2, 12) }.not_to raise_error }
    end
    context 'when got the date of saturday' do
      it { expect(timeGetter.weekday_name(2016, 01, 02)).to eq('Saturday') }
    end
  end
  describe '#weekday' do
    context 'when executed' do
      it { expect { timeGetter.weekday(2015, 02, 12) }.not_to raise_error }
    end
    context 'when got the nonexistent date' do
      it do
        expect { timeGetter.weekday(2015, 02, 30) }
          .to raise_error(ArgumentError, 'invalid date')
      end
    end
    context 'when got the date of saturday' do
      it { expect(timeGetter.weekday(2016, 01, 02)).to eq(6) }
    end
  end
  describe '#check_date' do
    context 'when executed' do
      it do
        expect { timeGetter.check_date(@time.year, @time.month, @time.day) }
          .not_to raise_error
      end
    end
    context 'when getting the bygone year' do
      it do
        expect(timeGetter.check_date(@time.year - 1, @time.month, @time.day))
          .to eq(false)
      end
    end
    context 'when getting the bygone month' do
      it do
        expect(timeGetter.check_date(@time.year, @time.month - 1, @time.day))
          .to eq(false)
      end
    end
    context 'when getting the bygone day' do
      it do
        expect(timeGetter.check_date(@time.year, @time.month, @time.day - 1))
          .to eq(false)
      end
    end
    context 'when getting the correct date' do
      it do
        expect(timeGetter.check_date(@time.year, @time.month, @time.day))
          .to eq(true)
      end
    end
  end
  describe '#check_today_time' do
    context 'when executed' do
      it do
        expect do
          timeGetter.check_today_time(@time.hour.to_s + '-' +
                                     (@time.min + 1).to_s)
        end
          .not_to raise_error
      end
    end
    context 'when got the correct time' do
      it do
        expect(timeGetter.check_today_time((@time.hour + 1).to_s +
        '-' + @time.min.to_s)).to eq(true)
      end
    end
    context 'when got the bygone time' do
      it do
        expect(timeGetter.check_today_time(@time.hour.to_s + '-' +
        (@time.min - 1).to_s)).to eq(false)
      end
    end
  end
  describe '#check_day_of_week' do
    context 'when executed' do
      it do
        expect { timeGetter.check_day_of_week(2016, 1, 1) }
          .not_to raise_error
      end
    end
    context 'when got the date of a workday' do
      it { expect(timeGetter.check_day_of_week(2016, 1, 1)).to eq('workday') }
    end
    context 'when got the date of weekend' do
      it { expect(timeGetter.check_day_of_week(2016, 1, 2)).to eq('weekend') }
    end
  end
end

describe PrepareData do
  before(:example) do
    @pd = PrepareData.new
  end
  describe '#check_empty_string' do
    context 'when executed' do
      it { expect { @pd.check_empty_string('anything') }.not_to raise_error }
    end
    context 'when got empty string' do
      it { expect(@pd.check_empty_string('')).to eq(true) }
    end
    context 'when got string with elements' do
      it { expect(@pd.check_empty_string('something')).to eq(false) }
    end
  end
  describe '#check_text_string' do
    context 'when executed' do
      it { expect { @pd.check_text_string('anything') }.not_to raise_error }
    end
    context 'when got the string which can be converted to number' do
      it { expect(@pd.check_text_string('23')).to eq(false) }
    end
    context 'when got the wrong string' do
      it { expect(@pd.check_text_string('something')).to eq(true) }
    end
  end
  describe '#casual_travel_time' do
    context 'when executed' do
      it { expect { @pd.casual_travel_time('1') }.not_to raise_error }
    end
    context 'when got the string' do
      it 'should eq its number' do
        expect(@pd.casual_travel_time('2')).to eq(2)
        expect(@pd.casual_travel_time('nonnumber')).to eq(0)
      end
    end
  end
  describe '#arrival_time_to_array' do
    context 'when executed' do
      it { expect { @pd.arrival_time_to_array('12-00') }.not_to raise_error }
    end
    context 'when got the time - hour and minutes' do
      it { expect(@pd.arrival_time_to_array('13-24')).to eq([13, 24]) }
    end
    context 'when got the time - hour' do
      it { expect(@pd.arrival_time_to_array('12')).to eq([12, 0]) }
    end
  end
  describe '#convert_minutes_to_hours' do
    context 'when executed' do
      it { expect { @pd.convert_minutes_to_hours(12) }.not_to raise_error }
    end
    context 'when got the number of minutes' do
      it 'should eq the number of hours in them' do
        expect(@pd.convert_minutes_to_hours(72)).to eq(1)
        expect(@pd.convert_minutes_to_hours(-20)).to eq(0)
      end
    end
  end
  describe '#rest_of_minutes' do
    context 'when executed' do
      it { expect { @pd.rest_of_minutes(12) }.not_to raise_error }
    end
    context 'when got the number of minutes' do
      it 'should eq the number of minutes without hours' do
        expect(@pd.rest_of_minutes(72)).to eq(12)
        expect(@pd.rest_of_minutes(31)).to eq(31)
      end
    end
  end
end

describe ValidData do
  before(:example) do
    @vd = ValidData.new
  end
  describe '#valid_arrival_time' do
    context 'when executed' do
      it { expect { @vd.valid_arrival_time('12-00') }.not_to raise_error }
    end
    context 'when got the right time' do
      it { expect(@vd.valid_arrival_time('13')).to eq(true) }
    end
    context 'when got the wrong time' do
      it do
        expect { @vd.valid_arrival_time('') }
          .to raise_error(ArgumentError, 'Invalid time format')
      end
    end
  end
  describe '#valid_hours' do
    context 'when executed' do
      it { expect { @vd.valid_hours('12-13') }.not_to raise_error }
    end
    context 'when got the right number of hours' do
      it { expect(@vd.valid_hours('12')).to eq(true) }
    end
    context 'when got the wrong number of hours' do
      it do
        expect { @vd.valid_hours('24') }
          .to raise_error(ArgumentError, 'Invalid hour')
      end
    end
  end
  describe '#valid_minutes' do
    context 'when executed' do
      it { expect { @vd.valid_minutes('12-13') }.not_to raise_error }
    end
    context 'when got the right number of hours' do
      it { expect(@vd.valid_minutes('12-00')).to eq(true) }
    end
    context 'when got the wrong number of hours' do
      it do
        expect { @vd.valid_minutes('13-60') }
          .to raise_error(ArgumentError, 'Invalid minutes')
      end
    end
  end
end

describe Traffic do
  before(:example) do
    @tr = Traffic.new
  end
  describe '#traffic_jam_hour_weekend' do
    context 'when executed' do
      it { expect { @tr.traffic_jam_hour_weekend(2) }.not_to raise_error }
    end
    context 'when got the hour when traffic is big' do
      it { expect(@tr.traffic_jam_hour_weekend(14)).to eq('Traffic') }
    end
    context 'when got the hour when traffic is small' do
      it { expect(@tr.traffic_jam_hour_weekend(16)).to eq('Possible') }
    end
    context 'when got the hour when there is no traffic' do
      it { expect(@tr.traffic_jam_hour_weekend(2)).to eq('False') }
    end
  end
  describe '#traffic_jam_hour_workday' do
    context 'when executed' do
      it { expect { @tr.traffic_jam_hour_workday(6) }.not_to raise_error }
    end
    context 'when got the hour when traffic is big' do
      it { expect(@tr.traffic_jam_hour_workday(14)).to eq('Traffic') }
    end
    context 'when got the hour when traffic is small' do
      it { expect(@tr.traffic_jam_hour_workday(17)).to eq('Possible') }
    end
    context 'when got the hour when there is no traffic' do
      it { expect(@tr.traffic_jam_hour_workday(2)).to eq('False') }
    end
  end
  describe '#traffic_time_multiple' do
    context 'when executed' do
      it do
        expect { @tr.traffic_time_multiple(12, 2016, 1, 1) }
          .not_to raise_error
      end
    end
    context 'when got the date when traffic is big' do
      it { expect(@tr.traffic_time_multiple(7, 2016, 1, 1)).to eq(2.5) }
    end
    context 'when got the date when traffic is small' do
      it { expect(@tr.traffic_time_multiple(8, 2016, 1, 2)).to eq(1.5) }
    end
    context 'when got the date when there is no traffic' do
      it { expect(@tr.traffic_time_multiple(0, 2016, 1, 1)).to eq(1) }
    end
  end
end

describe CalculateTime do
  before(:example) do
    @ct = CalculateTime.new
  end
  describe '#calculate_route_time' do
    context 'when executed' do
      it do
        expect { @ct.calculate_route_time(30, 8, 2016, 1, 1) }
          .not_to raise_error
      end
    end
    context 'when got the correct arguments' do
      it 'should eq the correct result' do
        expect(@ct.calculate_route_time(30, 8, 2016, 1, 1)).to eq(75)
      end
    end
  end
  describe '#calculate_time_to_go' do
    context 'when executed' do
      it do
        expect { @ct.calculate_time_to_go('08-00', 30, 2016, 1, 1) }
          .not_to raise_error
      end
    end
    context 'when got the right arguments' do
      it 'should eq the correct result' do
        expect(@ct.calculate_time_to_go('08-00', 30, 2016, 1, 1)).to eq('6-45')
      end
    end
  end
end
