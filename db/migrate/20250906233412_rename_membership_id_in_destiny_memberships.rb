class RenameMembershipIdInDestinyMemberships < ActiveRecord::Migration[8.0]
  def change
    rename_column :destiny_memberships, :membership_id, :membership_hash
  end
end
