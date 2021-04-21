require 'rails_helper'

RSpec.describe Quote, :type => :model do
    it { is_expected.to be_mongoid_document }
    it { is_expected.to have_field(:quote).of_type(String) }
    it { is_expected.to have_field(:author).of_type(String) }
    it { is_expected.to have_field(:author_about).of_type(String) }
    it { is_expected.to have_field(:tags).of_type(Array).with_default_value_of([]) } 
end
