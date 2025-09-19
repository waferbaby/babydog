module Destiny
  class Character < Base
    belongs_to :membership, primary_key: :membership_hash, foreign_key: :membership_hash

    def self.payload_to_attributes(payload)
      {
        character_hash: :characterId,
        membership_hash: :membershipId,
        emblem_hash: :emblemHash,
        last_played_at: :dateLastPlayed,
        race: :raceType,
        gender: :genderType,
        guardian_type: :classType
      }
    end

    def self.unique_keys
      [ :character_hash, :membership_hash ]
    end

    def race
      Restiny::Race.all[self[:race]]
    end

    def guardian_type
      Restiny::GuardianClass.all[self[:guardian_type]]
    end
  end
end
