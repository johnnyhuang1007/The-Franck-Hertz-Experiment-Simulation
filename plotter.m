function plotter(filename_list,atom)
    if lower(atom) == "hg"
        space = 4.2;
    else
        space = 16.0;
    end
    hold on;
    for i = 1:length(filename_list)
        filename = filename_list(i);
        tbl = readtable(filename);
        U2 = tbl{1:height(tbl), 2};
        Amp = tbl{1:height(tbl), 1};
        Wn = 0.4/(10/2); %cutoff_freq/(sample_rate/2)
        N = 1;
        [b, a] = butter(N, Wn, 'low');
        %noise mitigation
        mins = local_extremum_finder(filter(b, a, Amp),U2,"max",space);
        disp(filename)
        fprintf("max location: \n")
        disp(mins)
        fprintf("max difference: \n")
        disp(diff(mins))
        fprintf("average: \n")
        disp(mean(diff(mins)))
        plot(U2, filter(b, a, Amp));
    end


    xlabel('activation voltage,U2(V)');
    ylabel('total charge (C)');
    title('Franck-Hertz Experiment')
end 