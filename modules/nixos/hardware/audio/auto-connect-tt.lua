-- As explained on (and stolen from): https://bennett.dev/auto-link-pipewire-ports-wireplumber/
--
-- This script keeps my stereo-null-sink connected to whatever output I'm currently using.
-- I do this so Pulseaudio (and Wine) always sees a stereo output plus I can swap the output
-- without needing to reconnect everything.

-- Link two ports together
function link_port(output_port, input_port)
	if not input_port or not output_port then
		return nil
	end

	print("out", dump(output_port.properties))
	print("in", dump(input_port.properties))

	local link_args = {
		["link.input.node"] = input_port.properties["node.id"],
		["link.input.port"] = input_port.properties["object.id"],

		["link.output.node"] = output_port.properties["node.id"],
		["link.output.port"] = output_port.properties["object.id"],

		-- -- The node never got created if it didn't have this field set to something
		-- ["object.id"] = nil,
		--
		-- -- I was running into issues when I didn't have this set
		-- ["object.linger"] = 1,
		--
		-- ["node.description"] = "Link created by auto_connect_ports",
	}

	print(dump(link_args))

	local link = Link("link-factory", link_args)
	link:activate(1)

	print("link created", dump(link.properties))

	return link
end

-- Automatically link ports together by their specific audio channels.
--
-- ┌──────────────────┐         ┌───────────────────┐
-- │                  │         │                   │
-- │               FL ├────────►│ AUX0              │
-- │      OUTPUT      │         │                   │
-- │               FR ├────────►│ AUX1  INPUT       │
-- │                  │         │                   │
-- └──────────────────┘         │ AUX2              │
--                              │                   │
--                              └───────────────────┘
--
-- -- Call this method inside a script in global scope
--
-- auto_connect_ports {
--
--   -- A constraint for all the required ports of the output device
--   output = Constraint { "node.name"}
--
--   -- A constraint for all the required ports of the input device
--   input = Constraint { .. }
--
--   -- A mapping of output audio channels to input audio channels
--
--   connections = {
--     ["FL"] = "AUX0"
--     ["FR"] = "AUX1"
--   }
--
-- }

function dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

function auto_connect_ports(args)
	local output_om = ObjectManager({
		Interest({
			type = "port",
			args["output"],
			Constraint({ "port.direction", "equals", "out" }),
		}),
	})

	print("output_om", dump(output_om))

	local links = {}

	local input_om = ObjectManager({
		Interest({
			type = "port",
			args["input"],
			Constraint({ "port.direction", "equals", "in" }),
		}),
	})

	print("input_om", dump(input_om))

	local all_links = ObjectManager({
		Interest({
			type = "link",
		}),
	})

	print("all_links", dump(all_links))

	local unless = nil

	if args["unless"] then
		unless = ObjectManager({
			Interest({
				type = "port",
				args["unless"],
				Constraint({ "port.direction", "equals", "in" }),
			}),
		})
	end

	function _connect()
		print("connecting...")
		local delete_links = unless and unless:get_n_objects() > 0

		if delete_links then
			for _i, link in pairs(links) do
				link:request_destroy()
			end

			links = {}

			return
		end

		for output_name, input_names in pairs(args.connect) do
			local input_names = input_names[1] == nil and { input_names } or input_names

			-- for output in output_om:iterate() do
			-- 	print(dump(output.properties))
			-- end

			if delete_links then
			else
				-- Iterate through all the output ports with the correct channel name
				for output in output_om:iterate({ Constraint({ "audio.channel", "equals", output_name }) }) do
					for _i, input_name in pairs(input_names) do
						-- Iterate through all the input ports with the correct channel name
						-- print("inp name", input_name)
						-- print("output", dump(output.properties))
						-- for input in input_om:iterate() do
						-- 	print("hi")
						-- 	-- print(dump(input.properties))
						-- end
						for input in input_om:iterate({ Constraint({ "audio.channel", "equals", input_name }) }) do
							-- print("here2")
							-- Link all the nodes
							local link = link_port(output, input)
							-- print("linked")

							if link then
								table.insert(links, link)
							end
						end
					end
				end
			end
		end
	end

	output_om:connect("object-added", _connect)
	input_om:connect("object-added", _connect)
	all_links:connect("object-added", _connect)

	output_om:activate()
	input_om:activate()
	all_links:activate()

	if unless then
		unless:connect("object-added", _connect)
		unless:connect("object-removed", _connect)
		unless:activate()
	end

	print("dun")
end

-- Auto connect the stereo null sink to bluetooth headphones
auto_connect_ports({
	input = Constraint({
		"port.alias",
		"matches",
		"Scarlett Solo USB:playback_*",
	}),
	output = Constraint({ "port.alias", "matches", "ALC1220 Analog:capture_*" }),
	connect = {
		["FL"] = { "FL" },
		["FR"] = { "FR" },
	},
})
