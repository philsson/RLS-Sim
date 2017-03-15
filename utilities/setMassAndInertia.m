function [ returnCode ] = setMassAndInertia( clientID, mass_multiplier, inertia )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    global vrep;
    
    % Original settings
    % setMassAndInertia(clientID, 0.11999999731779,[8e-06 0.000904 0.000904]);
    
    original_mass = 0.12;
    original_inertia = [8e-06 0.000904 0.000904];
    
    for i=1:3
        inertia(i) = original_inertia(i) * inertia(i);
    end
    
    inertia = [inertia(1) 0 0 0 inertia(2) 0 0 0 inertia(3)];
    mni_single = single([inertia(1:end),original_mass*mass_multiplier]);
    mniPacked = vrep.simxPackFloats(mni_single);
    returnCode = vrep.simxSetStringSignal(clientID,'mni',mniPacked,8*10);


end

% V-rep code below

 % Init part %
 %   mass = 0
 %   inertia = {0,0,0,0,0,0,0,0,0}
 %   h=simGetObjectAssociatedWithScript(sim_handle_self)
    
 % Run part %
 %   MnI=simGetStringSignal('mni')
 %   simClearStringSignal('mni')
 %   if MnI ~=nil then
 %       unpacked_data=simUnpackFloats(MnI)
 %       mass = unpacked_data[10]
 %       for i=1,9,1 do
 %           inertia[i] = unpacked_data[i]
 %       end
 %       -- set mass and inertia
 %       simSetShapeMassAndInertia(h,0.1,{0.001,0,0,0,0.001,0,0,0,0.001},centerOfMass,nil)
 %   end
