local random = math.random

local pStatus = {
    count = 0,
    list = {}
}

setmetatable(pStatus, {
	__add = function(self, obj)
		self.list[obj.source] = obj
		self.count += 1
	end,

	__sub = function(self, obj)
		self.list[obj.source] = nil
		self.count -= 1
	end,

	__call = function(self, name)
		return self.list[name]
	end
})

local CStatus = {}
CStatus.__index = CStatus

---Add Status
---@param status string Status name
---@param amount number Status amount
---@return boolean Success
function CStatus:addStatus (status, amount)
    if self.status[status] then
        self.status[status] = self.status[status] + amount
        return true
    else
        print('[ERROR] Status not found: '..status.. 'for player: '..self.source)
        return false
    end
end

---Saves the Players statuses to the database
---@return boolean
function CStatus:saveStatuses()
    local result = MySQL.update.await('UPDATE characters SET status = ? WHERE charid = ?', {
        json.encode(self.status),
        self.charid
    })

    if result then return true else return false end
end

function CStatus:updateValues(data)
    for k, v in pairs(data) do
        self.status[v.name] = v.amount
    end
end

---Returns current Players statuses
function CStatus:getStatuses()
    return self.status
end

local i = 1
---Adds user to the pStatus class
---@param source integer Player Source
---@param status table @{hunger, thirst}
---@return number
function pStatus.new (source, status, charid)
    local self = {
        source = source,
        status = status or {
            hunger = Config.StatusMax,
            thirst = Config.StatusMax
        },
        charid = charid or nil,
    }

    if Config.Debug then print('[DEBUG] Setting status to: '..json.encode(self.status, {indent = true})) end
    i += 1

    setmetatable(self, CStatus)

    return pStatus + self
end

_ENV.pStatus = pStatus