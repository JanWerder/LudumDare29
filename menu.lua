menu = {}
menu.__index = menu

plyimg = love.graphics.newImage("img/play.png")

function menu.create()
  local menuMan = {}
  setmetatable(menuMan, menu)
  menuDrawn = true
  return menuMan
end

function menu:draw()
  love.graphics.setFont(love.graphics.newFont("font/a song for jennifer.ttf",50))
  love.graphics.printf("Steampunk submarine",325,75,320,"center")
  love.graphics.setFont(love.graphics.newFont("font/a song for jennifer.ttf",18))
  love.graphics.printf("Controls:\nWASD - move\nLeft Control - Shoot\nReturn - Restart\n\nSpace - Dive\nMove up underwater - Surface",325,150,320)
  love.graphics.draw(plyimg, 375,300)
  love.graphics.printf("Press Return to start",325,375,320)
end


function menu:update(dt)
  if love.keyboard.isDown("return") or love.mouse.isDown("l") then
    menuHold = nil
    love.load()
  end
end