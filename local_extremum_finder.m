function minimas = local_extremum_finder(Amps,U2,min_max,min_diff)
    minimas = [];
    interval = U2(2) - U2(1);
    init = U2(1);
    range = ceil(length(U2)/20);
    for i = range:length(Amps)-range
        if isempty(minimas)
            val = 0;
        else
            val = minimas(length(minimas));
        end
        if init+(i-1)*interval - val < min_diff
            continue;
        end
        if slope(Amps,i,i+range) < 0 && slope(Amps,i-range,i) > 0 && lower(min_max) == "max"
            minimas = [minimas init+(i-1)*interval];
        elseif slope(Amps,i,i+range) > 0 && slope(Amps,i-range,i) < 0 && lower(min_max) == "min"
            minimas = [minimas init+(i-1)*interval];
        end
    end
end

function S = slope(list,j,k)
    S = (list(j) - list(k))/(j-k);
end