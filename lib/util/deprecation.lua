local function deprecation(info, lvl)
    local caller = debug.getinfo(2 + (lvl or 0))
    local str = (
        "Deprecation: " .. caller.source .. ":" ..
        caller.linedefined .. " " .. (info or "")
    )
    if log then
        log:warn(str)
    else
        print(str)
    end
end

return deprecation
