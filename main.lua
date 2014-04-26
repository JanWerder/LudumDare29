require 'player'
require 'rocks'
require 'coin'
require 'bullet'
require 'enemyController'
Collider = require 'hardoncollider'
Camera = require 'hump.camera'

plyMan = {}
playerx = 200
playery = 400
playerw = 66
playerh = 120

camerax = 0
cameray = 300

underwaterbg = love.graphics.newImage("img/underwater_background.png")
waterbg = love.graphics.newImage("img/water_background.png")
plantbg = love.graphics.newImage("img/plant.png")

entities = {}

function love.load()
   love.graphics.setFont(love.graphics.newFont("font/a song for jennifer.ttf",18))
  -- Init world
  HC = Collider.new(150)

  -- Spawn player
  plyMan = player.create(playerx,playery,playerw,playerh)
  --table.insert(entities, plyMan)
   
  -- Camera setup
  cam = Camera(camerax, cameray)
  
  -- Colide Callbacks
  HC:setCallbacks(collide)
  HC:setCallbacks(nil, stop)
  
  -- Rock setup
  rockMan = rock.create(1,200,300)
  table.insert(entities, rockMan)

  -- Coin Setup
  for x = 0 , 150, 30 do
    coinMan = coin.create(500+x,150)
    table.insert(entities, coinMan)
  end
  
  --Enemy Setup
  enemycontrol = enemyController.create()
  
end

function love.update(dt)
    camerax = camerax + 1
    local dx,dy = camerax - cam.x, cameray - cam.y
    cam:move(dx/2, dy/2) 
    
    if not plyMan.isDead then
    plyMan:calcMove()  
    end
  
    for key, value in ipairs(entities) do
      value:update(dt)
    end
    enemycontrol:update(dt)
    HC:update(dt)
    for key, value in pairs(entities) do
      if value.x+400 < plyMan.x then
        table.remove(entities, key)
        HC:remove(value:getObj())
      end
      if value.y < 1 and value.y > -1 then
        table.remove(entities, key)
        HC:remove(value:getObj())
      end
    end
end

function love.draw()
  cam:attach()
  drawBackground()
  for key, value in ipairs(entities) do
    value:draw()
  end
  for key, value in ipairs(enemycontrol.enemyList) do
    value:draw()
  end
  if not plyMan.isDead then
  plyMan:draw()
  end
  cam:detach()
  --HUD
  drawHud()
end

function collide(dt, shape_one, shape_two, dx, dy)
    -- move both shape_one and shape_two to resolve the collision
   if plyMan:compareObj(shape_one)  then
    plyMan:collideWithObj(shape_two,dx,dy)
  elseif  plyMan:compareObj(shape_two ) then
    plyMan:collideWithObj(shape_one,dx,dy)
  end
  
  if shape_one.name == "bullet"  then
    bullet:collideWithObj(shape_one,shape_two,dx,dy)
  elseif  shape_two.name == "bullet" then
    bullet:collideWithObj(shape_two,shape_one,dx,dy)
  end
end

function stop(dt, shape_one, shape_two)
    --print('collision resolved')
end


function drawBackground()
  love.graphics.draw (underwaterbg, camerax - 450,0)
  love.graphics.draw (waterbg, camerax - 450,-600)
end

function drawHud()
love.graphics.printf("Score: " .. plyMan.score .."\nFPS: " .. love.timer.getFPS( ),10, 10, 200,"left") 
  if plyMan.isDead then
  love.graphics.setFont(love.graphics.newFont("font/a song for jennifer.ttf",48))
  love.graphics.printf("U r ded!",250, 200, 300,"center") 
  end
end