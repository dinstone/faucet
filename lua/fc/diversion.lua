local logmod = require("comm.log")

local getHost = function()
    local host = ngx.req.get_headers()['Host']
    if not host then return nil end
    local hostkey = ngx.var.hostkey
    if hostkey then
        return hostkey
    else
        return host
    end
end

local hostname = getHost()
local log = logmod:new(hostname)
log:info(hostname)

local upstream = nil

local pfunc = function()
    local upstream = ""
    local info = "canary"
    return upstream, info
end

local errorHandler = function(errinfo)
    local info 
    if type(errinfo) == 'table' then
        info = errinfo
    elseif type(errinfo) == 'string' then
        info = { 40201, errinfo }
    else
        info = { 40202, }
    end
    
    local errstack = debug.traceback()
    return {info, errstack}
end

local status, info, desc = xpcall(pfunc, errorHandler)
if not status then
    log:errlog(info)
else
    upstream = info
end

log:errlog(upstream)
if upstream then
    ngx.var.backend = upstream
end

-- local info = doredirect(desc)
-- log:errlog(info)