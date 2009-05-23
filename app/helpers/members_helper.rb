module MembersHelper
  def family_member_id
    family_member = @member.associated_member || @member
    
    if family_member.membership_type == MembershipType::Family
      family_member.id
    else
      nil
    end
  end
end