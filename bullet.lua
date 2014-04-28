bullet = {}
bullet.__index = bullet

bulletimg = love.graphics.newImage("img/bullet.png")
bulletObj ={}

function bullet.create(x,y,from,speed,angle)
  local bulletMan = {}
  setmetatable(bulletMan, bullet)
  bulletMan.x = x
  bulletMan.y = y
  bulletMan.speed = speed
  bulletMan.from = from
  bulletMan.angle = angle
  bulletMan:initObj()
  bulletMan.bulletObj.from = from
  return bulletMan
end

function bullet:initObj()
  self.bulletObj = HC:addRectangle(self.x,self.y,16,5)
  self.bulletObj.name = "bullet"
end

function bullet:getObj()
  return self.bulletObj
end

function bullet:compareObj(shape)
  if shape == self.bulletObj then
    return true
  end
  return false
end

function bullet:draw()
  --self.bulletObj:draw()
  love.graphics.draw(bulletimg, self.x, self.y)
end

function bullet:update(dt)
  if self.from == "player" then
  self.bulletObj:move(self.speed,self.angle)
  end

  if self.from == "enemy" then
  self.bulletObj:move(-self.speed,self.angle)
  end

  local x1,y1, x2,y2 = self.bulletObj:bbox()
  self.x = x1
  self.y = y1
end

function bullet:collideWithObj(shape_self,shape,dx,dy)
  if shape.name == "player" and shape_self.from ~= shape.name and plyMan.shield <= 0  then
    plyMan.isDead = true
  end
  if shape.name == "enemy" then
     for key, value in ipairs(enemycontrol.enemyList) do
      if value:getObj() == shape and shape_self.from ~= shape.name then
        value.lives = value.lives - 1
        for key2, value2 in ipairs(entities) do
          if value2:getObj() == shape_self then
            table.remove(entities, key2)
            HC:remove(value2:getObj())
          end
        end
        if value.lives < 1 then
          plyMan.isFightingBoss = nil
          plyMan.powerupDrop = plyMan.powerupDrop + 1
          if plyMan.powerupDrop % plyMan.powerupRate == 0 then
            table.insert(entities, powerup.create(math.random(1,4),value.x,value.y))
          end
          table.remove(enemycontrol.enemyList, key)
            if shape.boss == "kraken" then
              plyMan.hasKilledKraken = true
            elseif shape.boss == "plane" then
              plyMan.hasKilledPlane = true
            end
          HC:remove(shape)
        end
      end
    end
  end
end