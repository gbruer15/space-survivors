



function math.getSign(n)
	if n > 0 then
		return 1
	elseif n < 0 then
		return -1
	else
		return 0
	end
end

function math.round(x,n)
	local a =  math.floor(x/n)
	if x/n - a < 0.5 then
		return a * n
	end
	return n*a + n
end

function math.constrain(n,min,max)
	if max < min then
		max,min = min,max
	end
	return math.min(max,math.max(n,min))
end

function math.randomSign()
	return math.random(0,1)*2-1
end