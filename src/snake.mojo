from lib.Key import Key
import time
from sys import exit

@value
struct BodyPart():
    var x: Int
    var y: Int
    var cDir: Int
    var pDir: Int

    fn __init__(inout self, x: Int, y: Int, dir: Int):
        self.x = x
        self.y = y
        self.cDir = dir
        self.pDir = -1


fn main() raises:
    var key = Key()
    var clear = chr(27) + "[2J"

    var height = 12
    var width = 50

    var rows: String = '--'
    for _ in range(width):
        rows += '-'
    rows += '\n'
    for _ in range(height):
        rows += '|'
        for _ in range(width):
            rows += ' '
        rows += '|\n'
    for _ in range(width + 2):
        rows += '-'

    var dirs = Dict[String, Int]()
    dirs['w'] = 119
    dirs['a'] = 97
    dirs['s'] = 115
    dirs['d'] = 100
    var snake = List[BodyPart](BodyPart(1, int(height / 2), dirs['d']))
    var nextMove = dirs['d']
    random.seed()
    var randX = int(random.random_ui64(3, width))
    var randY = int(random.random_ui64(1, height))
    rows.unsafe_uint8_ptr()[randY * (width + 3) + randX] = 79

    var score = 0

    var t = time.now()
    var key_count = 0
    while True:
        var c = key.listen()
        if c != -1:
            key_count += 1
            if chr(c) in dirs:
                nextMove = c
            elif c == 122:
                print('\nexited')
                exit()
        if time.now() - t > 260000000:
            t = time.now()
            # Update game
            var lastPos = (0, 0)
            for i in range(len(snake)):
                snake[i].pDir = snake[i].cDir
                if i == 0:
                    if (nextMove == dirs['w'] and snake[i].cDir != dirs['s']) or
                       (nextMove == dirs['a'] and snake[i].cDir != dirs['d']) or 
                       (nextMove == dirs['s'] and snake[i].cDir != dirs['w']) or
                       (nextMove == dirs['d'] and snake[i].cDir != dirs['a']):
                        snake[i].cDir = nextMove
                else:
                    snake[i].cDir = snake[i - 1].pDir
                if i == len(snake) - 1:
                    lastPos = (snake[i].x, snake[i].y)
                    rows.unsafe_uint8_ptr()[snake[i].y * (width + 3) + snake[i].x] = 32
                if snake[i].cDir == dirs['w']:
                    snake[i].y -= 1
                elif snake[i].cDir == dirs['a']:
                    snake[i].x -= 1
                elif snake[i].cDir == dirs['s']:
                    snake[i].y += 1
                elif snake[i].cDir == dirs['d']:
                    snake[i].x += 1
            # Collision check
            var collision = rows.unsafe_uint8_ptr()[snake[0].y * (width + 3) + snake[0].x]
            if collision == 79:
                snake.append(BodyPart(lastPos[0], lastPos[1], snake[len(snake) - 1].cDir))
                rows.unsafe_uint8_ptr()[lastPos[1] * (width + 3) + lastPos[0]] = 35
                score += 10
                var verified = False
                while not verified:
                    verified = True
                    randX = int(random.random_ui64(1, width))
                    randY = int(random.random_ui64(1, height))
                    for body in snake:
                        if body[].x == randX and body[].y == randY:
                            verified = False
                            break
                rows.unsafe_uint8_ptr()[randY * (width + 3) + randX] = 79
            elif collision == 45 or collision == 124 or collision == 35:
                # Game over
                rows.unsafe_uint8_ptr()[snake[0].y * (width + 3) + snake[0].x] = 35
                for _ in range(key_count):
                    print(chr(8), end="")
                print(clear, end="")
                print('score: ' + str(score) + '\n' + rows)
                exit()
            # Render the frame
            rows.unsafe_uint8_ptr()[snake[0].y * (width + 3) + snake[0].x] = 35
            for _ in range(key_count):
                print(chr(8), end="")
                key_count = 0
            print(clear, end="")
            print('score: ' + str(score) + '\n' + rows)
