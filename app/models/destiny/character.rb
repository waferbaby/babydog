module Destiny
  class Character < ManifestEntry
    belongs_to :membership, primary_key: :membership_hash
  end
end
