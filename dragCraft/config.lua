---@diagnostic disable: missing-return

---@class CraftRecipe
---@field duration number ms it takes to craft the recipe.
---@field client? CallbackFunc Contains client-side functions to be executed before and after crafting.
---@field server? CallbackFunc Contains server-side functions to be executed before and after crafting.
---@field result ItemResult[] The items produced as a result of the crafting process.
---@field costs table<string, CraftCost> The resources required for crafting, including their quantities and removal flags.
---@field source? number The player id of the crafter

---@class CallbackFunc
---@field before fun(recipeData: CraftRecipe):boolean
---@field after fun(recipeData: CraftRecipe):boolean

---@class ItemResult
---@field name string The name of the item.
---@field amount number The amount of the item produced.

---@class CraftCost
---@field need number The quantity of the item needed for crafting.
---@field remove boolean Whether the item should be removed after crafting.
---@field metadata? table The metadata of the item that's being crafted.

---@type table<string, CraftRecipe>
local RECIPES = {
    ['garbage scrapmetal'] = {
        duration = 2000,
        client = {
            before = function(recipeData)
                -- some client logic to run before crafting
                -- if this returns false, it will cancel the craft
                -- returning true or nil will continue with the craft
            end,
            after = function(recipeData)
                -- some client logic to run after crafting
                -- returns boolean or nil
            end,
        },
        server = {
            before = function(recipeData)
                -- some server logic to run before crafting
                -- if this returns false, it will cancel the craft
                -- returning true or nil will continue with the craft
            end,
            after = function(recipeData)
                -- some server logic to run after crafting
                -- returns boolean or nil
            end,
        },
        costs = {
            ['garbage'] = { need = 1, remove = true },
            ['scrapmetal'] = { need = 0.1, remove = true },
        },
        result = {
            { name = 'lockpick', amount = 1 },
            -- { name = 'something', amount = 1 }
        },
    },

    ['weed rolling_paper'] = {
        duration = 2000,
        client = {
            before = function(recipeData)
                -- some client logic to run before crafting
                -- if this returns false, it will cancel the craft
                -- returning true or nil will continue with the craft
            end,
            after = function(recipeData)
                -- some client logic to run after crafting
                -- returns boolean or nil
            end,
        },
        server = {
            before = function(recipeData)
                local weedMetadata = recipeData.costs.weed.metadata
                local weedStrain = weedMetadata and weedMetadata.strain
                if not weedStrain then
                    return false
                end
                local jointMetadata = {
                    label = weedMetadata.label .. ' Joint',
                    strain = weedStrain,
                    type = weedMetadata.type,
                    stress = weedMetadata.stress,
                    armor = weedMetadata.armor,
                    image = 'joint_' .. string.lower(weedMetadata.type)
                }
                TriggerEvent('dragCraft:AddResultMetadata', recipeData.source, 1, jointMetadata)
            end,
            after = function(recipeData)
            end,
        },
        costs = {
            ['weed'] = {need = 1, remove = true},
            ['rolling_paper'] = {need = 1, remove = true},
        },
        result = {
            { name = 'joint', amount = 1},
        }
    },
    -- Additional recipes can be added here
}

return RECIPES
