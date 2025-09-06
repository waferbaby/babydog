class AddIndexToDestinyMemberships < ActiveRecord::Migration[8.0]
  def change
    add_index :destiny_memberships, :membership_id, unique: true
  end
end
