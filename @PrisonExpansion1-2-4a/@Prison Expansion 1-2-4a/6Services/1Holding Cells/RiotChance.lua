math.randomseed(os.time())
-- Creates a seed for RNG


function script:daily(x, y)

if math.random (0, 10000000)<=DL*100000 then

City.issueDisaster(City.DISASTER_RIOT, x + 1, y)
City.issueDisaster(City.DISASTER_RIOT, x - 1, y)
City.issueDisaster(City.DISASTER_RIOT, x, y + 1)
City.issueDisaster(City.DISASTER_RIOT, x, y - 1)

end
end
