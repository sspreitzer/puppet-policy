require 'spec_helper'
describe 'policy' do
  context 'with default values for all parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('policy') }
  end
end
