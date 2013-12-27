require 'puppet/type/brocade_messages'

Puppet::Type.newtype(:brocade_alias) do
  @doc = "This represents an alias name for a member on a brocade switch."

  apply_to_device

  ensurable

  newparam(:alias_name) do
    desc "This parameter describes the Brocade alias name for the MemberWWPN."
    isnamevar
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError, Puppet::Type::Brocade_messages::ALIAS_NAME_BLANK_ERROR
      end
	  if ( value =~ /[\W]+/ )
        raise ArgumentError, Puppet::Type::Brocade_messages::ALIAS_NAME_SPECIAL_CHAR_ERROR
      end
    end
  end

  newparam(:member) do
    desc "This parameter describes the MemberWWPN value whose alias is to be added."
    newvalues(/^\S+$/)
    validate do |value|
      if value.strip.length == 0
        raise ArgumentError , Puppet::Type::Brocade_messages::MEMBER_WWPN_BLANK_ERROR
       end 
       value.split(";").each do |line|
        item = line.strip
        unless item  =~ /^([0-9a-f]{2}:){7}[0-9a-f]{2}$/
          raise ArgumentError, Puppet::Type::Brocade_messages::MEMBER_WWPN_INVALID_FORMAT_ERROR
        end    
      end
	 end
  end

end
