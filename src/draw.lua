
colors ={[2]=13, [3]=8, [4]=1, [5]=3}
sizes ={[4]=4, [5]=2}
function draw()

    planet_radius = 100
    planet_pos = Vec2.new{x=128.0,y=128.0}
    scale = 50

    -- draw planet base circle
    spr(6, 8, 0, 8, 8)
    circfill(planet_pos.x, planet_pos.y, planet_radius, 11)
    circfill(planet_pos.x, planet_pos.y, planet_radius-10, 4)

    -- scan for blocks near player
    -- then draw them to the circle
    -- TODO: would be cool to fill the arcs for solid blocks
    for x=-128,128 do
        for y=0+16*player.level,14+16*player.level do
            m = mget(flr(player.pos.x/8)+x,y)
            if m == 2 or m == 3 or m == 4 or m == 5 then -- check for blocks, can also do this for spikes (red blocks)
                r_y = flr((15-y+16*player.level)/16*50)
                d_angle_1 = x/128
                d_angle_2 = (x+1)/128

                if m == 2 or m == 3 then
                  arc(128,128, 100+r_y, 0.375-d_angle_2, 0.375-d_angle_1, colors[m])
                elseif m == 4 then
                  circfill(128+(100+r_y)*cos(0.375-d_angle_1), 128+(100+r_y)*sin(0.375-d_angle_1), sizes[m], colors[m])
                elseif m == 5 then
                  rectfill(128+(100+r_y)*cos(0.375-d_angle_1), 128+(100+r_y)*sin(0.375-d_angle_1),
                      128+(100+r_y)*cos(0.375-d_angle_2), 128+(100+r_y)*sin(0.375-d_angle_2),
                        colors[m])
                end
            end
        end
    end
    -- normalized player y pos
    local norm_y = (128+ player.level * 16 * 8 - flr(player.pos.y))/128
    -- draw player
    circfill(128+(100+norm_y*scale)*cos(0.375), 128+(100+ norm_y*scale)*sin(0.375), 3, 2)
    circfill(128+(100+norm_y*scale)*cos(0.375), 128+(100+ norm_y*scale)*sin(0.375), 1, 10)
end

-- from https://www.lexaloffle.com/bbs/?tid=29664
-- too tired rn to do it myself
function arc(x, y, r, ang1, ang2, c)
 if ang1 < 0 or ang2 < 0 or ang1 >= 1 or ang2 > 1 then return end
 if ang1 > ang2 then
  arc(x, y, r, ang1, 1, c)
  arc(x, y, r, 0, ang2, c)
  return
 end
 for i = 0, .75, .25 do
  local a = ang1
  local b = ang2
  if a > i + .25 then goto next end
  if b < i then goto next end
  if a < i then a = i end
  if b > i + .25 then b = i + .25 end
  local x1 = x + r * cos(a)
  local y1 = y + r * sin(a)
  local x2 = x + r * cos(b)
  local y2 = y + r * sin(b)
  local cx1 = min(x1, x2)
  local cx2 = max(x1, x2)
  local cy1 = min(y1, y2)
  local cy2 = max(y1, y2)
  clip(cx1, cy1, cx2 - cx1 + 2, cy2 - cy1 + 2)
  circ(x, y, r, c)
  clip()
  ::next::
 end
end

