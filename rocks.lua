rock = {}
rock.__index = rock

rock1 = love.graphics.newImage("img/rock1.png")
rock2 = love.graphics.newImage("img/rock2.png")
rock3 = love.graphics.newImage("img/rock3.png")
ufo = love.graphics.newImage("img/ufo.png")
plant = love.graphics.newImage("img/plant.png")
plant2 = love.graphics.newImage("img/plant2.png")
plant3 = love.graphics.newImage("img/plant3.png")
plant4 = love.graphics.newImage("img/plant4.png")
plant5 = love.graphics.newImage("img/plant5.png")
bomb = love.graphics.newImage("img/bomb.png")

rockObj ={}

function rock.create(id,x,y)
  local rockMan = {}
  setmetatable(rockMan, rock)
  rockMan.x = x
  rockMan.y = y
  rockMan.rockid = 0
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
    self.rockid = rock1
    self.rockObj.name = "rock"
  elseif id == 2 then
    self.rockObj = HC:addRectangle(self.x,self.y,180,600)
    self.rockid = rock2
    self.rockObj.name = "rock"
  elseif id == 20 then
    self.rockObj = HC:addRectangle(self.x,self.y,300,400)
    self.rockid = rock3
    self.rockObj.name = "rock"
  elseif id == 3 then
    self.rockObj = HC:addRectangle(self.x,self.y,300,300)
    self.rockid = bomb
    self.rockObj.name = "bomb"
  elseif id == 4 then
    self.rockObj = HC:addPolygon(
      self.x+12,self.y+175, 
      self.x+70,self.y+134,
      self.x+56,self.y+95,
      self.x+80,self.y+75,
      self.x+115,self.y+30,
      self.x+170,self.y+10,
      self.x+185,self.y+20,
      self.x+230,self.y+20,
      self.x+250,self.y+57,
      self.x+360,self.y+50,
      self.x+393,self.y+60,
      self.x+393,self.y+179
    )
    self.rockid = ufo
    self.rockObj.name = "rock"
  elseif id == 5 then
    self.rockObj = HC:addRectangle(self.x,self.y,20,80)
    self.rockid = plant
    self.rockObj.name = "plant"
  elseif id == 6 then
    self.rockObj = HC:addRectangle(self.x,self.y,40,80)
    self.rockid = plant2
    self.rockObj.name = "plant"
  elseif id == 7 then
    self.rockObj = HC:addRectangle(self.x,self.y,20,80)
    self.rockid = plant3
    self.rockObj.name = "plant"
  elseif id == 8 then
    self.rockObj = HC:addRectangle(self.x,self.y,40,80)
    self.rockid = plant4
    self.rockObj.name = "plant"
  elseif id == 9 then
    self.rockObj = HC:addRectangle(self.x,self.y,100,250)
    self.rockid = plant5
    self.rockObj.name = "plant"
  end
end

function rock:getObj()
  return self.rockObj
end

function rock:draw()
  --self.rockObj:draw('line')
  love.graphics.draw(self.rockid, self.x, self.y)
end

function rock:update(dt)
end