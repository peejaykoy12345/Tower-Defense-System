local ReplicatedStorage = game:GetService("ReplicatedStorage")

return {
    ["Enemy"] = {
        Template = ReplicatedStorage.Fighter,
        Health = 100,
        Speed = 20,
    }
}