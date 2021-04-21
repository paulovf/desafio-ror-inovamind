require 'rails_helper'
RSpec.describe User, type: :model do
    it { is_expected.to be_mongoid_document }
    it { is_expected.to have_field(:email).of_type(String) }
    it { is_expected.to have_field(:password_digest).of_type(String) }
end