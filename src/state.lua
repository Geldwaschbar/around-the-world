---@class State
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
    sspr(0,8, 32,32, 32, 32, 64,64)
    local msg = "aROUND tHE wORLD"
    print(msg, 64 - #msg * 2, 20, 9)

    local msg = "press arrow keys to start!"
    print(msg, 64 - #msg * 2, 100, 13)
  end
)

Running = State.new(
  function ()
    player:update()
  end,
  function ()
    draw()
    print("score: " .. player.score, 0, 2, 12)
    print("record: " .. high_score, 0, 10, 1)
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
