function Data = importfile_SST(filename_SST)

%% Initialize variables.

delimiter = '\t';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as text:

% For more information, see the TEXTSCAN documentation.

formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.

fileID = fopen(filename_SST,'r');

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

for col=[1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]
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

% Convert the contents of columns with dates to MATLAB datetimes using the
% specified date format.
try
    dates{2} = datetime(dataArray{2}, 'Format', 'HH:mm:ss', 'InputFormat', 'HH:mm:ss');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{2} = cellfun(@(x) x(2:end-1), dataArray{2}, 'UniformOutput', false);
        dates{2} = datetime(dataArray{2}, 'Format', 'HH:mm:ss', 'InputFormat', 'HH:mm:ss');
    catch
        dates{2} = repmat(datetime([NaN NaN NaN]), size(dataArray{2}));
    end
end

dates = dates(:,2);

%% Split data into numeric and string columns.
rawNumericColumns = raw(:, [1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Create table
Data = table;

%% Allocate imported array to column variable names
Data.date = cell2mat(rawNumericColumns(:, 1));
Data.time = dates{:, 1};
Data.subject = cell2mat(rawNumericColumns(:, 2));
Data.expressionsblocknumber = cell2mat(rawNumericColumns(:, 3));
Data.response = cell2mat(rawNumericColumns(:, 4));
Data.expressionstrialnumber = cell2mat(rawNumericColumns(:, 5));
Data.valuesstimulus = cell2mat(rawNumericColumns(:, 6));
Data.valuessignal = cell2mat(rawNumericColumns(:, 7));
Data.valuescorrect = cell2mat(rawNumericColumns(:, 8));
Data.valuesresponse = cell2mat(rawNumericColumns(:, 9));
Data.valuesrt = cell2mat(rawNumericColumns(:, 10));
Data.valuesssd = cell2mat(rawNumericColumns(:, 11));
Data.expressionsp_rs = cell2mat(rawNumericColumns(:, 12));
Data.expressionsssd = cell2mat(rawNumericColumns(:, 13));
Data.expressionsssrt = cell2mat(rawNumericColumns(:, 14));
Data.expressionssr_rt = cell2mat(rawNumericColumns(:, 15));
Data.expressionsns_rt = cell2mat(rawNumericColumns(:, 16));
Data.expressionsns_hit = cell2mat(rawNumericColumns(:, 17));
Data.expressionsmiss = cell2mat(rawNumericColumns(:, 18));
Data.expressionsz_score = cell2mat(rawNumericColumns(:, 19));
Data.expressionsp_value = cell2mat(rawNumericColumns(:, 20));


