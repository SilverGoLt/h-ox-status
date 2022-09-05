local random = math.random

local Status = {
    count = 0,
    list = {}
}

setmetatable(Status, {
	__add = function(self, obj)
		self.list[obj.name] = obj
		self.count += 1
	end,

	__sub = function(self, obj)
		self.list[obj.name] = nil
		self.count -= 1
	end,

	__call = function(self, name)
		return self.list[name]
	end
})

local CStatus = {}
CStatus.__index = CStatus

---Add amount to status
---@param amount number Status amount
---@return boolean Success
function CStatus:add(amount)
    if self.amount + amount > Config.StatusMax then
        self.amount = Config.StatusMax
    else
        self.amount += amount
    end
    return false
end

function CStatus:remove(amount)
    if self.amount - amount < 0 then
        self.amount = 0
    else
        self.amount -= amount
    end
    return false
end

function CStatus:getPercent()
    return (self.amount / Config.StatusMax) * 100
end

function CStatus:destroy()
    Status[self.name] = nil
end

local i = 1
---Creates a Status class
---@param name string Status name
---@param amount number Status amount
---@return number
function Status.new(name, amount)
    local self = {
        name = name,
        amount = amount
    }

    if Config.Debug then print('[DEBUG] Creating '..name) end

    i += 1

    setmetatable(self, CStatus)

    return Status + self
end

_ENV.Status = Status