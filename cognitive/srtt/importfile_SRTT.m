function data = importfile_SRTT(filename_SRTT)
% This function imports the .csv datafiles generated from the serial
% reaction time task.

%   data = IMPORTFILE(FILENAME_SRTT) 
%   Reads data from text file FILENAME_SRTT.
%
% Example:
%   data = importfile('RD_05_1_SRTT_2016_Apr_04_0903.csv', 2, 401); - first
%   & last row arguments are optional. 


%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename_SRTT,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[2,4,8,9,10,11,13,14,16,18,19,20]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% Split data into numeric and string columns.
rawNumericColumns = raw(:, [2,4,8,9,10,11,13,14,16,18,19,20]);
rawStringColumns = string(raw(:, [1,3,5,6,7,12,15,17,21]));


%% Replace blank cells with NaN
R = cellfun(@(x) isempty(x) || (ischar(x) && all(x==' ')),rawNumericColumns);
rawNumericColumns(R) = {NaN}; % Replace blank cells

%% Make sure any text containing <undefined> is properly converted to an <undefined> categorical
for catIdx = [1,2,3,4,5,6,7,8,9]
    idx = (rawStringColumns(:, catIdx) == "<undefined>");
    rawStringColumns(idx, catIdx) = "";
end

%% Create output variable
data = table;
data.colourC = categorical(rawStringColumns(:, 1));
data.trial = cell2mat(rawNumericColumns(:, 1));
data.colourV = categorical(rawStringColumns(:, 2));
data.corrButton = cell2mat(rawNumericColumns(:, 2));
data.colourZ = categorical(rawStringColumns(:, 3));
data.colourX = categorical(rawStringColumns(:, 4));
data.corrAns = categorical(rawStringColumns(:, 5));
data.outerLoopthisRepN = cell2mat(rawNumericColumns(:, 3));
data.outerLoopthisTrialN = cell2mat(rawNumericColumns(:, 4));
data.outerLoopthisN = cell2mat(rawNumericColumns(:, 5));
data.outerLoopthisIndex = cell2mat(rawNumericColumns(:, 6));
data.key_resp_1keys = categorical(rawStringColumns(:, 6));
data.key_resp_1corr = cell2mat(rawNumericColumns(:, 7));
data.key_resp_1rt = cell2mat(rawNumericColumns(:, 8));
data.key_resp_2keys = categorical(rawStringColumns(:, 7));
data.key_resp_2rt = cell2mat(rawNumericColumns(:, 9));
data.date = categorical(rawStringColumns(:, 8));
data.frameRate = cell2mat(rawNumericColumns(:, 10));
data.expName = cell2mat(rawNumericColumns(:, 11));
data.session = cell2mat(rawNumericColumns(:, 12));
data.participant = categorical(rawStringColumns(:, 9));

