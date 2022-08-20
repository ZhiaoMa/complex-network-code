function [shortestPath, totalCost] = dijkstra(netCostMatrix, s, d)
n = size(netCostMatrix,1);
for i = 1:n
    farthestPrevHop(i) = i; 
    farthestNextHop(i) = i;
end
visited(1:n) = false;
distance(1:n) = inf;    
parent(1:n) = 0;
distance(s) = 0;
for i = 1:(n-1),
    temp = [];
    for h = 1:n,
        if ~visited(h)  
            temp=[temp distance(h)];
        else
            temp=[temp inf];
        end
    end;
    [t, u] = min(temp);     
    visited(u) = true;         
    for v = 1:n,  
        if ( ( netCostMatrix(u, v) + distance(u)) < distance(v) )
            distance(v) = distance(u) + netCostMatrix(u, v); 
            parent(v) = u;  
        end;
    end;
end;

shortestPath = [];
if parent(d) ~= 0 
    t = d;
    shortestPath = [d];
    while t ~= s
        p = parent(t);
        shortestPath = [p shortestPath];        
        if netCostMatrix(t, farthestPrevHop(t)) < netCostMatrix(t, p)
            farthestPrevHop(t) = p;
        end;
        if netCostMatrix(p, farthestNextHop(p)) < netCostMatrix(p, t)
            farthestNextHop(p) = t;
        end;        
        t = p;
    end;
end;
totalCost = distance(d);