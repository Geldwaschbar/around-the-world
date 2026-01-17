---@class Player
Player = {}
Player.__index = Player

function Player.new()
  local created = {}
  setmetatable(created, Player)
  created.score = 0
  created.pos = Vec2.new{ x=64.0, y=95.0 }
  created.vel = Vec2.new{ x=3.0, y=0.0 }
  return created
end

function Player:handle_keys()
  if btn(0) then end
  if btn(1) then end
  if btn(2) then
    if has_flag(Vec2.new{
      x=self.pos.x,
      y=self.pos.y + 2.0
    }, 0) then
      self.vel.y = - 7.0
    end
  end
  if btn(3) then end
end

function Player:movement()
  self.vel.y = self.vel.y + 0.6

  next = Vec2.new {
    x=(self.pos.x + self.vel.x - 64.0) % (94 * 8) + 64.0,
    y=clamp(0, self.pos.y + self.vel.y, 120)
  }
  if has_flag(next, 0) then
    self.pos.x = next.x
    self.pos.y = flr(self.pos.y)
    self.vel.y = 0
  else
    self.pos = next
  end
end

function Player:collission()
  if has_flag(self.pos, 1) then
    state = Lost
  else
    self.score += 1
  end
end

function Player:update()
  self:handle_keys()
  self:movement()
  self:collission()
end

function Player:draw()
  oval(self.pos.x - 2.5, self.pos.y, self.pos.x + 2.5, self.pos.y - 10., 4)
  print("score: " .. self.score, self.pos.x - 14, 2, 2)
  print(has_flag(Vec2.new{
    x=self.pos.x,
    y=self.pos.y + 1.0
  }, 0), self.pos.x - 14, 10, 2)
end
