require 'player'
require 'rocks'
require 'coin'
require 'bullet'
require 'enemyController'
require 'powerup'
require 'dialog'
Collider = require 'hardoncollider'
Camera = require 'hump.camera'

plyMan = {}
playerx = 200
playery = 300
playerw = 66
playerh = 120

camerax = 0
cameray = 300

plantLastXKoord = 0

underwaterbg = love.graphics.newImage("img/underwater_background.png")
waterbg = love.graphics.newImage("img/water_background.png")
plantbg = love.graphics.newImage("img/plant.png")

entities = {}
hud ={}

function love.load()
   love.graphics.setFont(love.graphics.newFont("font/a song for jennifer.ttf",20))
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
  
  table.insert(hud, dialog.create(1))
  
  -- Rock setup
  --table.insert(entities, rock.create(20,600,200))
  
  --powerup setup
  table.insert(entities, powerup.create(1,500,100))
  table.insert(entities, powerup.create(2,500,150))
  
  -- UFO setup
  table.insert(entities, rock.create(1,400,600-175))
  table.insert(entities, rock.create(4,200,600-175))

  -- Plant setup
  plantXKoord = -400
  while plantXKoord <= 820 do
    plantId = math.random(5,9)
    if plantId == 9 then
      table.insert(entities, rock.create(plantId,plantXKoord,600-250))
    else
      table.insert(entities, rock.create(plantId,plantXKoord,600-80))
    end
    plantXKoord = plantXKoord + 30 + math.random(0,5)
  end
  
  --table.insert(entities, rock.create(2,400,10))
  -- Coin Setup
  for x = 0 , 150, 30 do
    coinMan = coin.create(600+x,150)
    table.insert(entities, coinMan)
  end
  
  --Enemy Setup
  enemycontrol = enemyController.create()
  
end

dialog1done = false
dialog2done = false

function love.update(dt)
    -- Plant setup
    if math.floor(cam.x % 30) == 0 or math.floor(cam.x % 30) == 1 then
      plantId = math.random(5,9)
      if plantId == 9 then
        table.insert(entities, rock.create(plantId,math.floor(cam.x)+850+math.random(0,5),600-250))
      else
        table.insert(entities, rock.create(plantId,math.floor(cam.x)+850+math.random(0,5),600-80))
      end
    end   
    
    if plyMan.hasKilledKraken and not plyMan.hasKilledPlane and dialog1done == false then
      table.insert(hud, dialog.create(5))
      dialog1done = true
    end
    
    if plyMan.hasKilledKraken and plyMan.hasKilledPlane and dialog2done == false then
      table.insert(hud, dialog.create(6))
      dialog2done = true
    end
    
    camerax = camerax + 2
    local dx,dy = camerax - cam.x, cameray - cam.y
    cam:move(dx/2, dy/2) 
    
    plyMan:update(dt)
    plyMan:calcMove()  
  
    if love.keyboard.isDown("return") then
       restart()
    end
  
    for key, value in ipairs(entities) do
      value:update(dt)
    end
    for key, value in ipairs(hud) do
      value:update(dt)
    end
    enemycontrol:update(dt)
    HC:update(dt)
    for key, value in pairs(entities) do
      if value:getObj().name == "rock" then
        if value.x+1400 < plyMan.x then
          table.remove(entities, key)
          HC:remove(value:getObj())
        end
      else
        if value.x+600 < plyMan.x or (value.x-800 > plyMan.x and value:getObj().name ~= "plant") then
          table.remove(entities, key)
          HC:remove(value:getObj())
        end
        if value.y < 1 and value.y > -1 and value:getObj().name ~= "plant" then
          table.remove(entities, key)
          HC:remove(value:getObj())
        end
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
    if value.shootMode == 4 or value.shootMode == 5 then
      plyMan.isFightingBoss = value
    end
  end
  plyMan:draw()
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

isDiveTipShown = false
diveTipShowCounter = 0
hudspace = love.graphics.newImage("img/space_quad.png")
hudspacetop = love.graphics.newQuad(0,0,250,50,250,100)
hudspacebottom = love.graphics.newQuad(0,50,250,50,250,100)

hudenemybar = love.graphics.newImage("img/enemybar.png")
hudenemybarfill = love.graphics.newImage("img/progressbarfill.png")

hudairbar = love.graphics.newImage("img/airbar.png")
hudairbarfill = love.graphics.newImage("img/airbarfill.png")

function drawHud()
    for key, value in ipairs(hud) do
    value:draw()
  end
  
    if plyMan.isDead then
    love.graphics.setFont(love.graphics.newFont("font/a song for jennifer.ttf",48))
    love.graphics.printf("U r ded!\nPress Return to restart",250, 200, 350,"center") 
   -- love.system.openURL("http://eelslap.com/")
  end
  love.graphics.setFont(love.graphics.newFont("font/a song for jennifer.ttf",18))
love.graphics.printf("Score: " .. plyMan.score .."\nFPS: " .. love.timer.getFPS( ),10, 10, 200,"left") 

  
  --tipShowCounter = 0
  if isDiveTipShown == false and plyMan.isSurfaced == true  and diveTipShowCounter < 100 then
    if diveTipShowCounter < 30 or diveTipShowCounter > 60 then
    love.graphics.draw(hudspace,hudspacetop,300,500)
    else
    love.graphics.draw(hudspace,hudspacebottom,300,500)
    end
    diveTipShowCounter = diveTipShowCounter + 1
  end
  
  if diveTipShowCounter == 100 then
    table.insert(hud, dialog.create(2))
    diveTipShowCounter = diveTipShowCounter + 1
  end
  
  if plyMan.isFightingBoss ~= nil then
    hudenemybarfillquad = love.graphics.newQuad(0,0,214/10*plyMan.isFightingBoss.lives,20,214,20)
    love.graphics.draw(hudenemybar,300,500)
    love.graphics.draw(hudenemybarfill,hudenemybarfillquad,300+39,500+13)
  end
  
  hudairbarlquad = love.graphics.newQuad(0,0,20,214/30*plyMan.air,20,214)
  if plyMan.air > 0 then
  love.graphics.draw(hudairbarfill,hudairbarlquad,0+13,100+8+214+(214/30*plyMan.air*-1))
  end
  love.graphics.draw(hudairbar,0,100)
end

function restart()
  enemycontrol.enemyList = {}
  entities = {}
  cam = {}
  HC = {}
  camerax = 0
  cameray = 300
  love.load()
end