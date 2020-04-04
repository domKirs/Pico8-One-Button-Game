pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

local player = {x = 64, y = 64, di = 1, jump_counter = 0, ground = true} 
local block_list = {}
local current_block = nil

function create_block(x,y,w,h)
    return {x = x, y = y, w = w, h = h, obstacles = {}}
end

function draw_block(b,c)
    if b == nil then return end
    rect(b.x, b.y, b.x + b.w, b.y - b.h, c)

    for obs in all(b.obstacles) do
        print("*", b.x + (b.w * obs.value), b.y - 6, 8)
    end
end

function add_obstacle(b, v)
    if b == nil then return end
    add(b.obstacles, {value = v})
end

function player_jumping()
    if btnp(4) and
       player.jump_counter == 0 and
       player.ground == true
    then
        player.jump_counter = 20
        player.ground = false
    end

    local next_py = player.y

    if player.jump_counter > 0 then
        player.jump_counter -= 1
    end

    if player.jump_counter > 10 then
        next_py = player.y - 1
    end

    player.y = next_py
end

function player_apply_gravity()
    local next_py = player.y

    if player.ground == false and
       player.jump_counter <= 0 
    then
        next_py += 1
    end

    if is_inside_block(player.x, player.y, current_block) == true and
        is_inside_block(player.x, next_py, current_block) == false 
    then
        next_py = player.y
        player.ground = true
    end 

    player.y = next_py
end

function player_running()
    local next_px = player.x + player.di
    if is_inside_block(player.x, player.y, current_block) == true and
       is_inside_block(next_px, player.y, current_block) == false 
    then
        player.di = player.di * -1
        next_px = player.x + player.di
    end

    player.x = next_px

end

function player_find_new_current_block()
    if player.ground == false and 
       is_inside_block(player.x, player.y, current_block) == false 
    then
        for b in all(block_list) do
            if is_inside_block(player.x, player.y, b) == true then
                current_block = b
                break
            end
        end
    end
end

function is_inside_block(x, y, b)
    if b == nil then return end

    if x >= b.x and x < b.x + b.w and
       y <= b.y and y > b.y - b.h
    then
        return true
    end

    return false
end

function _init()
    add(block_list, create_block(16, 64, 96, 8))
    add(block_list, create_block(16, 56, 96, 8))
    add(block_list, create_block(16, 48, 96, 8))
    current_block = block_list[1]

    add_obstacle(block_list[2], 0.8)
    add_obstacle(block_list[3], 0.2)
    add_obstacle(block_list[3], 0.5)
end

function _update60()
    player_running()
    player_jumping()
    player_apply_gravity()
    player_find_new_current_block()
end

function _draw() 
    cls(0)
    print("▥", player.x-3, player.y-5, 7)
    for b in all(block_list) do 
        draw_block(b, 7)
    end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
