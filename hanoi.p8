pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _init()
  cls()
  chanoi = cocreate(hanoi)
  state = -2
  disks = 4
  pegs = {
    {},
    {},
    {},
  }
  for i = disks, 1, -1 do
    add(pegs[1], i)
  end

  moving_disk = -1
  moving_x = 0
  moving_y = 0

  peg_top = 45
  peg_bottom = 80
  speed = 4

end

function _update()
  if state == -2 then
    if btn(4) then
      state = 0
    end
  elseif state == 0 then
    if costatus(chanoi) ~= "dead" then
      coresume(chanoi, disks, 1, 3, 2)
      if from_peg ~= nil then
        -- Remove disk, start animation
        moving_disk = pegs[from_peg][#pegs[from_peg]]
        del(pegs[from_peg], moving_disk)

        moving_x = from_peg * 40 - 16 - moving_disk * 2
        moving_y = peg_bottom - 7 - #pegs[from_peg] * 8
        moving_to_x = to_peg * 40 - 16 - moving_disk * 2
        moving_to_y = peg_bottom - 7 - #pegs[to_peg] * 8

        state = 1
      end
    else
      status = -1
      moving_disk = -1
    end
  elseif state == 1 then
    -- Moving up from the peg
    moving_y = moving_y - speed

    if moving_y <= peg_top - 10 then
      moving_y = peg_top - 10
      state = 2
    end
  elseif state == 2 then
    -- Flying between pegs
    local stop = false
    if from_peg > to_peg then
      moving_x = moving_x - speed
      if moving_x <= moving_to_x then
        stop = true
      end
    else
      moving_x = moving_x + speed
      if moving_x >= moving_to_x then
        stop = true
      end
    end

    if stop then
      moving_x = moving_to_x
      state = 3
    end
  elseif state == 3 then
    -- Moving down the target peg
    moving_y = moving_y + speed

    if moving_y >= moving_to_y then
      -- Add disk to the target peg
      add(pegs[to_peg], moving_disk)
      moving_disk = -1
      state = 0
    end
  end
end

function _draw()
  cls(7)
  color(0)
  -- Draw pegs
  line(24, peg_top, 24, peg_bottom, 6)
  line(25, peg_top, 25, peg_bottom, 5)
  line(64, peg_top, 64, peg_bottom, 6)
  line(65, peg_top, 65, peg_bottom, 5)
  line(104, peg_top, 104, peg_bottom, 6)
  line(105, peg_top, 105, peg_bottom, 5)

  -- Draw disks on pegs
  for i = 1, #pegs do
    local peg = pegs[i]
    for j = 1, #peg do
      local disk = peg[j]
      local x = i * 40 - 16 - disk * 2
      local y = peg_bottom + 1 - j * 8
      draw_disk(x, y, disk)
    end
  end

  -- Draw moving disk
  if moving_disk ~= -1 then
    draw_disk(moving_x, moving_y, moving_disk)
  end
end

function draw_disk(x, y, disk)
  rectfill(x, y, x + disk * 4, y + 7, 4)
  line(x, y, x + disk * 4 + 1, y, 9)
  line(x, y, x, y + 7, 9)
  line(x + disk * 4 + 1, y + 1, x + disk * 4 + 1, y + 7, 2)
  line(x + 1, y + 7, x + disk * 4 + 1, y + 7, 2)
end

function move_disk(from, to)
  moving_disk = pegs[from][#pegs[from]]
  del(pegs[from], moving_disk)
  add(pegs[to], moving_disk)
end


function hanoi(disks, source, target, spare)
  local is_even = (disks % 2 == 0)
  local pegs = {
    source,
    is_even and target or spare,
    is_even and spare or target
  }

  for m = 1, shl(1, disks) - 1 do
    from_peg = pegs[1 + band(m, m - 1) % 3]
    to_peg = pegs[1 + (bor(m, m - 1) + 1) % 3]
    yield()
  end
  from_peg = nil
  to_peg = nil
end