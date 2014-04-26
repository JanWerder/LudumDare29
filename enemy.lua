enemy = {}
enemy.__index = enemy

enemyimg = love.graphics.newImage("img/enemy.png")
enemyObj ={}

function enemy.create(x,y,shootMode, shootSpeed)
  local enemyMan = {}
  setmetatable(enemyMan, enemy)
  enemyMan.x = x
  enemyMan.y = y
  enemyMan.timeSinceLastShot = 0
  enemyMan.shootMode = shootMode
  enemyMan.shootSpeed = shootSpeed
  enemyMan:initObj(id)
  return enemyMan
end

function enemy:initObj(id)
  self.enemyObj = HC:addRectangle(self.x,self.y,100,72)
  self.enemyObj.name = "enemy"
end

function enemy:getObj()
  return self.enemyObj
end

function enemy:draw()
  self.enemyObj:draw()
  love.graphics.draw(enemyimg, self.x, self.y)
end