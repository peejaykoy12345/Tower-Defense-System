local ModelUtils = {}

function ModelUtils:SetPartsProperties(parts: {Instance}, propertyName: string, value: number | boolean, ignoreList: {Instance}?)
    for _, part in ipairs(parts) do
        print(`{part.Name} if not {part:IsA("BasePart")} then continue end `)
        if not part:IsA("BasePart") then continue end
        if ignoreList and table.find(ignoreList, part) then continue end

        part[propertyName] = value
    end
end

function ModelUtils:SetPartsTransparency(parts: {Instance}, transparency: number, ignoreList: {Instance}?)
    self:SetPartsProperties(parts, "Transparency", 0.45, ignoreList)
end

function ModelUtils:SetPartsCanCollide(parts: {Instance}, CanCollide: boolean, ignoreList: {Instance}?)
    self:SetPartsProperties(parts, "CanCollide", CanCollide, ignoreList)
end

return ModelUtils