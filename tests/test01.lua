local function send_callbacks(args, ...)
    local iterables = {...}
    if #iterables == 0 then
        return
    end
    for _, it in ipairs(iterables) do
        if #it ~= 0 then
            for _, cmd in ipairs(it) do
                cmd(args)
            end
        end
    end
end

send_callbacks(10, {print})
