class VaultItem
  include Recordable

  belongs_to :membership

  field :quantity, type: Integer
  field :location, type: Integer
  field :state, type: Integer
  field :bind_state, type: Integer
  field :lockable, type: Boolean
end
