require 'spec_helper'

describe 'sensu::filter', :type => :define do
  let(:pre_condition) do
    <<-'ENDofPUPPETcode'
    include ::sensu
    ENDofPUPPETcode
  end
  let(:title) { 'myfilter' }

  context 'negate' do
    let(:params) { {:negate => false } }
    it { should contain_file('/etc/sensu/conf.d/filters/myfilter.json').with(:ensure => 'present') }
    it { should contain_sensu_filter('myfilter').with( :negate => false ) }
  end

  context 'attributes' do
    let(:params) { {
      :attributes => { 'a' => 'b', 'c' => 'd' }
    } }
    it { should contain_file('/etc/sensu/conf.d/filters/myfilter.json').with(:ensure => 'present') }
    it { should contain_sensu_filter('myfilter').with(:attributes => { 'a' => 'b', 'c' => 'd' } ) }
  end

  describe 'when' do
    let(:when_spec) do
      { 'days' => { 'all' => [ { 'begin' => '5:00 PM', 'end' => '8:00 AM' } ] } }
    end
    let(:params) do
      { :when => when_spec }
    end
    it { should contain_file('/etc/sensu/conf.d/filters/myfilter.json').with(:ensure => 'present') }
    it { should contain_sensu_filter('myfilter').with(:when => when_spec) }
  end

  context 'absent' do
    let(:params) { {
      :ensure => 'absent'
    } }
    it { should contain_file('/etc/sensu/conf.d/filters/myfilter.json').with(:ensure => 'absent') }
    it { should contain_sensu_filter('myfilter').with(:ensure => 'absent') }
  end

  describe 'on osfamily Darwin' do
  let(:facts) do
    {
      :osfamily => 'Darwin',
      :kernel   => 'Darwin',
      :macosx_productversion_major => '10.12',
    }
  end

  context 'by default' do
    it { should contain_file('/etc/sensu/conf.d/filters/myfilter.json').with(
      :owner => '_sensu',
      :group => 'wheel'
    ) }
    end
  end
end
