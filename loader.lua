local files = {
    "auto%20clicker.lua",
    "esp.lua",
    "fast%20kill.lua",
    "na%20afka%20telepoti.lua",
    "tower%20of%20hell.lua",
    "telefon%20symulacja.lua",
    "fogrem.lua",
    "dec.lua",
    "zmienrozb.lua",
    "Ai.lua",
    "zmienrozl.lua",
    "kloc.lua"
}

local baseUrl = "https://raw.githubusercontent.com/fagatabez/haksy-pe/main/"
local loadedFiles = {} -- Przechowuje informacje o załadowanych plikach

for _, file in ipairs(files) do
    if loadedFiles[file] then
        print("⏩ Plik " .. file .. " został już załadowany, pomijam.")
    else
        local url = baseUrl .. file
        print("⏳ Pobieranie pliku: " .. file .. " z URL: " .. url)

        local response
        local success, err = pcall(function()
            response = game:HttpGet(url, true)
        end)

        if success and response and response ~= "" then
            local executeSuccess, executeErr = pcall(function()
                loadstring(response)()
            end)

            if executeSuccess then
                print("✅ " .. file .. " załadowany pomyślnie!")
                loadedFiles[file] = true  -- Zapisuje, że plik został pobrany
            else
                warn("❌ Błąd wykonania pliku: " .. file .. " | " .. tostring(executeErr))
            end
        else
            warn("⚠️ Błąd pobierania pliku: " .. file .. " | " .. tostring(err))
        end
    end

    task.wait(0.5) -- Opóźnienie dla stabilności
end
