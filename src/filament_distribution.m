function value = filament_distribution()
    h = 6.626*10^(-34);
    k_B = 1.3806*10^(-23);
    T = 800;
    Qe = 1.602*10^(-19);
    Ef = 4.5*Qe;
    m = 9.109*10^-31;
    n = @(E) exp(-1*(E.^2)*m/(2*k_B*T));
    random_samples = filament_rand(n, 1);
    value = random_samples(1);
end

function samples = filament_rand(n, num_samples)
    Qe = 1.602*10^(-19);
    max_val = 1500000; 
    max_n = max(n(linspace(0, max_val, 10000))); 
    samples = zeros(num_samples, 1);
    count = 1;
    while count <= num_samples  %ACCEPT/DENIAL ALGO 
        E = max_val * rand();
        if rand() < n(E) / max_n
            samples(count) = E;
            count = count + 1;
        end
    end
end