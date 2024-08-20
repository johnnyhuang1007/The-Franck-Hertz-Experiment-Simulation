classdef tube < handle
    properties (Constant)
        length = 0.1;
        width = 0.002;
        wire_d = 0.001; %1mm
    end
    properties
        temp;
        atom;
        fm_path;
        U1;
        U2;
        U3;
        N = 200;
        electrons;% = electron.empty(0,N);
        precision = 6;
    end
    methods
        function this = tube(temp,atom,free_mean_path,U1,U2,U3,precision)
            this.temp = temp;   %in celsius
            this.atom = atom;
            this.U1 = U1;
            this.U2 = U2;
            this.U3 = U3;
            this.fm_path = 100*sqrt(2)*free_mean_path;

    %it will be too slow if simply use the real fmp. Different distance
    %indeed impact the result, the "shape" of tube does either. 
    %Therefore, how the temperature affect the curve is what we care about. 
            this.electrons = electron.empty(0,this.N);
            this.precision = precision;
            for k = 1:this.N
                this.electrons(k) = electron([rand*0.028-0.014 0],[0 0]); 
            end
        end
        function disp(this)
            fprintf('Tube:[\n');
            fprintf('\t temp: ');
            disp(this.temp);
            fprintf('\t atom: ');
            disp(this.atom.name);
            fprintf('\t U1: ');
            disp(this.U1);
            fprintf('\t U3: ');
            disp(this.U3);
            fprintf('\t free mean path: ');
            disp(this.fm_path);
            fprintf('\t ]\n');
        end

        function init_electrons_speed(this)
            for i = 1:this.N
                new_speed = sqrt(2*1.602*(10^-19)*this.U1/(9.109*10^-31));
                this.electrons(i).velocity(1) =this.electrons(i).velocity(1)+ new_speed;
                this.electrons(i).update_energy();
                this.electrons(i).position = [0 rand*(this.wire_d + this.width)];
                this.electrons(i).exist_time = 0;
                if this.electrons(i).velocity(1) < 0
                    this.electrons(i).kill();
                end
            end
        end

        function setU2(this,newU2)
            this.U2 = newU2;
        end

        function journey(this,i)
            U3_len = 0.02;
            pos_f = make_field(this.U2,this.length);
            rev_f = make_field(-this.U3,U3_len);
            emp_f = make_field(0,U3_len);
            
            %this.electrons(i).fast_journey(0.095,this.width,this.excited_energy,pos_f);
            
            pos_o = this.electrons(i).pos();
            pos_p = pos_o;
            F_M_P = this.fm_path;
            fm = exprnd(F_M_P);
            while this.electrons(i).pos(1) < this.length + this.wire_d/2 + U3_len
                between = 0;
                if this.electrons(i).pos(1) < this.length - this.wire_d/2
                    f = pos_f;
                elseif this.electrons(i).pos(1) > this.length + this.wire_d/2
                    f = rev_f;
                elseif this.electrons(i).pos(1) == this.length - this.wire_d/2 && this.electrons(i).velocity(1) < 0
                    f = pos_f;
                elseif this.electrons(i).pos(1) == this.length + this.wire_d/2 && this.electrons(i).velocity(1) > 0
                    f = rev_f;
                else
                    f = emp_f;
                    between = 1;
                end
                
                success = this.electrons(i).movement_detailed(pos_o,this.wire_d,this.length,fm,f);
                if success
                    this.electrons(i).collide(this.atom,this.length - this.wire_d/2);
                    pos_o = this.electrons(i).pos();
                    fm = exprnd(F_M_P);
                end
                %an electron is killed if 1. it hit on grid or 2. not
                %enough energy
                if between && this.electrons(i).pass_through_wire(pos_p,this.length,this.width,this.wire_d)
                    this.electrons(i).kill();
                    return;
                end
                
                if this.electrons(i).energy<-1*this.U3*this.electrons(i).charge && this.electrons(i).pos(1) > this.length
                    this.electrons(i).kill();
                    return;
                end

                pos_p = this.electrons(i).pos();
            end


        end

        function reset_electrons(this)
            %Child-Langmuir Law
            this.N = ceil((this.U2+this.U1)^(3/2)*this.precision);
            this.electrons = electron.empty(0,this.N);
            for k = 1:this.N
                %M_B distribution
                this.electrons(k) = electron([0.028 0],[filament_distribution() 0]);
                this.electrons(k).update_energy();
            end
        end
    end
end

