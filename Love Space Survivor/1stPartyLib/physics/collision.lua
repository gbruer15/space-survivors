collision = {}

function collision.rectangles(left1,top1,width1,height1, left2,top2,width2,height2)
	collide = (left1 + width1 > left2 and left1 < left2 + width2 and top1 < top2 + height2 and top1 + height1 > top2)
	return collide
end

function collision.rectanglesOverlap(left1,top1,width1,height1, left2,top2,width2,height2)
	local yoverlap = 0
	if top1 > top2 then
		if top1 + height1 <= top2 + height2 then
			yoverlap = height1
		else
			yoverlap = top2+height2 - top1
		end
	else
		if top2 + height2 <= top1 + height1 then
			yoverlap = height2
		else
			yoverlap = top1+height1 - top2
		end 
	end

	local xoverlap = 0
	if left1 > left2 then
		if left1 + width1 <= left2 + width2 then
			xoverlap = width1
		else
			xoverlap = left2+width2 - left1
		end
	else
		if left2 + width2 <= left1 + width1 then
			xoverlap = width2
		else
			xoverlap = left1+width1 - left2
		end 
	end

	return xoverlap,yoverlap
end

function collision.rotatedRectangles(l1,t1,w1,h1,a1, l2,t2,w2,h2,a2)
	local points1 = collision.getRectanglePoints(l1,t1,w1,h1,a1)
	table.insert(points1,l1)
	table.insert(points1,t1)
	local points2 = collision.getRectanglePoints(l2,t2,w2,h2,a2)
	table.insert(points2,l2)
	table.insert(points2,t2)
	for i=1,#points1-3,2 do
		for j=1,#points2-3,2 do
			if collision.lineSegments(points1[i],points1[i+1],points1[i+2],points1[i+3],points2[i],points2[i+1],points2[i+2],points2[i+3]) then
				return true
			end
		end
	end
	
	return false -- will return false if one is completely inside the other
end

function collision.lineRectangle(ax,ay,bx,by, left,top,width,height)
	if collision.pointRectangle(ax,ay,left,top,width,height) then
		return true,ax,ay,"A in"
	elseif collision.pointRectangle(bx,by,left,top,width,height) then
		return true,bx,by,"B in"
	end
	 
	if bx == ax then
		--we've already tested if the either point is in the rectangle 
		--so this checks to see if the line is horizontally positioned correctly
		--and if the line starts above the rectangle and ends below it.
		return (ax>left and ax < left+width) and ((ay < top and by > top+height) or (ay> top+height and by<top)) ,ax,top,"vertical linex"
	else
		local m = (ay-by)/(ax-bx)
		local b = ay - m*ax
		
		local lefty = m*left+b
		if (lefty > top and lefty < top+height) and (lefty-ay)*(lefty-by)<=0 then
			return true,left,lefty,"lefty was good"
		end
		
		local righty = m*(left+width)+b
		if (righty > top and righty < top+height) and (righty-ay)*(righty-by)<=0 then
			return true,left+width,righty,"righty was good"
		end
		
		local topx = (top-b)/m
		if (topx > left and topx < left+width) and (topx-ax)*(topx-bx) <= 0 then
			return true,topx,top,"topx was good"
		end
		
		local bottomx = (top+height-b)/m
		if (bottomx > left and bottomx < left+width) and (bottomx-ax)*(bottomx-bx) <= 0 then
			return true,bottomx,top+height,"bottomx was good"
		end
	end
	return false
end

function collision.getRectanglePoints(l,t,w,h,a)
	a = a or 0
	local inA = math.atan(h/w)
	local hyp = math.sqrt(h*h+w*w)
	
	local points = {l,t}
	points[3],points[4] = points[1]+w*math.cos(a),points[2]+w*math.sin(a)
	points[5],points[6] = points[1]+hyp*math.cos(a+inA),points[2]+hyp*math.sin(a+inA)
	points[7],points[8] = points[1]-h*math.cos(-a+math.pi/2),points[2]+h*math.sin(-a+math.pi/2)
	return points
end


collision.direction = {}
function collision.direction.rectangles1(left1,top1,width1,height1,xspeed1,yspeed1, left2,top2,width2,height2,xspeed2,yspeed2)
	
	--[
	if (left1 >= left2 + width2 and left1 + width1 >= left2 + width2) then
		return "right"
	elseif (left1 <= left2  and left1 + width1 <= left2) then
		return "left"
	elseif (top1 <= top2 and top1 + height1 <= top2)  then
		return "top"
	elseif (top1 >= top2 + height2 and top1 + height1 >= top2 + height2)  then
		return "bottom"
	end	
	--]]
end

function collision.direction.rectangles2(left1,top1,width1,height1,xspeed1,yspeed1, left2,top2,width2,height2,xspeed2,yspeed2)
	--local xoverlap,yoverlap = collision.rectanglesOverlap(left1,top1,width1,height1,left2,top2,width2,height2)
	--[
	local relxspeed = xspeed1-xspeed2
	local relyspeed = yspeed1-yspeed2
	local xoverlap,yoverlap
	if relxspeed > 0 then
		xoverlap = left1+width1-left2
	else
		xoverlap = left2+width2-left1
	end

	if relyspeed > 0 then
		yoverlap = top1+height1-top2
	else
		yoverlap = top2+height2-top1
	end

	local xtime = math.abs(xoverlap/relxspeed)
	local ytime = math.abs(yoverlap/relyspeed)
	
	if xtime < ytime then --it's an x direction collision
		if relxspeed > 0 then
			return 'left'
		elseif relxspeed < 0 then
			return 'right'
		end
	elseif ytime < xtime then  --it's a y direction collision
		if relyspeed > 0 then
			return 'top'
		elseif relyspeed < 0 then
			return 'bottom'
		end
	end

	--]]
end

function collision.direction.pointRectangle(px,py,pxspeed,pyspeed, left,top,width,height,xspeed,yspeed) 
	
	local relxspeed = pxspeed-xspeed
	local relyspeed = pyspeed-yspeed

	if relxspeed > 0 then
		xoverlap = px-left
	else
		xoverlap = left+width-px
	end

	if relyspeed > 0 then
		yoverlap = py-top
	else
		yoverlap = top+height-py
	end

	local xtime = math.abs(xoverlap/relxspeed)
	local ytime = math.abs(yoverlap/relyspeed)
	
	if xtime < ytime then --it's an x direction collision
		if relxspeed > 0 then
			return 'left'
		else
			return 'right'
		end
	else  --it's a y direction collision
		if relyspeed > 0 then
			return 'top'
		else
			return 'bottom'
		end
	end
end

function collision.circles(centerx1,centery1,radius1, centerx2,centery2,radius2)
	return (  ( ((centerx1-centerx2)^2) + ((centery1-centery2)^2) )^0.5 < (radius1 + radius2) )
end

function collision.rectangleCircle(left1,top1,width1,height1, centerx2,centery2,radius2) 
--Just an approximation
	return collision.rectangles(left1,top1,width1,height1, centerx2-radius2,centery2-radius2, radius2*2, radius2*2)
end

function collision.pointRectangle(x,y,  left,top,width,height)
	return (x < left+width and x > left and y > top and y < top + height)
end

function collision.pointCircle(x,y, centerx,centery,radius)
	return    (x-centerx)^2 + (y-centery)^2 < radius*radius 
end

--ax,ay,bx,by define a line, while ox, oy,px,py define a line segment
function collision.lineLineSegment(ax,ay,bx,by,  ox,oy,px,py)
  local a = {X = ax, Y = ay}  
  local b = {X = bx, Y = by}
  local c = {X = ox, Y = oy}
  local d = {X = px, Y = py}

  local denominator = ((b.X - a.X) * (d.Y - c.Y)) - ((b.Y - a.Y) * (d.X - c.X));
  local  numerator1 = ((a.Y - c.Y) * (d.X - c.X)) - ((a.X - c.X) * (d.Y - c.Y));
  local  numerator2 = ((a.Y - c.Y) * (b.X - a.X)) - ((a.X - c.X) * (b.Y - a.Y));
	
  -- check for parallel lines	
  if (denominator == 0) then return numerator1 == 0 and numerator2 == 0, bx,by end

  local r = numerator1 / denominator;
  local s = numerator2 / denominator;

  return (s >= 0 and s <= 1), ox + s*(px-ox), oy + s*(py-oy)
end

function collision.lineSegments(ax,ay,bx,by,  ox,oy,px,py)
  local a = {X = ax, Y = ay}  
  local b = {X = bx, Y = by}
  local c = {X = ox, Y = oy}
  local d = {X = px, Y = py}

  local denominator = ((b.X - a.X) * (d.Y - c.Y)) - ((b.Y - a.Y) * (d.X - c.X));
  local  numerator1 = ((a.Y - c.Y) * (d.X - c.X)) - ((a.X - c.X) * (d.Y - c.Y));
  local  numerator2 = ((a.Y - c.Y) * (b.X - a.X)) - ((a.X - c.X) * (b.Y - a.Y));

  -- Detect parallel lines 
  if (denominator == 0) then
  	 if numerator1 ~= 0 or numerator2 ~= 0 then
  		return false, bx,by 
  	end
  	--else the line segments are coincident. need to do something special
  	local ro
  	if bx ~= ax then
  		ro = (ox - ax)/(bx-ax)
  	else
  		ro = (oy - ay)/(by-ay)
  	end
  	local rp
  	if bx ~= ax then
  		rp = (px - ax)/(bx-ax)
  	else
  		rp = (py - ay)/(by-ay)
  	end

  	if (1 > ro and 0 < rp) or (1 > rp and 0 < ro) then
  		local r = math.constrain(ro, 0, 1)
  		return true, ax + r*(ax-ax), ay + r*(ay-ay)
  	end

  	return false
  end

  local r = numerator1 / denominator;
  local s = numerator2 / denominator;

  return (r >= 0 and r <= 1) and (s >= 0 and s <= 1), ox + s*(px-ox), oy + s*(py-oy)
end

--ax,ay,bx,by define a ray starting at ax,ay and passing through bx,by. ox,oy,px,py define line segment
function collision.rayLineSegment(ax,ay,bx,by,  ox,oy,px,py, debug, i)
	local col, solux, soluy = collision.lineLineSegment(ax,ay,bx,by,  ox,oy,px,py)

	--return false if solux is not in direction of bx
	return (col and math.getSign(solux-ax) == math.getSign(bx-ax))
end

function collision.polygons(array1,array2)
	local i = 1
	for i=1,#array1-3,2 do
		for n=1,#array2-3,2  do
			if collision.lineSegments(array1[i],array1[i+1],array1[i+2], array1[i+3], array2[n],array2[n+1],array2[n+2], array2[n+3]) then
				return true
			end
		end

		--check line from first point to last point
		if collision.lineSegments(array1[i],array1[i+1],array1[i+2], array1[i+3], array2[1],array2[2],array2[#array2-1], array2[#array2]) then
			return true
		end
	end

	--check line from first point to last point
	for n=1,#array2-3,2  do
		if collision.lineSegments(array1[1],array1[2],array1[#array1-1], array1[#array1], array2[n],array2[n+1],array2[n+2], array2[n+3]) then
			return true
		end
	end



	for i=1,#array1-1,2 do
		if collision.pointPolygon(array1[i],array1[i+1], array2) then
			return true
		end
	end

	for i=1,#array2-1,2 do
		if collision.pointPolygon(array2[i],array2[i+1], array1) then
			return true
		end
	end
	return false
end
function collision.getBoundingBox(array)
	local left = array[1]
	local right = array[1]
	local top = array[2]
	local bottom = array[2] 
	local odd = true
	for i,v in pairs(array) do
		if odd then
			if v < left then
				left = v
			elseif v > right then
				right = v
			end
		else
			if v < top then
				top = v
			elseif v > bottom then
				bottom = v
			end
		end
		odd = not odd
	end
	
	return left, top, right-left, bottom-top
end

function collision.pointArc(x,y,a,b,r,a1,a2)
	if not collision.pointCircle(x,y,a,b,r) then
		return false
	end
	local angle = math.atan2(y-b,x-a)
	return angle > a1 and angle < a2, angle
end

function collision.pointPolygon(x,y,points, debug)
	--count the number of polygon edge collisions with an arbitrary ray
	if #points % 2 ~= 0 then
		error('missing half a point')
	end

	local count = 0

	for i=3,#points-1,2 do
		if collision.rayLineSegment(x,y,x+5,y+5, points[i-2],points[i-1], points[i],points[i+1], debug, i) then
			count = count + 1
		end
	end

	local n = #points
	if collision.rayLineSegment(x,y, x+5,y+5 , points[1],points[2], points[n-1],points[n], debug, n-1) then
		count = count + 1
	end

	--the # of intersections will be odd if it's inside the polygon
	return count%2 ~= 0
end