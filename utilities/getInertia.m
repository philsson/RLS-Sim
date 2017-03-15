[returnCode, mass]                  = vrep.simxGetStringSignal(clientID,'mass',8);
[returnCode, inertiaPacked]         =  vrep.simxGetStringSignal(clientID,'inertiaMatrix',8*9);
[returnCode, centerOfMassPacked]    = vrep.simxGetStringSignal(clientID,'centerOfMass',3*8);
inertia = vrep.simxUnpackFloats(inertiaPacked);
centerOfMass = vrep.simxUnpackFloats(centerOfMassPacked);

disp(['mass: ' num2str(mass) ' inertia: ' num2str(inertia) ' CoM: ' num2str(centerOfMass)])

% And this is how it is sent in V-rep
%   ff=simGetObjectMatrix(heli,-1)
%   mass,inertiaMatrix,centerOfMass=simGetShapeMassAndInertia(heli,ff)

%   --massData = simPackFloats(mass)
%   inertiaMatrixData = simPackFloats(inertiaMatrix)
%   centerOfMassData = simPackFloats(centerOfMass)
%   --simSetStringSignal('mass',massData)
%   simSetStringSignal('mass',mass)
%   simSetStringSignal('inertiaMatrix',inertiaMatrixData)
%   simSetStringSignal('centerOfMass',centerOfMassData)