function result = pass_through_wire(pos,pos_o,Loc_x,L,d)
    top_half = [Loc_x, L+d];
    buttom_half = [Loc_x,0];
    
    Pos = pos;
    Pos(1) = Pos(1)+(L+d)*1000000;
    pos_modified = mod(Pos(1),L+d);
    dy = Pos(1) - pos_modified;
    Pos_o = pos_o;
    Pos_o(1) = Pos_o(1)+(L+d)*1000000 - dy;
    a = (Pos_o(2) - Pos(2))/(Pos_o(1) - Pos(1));
    b = -1;
    c = Pos(2)-a*Pos(1);
    coef = [a,b,c];

    if distance(coef,top_half) <= (d/2)
        result = 1;
        return;
    end
    if distance(coef,buttom_half) <= (d/2)
        result = 1;
        return;
    end
    result = 0;
end

function dist = distance(coef,p)
    dist = abs(coef(1)*p(1)+coef(2)*p(2)+coef(3))/abs(sqrt(coef(1)^2 + coef(2)*coef(2)));
end