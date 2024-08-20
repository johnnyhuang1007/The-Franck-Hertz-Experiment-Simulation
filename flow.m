function filename = flow(U1,max_val,U3,fmp_para,atom_name,interval,precision)
    addpath(".\include");
    addpath(".\src");
    eV = 1.602*10^-19;
    k_B = 1.38064852*10^-23;
    
    
    %fmp_para is Temp for mercury
    sigma = 2.1*10^-19;
    temp = fmp_para;
    pressure = 8.3*10^(9-3110/(273.15+temp));
    free_mean_path = (k_B*(temp+273.15))/(sigma*pressure);  

    if lower(atom_name)=="neon" || lower(atom_name)=="ne"
        %fmp_para is Torr for neon. You may use 5 torr if not sure what to use 
        %5 torr is based on "MICHIGAN TECHNOLOGICAL UNIVERSITY DEPARTMENT, MODERN PHYSICS LABORATORY"
        Pa = fmp_para * 133.322; 
         
        free_mean_path = (k_B*(25+273.15))/(pi*(275/2*10^-12)^2*Pa);%exp in room tmp
        temp = 25;
    end

    free_mean_path = free_mean_path/sqrt(2);

    Franck_Hertz = tube(temp,atom(atom_name),free_mean_path,U1,interval,U3,precision);  %constructor

    Amps = [];
    for U2 = 0.1:interval:max_val
        
        Franck_Hertz.setU2(U2);
        Franck_Hertz.reset_electrons();
        Franck_Hertz.init_electrons_speed();
        Amp = 0;
        %let all of the electrons go through the tube (journey), and
        %count the electrons that pass the cathode 
        for i = 1:length(Franck_Hertz.electrons)
            Franck_Hertz.journey(i);
            Amp = Amp + Franck_Hertz.electrons(i).eqv_charge();
        end
        Amp = Amp*12/precision;
        disp(Amp)
        disp(U2)
        Amps = [Amps Amp];
    end

    %use l-pass filter to minimize the noise
    disp(Amps)


    %write data before l-pass filter
    T = table(Amps', (0.1:interval:max_val)', 'VariableNames', {'amp', 'u2'});
    current_time = datetime('now', 'Format', 'yyyyMMdd_HHmmss');
    filename = sprintf('/data/%s.csv', current_time);
    filename = string(fullfile(pwd,filename));
    writetable(T, filename);
    
    
end