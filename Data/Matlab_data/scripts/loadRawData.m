manoeuvre = "Suturing";
dataRoute = strcat("Data/", manoeuvre, "/");
kinematicsRoute = strcat(dataRoute,"kinematics/AllGestures/");
labelsRoute = strcat(dataRoute,"transcriptions/");

disp(strcat("Loading data from ", dataRoute, "..."));
disp(" ");

% Get all files in that route to get both number of surgeons and number of
% trials
listing = dir(kinematicsRoute);
fileNames = {listing(~[listing.isdir]).name};
numFiles = length(fileNames);

% Extract experiment codes
surgeons = [];
trials = [];

% Example filename: Suturing_C003.txt
for i = 1:length(fileNames)
    surgeons = [surgeons; fileNames{i}(end-7)];
    trials = [trials, str2num(fileNames{i}(end-4))];
end

% Get number of users/surgeons and number of trials
numUsers = length(unique(surgeons));
numTrials = max(trials);
dictUsers = dictionary((unique(surgeons)),(1:numUsers)');    % To convert users str to num

disp(strcat("Number of users: ", num2str(numUsers)));
disp(strcat("Number of trials: ", num2str(numTrials)));
disp(" ");

% Where to store the kinematics data
kinematicsData = cell(numUsers,numTrials);
labelsDataRaw = cell(numUsers,numTrials);

% Pre-append folder route to fileNames
kinematicsFiles = append(kinematicsRoute,fileNames);
labelsFiles = append(labelsRoute,fileNames);

% Read .txt files and save contents to cell arrays
for i = 1:numFiles
    % Example filename: Suturing_C003.txt
    user = fileNames{i}(end-7);
    user = dictUsers(user);
    trial = fileNames{i}(end-4);
    trial = str2num(trial);
    disp(strcat("Processing file ", kinematicsFiles{i}));
    try
        data = readmatrix(kinematicsFiles{i},"NumHeaderLines",0,"ExpectedNumVariables",76,"DecimalSeparator",'.','OutputType','double');
        kinematicsData{user,trial} = data;
        data = readmatrix(labelsFiles{i},"NumHeaderLines",0,"ExpectedNumVariables",3,"FileType","text","Delimiter",' ','OutputType','string');
        labelsDataRaw{user,trial} = data;
    catch ME
        warning(ME.message)
    end
end

% Labels data uses the following header:
% start-frame:num end-frame:num label:str
% For that we have to process each cell labelsDataRaw into a 1D vector of
% labels

labelsData = cell(numUsers,numTrials);

for user = 1:numUsers
    for trial = 1:numTrials
        rawLabels = labelsDataRaw{user,trial};
        experimentLength = size(kinematicsData{user,trial},1); % Num of rows of the vector
        labelsData{user,trial} = processRawLabels(rawLabels,experimentLength);
    end
end

outputFileName = strcat("NewFolders/Data/Matlab_data/",manoeuvre,"_raw_data.mat");
disp(strcat("Saving output to ", outputFileName, " ..."));
save(outputFileName,"*Data");
disp(strcat("Saved output to ", outputFileName));