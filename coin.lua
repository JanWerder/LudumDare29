coin = {}
coin.__index = coin

coinimg = love.graphics.newImage("img/bitcoin.png")
coinObj ={}

function coin.create(x,y)
  local coinMan = {}
  setmetatable(coinMan, coin)
  coinMan.x = x
  coinMan.y = y
  coinMan:initObj(id)
  return coinMan
end

function coin:initObj(id)
  self.coinObj = HC:addCircle(self.x+16,self.y+16,16)
  self.coinObj.name = "coin"
end

function coin:getObj()
  return self.coinObj
end

function coin:draw()
 -- self.coinObj:draw('line')
  love.graphics.draw(coinimg, self.x, self.y)
end

function coin:update(dt)
end