require 'spec_helper'

describe 'sensu' do
  let(:title) { 'sensu::server' }
  let(:facts) do
    {
      :osfamily => 'RedHat',
      :kernel   => 'Linux',
    }
  end

  context 'without server (default)' do

    it { should contain_service('sensu-server').with(
      :ensure     => 'stopped',
      :enable     => false,
      :hasrestart => true
    ) }
  end # without server

  context 'with server' do
    let(:params) { { :server => true } }

    it { should contain_service('sensu-server').with(
      :ensure     => 'running',
      :enable     => true,
      :hasrestart => true
    ) }
  end # with server

  context 'with hasrestart=false' do
    let(:params) { { :server => true, :hasrestart => false } }
    it { should contain_service('sensu-server').with(
      :ensure     => 'running',
      :enable     => true,
      :hasrestart => false
    ) }
  end # with hasrestart=false

  context 'on Darwin' do
    let(:facts) do
      {
        :osfamily => 'Darwin',
        :kernel   => 'Darwin',
        :macosx_productversion_major => '10.12',
      }
    end
    it { should_not contain_service('sensu-server') }
  end # On Darwin sensu server is not supported

  context 'on Windows' do
    let(:facts) do
      {
        :operatingsystem => 'Windows',
        :kernel          => 'windows',
        :osfamily        => 'windows',
        :os              => {
          :architecture => 'x64',
          :release => {
            :major => '2012 R2',
          },
        },
      }
    end
    it { should_not contain_service('sensu-server') }
  end # On Windows sensu server is not supported

end
