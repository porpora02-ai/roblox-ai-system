local HttpService = game:GetService("HttpService")

local toolbar = plugin:CreateToolbar("AI Builder")

local button = toolbar:CreateButton(
	"Import AI",
	"Build AI Generated Game",
	""
)

-- CHANGE THIS AFTER RENDER DEPLOY
local API_URL = "http://localhost:3000/project/USER123"

local function createScript(scriptType, parent, name, source)

	local obj

	if scriptType == "LocalScript" then
		obj = Instance.new("LocalScript")
	else
		obj = Instance.new("Script")
	end

	obj.Name = name
	obj.Source = source
	obj.Parent = parent
end

local function buildProject(data)

	if not data then
		warn("No data received")
		return
	end

	print("Loading Project:", data.projectName)

	for _, scriptData in ipairs(data.scripts) do

		local location

		pcall(function()
			location = game:GetService(scriptData.location)
		end)

		if location then
			createScript(
				scriptData.type,
				location,
				scriptData.name,
				scriptData.code
			)

			print("Created:", scriptData.name)
		else
			warn("Invalid location:", scriptData.location)
		end
	end
end

button.Click:Connect(function()

	local success, response = pcall(function()
		return HttpService:GetAsync(API_URL)
	end)

	if success then
		local data = HttpService:JSONDecode(response)
		buildProject(data)
	else
		warn("Failed to connect to backend")
		warn(response)
	end
end)
