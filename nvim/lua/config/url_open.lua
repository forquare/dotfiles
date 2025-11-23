local M = {}

local sysname = vim.loop.os_uname().sysname

local function get_open_cmd()
  if sysname == 'Darwin' then
    return 'open'
  elseif sysname == 'Linux' or sysname == 'FreeBSD' then
    return 'xdg-open'
  end
end

function M.open_url_under_cursor()
  local url = vim.fn.expand '<cfile>'
  if not url or url == '' then
    return
  end
  local opener = get_open_cmd()
  if not opener then
    vim.notify('No URL opener configured for this OS', vim.log.levels.WARN)
    return
  end
  vim.fn.jobstart({ opener, url }, { detach = true })
end

return M
