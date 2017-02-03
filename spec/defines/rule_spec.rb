require 'spec_helper'
describe 'policy::rule' do
  let(:title) { 'custom.setting' }

  context 'with default values for all parameters' do
    let(:params) {
      {
        :component => 'nova',
        :value     => 'testtest'
      }
    }
    it { is_expected.to contain_augeas('nova-custom.setting-policy').with(
      :lens    => 'Json.lns',
      :incl    => '/etc/nova/policy.json',
      :context => '/files/etc/nova/policy.json',
      :changes => [
        'set dict/entry[last()+1] "custom.setting"',
        'set dict/entry[last()]/string "testtest"'
      ]
    )}
  end

  context 'with a yaml policy and default parameters' do
    let(:params) {
      {
        :component => 'nova',
        :value     => 'testtest',
        :type      => 'yaml',
      }
    }
    it { is_expected.to contain_augeas('nova-custom.setting-policy').with(
      :lens    => 'Yaml.lns',
      :incl    => '/etc/nova/policy.yaml',
      :context => '/files/etc/nova/policy.yaml',
      :changes => [
        'set dict/entry[last()+1] "custom.setting"',
        'set dict/entry[last()]/string "testtest"'
      ]
    )}
  end

  context 'with faulty type' do
    let(:params) {
      {
        :component => 'nova',
        :value     => 'testtest',
        :type      => 'faultytype',
      }
    }
    it { is_expected.to raise_error(Puppet::Error, /extension faultytype is unknown/)}
  end

  context 'with default values and absenting policy' do
    let(:params) {
      {
        :component => 'nova',
        :ensure    => 'absent'
      }
    }
    it { is_expected.to contain_augeas('nova-custom.setting-policy').with(
      :lens    => 'Json.lns',
      :incl    => '/etc/nova/policy.json',
      :context => '/files/etc/nova/policy.json',
      :changes => 'rm dict/entry[.= "custom.setting"]'
    )}
  end
end
