local param = require("comm.param")
local args = ngx.req.get_uri_args()

if not param.is_number(2, args.a, args.b) then
    ngx.exit(ngx.HTTP_BAD_REQUEST)
    return
end