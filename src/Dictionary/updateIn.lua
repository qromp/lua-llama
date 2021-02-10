local removeKey = require(script.Parent.removeKey)
local set = require(script.Parent.set)
local map = require(script.Parent.map)
local slice = require(script.Parent.Parent.List.slice)

local function quoteString(value)
	return string.format("%q", value)
end

local function updateInDeeply(existing, keyPath, notSetValue, updater, i)
	local wasNotSet = existing == nil
	if i > #keyPath then
		local existingValue = wasNotSet and notSetValue or existing
		local newValue = updater(existingValue)
		return newValue == existingValue and existing or newValue
	end

	if not wasNotSet and type(existing) ~= "table" then
		error(string.format(
			"Cannot update within non-table value in path [%s] = %s",
			table.concat(map(slice(keyPath, 1, i-1), quoteString), ", "),
			tostring(existing)
		))
	end

	local key = keyPath[i]
	local nextExisting
	if wasNotSet then
		nextExisting = notSetValue and notSetValue[key] or nil
	else
		nextExisting = existing[key]
	end

	local nextUpdated = updateInDeeply(nextExisting, keyPath, notSetValue, updater, i + 1)

	if nextUpdated == nil then
		if existing or notSetValue then
			return removeKey(existing or notSetValue, key)
		end
	else
		return set(existing or notSetValue, key, nextUpdated)
	end

	return nil
end

return function(dictionary, keyPath, updater, notSetValue)
	local updatedValue = updateInDeeply(
		dictionary, keyPath, notSetValue, updater, 1
	)

	return updatedValue or notSetValue
end
