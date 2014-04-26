player = {}
player.__index = player

playerimg = love.graphics.newImage("img/player.png")
playermetalimg = love.graphics.newImage("img/player_metal.png")
--local plyObj = {}

function player.create(x,y,w,h)
  local plyMan = {}
  setmetatable(plyMan, player)
  plyMan.x = x
  plyMan.y = y
  plyMan.w = w
  plyMan.h = h
  plyMan.score = 0
  plyMan.bulletDelay = 0
  plyMan.shield = 0
  plyMan.isSurfaced = false
  plyMan.isDead = false
  
  plyMan.levdir = 1
  plyMan.levdur = 0
  
  plyMan:initObj()
  --ply:setColor(150,210,30)
  --ply:setImage(playerimg)
  --ply:setCallbacks(beginContact, endContact, preSolve, postSolve)
  return plyMan
end

function player:update(dt)
end

  function player:calcMove(plyMan)
    --keyboard input
    if (love.keyboard.isDown("w")) then
    self.plyObj:move(0,-3)
  end
    if (love.keyboard.isDown("s")) then
    self.plyObj:move(0,3)
  end
    if (love.keyboard.isDown("a")) then
    self.plyObj:move(-5,0)
  end
    if (love.keyboard.isDown("d")) then
    self.plyObj:move(5,0)   
  end  
  
  if self.y < 0 and self.isSurfaced == false then
    self.shield = 2
    self:triggerSurface()
  elseif self.isSurfaced == true and love.keyboard.isDown(" ") then
    self.shield = 2
    self:triggerDive()
  end
  
  if self.shield > 0 then
    self.shield = self.shield - love.timer.getDelta()
  end
  
  if self.bulletDelay > 20 then
    if (love.keyboard.isDown("lctrl")) then
      bulletMan = bullet.create(self.x+100,self.y+10,"player",10,0)
      table.insert(entities, bulletMan)
    end
    self.bulletDelay = 0
  else
    self.bulletDelay = self.bulletDelay + 1
  end
  
  --Levitation
  self.plyObj:move(0,self.levdir * -0.1)
  self.levdur = self.levdur + 1
  
  if self.levdur == 45 then
  self.levdur = 0
  --invert levdir
  self.levdir = self.levdir * -1
  end
  
  self:setCoordinates()
end

function player:triggerSurface()
  self.plyObj:moveTo(self.x,-300)
  cameray = -300
  self.isSurfaced = true
end

function player:triggerDive()
  self.plyObj:moveTo(self.x,300)
  cameray = 300
  self.isSurfaced = false
end

function player:initObj()
  self.plyObj = HC:addRectangle(self.x,self.y,self.w,self.h)
  print(self.plyObj)
  self.plyObj:rotate(math.rad(90),self.x,self.y)
  self.plyObj.name = "player"
  self:setCoordinates()
end

function player:compareObj(shape)
  if shape == self.plyObj then
    return true
  end
  return false
end

function player:draw()
  --self.plyObj:draw()
  if self.shield > 0 then
    love.graphics.draw(playermetalimg, self.x, self.y)
  else
  love.graphics.draw(playerimg, self.x, self.y)
  end
end

function player:setCoordinates()
  local x1,y1, x2,y2 = self.plyObj:bbox()
  self.x = x1
  self.y = y1
end

function player:collideWithObj(shape,dx,dy)
  if shape.name == "rock" then
    self:crashesRock(dx,dy)
  end
  if shape.name == "enemy" then
    if plyMan.shield <= 0 then
    self.isDead = true
    end
  end
  if shape.name == "coin" then
    --TODO: remove coin
    self.score = self.score + 1
    for key, value in ipairs(entities) do
      if value:getObj() == shape then
        table.remove(entities, key)
        HC:remove(shape)
      end
    end
  end
end

function player:crashesRock(dx,dy)
  self.plyObj:move(dx, dy)  
  self:setCoordinates()
end

function player:getObj()
  return self.plyObj
end