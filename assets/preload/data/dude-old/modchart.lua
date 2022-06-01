-- this gets called starts when the level loads.
function start(song) -- arguments, the song name

end

-- this gets called every frame
function update(elapsed) -- arguments, how long it took to complete a frame
    if difficulty == 2 and curStep > 32 then
        -- you can just type dad, gf, boyfriend in the code and modify them from anywhere!
        dad:changeCharacter("mom") -- changes to mom at x30 and y30
    end
end

-- this gets called every beat
function beatHit(beat) -- arguments, the current beat of the song

end

-- this gets called every step
function stepHit(step) -- arguments, the current step of the song (4 steps are in a beat)

end

