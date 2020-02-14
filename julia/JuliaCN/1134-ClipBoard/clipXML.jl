
function clipboard()
    systemerror(:OpenClipboard, 0==ccall((:OpenClipboard, "user32"), stdcall, Cint, (Ptr{Cvoid},), C_NULL))
    pdata = ccall((:GetClipboardData, "user32"), stdcall, Ptr{UInt16}, (UInt32,), 13)
    systemerror(:SetClipboardData, pdata==C_NULL)
    systemerror(:CloseClipboard, 0==ccall((:CloseClipboard, "user32"), stdcall, Cint, ()))
    plock = ccall((:GlobalLock, "kernel32"), stdcall, Ptr{UInt16}, (Ptr{UInt16},), pdata)
    systemerror(:GlobalLock, plock==C_NULL)
    # find NUL terminator (0x0000 16-bit code unit)
    len = 0
    while unsafe_load(plock, len+1) != 0; len += 1; end
    # get Vector{UInt16}, transcode data to UTF-8, make a String of it
    s = transcode(String, unsafe_wrap(Array, plock, len))
    systemerror(:GlobalUnlock, 0==ccall((:GlobalUnlock, "kernel32"), stdcall, Cint, (Ptr{UInt16},), plock))
    return s
end