require 'enemy'
require 'bullet'

enemyController = {}
enemyController.__index = enemyController



function enemyController.create()
  local enemyControllerMan = {}
  setmetatable(enemyControllerMan, enemyController)
  enemyControllerMan.timeSinceLastSpawn = 0
  enemyControllerMan.enemyList = {}
  return enemyControllerMan
end

function enemyController:update(dt)
  -- Spawn new Enemys
  distanceToSpawn = 800
  self.timeSinceLastSpawn = self.timeSinceLastSpawn + dt
  
  if (plyMan.x % 100) > 94 or (plyMan.x % 100) < 1 then
    newEnemy = true
    newEnemyXKoord = math.floor((plyMan.x+distanceToSpawn)/100)*100+100
    for key, value in ipairs(self.enemyList) do
      if value.x == newEnemyXKoord then
        newEnemy = false
      end
      if value.shootMode == 4 or value.shootMode == 5 then
        newEnemy = false
      end
    end
    if self.timeSinceLastSpawn < (2000/plyMan.x) or plyMan.x < 0 then
      newEnemy = false
    end
    if newEnemy == true then
      if plyMan.x > 2000 then
        if plyMan.y < 0 then
          nenemy = enemy.create(newEnemyXKoord, plyMan.y, 5, 1)
        else
          nenemy = enemy.create(newEnemyXKoord, plyMan.y, 4, 1)
        end
      else
        nenemy = enemy.create(newEnemyXKoord, plyMan.y, math.random(1,3), math.random(0.1,1))
      end
      table.insert(self.enemyList, nenemy)
      self.timeSinceLastSpawn = 0
    end
  end
  

  -- Do Action with Existing Enemies
  for key, value in pairs(self.enemyList) do
    value.timeSinceLastShot = value.timeSinceLastShot + dt
    if value.shootMode ~= 0 then
      self:enemyShoot(value)
    end
  end
end

function enemyController:enemyShoot(enemy)
  if enemy.timeSinceLastShot > enemy.shootSpeed+enemy.shootSpeed then
    -- single shot
    if enemy.shootMode == 1 then
      newBullet = bullet.create(enemy.x,enemy.y,"enemy",10,0)
      table.insert(entities, newBullet)
      enemy.timeSinceLastShot = 0
    end
    -- burst
    if enemy.shootMode == 2 then
      newBullet = bullet.create(enemy.x,enemy.y,"enemy",10,-5)
      table.insert(entities, newBullet)
      newBullet = bullet.create(enemy.x,enemy.y,"enemy",10,0)
      table.insert(entities, newBullet)
      newBullet = bullet.create(enemy.x,enemy.y,"enemy",10,5)
      table.insert(entities, newBullet)
      enemy.timeSinceLastShot = 0
    end
  end
  -- shark attack
  if enemy.shootMode == 3 then
    enemy.x = enemy.x-enemy.shootSpeed*10
    enemy.y = plyMan.y-20
    enemy:getObj():moveTo(enemy.x+(100/2),enemy.y+(72/2))
    enemy:draw()
  end
  
  -- end Boss water
  if enemy.shootMode == 4 then
    enemy.timeSinceItemDrop = enemy.timeSinceItemDrop + love.timer.getDelta()
    if plyMan.air < 10 then
      if enemy.timeSinceItemDrop > 5 then
        table.insert(entities, powerup.create(2,enemy.x, enemy.y))
        enemy.timeSinceItemDrop = 0
      else
      end
    end
    if enemy.timeSinceLastShot > enemy.shootSpeed+enemy.shootSpeed then
      newBullet = bullet.create(enemy.x,enemy.y,"enemy",10,-5)
      table.insert(entities, newBullet)
      newBullet = bullet.create(enemy.x,enemy.y,"enemy",10,0)
      table.insert(entities, newBullet)
      newBullet = bullet.create(enemy.x,enemy.y,"enemy",10,5)
      table.insert(entities, newBullet)
      enemy.timeSinceLastShot = 0
    end
    if math.random(0,300) == 10 then
      enemy.timeSinceLastShot = -9999999999
      enemy.bossMoveDirection = 1
    end
    if enemy.timeSinceLastShot < 0 then
      if enemy.bossMoveDirection == 1 then
        enemy.x = enemy.x - 20
        worldX,worldY = cam:pos()
        if enemy.x < worldX-100-math.random(0,400) then
          enemy.bossMoveDirection = -1
        end
      else
        enemy.x = enemy.x + 20
        
        worldX,worldY = cam:pos()
        if enemy.x > worldX+180 then
          enemy.bossMoveDirection = 1
          enemy.timeSinceLastShot = 0
          enemy.x = worldX+180
        end
      end
    else
      worldX,worldY = cam:pos()
      if enemy.x < worldX+180 then
        enemy.x = worldX+180
      end
      enemy.y = enemy.y+(enemy.shootSpeed*math.random(7,15)*enemy.bossMoveDirection)
      if enemy.y > 600-72 then
        enemy.bossMoveDirection = -1
      elseif enemy.y < 0 then
        enemy.bossMoveDirection = 1
      end
    end
    enemy:getObj():moveTo(enemy.x+(341/2),enemy.y+(300/2))
    enemy:draw()
  end
  
  -- end Boss air
  if enemy.shootMode == 5 then
    enemy.timeSinceLastShot = enemy.timeSinceLastShot + love.timer.getDelta()
    if enemy.timeSinceLastShot > 1 then
      for key, value in ipairs(entities) do
        if value:getObj().name == "bomb" then
          table.remove(entities, key)
          HC:remove(value:getObj())
        end
      end
    end
    diffX = plyMan.x - (enemy.x+400/2)
    diffY = plyMan.y - (enemy.y+345/2)

    if enemy.bombtimer == -1 then
      if math.sqrt(diffX*diffX) < 10 and math.sqrt(diffY*diffY) < 10 then
        enemy.bombtimer = 0
      else
        if diffX > 5 then
          enemy.x = enemy.x + 4
        elseif diffX < 5 then
          enemy.x = enemy.x - 2
        end
        if diffY > 5 then
          enemy.y = enemy.y + 2
        elseif diffY < 5 then
          enemy.y = enemy.y - 2
        end
      end
    else
      if enemy.bombtimer < 2 then
        if enemy.bombtimer == -1 then
          enemy.bombtimer = love.timer.getDelta()
        else
          enemy.x = enemy.x + 2
          enemy.bombtimer = enemy.bombtimer + love.timer.getDelta()
        end
      else
        table.insert(entities, rock.create(3,enemy.x+(400/4),enemy.y+(345/4)))
        enemy.timeSinceLastShot = 0
        enemy.bombtimer = -1
        love.timer.getDelta()
      end
    end
    enemy:getObj():moveTo(enemy.x+(400/2),enemy.y+(345/2))

  end
end