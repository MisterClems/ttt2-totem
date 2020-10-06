TTT2Totem = {}

hook.Add("TTTPlayerSpeedModifier", "TTT2TotemSpeed", function(ply, _, _, noLag)
	if not GetGlobalBool("ttt2_totem", false) or not ttt2net.GetGlobal({"TTT2Totem", "AnyTotems"}) then return end

	local rs = GetRoundState()

	if rs ~= ROUND_ACTIVE and rs ~= ROUND_POST then return end

	local mul = 1

	if not IsValid(ply:GetTotem()) and not ply:TTT2NETGetBool({ "TTT2Totem", "CanSpawnTotem" }) then
		mul = 0.4
	elseif GetGlobalBool("ttt2_totem_enable_speedmodifier", true) then
		local Totem = ply:GetTotem()

		if IsValid(Totem) then
			local distance = Totem:GetPos():Distance(ply:GetPos())

			if distance >= 2500 then
				mul = math.Round(math.Remap(distance, 2500, 5000, 1, 0.75), 2)
			elseif distance <= 1000 then
				mul = 1.25
			end
		else
			mul = 0.75
		end
	end

	noLag[1] = noLag[1] * mul
end)

local plymeta = FindMetaTable("Player")

function plymeta:GetTotem()
	return self:GetNWEntity("Totem", NULL)
end

function plymeta:HasTotem()
	return IsValid(self:GetTotem())
end
