pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

function _init()
  freq1 = 0.0101
  freq2 = 0.01
  p1 = 0
  p2 = 0
  amps = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
  --amps = {0x0000, 0x01FA, 0x0393, 0x0520, 0x079A, 0x0A57, 0x0EEF, 0x13E9, 0x1C70, 0x2603, 0x3628, 0x47F6, 0x6682, 0x88D0, 0xC20C, 0xFFFF}
end

function _update60()
  if stat(108) < 512 then
    for i = 0x4300, 0x43ff do
      local tri = amps[flr(p1 * 16) + 1]
      local sq = (p2 < 0.5) and 0 or 1
      poke(i, tri * sq + 128)
      p1 += freq1
      p2 += freq2
      if (p1 >= 1) p1 -= 1
      if (p2 >= 1) p2 -= 1
    end
    serial(0x808, 0x4300, 256)
  end
end

function _draw()
  cls()
  print(stat(108), 0, 0, 7)
  print(flr(stat(1) * 100), 0, 8, 7)
end
