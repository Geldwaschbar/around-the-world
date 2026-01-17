---@class
State = {}
State.__index = State

function State.new(update, draw)
  local created = {}
  setmetatable(created, State)
  created.update = update
  created.draw = draw
  return created
end

Start = State.new(
  function ()
    for i=0,3 do
      if btn(i) then
        state = Running
      end
    end
  end,
  function ()
    local msg = "add titlescreen here"
    print(msg, 64 - #msg * 2, 64, 9)

    local msg = "press w/a/s/d to start!"
    print(msg, 64 - #msg * 2, 96, 13)
  end
)

Running = State.new(
  function ()
    player:update()
  end,
  function ()
    map()
    camera(player.pos.x - 16., 0.)
    player:draw()
  end
)

Lost = State.new(
  function ()
    for i=0,3 do
      if btn(i) then
        state = Running
        player = Player.new()
      end
    end
  end,
  function ()
    camera(0., 0.)
    local msg = "you lost!"
    print(msg, 64 - #msg * 2, 64 - 8, 8)
    local msg = "score: " .. player.score
    print(msg, 64 - #msg * 2, 64 + 8, 7)
  end
)
