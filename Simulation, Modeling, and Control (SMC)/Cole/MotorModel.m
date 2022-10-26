function [U] = MotorModel(U_bar)
    persistent UbarOld;
    persistent Uncert;
    global includeUncertainty;
    global sigmaSteering;
    global sigmaDrive;
    global driveTable;
    global steerTable;
    
    driveCurve = U_bar(1);
    steerCurve = rad2deg(U_bar(2));
    
    driveTable = [77, 0.9; 78 1.1; 79 1.5; 80 1.9];
    steerTable = [75, 84; 76, 86];
    driveCurvePWM = [];
    steerCurvePWM = [];
    
    for i = 1:size(driveTable, 1)
        if(isempty(driveCurvePWM) && driveCurve >= 0.9 * driveTable(i, 2) && driveCurve <= 1.1 * driveTable(i, 2))
            U(1) = driveTable(i,2) % set the velocity to a possible velocity based on curve
            driveCurvePWM = driveTable(i,1) % output corresponding PWM
        end
    end
    
%     for i = 1:size(steerTable, 1)
%         if(isempty(steerCurvePWM) && steerCurve >= 0.9 * steerTable(i, 2) && steerCurve <= 1.1 * steerTable(i, 2))
%             U(2) = deg2rad(steerTable(i,2)); % set the velocity to a possible velocity based on curve
%             steerCurvePWM = driveTable(i,1); % output corresponding PWM
%         end
%     end

    steerCurvePWM = (steerCurve-214)/-2.8
     if(steerCurvePWM < 64)
            steerCurvePWM = 65;
        elseif(steerCurvePWM > 91)
            steerCurvePWM = 90;
        end
    U(2) = deg2rad(steerCurve);

   
    if(isempty(driveCurvePWM))
        driveCurvePWM = 80;
        U(1) = U_bar(1);
    end
    
    if(isempty(steerCurvePWM))
        steerCurvePWM = 74;
        U(2) = U_bar(2);
    end
end