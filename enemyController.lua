require 'enemy'
require 'bullet'

enemyController = {}
enemyController.__index = enemyController



function enemyController.create()
  local enemyControllerMan = {}
  setmetatable(enemyControllerMan, enemyController)
  enemyControllerMan.enemyList = {}
  return enemyControllerMan
end

function enemyController:update(dt)
  -- Spawn new Enemys
  distanceToSpawn = 400
  if (plyMan.x % 100) > 94 or (plyMan.x % 100) < 1 then
    newEnemy = true
    newEnemyXKoord = math.floor((plyMan.x+distanceToSpawn)/100)*100+100
    for key, value in ipairs(self.enemyList) do
      if value.x == newEnemyXKoord or value.x > newEnemyXKoord-distanceToSpawn-1 then
        newEnemy = false
      end
    end
    if newEnemy == true then
      nenemy = enemy.create(newEnemyXKoord, plyMan.y, math.random(1,3), math.random(0.1,1))
      table.insert(self.enemyList, nenemy)
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
      
    end
    -- burst
    if enemy.shootMode == 2 then
      newBullet = bullet.create(enemy.x,enemy.y,"enemy",10,-5)
      table.insert(entities, newBullet)
      newBullet = bullet.create(enemy.x,enemy.y,"enemy",10,0)
      table.insert(entities, newBullet)
      newBullet = bullet.create(enemy.x,enemy.y,"enemy",10,5)
      table.insert(entities, newBullet)
    end
    enemy.timeSinceLastShot = 0
  end
  -- shark attack
  if enemy.shootMode == 3 then
    enemy.x = enemy.x-enemy.shootSpeed*10
    enemy:getObj():move(-enemy.shootSpeed*10,0)
    enemy:draw()
  end
  
end