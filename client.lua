-- Ustawienia
local pedTalkDistance = 5.0 -- Odległość, z której można porozmawiać z pedem
local pedHireDistance = 10.0 -- Odległość, z której można zatrudnić peda

-- Zmienne
local pedHired = false -- Czy ped jest zatrudniony
local pedHiredEntity = nil -- Referencja do zatrudnionego peda

-- Funkcje
-- Funkcja wywoływana, gdy gracz wchodzi w zasięg peda
function OnPedInRange(ped)
	-- Sprawdź, czy gracz jest w zasięgu rozmowy
	if(Vdist(ped.position.x, ped.position.y, ped.position.z, GetEntityCoords(PlayerPedId())) <= pedTalkDistance) then
		-- Wyświetl menu dialogowe
		DisplayHelpText("Naciśnij ~INPUT_CONTEXT~ aby porozmawiać z pedem")
		if(IsControlJustPressed(1, 51)) then
			-- Wyświetl menu dialogowe
			TriggerEvent("chatMessage", "Ped", {255, 0, 0}, "Cześć, co mogę dla ciebie zrobić?")
			-- Wyświetl opcje
			TriggerEvent("chatMessage", "", {255, 255, 255}, "1: Porozmawiaj")
			TriggerEvent("chatMessage", "", {255, 255, 255}, "2: Zatrudnij")
			-- Wyświetl instrukcje
			DisplayHelpText("Naciśnij ~INPUT_CELLPHONE_UP~ aby wybrać opcję")
			-- Obsłuż wybór opcji
			if(IsControlJustPressed(1, 27)) then
				-- Wybór opcji 1
				if(GetLastInputMethod(2)) then
					-- Wyświetl losowy dialog
					local randomDialogue = math.random(1, 3)
					if(randomDialogue == 1) then
						TriggerEvent("chatMessage", "Ped", {255, 0, 0}, "Co słychać?")
					elseif(randomDialogue == 2) then
						TriggerEvent("chatMessage", "Ped", {255, 0, 0}, "Jak się masz?")
					elseif(randomDialogue == 3) then
						TriggerEvent("chatMessage", "Ped", {255, 0, 0}, "Co u Ciebie słychać?")
					end
				-- Wybór opcji 2
				else
					-- Sprawdź, czy gracz jest w zasięgu zatrudnienia
					if(Vdist(ped.position.x, ped.position.y, ped.position.z, GetEntityCoords(PlayerPedId())) <= pedHireDistance) then
						-- Zatrudnij peda
						pedHired = true
						pedHiredEntity = ped
						TriggerEvent("chatMessage", "Ped", {255, 0, 0}, "Zatrudniono mnie! Co teraz?")
					else
						-- Wyświetl komunikat o błędzie
						TriggerEvent("chatMessage", "Ped", {255, 0, 0}, "Musisz być bliżej, aby mnie zatrudnić!")
					end
				end
			end
		end
	end
end

-- Funkcja wywoływana, gdy gracz jest w zasięgu peda
Citizen.CreateThread(function()
	while true do
		-- Pobierz wszystkie pedy w zasięgu
		local pedList = GetNearbyPeds(pedTalkDistance)
		-- Przeiteruj po wszystkich pedach
		for _, ped in ipairs(pedList) do
			-- Wywołaj funkcję dla każdego peda
			OnPedInRange(ped)
		end
		-- Zatrzymaj wątek na 100 milisekund
		Citizen.Wait(100)
	end
end)

-- Funkcja wywoływana, gdy ped jest zatrudniony
Citizen.CreateThread(function()
	while true do
		-- Sprawdź, czy ped jest zatrudniony
		if(pedHired) then
			-- Ustaw peda jako współtowarzysza
			SetPedAsGroupMember(pedHiredEntity, GetPlayerGroup(PlayerId()))
			-- Ustaw peda jako strzelca
			SetPedCombatAttributes(pedHiredEntity, 5, true)
			-- Wyświetl komunikat
			TriggerEvent("chatMessage", "Ped", {255, 0, 0}, "Jestem gotowy do strzelania!")
			-- Wyłącz zmienną
			pedHired = false
		end
		-- Zatrzymaj wątek na 100 milisekund
		Citizen.Wait(100)
	end
end)