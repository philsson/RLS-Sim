Här lägger vi in alla awesome grejer för vår RLS simulering

Mappen "Script Backups" är Lua script vi modifierar i V-Rep som vi vill spara ett original utav

Default porten för V-rep (startar redan innan simuleringen är igång) är 19997

Följande filer tillhör "remoteApi". Jag är osäker på om dessa behövs
extApi.c
extApi.h
extApiInternal.h
extApiPlatform.c
extApiPlatform.h

Följande filer är matlab specifika och vissa av dessa är exempel
complexCommandTest.m
readMe - matlabApi.txt
remApi.m
remoteApiProto.m
simpleSynchronousTest.m
simpleTest.m

Följande krävs beroende på plattform.
remoteApi.dll (Windows)
remoteApi.sh (Linux)
remoteApi.dylib (OSX)