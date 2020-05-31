return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local lib = ReplicatedStorage.lib
	local Llama = require(lib.Llama)

	local List = Llama.List
	local set = List.set

	it("should return a new table", function()
		local list = {1, 2, 3}

		expect(set(list, 2, 0)).never.to.equal(list)
	end)

	it("should not mutate the original list", function()
		local list = {false, "foo", 3}
		local value = {}
		set(list, 2, value)

		expect(#list).to.equal(3)
		expect(list[1]).to.equal(false)
		expect(list[2]).to.equal("foo")
		expect(list[3]).to.equal(3)
	end)

	it("should replace the value at the given index", function()
		local list = {1, 2, 3}
		local value = {}
		local result = set(list, 2, value)

		expect(result[1]).to.equal(1)
		expect(result[2]).to.equal(value)
		expect(result[3]).to.equal(3)
		expect(next(result[2])).to.equal(nil)
	end)

	it("should throw if the given index is higher than the list length", function()
		local list = {1}

		expect(function()
			set(list, #list + 1, {})
		end).to.throw()
	end)

	it("should throw if the given index is lower than 1", function()
		local list = {1}

		expect(function()
			set(list, 0, {})
		end).to.throw()
	end)

	it("should be able to replace to a falsy value", function()
		local tableElement = {}
		local list = {tableElement, false, "value", true}
		local newValue = false

		local result = set(list, 3, newValue)

		expect(result[1]).to.equal(tableElement)
		expect(result[2]).to.equal(false)
		expect(result[3]).to.equal(newValue)
		expect(result[4]).to.equal(true)
	end)
end