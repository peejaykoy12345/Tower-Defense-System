local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TowerModels = ReplicatedStorage.Assets.Models["Tower Models"]

return {
    Fighter = {
        TYPE = "Melee",
        PRICE = 100,
        Model = TowerModels.Fighter,
        [1] = {
            DAMAGE = 20,
            RANGE_RADIUS = 15,
            ATTACK_COOLDOWN = 0.5,
        },
        [2] = {
            DAMAGE = 40,
            RANGE_RADIUS = 20,
            ATTACK_COOLDOWN = 0.45,
        }
    }
}