module Destiny
  module ItemFilters
    SLOTS = {
      energy_weapon: "Energy Weapon",
      kinetic_weapon: "Kinetic Weapon",
      power_weapon: "Power Weapon"
    }.freeze

    WEAPONS = {
      weapon: "Weapon",
      auto_rifle: "Auto Rifle",
      bow: "Bow",
      fusion_rifle: "Fusion Rifle",
      glaive: "Glaive",
      grenade_launcher: "Grenade Launcher",
      hand_cannon: "Hand Cannon",
      linear_fusion_rifle: "Linear Fusion Rifle",
      machine_gun: "Machine Gun",
      pulse_rifle: "Pulse Rifle",
      rocket_launcher: "Rocket Launcher",
      scout_rifle: "Scout Rifle",
      shotgun: "Shotgun",
      sidearm: "Sidearm",
      sniper_rifle: "Sniper Rifle",
      sword: "Sword",
      trace_rifle: "Trace Rifle"
    }.freeze

    ARMOUR = {
      armor: "Armor",
      arms: "Arms",
      chest: "Chest",
      legs: "Legs"
    }

    GUARDIANS = {
      warlock: "Warlock",
      hunter: "Hunter",
      titan: "Titan"
    }.freeze

    def self.all
      constants.map do |type|
        const_get(type)
      end
    end
  end
end
