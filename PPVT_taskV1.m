%**************************************************************************
% PPVT- 4a 4way rand
% Created by Alyse Brown, Jan 2020
% each trial the image locations are randimised
% accept numbers (1-4) as keypress
%
% Get (and set) information about a window or screen:

% PPVT will quit if 7+ errors occur in one set
% PPVT states that partipants must get all of the first set right
% to be valid. task will run all the way through a then at the end tell you if you need 
% to run a earlier set. Message "Take a short break" will appear, 
% Run task again and code Y=1 for run time 2, this should also create a new filename   

%Note: The var Finish on the sencond run might need changing if you think they need to 
%go back more than one set see ie Finish= 12 to Finish = 24 to run through 2 sets 
% See line 108

%**************************************************************************

%% Important things to do before we start:
% Clear all old variables, globals, functions and MEX links,
clear all; close all; clc;
%Screen('Preference','SkipSyncTests',1); % com this out

% Define global variables

global p wptr exp_dir

% PsychDefaultSetup(2);
% [window, windowRect] = PsychImaging(OpenWindow', screenNumber, grey)
% %rect =Screen('rect', window)
% [screenXpixels, screenYpixels] = Screen('WindowSize', window)


%% Make sure psychtoolbox is working properly;
% break and issue an eror message if the installed Psychtoolbox is not based
% on OpenGL or if Screen() is not working properly.
AssertOpenGL;
% Use a (mostly) shared name mapping for the keys. This makes sure that at
% least the names of special keys like cursor keys, function keys and
% such will be shared between the operating systems. This is useful if you
% run your code on a different operating system from the one you wrote it on.
KbName('UnifyKeyNames')
%% Initialise Sound
    % Perform basic initialisation of the sound driver
   
InitializePsychSound
%  nrchannels = 2;
%  pnhandle = PsychPortAudio('Open', [], [], 3, nrchannels);


    
    
% %%Load in the sound 
% bing = audioread('insight.mp3');
% bing = bing(:,1);
% 
% PyschPortAudio('FillBuffer',[bing';zeros(1,size(bing,1))]);

%set some vars for later
setcount = 0 ;    
error_count = 0;   


% Get experiment directory
%exp_dir = fileparts(mfilename('fullpath'));
exp_dir = 'C:\Users\ab11\Desktop\PPVT\PPVT_task';
exp_dir = 'C:\Users\train15user\Desktop\N400_ASD2020\PPVT';
% Add the experiment directory to matlab path
addpath(genpath(exp_dir));

% Check if there's a data folder. If not, we make one.
% if exist([exp_dir,filesep,'Data'],'dir') ~= 7
%     mkdir(exp_dir,'Data')
% end
% Swith to the data folder so we can save our output there.
datdir = [exp_dir,filesep,'Data'];

% Generate random numbers that are different each time: all the random
% number functions draw values from a shared random number generator,
% which resets itself to the same state every time you restart MATLAB
% or the script/function. This can be prevented by initializing the
% generator using a different seed every time (in this case, the clock is
% our seed).
rng('default');
rng('shuffle');
p.seed_rng = rng;

%% define the number of trials per set
ntrialsSet=12;

%% Get subject information
% % We can use  inputdlg (input dialog box) to get a window where we can fill
% % in the subject information
prompt = {'Please enter the participant number:'};
rsp = inputdlg(prompt,'Experimental setup information');
% What is the subject number?
subj_id = str2double(rsp{1});


% what set to start on
prompt = {'Enter the set you would like to start on'};
rsp = inputdlg(prompt,'Experimental setup information');
% What is the subject number?
start_set = str2double(rsp{1});
moving_start_set = start_set;

% what set to start on
prompt = {'Is this your second run through Y=1, N=0'};
rsp = inputdlg(prompt,'Experimental setup information');
% What is the subject number?
run_time2 = str2double(rsp{1});
if run_time2 == 1
    save_T2 = 'T2';
  prompt = {'how many sets back?'};
  rsp = inputdlg(prompt,'Experimental setup information');
  back_sets = str2double(rsp{1});
else
   save_T2 = ' '; 
end

    
% Make a name for the output file containing the subject information
%fn = {num2str(subj_id,'S%02d'),num2str(session,'Session%02d'),'Semantic_Congruency'};
%fn = {num2str(subj_id,'S%02d'), num2str(start_set, 'S%02d'),'PPVT_4a'};
fn = {num2str(subj_id,'S%02d'),num2str(save_T2,'S%02d'),'PPVT_4a'};
file_name = fullfile(datdir, [sprintf('%s_',fn{1:end-1}), fn{end}]);

%% Check if file name has already been used
% If so, we ask if it is ok to overwrite the existing file
if exist([file_name,'.csv'],'file') > 0
    disp('WARNING! File name has already been used!');
    query = input('Do you want to OVERWRITE the existing file?  y or n(default)?','s');
    if query(1) ~= 'y'
        error('Exiting program...');
    end
end

%% Get parameters & stimulus conditions
% Get screen number
% Get the list of screens and choose the one with the highest screen number.
% Screen 0 is, by definition, the display with the menu bar.
p.screen_nr = max(Screen('Screens'));

% Define parameters computer
p.distance = 60;
p.screen_width_cm = 34.544;     % Define the screen width in cm
p.screen_height_cm = 19.304;    % Define the screen height in cm

% Set the presented image size (original = 1109 x 1516 pix)
p.im_width =  505%
p.im_height = 370%

% Set the presented background size (original = 1109 x 1516 pix)
p.BG_width = 600%842% 616;%1010;
p.BG_height = 450%616%842;


% Define colours
% Find the color values which correspond to white and black
p.white = WhiteIndex(p.screen_nr);
p.black = BlackIndex(p.screen_nr);
p.background = p.white;



%% Load in the stimulus conditions

[item_num] = xlsread([exp_dir,filesep,'task_info','.xlsx']);
p.num_trials = size(item_num,1);
% Make a stimulus matrix
p.stimulus = zeros(p.num_trials,2);
% Column 1: Target image (Target image is coded by numbered folder[1 2 3 4])
p.stimulus(:,1) = item_num(:,2);
% Column 2: Set numbers
p.stimulus(:,2) = item_num(:,3);
% Column 3: Starting trial of sets
p.stimulus(:,3) = item_num(:,4);


%% Open window and store its height and width
try
 %[wptr,wrect] = Screen('OpenWindow',p.screen_nr,p.background,[0 0 720 768]);
   %%% [wptr,wrect] = Screen('OpenWindow',p.screen_nr,p.background,[0 0 1000 1000]);
   %%%  [wptr, wrect] = Screen('OpenWindow', p.screen_nr,p.background);
 [wptr, wrect] = Screen('OpenWindow', p.screen_nr); %full screen
    [p.screen_width_pix,p.screen_height_pix] = Screen('WindowSize',p.screen_nr);
    
    % Get the flip interval
    p.FR = Screen('NominalFrameRate',wptr);
    if p.FR == 0
        p.FI = Screen('GetFlipInterval',wptr);
    else
        p.FI = 1/p.FR;
    end
    
    % Make sure we can show images with a transparant background, by
    % allowing alpha blending
    Screen('BlendFunction',wptr,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');
    % allColors = [1 0 0 1; 0 1 0 1; 0 0 1 0.5]
    
    %% Calculate pixels per degree
    pix_per_deg(1,1) = p.screen_width_pix/(atan(p.screen_width_cm/2/p.distance)*180/pi*2);
    pix_per_deg(1,2) = p.screen_height_pix/(atan(p.screen_height_cm/2/p.distance)*180/pi*2);
    p.pix_per_deg = mean(pix_per_deg);
    
    
    %% Get a destination rect for the images
    
    % Making 4 stimulus locations Top Left, Top Right, Bottom Left Bottom Right([300,200],([300,-250]
    
    % Top Left
    loc1 = repmat([-300,-250],[1,2]);
    p.dest_loc(1,:) = [p.screen_width_pix/2-p.im_width/2,p.screen_height_pix/2-p.im_height/2,...
        p.screen_width_pix/2+p.im_width/2,p.screen_height_pix/2+p.im_height/2]+loc1;
    % Top right
    loc2 = repmat([300,-250],[1,2]);
    p.dest_loc(2,:) = [p.screen_width_pix/2-p.im_width/2,p.screen_height_pix/2-p.im_height/2,...
        p.screen_width_pix/2+p.im_width/2,p.screen_height_pix/2+p.im_height/2]+loc2;
    % Bottom left
    loc3 = repmat([-300,200],[1,2]);
    p.dest_loc(3,:) = [p.screen_width_pix/2-p.im_width/2,p.screen_height_pix/2-p.im_height/2,...
        p.screen_width_pix/2+p.im_width/2,p.screen_height_pix/2+p.im_height/2]+loc3;
    % Bottom right
    loc4 = repmat([300,200],[1,2]);
    p.dest_loc(4,:) = [p.screen_width_pix/2-p.im_width/2,p.screen_height_pix/2-p.im_height/2,...
        p.screen_width_pix/2+p.im_width/2,p.screen_height_pix/2+p.im_height/2]+loc4;
    
    % background
    p.dest_rect_background = [p.screen_width_pix/2-p.BG_width,p.screen_height_pix/2-p.BG_height,...
        p.screen_width_pix/2+p.BG_width,p.screen_height_pix/2+p.BG_height];
    
    
    
    
    %% Initialise response vector
    d.data = zeros(p.num_trials,12);
    d.data(:,1) = 1:p.num_trials;
    d.data(:,2:4) = p.stimulus; %Target and set number
    
    %% Save data
    % Save matlab file
    save(file_name)
    
    % Open csv file to store the data in
    var_names = 'Trial, set_num, Starting_Set, Correct/incorrect, End_Set';
    data_file_name = [file_name,'.csv'];
    fileID = fopen(data_file_name,'w');
    fprintf(fileID,'%s\n',var_names);
    fclose(fileID);
    
    %% Load in the background images
    
    % background with black lines and numbers 1 to 4
    I = imread(fullfile(exp_dir,'items','background_layer.jpg'));
    image_background = Screen('MakeTexture', wptr, I);
    
    
    

    
    
    
    
    %% Run experiment
    % HideCursor;
    ListenChar(2); %2stops keys %this stops keyboard inputs to matlab
    
    % Show start screen
    
    Screen('TextFont',wptr,'Helvetica');
    Screen('TextSize',wptr,20);
    DrawFormattedText(wptr,'Press any key to start','center','center');
    Screen('Flip',wptr);
    exp_start = KbWait();
    %exp_start=1;
    
    
    % Establish where the trials should start
    start = find(start_set==p.stimulus(:,3)); 
   % Establish where the trials should finish if    
if run_time2 == 1
    finish = start + (12* back_sets);
else 
    finish = p.num_trials;
end   
    
    %%% start of experiment loop
    finished=0; %we haven't finished the experiment yet
    while ~finished %keep doing the experiment until you get the signal to quit
        
        % Start experiment loop
        trialcounter=0; %start counting how many trials they've done
        for trial_num = start:finish %p.num_trials %
            trialcounter=trialcounter+1;
            
            %AW 5/8/20 add a wait for 1s at the start of each trial except
            %the first trial
            if trialcounter>1
                Screen('Flip',wptr); %clear screen
                WaitSecs(1); % wait 1s
            end
            
            %what is the target on this trial?
            Target_thisTrial = p.stimulus(trial_num,1);
            
            % semi rand the image locations
            trial_locations = randperm(4); % this randomises numbers 1 to 4
            
            %record the location of the target on this trial
            target_locations(trial_num) = trial_locations(:,Target_thisTrial);
            
            %check whether that was the target location on the last two
            %trials
            if trialcounter>2
                while 1 %start looping indefinitely
                    % if target is in the same place more than 2 times shuffle again
                    
                    if  target_locations(trial_num)==target_locations(trial_num-1) && target_locations(trial_num)==target_locations(trial_num-2)
                        trial_locations = Shuffle(trial_locations);
                        target_locations(trial_num)=find(trial_locations==Target_thisTrial);
                    else
                        %if this target is in a different location to the
                        %previous two, stop looking for a new target
                        %location
                        break %get out of the indefinite loop
                    end
                end
                
            end
            
            correct_response =(trial_locations(:,Target_thisTrial));
           
            
            %%%%%% the folder numbers ie F1 tell you about the original image location in the PPVT 
            
            
            Screen('DrawTextures', wptr, image_background,[], p.dest_rect_background);
            
            I = imread(fullfile(exp_dir, 'items', 'F1', [num2str(trial_num),'.jpg']));
            F1 = Screen('MakeTexture', wptr, I);
            Screen('DrawTextures', wptr, F1,[], p.dest_loc(trial_locations(1),:));
            
            I = imread(fullfile(exp_dir, 'items', 'F2', [num2str(trial_num),'.jpg']));
            F2 = Screen('MakeTexture', wptr, I);
            Screen('DrawTextures', wptr, F2,[], p.dest_loc(trial_locations(2),:));
            
            I = imread(fullfile(exp_dir, 'items', 'F3', [num2str(trial_num),'.jpg']));
            F3 = Screen('MakeTexture', wptr, I);
            Screen('DrawTextures', wptr, F3,[], p.dest_loc(trial_locations(3),:));
            
            I = imread(fullfile(exp_dir, 'items', 'F4', [num2str(trial_num),'.jpg']));
            F4 = Screen('MakeTexture', wptr, I);
            Screen('DrawTextures', wptr, F4,[], p.dest_loc(trial_locations(4),:));
            
            
            
            
            %Show image
            Screen('Flip',wptr);
            
            
            %note down the image locations in excel i.e F1 image was
            %presentsed 
           
            d.data(trial_num,5) = correct_response;
            
            
            %% Get input
            
            %AW 5/8/20 restrict to certin keys
            validinput = 0;
            while validinput == 0
            % Check the keyboard to see if a button has been pressed
            [keydown,secs,keycode] = KbCheck();
            % exp_start = KbWait();
            
            % What key was pressed
            keypress = KbName();  
            
            if keypress == "ESCAPE" || keypress == "1" || keypress == "2" || keypress == "3" || keypress == "4"
                validinput=1;
            end
            %sca; - AW dubugging
            end
            if keypress == "ESCAPE" 
               keypress = 9;
            else
               key = str2num(keypress);
            end
            
                      
            d.data(trial_num,6) = key;
            setcount = setcount+1;
             if setcount ==12;
                setcount = 0;
                error_count=0;
            end
            
            if correct_response == key
                resp = 1;
                d.data(trial_num,7) = resp;
            else
                resp = 0;
                d.data(trial_num,7) = resp;
                error_count = error_count+1;
                
            end
           
            %if they've made 7 errors or finished all the trials
            if error_count == 8 || trial_num==finish || keypress == 9;
                
                %record which set they finished on
                finish_set = p.stimulus(trial_num,2);
                
                %find out whether they made mistakes in the first set.
                %if so, run PPVT a second time with a new start set 
               start_set_error = numel(find(d.data(start_set:start_set+ntrialsSet-1,11)==0))>=1; %if there are any incorrect responses in the first batch
%                     %finish=start-1; %record where the last set started so we don't repeat those trials
%                     moving_start_set=start_set-1; %drop down below the first set
%                     start = find(moving_start_set==p.stimulus(:,3));%find our new starting point
%                     trial_num = start;
                %quitting - show message that we need to do 12 more
                if start_set_error == 1
                    DrawFormattedText(wptr,'Well Done! Have a short break','center','center');
                    Screen('Flip',wptr);
                    WaitSecs(2)
                    
                else
                    %quitting - show happy message
                    DrawFormattedText(wptr,'Well Done!','center','center');
                    Screen('Flip',wptr);
                    WaitSecs(2)
                end
                savetraildata = d.data;
                PPVT_count = sum(d.data(:,7));
                
                % Save to CSV fileimage_background
                save([file_name], 'start_set', 'finish_set', 'PPVT_count', 'savetraildata');
                fileID = fopen(data_file_name);%,'a+');
                
                %fprintf(fileID,'%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n', d.data(start:trial_num',:));
                %fprintf(fileID,d.data(trial_num,:));
                
                
                fclose(fileID);
                
                %% Close up
                % Show exit screen
                Screen('TextFont',wptr,'Helvetica');
                Screen('TextSize',wptr,20);
                DrawFormattedText(wptr, 'End of the experiment\n\n\npress any key to close', 'center', 'center');
                Screen('Flip',wptr);
                KbStrokeWait;
                
                % Close everything
                ListenChar(0);
                Screen('CloseAll');
                ShowCursor;
                
                finished=1; %tell the while loop to stop going through the trials
            end
            
        end % quite rule
       
    end

    
    
    
    
catch ME
    ListenChar(0);
    Screen('CloseAll');
    ShowCursor;
    %PsychPortAudio('Close');
    rethrow(ME);
    save('errors.mat', 'ME');
end
