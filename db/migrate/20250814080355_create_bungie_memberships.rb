class CreateBungieMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :bungie_memberships do |t|
      t.bigint :membership_id
      t.integer :membership_type
      t.string :username
      t.timestamps
    end
  end
end
