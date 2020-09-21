
push = require 'push'
class = require 'class'
require 'paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

SPEED = 270

function love.load()

  love.window.setTitle('PONG !!')

  player1score = 0
  player2score = 0

  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest','nearest')

  textFont = love.graphics.newFont('font.ttf',8)

  scorefont = love.graphics.newFont('font.ttf', 32)

  WINfont = love.graphics.newFont('font.ttf', 20)

  love.graphics.setFont(textFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
   fullscreen = false,
   resizable = true,
   vsync = true
  })

 player1= paddle(10 , 30 , 5 ,20)
 player2 = paddle(VIRTUAL_WIDTH-15 , VIRTUAL_HEIGHT - 50 , 5, 20)


 ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2 ,4,4)

 servingplayer = 1

 sounds = {
     ['paddle_hit'] = love.audio.newSource('Sounds/paddle_hit.wav' , 'static'),
     ['Score_hit'] = love.audio.newSource('Sounds/SCORE_HIT.wav' , 'static'),
     ['Wall_hit'] = love.audio.newSource('Sounds/Wall_hit.wav' , 'static'),
     ['Win_hit'] = love.audio.newSource('Sounds/WIN_HIT.mp3' , 'static'),

 }

 gameState = 'start'

end

function love.resize(w , h)
  push:resize(w,h)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'serve'
    elseif gameState == 'serve' then
      gameState = 'play'
    elseif gameState == 'win' then
      resetScore()
      gameState = 'start'
  end
 end
end
  function love.update(dt)
    if love.keyboard.isDown('z') then
      player1.dy = -SPEED
    elseif love.keyboard.isDown('s') then
      player1.dy = SPEED
    else
      player1.dy = 0
    end

    if ball.x >= player1.x + 5  then
      player2.y = math.min(ball.y - 5 , VIRTUAL_HEIGHT - 20) 
    end



  if gameState == 'serve' then
     ball.dy = math.random( -50 , 50)
    if servingplayer == 1 then
      ball.dx = math.random(170 , 250)
    else
      ball.dx = -math.random(170, 250)
    end
end
if gameState == 'play' then
  ball:update(dt)
end

 if ball:collide(player1) then
   sounds.paddle_hit:play()
  ball.dx = -ball.dx * 1.05
  ball.x = player1.x + 5
  if ball.dy > 0 then
    ball.dy = math.random(10, 150 )
  else
    Ball.dy = -math.random(10, 150)
  end

 else if ball:collide(player2) then
   sounds.paddle_hit:play()
  ball.dx = -ball.dx * 1.05
  ball.x = player2.x - 4
  if ball.dy > 0 then
    ball.dy = math.random(10, 150 )
  else
    Ball.dy = -math.random(10, 150)
  end

end

  if ball.y <= 0 then
    sounds.Wall_hit:play()
    ball.y = 0
    ball.dy = -ball.dy * 1.0002
  elseif ball.y >= VIRTUAL_HEIGHT - 4 then
    sounds.Wall_hit:play()
    ball.y = VIRTUAL_HEIGHT - 4
    ball.dy = -ball.dy * 1.0002
  end


  player1:update(dt)
  player2:update(dt)
end


   if ball.x > VIRTUAL_WIDTH then
     sounds.Score_hit:play()
    player1score = player1score + 1
    servingplayer = 2
    ball:reset()
    gameState = 'serve'

   elseif ball.x < 0 then
     sounds.Score_hit:play()
    player2score = player2score + 1
    servingplayer = 1
    ball:reset()
    gameState = 'serve'

   end

   if player1score == 10 then
     gameState = 'win'
   elseif player2score == 10 then
     gameState = 'win'
   end

  if gameState == 'win' then
    sounds.Win_hit:play()
  end
end

function love.draw()

   push:apply('start')

  love.graphics.clear(40, 45, 52, 255)
  love.graphics.setFont(textFont)

  if gameState == 'start' then
    love.graphics.printf('Welcome to PONG!',0 , 10 , VIRTUAL_WIDTH , 'center')
    love.graphics.printf('press enter to begin' , 0 , 25, VIRTUAL_WIDTH , 'center')
  end

  if gameState == 'serve' then
    love.graphics.printf('player '.. tostring(servingplayer) .. "'s serve",0 , 10, VIRTUAL_WIDTH , 'center' )
    love.graphics.printf('press enter to serve'  , 0 , 25 , VIRTUAL_WIDTH , 'center')
  end

  if gameState == 'play'  then
    if ball.x > VIRTUAL_WIDTH / 2 - 50 and ball.x  < VIRTUAL_WIDTH / 2 + 50 then

    love.graphics.printf(' GETTEM BOI :3 ' , 0 , 10 , VIRTUAL_WIDTH , 'center')

 end
end
   love.graphics.setFont(WINfont)
   if gameState == 'win' then
      if player1score == 10 then
     love.graphics.printf('player1 Wins With  '..tostring(player1score)..'  Points :)' , 10 , VIRTUAL_HEIGHT / 2 - 6 , VIRTUAL_WIDTH , 'center')
   else
     love.graphics.printf('player2 Wins With  '..tostring(player2score)..'  Points :)' , 10 , VIRTUAL_HEIGHT / 2 - 6 , VIRTUAL_WIDTH , 'center')
   end
 end


  displayscore()
  displayplayers()
  ball:render()
  player1:render()
  player2:render()
  displayFPS()


  push:apply('end')
end


function displayscore()
  love.graphics.setFont(scorefont)
  love.graphics.setColor(182 , 53 , 200 ,255)
  love.graphics.printf( tostring(player1score) , -25 , 45 , VIRTUAL_WIDTH , 'center')
  love.graphics.setColor(54 , 207 , 135 ,255)
  love.graphics.printf(tostring(player2score) , 25 , 45 , VIRTUAL_WIDTH , 'center')
end

function displayplayers()
  love.graphics.setFont(textFont)
  love.graphics.setColor(54 , 207 , 135 ,255)
  love.graphics.printf('PLAYER 2',150 , 30 , VIRTUAL_WIDTH , 'center')
  love.graphics.setColor(182 , 53 , 200 ,255)
  love.graphics.printf('PLAYER 1', -150 , 30 ,VIRTUAL_WIDTH , 'center')
end

function displayFPS()
  love.graphics.setColor(0 , 255 , 0 ,255)
  love.graphics.print('FPS :'..tostring(love.timer.getFPS()),5 ,5 )
end


function resetScore()
  player1score = 0
  player2score = 0
end
