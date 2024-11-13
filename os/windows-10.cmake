# Copyright (c) 2024 Yannic Staudt
# All rights reserved.
# tipi technologies AG - Zürich

#
# Minimum value for _WIN32_WINNT and WINVER vs windows release
# ref: https://learn.microsoft.com/en-gb/windows/win32/winprog/using-the-windows-headers?redirectedfrom=MSDN
# Windows 10 	                                        _WIN32_WINNT_WIN10 (0x0A00)  <--
# Windows 8.1 	                                        _WIN32_WINNT_WINBLUE (0x0603)
# Windows 8 	                                        _WIN32_WINNT_WIN8 (0x0602)
# Windows 7 	                                        _WIN32_WINNT_WIN7 (0x0601)
# Windows Server 2008 	                                _WIN32_WINNT_WS08 (0x0600)
# Windows Vista 	                                    _WIN32_WINNT_VISTA (0x0600)
# Windows Server 2003 with SP1, Windows XP with SP2 	_WIN32_WINNT_WS03 (0x0502)
# Windows Server 2003, Windows XP 	                    _WIN32_WINNT_WINXP (0x0501)
set(tipi_env_target_windows_version "0x0A00")
add_compile_definitions(_WIN32_WINNT=${tipi_env_target_windows_version})
add_compile_definitions(WINVER=${tipi_env_target_windows_version})

# avoid the STL's minmax macro interfering with std::minmax()
add_compile_definitions(NOMINMAX)

# https://devblogs.microsoft.com/oldnewthing/20091130-00/?p=15863
# ->  excludes APIs such as Cryptography, DDE, RPC, Shell, and Windows Sockets.
add_compile_definitions(WIN32_LEAN_AND_MEAN)

# prefer recent enough versions of the windows SDK
# seems to help builds on parallel VMs on Apple M* processors
set (CMAKE_SYSTEM_VERSION "10.0.10240" CACHE STRING "Prefer recent enough versions of the windows SDK" FORCE)
