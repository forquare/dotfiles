local sysname = vim.loop.os_uname().sysname or ''

local M = {
  sysname = sysname,
  is_mac = sysname == 'Darwin',
  is_linux = sysname == 'Linux',
  is_freebsd = sysname == 'FreeBSD',
  is_windows = sysname == 'Windows_NT',
}

return M
