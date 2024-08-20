classdef electron < handle
    properties (Constant)
        mass = 9.109*10^-31;
        eV = 1.602*10^-9;
        charge = -1.602*10^-19;
    end
    properties
        position;
        velocity;
        energy;
        Equ_quan;
        exist_time;
    end
    methods
        function this = electron(pos,vel)
            % Constructor
            if nargin > 0   %argc
                this.position = pos;
                this.velocity = vel;
            else
                this.position = [0 0];
                this.velocity = [0 0];
            end
            this.Equ_quan = 100;
            this.energy = (1/2)*this.mass*sum(this.velocity.^2);
            this.exist_time = 0;
        end
        function disp(this)
            fprintf('Electrons:[\n');
            fprintf('\t position: ');
            disp(this.position);
            fprintf('\t velocity: ');
            disp(this.velocity);
            fprintf('\t energy: ');
            disp(this.energy);
            fprintf('\t Equ_quan: ');
            disp(this.Equ_quan);
            fprintf('\t ]\n');
        end


        function success = collide(this,atom,bound)
            success = 0;
            for i = 1:length(atom.excited_energy)          %more than 1 excited energy 
                if this.energy > atom.excited_energy(i)
                    this.energy = this.energy - atom.excited_energy(i);
                    success = 1;
                    break;
                end
            end
            if this.pos(1) < bound %speed up process, the collision at acc. part is meaningless
                dir = 0;
            else
                dir = rand*2*pi;  %模擬被g2吸收
            end
            max_partial = sqrt(2*this.energy/this.mass);

            x_dir = max_partial*cos(dir);
            y_dir = max_partial*sin(dir);
            this.velocity = [x_dir y_dir];
        end

        function fast_journey(this,max_len,width,inelastic_energy,f)
            %WRONG
            a = f(this.position);
            this.energy = this.energy + max_len*a(1)*this.charge;
            while this.energy > inelastic_energy
                this.energy = this.energy - inelastic_energy;
            end
            dir = rand*pi - pi/2;
            max_partial = sqrt(2*this.energy/this.mass);
            x_dir = max_partial*cos(dir);
            y_dir = max_partial*sin(dir);
            this.velocity = [x_dir y_dir];
            this.position = [max_len rand*width];

        end
        
        function collided_on_atom = movement_detailed(this,pos_o,d,L,free_mean_path,f)

            %3 case: collide on atom, the field change(f to none or none to rev_f)
            %use root() speed up 
            a = (this.charge/this.mass)*f(this.pos());
            coef1 = [(a(1)^2)/4,this.velocity(1)*a(1),sum(this.velocity.^2)+a(1)*(this.pos(1)-pos_o(1)),2*this.velocity(1)*(this.pos(1)-pos_o(1))+2*this.velocity(2)*(this.pos(2)-pos_o(2)),(pos_o(1)-this.pos(1))^2+(pos_o(2)-this.pos(2))^2-1*free_mean_path^2];
            coef2 = [1/2*a(1),this.velocity(1),pos_o(1)-(L-d/2)];
            coef3 = [1/2*a(1),this.velocity(1),pos_o(1)-(L+d/2)];
            t = [99999999,99999999,99999999];

            t1 = roots(coef1);
            t1 = t1(imag(t1) == 0);
            if isempty(t1)  %rare error
                disp(coef1)
                disp(free_mean_path)
                disp(pos_o)
                disp(this.pos())
            end
            t1 = max(t1);
            t(1) = t1;
            
            t2 = roots(coef2);
            t2 = t2(imag(t2) == 0);
            t2 = t2(t2 > 0);
            if  ~isempty(t2)    %t2 and t3 might not have a real solution
                t2 = max(t2);
                t(2) = t2;
            end
            
            t3 = roots(coef3);
            t3 = t3(imag(t3) == 0);
            t3 = t3(t3 > 0);
            if  ~isempty(t3)
                t3 = max(t3);
                t(3) = t3;
            end
            dt = min(t);

            this.exist_time = this.exist_time + dt;
            v_org = this.velocity;
            
            displace = [(v_org(1)+(1/2)*a(1).*dt).*dt ,v_org(2).*dt ];
            this.position = this.position+displace;
            this.velocity = this.velocity + a.*dt;
            this.update_energy();

            if t1 == dt
                collided_on_atom = 1;
            else
                collided_on_atom = 0;
            end
        end

        function movement(this,free_mean_path,f)

            a = (this.charge/this.mass)*f(this.pos());
            coef = [(a(1)^2)/4,this.velocity(1)*a(1),this.velocity(1)^2 + this.velocity(2)^2,0,-1*free_mean_path^2];
            times = roots(coef);
            real_roots = times(imag(times) == 0);
            dt = max(real_roots);

            %disp(dt)
            this.exist_time = this.exist_time + dt;
            v_org = this.velocity;
            
            displace = [(v_org(1)+(1/2)*a(1).*dt).*dt ,v_org(2).*dt ];
            this.position = this.position+displace;
            this.velocity = this.velocity + a.*dt;
            this.update_energy();
        end
        function update_energy(this)
            this.energy = (1/2)*this.mass*sum(this.velocity.^2);
        end
        function val = pos(this,arg)
            if nargin == 1   %argc
                val = this.position;
            else
                val = this.position(arg);
            end
        end
        function result = pass_through_wire(this,pos_o,Loc_x,L,d)
            result = pass_through_wire(this.pos(),pos_o,Loc_x,L,d);
        end
        function kill(this)
            this.Equ_quan = 0;
        end

        function val = eqv_charge(this)
            val = -1*this.charge*this.Equ_quan;
        end
    end
end

