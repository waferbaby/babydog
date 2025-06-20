class Membership
  include Recordable

  has_many :vault_items

  field :type, type: Integer
  field :display_name, type: String
end
