-- dotfiles: blank the panel while the lid is closed
-- With HandleLidSwitch=ignore the panel stays lit under the lock screen; the T2 firmware does not cut it.
o.bind("switch:on:Lid Switch", nil, [[hyprctl dispatch 'hl.dsp.dpms({ action = "off", monitor = "eDP-1" })']], { locked = true })
o.bind("switch:off:Lid Switch", nil, [[hyprctl dispatch 'hl.dsp.dpms({ action = "on", monitor = "eDP-1" })']], { locked = true })
