powerup = {}
powerup.__index = powerup

powerupspeed = love.graphics.newImage("img/PUspeed.png")
powerupspreadshot = love.graphics.newImage("img/PUspreadshot.png")
powerupair = love.graphics.newImage("img/PULuft.png")

powerupObj ={}

function powerup.create(id,x,y)
  local powerupMan = {}
  setmetatable(powerupMan, powerup)
  powerupMan.x = x
  powerupMan.y = y
  powerupMan.powerupid = 0
  powerupMan.duration = 10
  powerupMan.isCollected = false
  powerupMan:initObj(id)
  return powerupMan
end

function powerup:initObj(id)
  if id == 1 then
    self.powerupObj = HC:addCircle(self.x+15,self.y+15,15)
    self.powerupid = powerupspeed
    self.powerupObj.name = "powerup"
    self.powerupObj.type = "speed"
  end
  
  if id == 2 then
    self.powerupObj = HC:addCircle(self.x+15,self.y+15,15)
    self.powerupid = powerupair
    self.duration = 0
    self.powerupObj.name = "powerup"
    self.powerupObj.type = "air"
  end
end

function powerup:getObj()
  return self.powerupObj
end


function powerup:draw()
  if self.isCollected == false then
    --self.powerupObj:draw('line')
    love.graphics.draw(self.powerupid, self.x, self.y)
  end
end

function powerup:rollback()
  if self.powerupid == powerupspeed then
    plyMan.bulletSpeed = 20
  end
end

function powerup:update(dt)
  if self.isCollected == true then
    self.duration = self.duration - dt
  end  
end