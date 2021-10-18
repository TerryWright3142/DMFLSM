disp('STARTING SLAVE CONTROLLER ******************************');
disp('RUN AFTER SLAVE*************************************');
disp('*****************************************************');


addpath('..\');
addpath('..\..\ALPAO_DM');
addpath('..\..\NEWPORT_ESP_100');
addpath('..\..\MISC_CLASSES\SURFACES');
dllFolder = 'C:\Users\BHFuser\Desktop\Terry_Matlab_Equipment_Code\ORCA_FLASH\6_MUTEX DLL\';
winDLL = 'win_mutex';
headerFolder = 'C:\Users\BHFuser\Desktop\Terry_Matlab_Equipment_Code\ORCA_FLASH\3_VS DLL Code\samples\cpp\init_uninit\win_mutex\';
header = 'win_mutex.h';
loadlibrary([dllFolder, winDLL], [headerFolder,  header], 'alias', winDLL);  
libfunctions(winDLL); %lists out functions available in the dll
calllib(winDLL, 'Win_InitSpeechEngine');

Speak('Stage control program. This program will read the config.xml file.');
disp('INIT LIBRARIES');
%
disp('HOME STAGE');
Speak('In order to home the stage well away from the lens so that it does not crash');
Speak('Enter any number once stage in acceptable position');
input('Enter any number when ready stage adjusted ');
%
disp('INIT STAGE');
stage = Newport_ESP100();
comPort = 12;
stage.Init(comPort);
fprintf('STAGE at start position %d \n', stage.GetPositionAbs() );
stage.SetMaxVelocity(0.02);
stage.AbsMoveSynch(5);
fprintf('STAGE at mid position %d \n', stage.GetPositionAbs() );
Speak('Homing finished, now use HCI to adjust the focus onto the slide');
disp('STAGE HOMED');
%
disp('Homing finished, now use HCI to focus the system on the slide - this will be the zero position');
Speak('Enter any number when ready to continue.');
input('Enter any number when ready to continue ');

szFolder = ['.\'];
mkdir(szFolder);
%Speak('Starting stage loop.');
curStagePos = (stage.GetPositionAbs()- 5)*1000;
%
while true
    
    xmlSz = fileread([szFolder 'stage_config.xml']);
    szList = ["stagePosition"];
    szList1 = zeros(size(szList));
    for f = 1:numel(szList)
        cac = regexp(xmlSz, ['<' char(szList(f)) '>([+-]?\d+\.?\d*)'], 'tokens');
        szList1(f) = str2num(char(cac{1}));
    end
    stagePosition = szList1(1);
    if curStagePos ~= stagePosition
        %move the stage
                stage.AbsMoveSynch((stagePosition )/1000 + 5 - 0.1);
                stage.AbsMoveSynch((stagePosition )/1000 + 5 ); 
                curStagePos = stagePosition;
                if curStagePos >= 0
                    Speak(['Stage moved to ' num2str(abs(curStagePos)) ' microns from focus']);
                else
                    Speak(['Stage moved to minus ' num2str(abs(curStagePos)) ' microns from focus']);
                end
                fprintf('STAGE MOVED TO %d \n', curStagePos);
                  
    end
    pause(2);
    
end


%%
stage.Shutdown();

calllib(winDLL, 'Win_ShutdownSpeechEngine');
unloadlibrary(winDLL);