function datafile_mst = importfile_mst(workbookFile, sheetName, dataLines)
%IMPORTFILE Import data from a spreadsheet
% 
%  Example:
%  Data = importfile("/Volumes/LaCie/Ex_rTMS_study/Data/all_subjects/S2_MS/Cognitive/llpc/MST/pre/S2_MS_pre.xlsx", "Sheet1", [3, 131]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 17-Apr-2019 17:47:47

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [3, 131];
end

%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 7);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":G" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["Trial", "Img", "Cond", "LBin", "Resp", "Acc", "RT"];
opts.SelectedVariableNames = ["Trial", "Img", "Cond", "LBin", "Resp", "Acc", "RT"];
opts.VariableTypes = ["char", "char", "categorical", "double", "double", "double", "double"];
opts = setvaropts(opts, [1, 2], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3], "EmptyFieldRule", "auto");

% Import the data
datafile_mst = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":G" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    datafile_mst = [datafile_mst; tb]; %#ok<AGROW>
end

end