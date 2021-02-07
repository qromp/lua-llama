return function(dictionary, keyPath, default)
	assert(type(keyPath) == "table" and #keyPath > 0, string.format("Invalid keyPath: expected array: %s", tostring(keyPath)))

	local node = dictionary
	for _, path in ipairs(keyPath) do
		node = node[path]
		if not node then
			return default
		end
	end

	return node
end
