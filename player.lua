player = {}
player.__index = player

playerimg = love.graphics.newImage("img/player.png")
playermetalimg = love.graphics.newImage("img/player_metal.png")
playertopimg = love.graphics.newImage("img/player_top.png")
playertopmetalimg = love.graphics.newImage("img/player_top_metal.png")
--local plyObj = {}
powerups = {}

function player.create(x,y,w,h)
  local plyMan = {}
  setmetatable(plyMan, player)
  plyMan.x = x
  plyMan.y = y
  plyMan.w = w
  plyMan.h = h
  plyMan.speed = 5
  plyMan.score = 0
  plyMan.bulletDelay = 0
  plyMan.bulletSpeed = 20
  plyMan.shield = 0
  plyMan.air = 30
  plyMan.powerupDrop = 0
  plyMan.powerupRate = 3
  plyMan.isSurfaced = false
  plyMan.isDead = false
  plyMan.isFightingBoss = nil
  plyMan.isAirWarned = false
  plyMan.hasKilledKraken = false
  plyMan.hasKilledPlane = false
  plyMan.spreadshot = false
  plyMan.ShieldBlock = false
  plyMan.shieldBlockDuration = 2
  
  plyMan.levdir = 1
  plyMan.levdur = 0
  
  plyMan:initObj()
  --ply:setColor(150,210,30)
  --ply:setImage(playerimg)
  --ply:setCallbacks(beginContact, endContact, preSolve, postSolve)
  return plyMan
end

lastdt = 0
function player:update(dt)
  lastdt = lastdt + dt
  if not plyMan.hasKilledKraken or not plyMan.hasKilledPlane then
    if lastdt >= 1 and self.isSurfaced == false then
      lastdt = 0
      self.air = self.air - 1
    end
    if lastdt >= 1 and self.isSurfaced == true and self.air < 30 then
      lastdt = 0
      if self.air % 2 == 0 then
        self.air = self.air + 1
      end
      self.air = self.air + 1
    end
    
    if self.air <= 0 then
      self.isDead = true
    end 
  end
  
  if self.air <= 10 and self.isAirWarned == false then
      table.insert(hud, dialog.create(3))
      self.isAirWarned = true
  end 
  
  --Powerup calc
  for key, value in ipairs(powerups) do
    if value ~= nil then
        value.duration = value.duration - dt
        if value.duration <= 0 then
          value:rollback()
          table.remove(powerups, key) 
       end
    end
  end
  
end

function player:calcMove(plyMan)
    --keyboard input
   
if not self.isDead then
  self.plyObj:move(2,0)
    if (love.keyboard.isDown("w")) and self.y > -600 then
    self.plyObj:move(0,-self.speed-2)
  end
    if (love.keyboard.isDown("s")) and self.y < 600-self.w then
    self.plyObj:move(0,self.speed)
  end
    camX,camY = cam:worldCoords(0,0)
    if (love.keyboard.isDown("a")) and self.x > camX then
    self.plyObj:move(-self.speed,0)
  end
    if (love.keyboard.isDown("d")) and self.x < camX+800-self.h then
    self.plyObj:move(self.speed-2,0)   
  end  
  
  
  if self.x < camX then
    self.plyObj:move(2,0)   
  end
  
  if self.y >= -self.w-5 and self.isSurfaced then
    self.plyObj:move(0,-self.speed)   
  end
  
-- fuck this
--  if self.x < camX-20 then
--    self.isDead = true
--  end  

  
  if ( self.y < 0 and self.isSurfaced == false ) then
    if self.isFightingBoss == nil then
      self:raiseShield()
      
      delKeys = {}
      for key, value in pairs(entities) do
        if value.x < self.x+350 and value:getObj().name == "rock" and value.y < 0 then
          table.insert(delKeys, key)
          HC:remove(value:getObj())
        end
      end
      table.sort(delKeys, comp)
      for key, value in pairs(delKeys) do
        table.remove(entities, value)
      end

      self:triggerSurface()
    end    
  elseif (self.isSurfaced == true and love.keyboard.isDown(" ") and self.isFightingBoss == nil) then
    if self.isFightingBoss == nil then
      self:raiseShield()
      self:triggerDive()
      end
  end
  
  if self.shield > -0.5 then
    self.shield = self.shield - love.timer.getDelta()
    if self.shield < 0 then
      self.ShieldBlock = true
    end
    if self.shield > 0 then
      self.ShieldBlock = false
    end
  end
  
  if self.shield <= -0.5 then
    --print("ding")
    self.ShieldBlock = false
    --self.shieldBlockDuration = 2
  end
  
  if self.bulletDelay > self.bulletSpeed then
    if (love.keyboard.isDown("lctrl")) then
      if self.spreadshot == false then
        bulletMan = bullet.create(self.x+100,self.y+10,"player",10,0)
        table.insert(entities, bulletMan)
      else
        table.insert(entities, bullet.create(self.x+100,self.y+10,"player",10,-5))
        table.insert(entities, bullet.create(self.x+100,self.y+10,"player",10,0))
        table.insert(entities, bullet.create(self.x+100,self.y+10,"player",10,5))
      end
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
  elseif self.isDead == true and self.isSurfaced  == false then
     self:getObj():move(0,2)
     else
   end

  
  self:setCoordinates()
end

function player:raiseShield()
  if self.shield <= 2 and self.shield > -0.5 then
    self.shield = -0.1
  end
  if self.shield <= -0.5 then
    self.shield = 2
  end
end

function player:triggerSurface()
  self.plyObj:moveTo(self.x,-300)
  cameray = -300
  self.isSurfaced = true
end

function player:triggerDive()
  self.plyObj:moveTo(self.x,200)
  cameray = 300
  self.isSurfaced = false
end

function player:initObj()
  self.plyObj = HC:addRectangle(self.x,self.y+15,self.h,self.w-15)
  --print(self.plyObj)
  --self.plyObj:rotate(math.rad(90),self.x,self.y)
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
 -- self.plyObj:draw()
  
  if self.isSurfaced == false then
    --print(self.shield)
    --print(self.ShieldBlock)
    if self.shield > 0 and not self.ShieldBlock and self.isDead == false then
        if  self.isDead == true then
          love.graphics.draw(playermetalimg, self.x+self.h, self.y+self.w, math.rad(180))
        else
          love.graphics.draw(playermetalimg, self.x, self.y)
        end
    else
        if  self.isDead == true then      
          love.graphics.draw(playerimg, self.x+self.h, self.y+self.w, math.rad(180))
        else
          love.graphics.draw(playerimg, self.x, self.y)
        end
     end
  else
    if self.shield > 0 and  not self.ShieldBlock then
      love.graphics.draw(playertopmetalimg, self.x, self.y)
    else
    love.graphics.draw(playertopimg, self.x, self.y)
    end  
  end
end

function player:setCoordinates()
  local x1,y1, x2,y2 = self.plyObj:bbox()
  self.x = x1
  self.y = y1-15
end

function player:collideWithObj(shape,dx,dy)
  if shape.name == "rock" then
    self:crashesRock(dx,dy)
  end
  if shape.name == "powerup" then
    if shape.type == "bullet" then
      self.bulletSpeed = 7
    end
    if shape.type == "speed" then
      self.speed = 10
    end
    if shape.type == "air" then
      self.air = 30
    end
    if shape.type == "spreadshot" then
      self.spreadshot = true
    end
    
    
    for key, value in ipairs(entities) do
      if value:getObj() == shape then
        value.isCollected = true
        table.insert(powerups, value)
        --PowerupMan löscht in update
        HC:remove(shape)
      end
    end
  end
  if shape.name == "bomb" then
    self:crashesRock(dx,dy)
  end
  if (shape.name == "enemy") and shape.boss ~= "plane" then
    --print(shape.boss)
    if plyMan.shield <= 0 then
    self.isDead = true
    end
  end
  if shape.name == "coin" then
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
  --self.plyObj:move(dx, dy)  
  self.isDead = true
  self:setCoordinates()
end

function player:getObj()
  return self.plyObj
end
function comp(w1,w2)
    if w1 > w2 then
        return true
    end
end