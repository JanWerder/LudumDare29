dialog = {}
dialog.__index = dialog

com_open = love.graphics.newImage("img/com_open.png")
com_shut = love.graphics.newImage("img/com_shut.png")

audio1 = love.audio.newSource("sound/1.wav", "static")
audio2 = love.audio.newSource("sound/2.wav", "static")
audio3 = love.audio.newSource("sound/3.wav", "static")
audio4 = love.audio.newSource("sound/4.wav", "static")
audio5 = love.audio.newSource("sound/5.wav", "static")
audio6 = love.audio.newSource("sound/6.wav", "static")
audio7 = love.audio.newSource("sound/7.wav", "static")

function dialog.create(id)
  local dialogMan = {}
  setmetatable(dialogMan, dialog)
  dialogMan.x = 300
  dialogMan.y = 10
  dialogMan.mouthOpen = true 
  dialogMan.mouthDuration = 0.15
  dialogMan.mouthDelay = dialogMan.mouthDuration
  dialogMan.text = ""
  dialogMan.textShown = ""
  dialogMan.duration = 0
  dialogMan.dialogid = 0
  dialogMan:initObj(id)
  return dialogMan
end

function dialog:initObj(id)
  love.graphics.setFont(love.graphics.newFont("font/a song for jennifer.ttf",18))
  if id == 1 then
    self.text = "The Kraken's fish want to kill us. Defeat the Kraken to end this fight!"
    self.duration = 4
    love.audio.play(audio1)
  end
  if id == 2 then
    self.text = "Oh, and the Navy wants to see us dead aswell. Watch out!"
    self.duration = 5
    love.audio.play(audio2)
  end    
  if id == 3 then
    self.text = "Watch your Air!"
    self.duration = 3
    love.audio.play(audio3)
  end  
  if id == 4 then
    self.text = "Oh, you spotted the commando plane! Kill it to...uhm..test your weapon!?"
    self.duration = 4
    love.audio.play(audio4)
  end
  if id == 5 then
    self.text = "Good job, but the Navy is still looking for us. Kill their commando plane to end this fight. For real this time!"
    self.duration = 7
    love.audio.play(audio5)
  end  
  if id == 6 then
    self.text = "Good job, you made it!"
    self.duration = 3
    love.audio.play(audio6)
  end  
  if id == 7 then
    self.text = "There here is, kill him!"
    self.duration = 4
    love.audio.play(audio7)
  end  
end

function dialog:getObj()
  self.rockObj = {}
  self.rockObj.name = "Dialog"
  return self.rockObj
end

function dialog:draw()
  --draw character
  if self.mouthOpen == false then
    love.graphics.draw(com_shut,self.x,self.y)
      self.mouthDelay = self.mouthDelay - love.timer.getDelta()
      if self.mouthDelay <= 0 then
        self.mouthOpen = true
        self.mouthDelay = self.mouthDuration
      end
  elseif  self.mouthOpen == true then
    love.graphics.draw(com_open,self.x,self.y)
      self.mouthDelay = self.mouthDelay - love.timer.getDelta()
    if self.mouthDelay <= 0 then
      self.mouthOpen = false
      self.mouthDelay = self.mouthDuration
    end
  end

  self.duration = self.duration - love.timer.getDelta()
  if self.duration <= 0 then
     for key, value in ipairs(hud) do
      if value == self then
        table.remove(hud, key)
      end
    end
  end
  
  love.graphics.printf(self.textShown,402, 30, 350,"left")
end


function dialog:update(dt)
  if string.len(self.text) > string.len(self.textShown)  then
    self.textShown = string.sub(self.text,0,string.len(self.textShown)+1)
  end
end