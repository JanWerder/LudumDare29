menu = {}
menu.__index = menu

plyimg = love.graphics.newImage("img/play.png")
menubg = love.graphics.newImage("img/bg.png")

function menu.create()
  local menuMan = {}
  setmetatable(menuMan, menu)
  menuDrawn = true
  love.window.setTitle("Shootmarine")
  HC = Collider.new(150)
  plyMan = player.create(playerx,playery,playerw,playerh)
  return menuMan
end

function menu:draw()
  love.graphics.draw (menubg, 0,0)
  love.graphics.setFont(love.graphics.newFont("font/a song for jennifer.ttf",80))
  love.graphics.printf("Shootmarine",330,30,320,"center")
  love.graphics.setFont(love.graphics.newFont("font/a song for jennifer.ttf",25))
  love.graphics.printf("Controls:\nWASD - Move\nLeft Control - Shoot\nReturn - Restart\n\nSpace - Dive\nMove up underwater - Surface",280,140,320)
  love.graphics.draw(plyimg, 350,370)
  love.graphics.printf("Press Return to start",280,440,320)
  plyMan:draw()
end


function menu:update(dt)
  if love.keyboard.isDown("return") or love.mouse.isDown("l") then
    menuHold = nil
    love.load()
  end
end