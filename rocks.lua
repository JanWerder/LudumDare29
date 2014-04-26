rock = {}
rock.__index = rock

rock1 = love.graphics.newImage("img/rock1.png")
rockObj ={}

function rock.create(id,x,y)
  local rockMan = {}
  setmetatable(rockMan, rock)
  rockMan.x = x
  rockMan.y = y
  rockMan:initObj(id)
  return rockMan
end

function rock:initObj(id)
  if id == 1 then
  self.rockObj = HC:addPolygon(self.x+13,self.y+300, 
    self.x+43,self.y+170,
    self.x+64,self.y+180,
    self.x+64,self.y+151, 
    self.x+82,self.y+131,
    self.x+93,self.y+104, 
    self.x+104,self.y+82, 
    self.x+124,self.y+88, 
    self.x+126,self.y+106, 
    self.x+129,self.y+114, 
    self.x+128,self.y+120, 
    self.x+128,self.y+129, 
    self.x+150,self.y+100, 
    self.x+163,self.y+88, 
    self.x+171,self.y+100, 
    self.x+185,self.y+169, 
    self.x+190,self.y+209, 
    self.x+199,self.y+300)
  end
  self.rockObj.name = "rock"
end

function rock:getObj()
  return self.rockObj
end

function rock:draw()
  self.rockObj:draw('line')
  love.graphics.draw(rock1, self.x, self.y)
end

function rock:update(dt)
end