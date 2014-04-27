enemy = {}
enemy.__index = enemy

enemyObj ={}

function enemy.create(x,y,shootMode, shootSpeed)
  local enemyMan = {}
  setmetatable(enemyMan, enemy)
  enemyMan.x = x
  enemyMan.y = y
  enemyMan.lives = 0
  enemyMan.enemyimg = ""
  enemyMan.bossMoveDirection = 1
  enemyMan.timeSinceItemDrop = 0
  enemyMan.timeSinceLastShot = 0
  enemyMan.shootMode = shootMode
  enemyMan.shootSpeed = shootSpeed
  enemyMan.bombtimer = -1
  enemyMan:initObj(id)
  enemyMan:setEnemyImg()
  return enemyMan
end

function enemy:setEnemyImg()
  if plyMan.isSurfaced == false then
    if self.shootMode == 3 then
      self.enemyimg = love.graphics.newImage("img/shark.png")
    elseif self.shootMode == 4 then
      self.enemyimg = love.graphics.newImage("img/kraken.png")
    else
      self.enemyimg = love.graphics.newImage("img/enemy.png")
    end
  else
    if self.shootMode == 3 then
      self.enemyimg = love.graphics.newImage("img/sharkSurfaced.png")
    elseif self.shootMode == 5 then
      self.enemyimg = love.graphics.newImage("img/plane.png")
    else
      self.enemyimg = love.graphics.newImage("img/enemySurfaced.png")
    end
  end
end

function enemy:initObj(id, lives, width, lenght)
  
  if self.shootMode == 4 then
    self.lives = 10
    self.enemyObj = HC:addRectangle(self.x,self.y,341,300)
    self.enemyObj.boss = "kraken"
  elseif self.shootMode == 5 then
    self.lives = 10
    self.enemyObj = HC:addRectangle(self.x,self.y,400,345)
    self.enemyObj.boss = "plane"
  else
    self.lives = 1
    self.enemyObj = HC:addRectangle(self.x,self.y,100,72)
  end
  self.enemyObj.name = "enemy"
  if self.enemyObj.boss == nil then
    self.enemyObj.boss = "nope"
  end
end

function enemy:getObj()
  return self.enemyObj
end

function enemy:draw()
  self.enemyObj:draw()
  love.graphics.draw(self.enemyimg, self.x, self.y)
end