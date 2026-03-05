local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TowerModels = ReplicatedStorage.Assets.Models["Tower Models"]

return {
    Fighter = {
        TYPE = "Melee",
        PRICE = 100,
        [1] = {
            DAMAGE = 5,
            RANGE_RADIUS = 15,
            ATTACK_COOLDOWN = 1,
            Model = TowerModels.Fighter
        },
    }
}