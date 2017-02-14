-- Check the end of the script for some explanations!

if (sim_call_type==sim_childscriptcall_initialization) then
    modelBase=simGetObjectAssociatedWithScript(sim_handle_self)
    ref=simGetObjectHandle('GyroSensor_reference')
    ui=simGetUIHandle('GyroSensor_UI')
    simSetUIButtonLabel(ui,0,simGetObjectName(modelBase))
    gyroCommunicationTube=simTubeOpen(0,'gyroData'..simGetNameSuffix(nil),1)
    oldTransformationMatrix=simGetObjectMatrix(ref,-1)
    lastTime=simGetSimulationTime()
end

if (sim_call_type==sim_childscriptcall_cleanup) then

end

if (sim_call_type==sim_childscriptcall_sensing) then
    local transformationMatrix=simGetObjectMatrix(ref,-1)
    local oldInverse=simGetInvertedMatrix(oldTransformationMatrix)
    local m=simMultiplyMatrices(oldInverse,transformationMatrix)
    local euler=simGetEulerAnglesFromMatrix(m)
    local currentTime=simGetSimulationTime()
    local gyroData={0,0,0}
    local dt=currentTime-lastTime
    if (dt~=0) then
        gyroData[1]=euler[1]/dt
        gyroData[2]=euler[2]/dt
        gyroData[3]=euler[3]/dt
    end
    simTubeWrite(gyroCommunicationTube,simPackFloats(gyroData))
    simSetUIButtonLabel(ui,3,string.format("X-Gyro: %.4f",gyroData[1]))
    simSetUIButtonLabel(ui,4,string.format("Y-Gyro: %.4f",gyroData[2]))
    simSetUIButtonLabel(ui,5,string.format("Z-Gyro: %.4f",gyroData[3]))
    oldTransformationMatrix=simCopyMatrix(transformationMatrix)
    lastTime=currentTime


    -- To read data from this gyro sensor in another script, use following code:
    --
    -- gyroCommunicationTube=simTubeOpen(0,'gyroData'..simGetNameSuffix(nil),1) -- put this in the initialization phase
    -- data=simTubeRead(gyroCommunicationTube)
    -- if (data) then
    --     angularVariations=simUnpackFloats(data)
    -- end
    --
    -- If the script in which you read the gyro sensor has a different suffix than the gyro suffix,
    -- then you will have to slightly adjust the code, e.g.:
    -- gyroCommunicationTube=simTubeOpen(0,'gyroData#') -- if the gyro script has no suffix
    -- or
    -- gyroCommunicationTube=simTubeOpen(0,'gyroData#0') -- if the gyro script has a suffix 0
    -- or
    -- gyroCommunicationTube=simTubeOpen(0,'gyroData#1') -- if the gyro script has a suffix 1
    -- etc.
    --
    --
    -- You can of course also use global variables (not elegant and not scalable), e.g.:
    -- In the gyro script:
    -- simSetFloatSignal('gyroX',angularVariation[1])
    -- simSetFloatSignal('gyroY',angularVariation[2])
    -- simSetFloatSignal('gyroZ',angularVariation[3])
    --
    -- And in the script that needs the data:
    -- angularVariationX=simGetFloatSignal('gyroX')
    -- angularVariationY=simGetFloatSignal('gyroY')
    -- angularVariationZ=simGetFloatSignal('gyroZ')
    --
    -- In addition to that, there are many other ways to have 2 scripts exchange data. Check the documentation for more details
end
