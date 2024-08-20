classdef atom < handle  
    %free mean path 交給tube處理，這邊負責excited energy
    properties
        name = "Hg";
        excited_energy = [4.86*1.602*10^(-19)];
    end
    methods
        function this = atom(name)
            if lower(name) == "neon"
                this.name = name;
                list = 1.602*10^(-19)*[16.703 16.6595 16.836 18.369 18.6986 18.5425 18.5632 18.59999 18.624 18.6806 18.6913 18.5897 18.95298 19.65066 19.6747 19.747 19.7663 20.0109 20.0128 20.021 20.0212 20.023 20.0267 20.034];
                this.excited_energy = sort(list,'descend');
            end
        end
    end
end