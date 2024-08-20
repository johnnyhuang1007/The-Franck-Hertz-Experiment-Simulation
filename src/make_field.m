function f = make_field(U2,dist)
    fx = @(a)-(U2/dist);
    fy = @(a)0;
    f = @(pos)[fx(pos), fy(pos)];
end