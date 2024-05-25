if exists("g:loaded_preview-me")
    finish
endif
let g:loaded_previewme = 1

let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/preview-me/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

command! -nargs=0 PreviewMe lua require("preview-me").open()
command! -nargs=0 PreviewMeOpenInBuf lua require("preview-me").open_in_buf()
command! -nargs=0 PreviewMeOpenVertSplit lua require("preview-me").split_v_ref()
command! -nargs=0 PreviewMeOpenHorSplit lua require("preview-me").split_h_ref()
command! -nargs=0 PreviewMeOpenInNewTab lua require("preview-me").open_in_new_tab()
