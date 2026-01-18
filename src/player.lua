---@class Player
Player = {}
Player.__index = Player

function Player.new()
  local created = {}
  setmetatable(created, Player)
  created.score = 0
  created.pos = Vec2.new{ x=0.0, y=118.0 }
  created.vel = Vec2.new{ x=3.0, y=0.0 }
  created.level = 0
  created.grounded = true
  return created
end

function Player:state()
    -- also check block in front and behind for
    -- not so brutal inputs
  if has_flag(Vec2.new{
      x=self.pos.x,
      y=self.pos.y + 5.0
    }, 0) or has_flag(Vec2.new{
      x=self.pos.x - 5.0,
      y=self.pos.y + 5.0
    }, 0) or has_flag(Vec2.new{
      x=self.pos.x + 5.0,
      y=self.pos.y + 5.0
    }, 0)
    then
        self.grounded = true
    else
        self.grounded = false
    end
  if player.score > starting_hscore then
      high_score = player.score
      if state ~= Lost then
        sfx(3)
      end
  end
end

function Player:handle_keys()
  if btn(2) then
    if self.grounded
    then
      self.vel.y = - 6.0
    end
  end
  -- could add a functionality to dash downwards
  if btn(3) then end
end

function Player:movement()
  self.vel.y = self.vel.y + 0.5

  x_next = self.pos.x + self.vel.x
  if x_next > 128 * 8 then
    x_next = 0
    prev_level = self.level
    self.level = (self.level + flr(rnd(4))) % 4
    y_next = clamp(0+self.level * 16 * 8,self.pos.y + self.vel.y + - prev_level * 16*8 +self.level * 16 * 8, 118 + self.level *16*8)
  else
    y_next = clamp(0+self.level * 16 * 8, player.pos.y + self.vel.y, 118 + self.level *16*8)
  end
  next = Vec2.new {
    x=x_next,
    y=y_next
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
  -- blocks should also kill if you are inside them
  if has_flag(self.pos, 1) or has_flag(self.pos, 0) then
    state = Lost
    if player.score > starting_hscore then
      sfx(2)
      dset(0, high_score)
    else
      sfx(1)
    end
  else
    self.score += 1
    if self.score % 1000 == 0 then
      sfx(0)
    end
  end
end

function Player:update()
  self:state()
  self:handle_keys()
  self:movement()
  self:collission()
end
