

Ball = class{}

function Ball:init( x, y, width, height)

  self.x = x
  self.y = y
  self.width = width
  self.height = height

  self.dx = math.random(2) == 1 and math.random(10, 140) or -math.random(10 , 140)
  self.dy = math.random(-50 , 50)
end
function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2

  self.dx = math.random(2) == 1 and math.random(10, 140) or -math.random(10 , 140)
  self.dy = math.random(-50, 50)
end

function Ball:collide(paddle)

  if self.x + self.width < paddle.x or self.x > paddle.x + paddle.width then
    return false

  elseif
   self.y + self.height < paddle.y or self.y  > paddle.y + paddle.height then
     return false

   else
     return true
   end
 end


function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:render()
  love.graphics.setColor(255 , 255 , 255 , 255)
  love.graphics.rectangle('fill' , self.x , self.y , self.width , self.height)
end
