require 'puppet/type/brocade_messages'

Puppet::Type.newtype(:brocade_config) do
  @doc = "This represents a zone config on a brocade switch."

  apply_to_device

  ensurable do 
    desc "config ensure property"
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do 
      provider.destroy
    end
  end

  newparam(:configname) do
    desc "Config name"
    isnamevar
    newvalues(/[\w]+/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, Puppet::Type::Brocade_messages::CONFIG_NAME_BLANK_ERROR
      end
      if ( value =~ /[\W]+/ )      
        raise ArgumentError, Puppet::Type::Brocade_messages::CONFIG_NAME_SPECIAL_CHAR_ERROR
      end
    end
  end

  newproperty(:member_zone) do
    desc "zone member in the config"
    #newvalues(/^\S+$/)
  end

  newproperty(:configstate) do
    desc "config state"
    newvalues(:enable, :disable)
  end


end
