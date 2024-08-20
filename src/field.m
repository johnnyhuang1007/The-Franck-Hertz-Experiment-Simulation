function f = field(pos) %it return fx(x,y) and fy(x,y)
    fx = @(a)-200;
    fy = @(a)0;

    f = [fx(pos) , fy(pos)];
end
