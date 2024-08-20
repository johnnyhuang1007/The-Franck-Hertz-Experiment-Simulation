function minimas = local_extremum_finder(Amps,U2,min_max)
    minimas = [];
    interval = U2(2) - U2(1);
    init = U2(1);

    for i = 1:length(Amps)-1
        if slope(Amps,i,i+1) < 0 && slope(Amps,i-1,i) > 0 && lower(min_max) == "max"
            minimas = [minimas init+(i-1)*interval];
        elseif slope(Amps,i,i+1) > 0 && slope(Amps,i-1,i) < 0 && lower(min_max) == "min"
            minimas = [minimas init+(i-1)*interval];
        end
    end
end

function S = slope(list,j,k)
    S = (list(j) - list(k))/(j-k);
end