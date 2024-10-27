% readNihonKodenM00 - reads Nihon Koden .m00 text files.
%
% Usage  : [output,srate,scale,chanlabels] = readNihonKodenM00(input);
%
% Inputs : Fullpath to the Nihon Koden .m00 text file
% 
% Outputs: Matlab variable in channels x timepoints, sampling rate, and
%          amplitude scale in bins/microV (usually 1, which means the unit
%          of the is in microV). If 'scale' is 1, no need to rescale the data. If
%          'scale'~=1, you usually need to rescale the data by the factor of 'scale'. 
%
% History:
% 10/27/2024 Makoto. Error report by Atsuhito. A new type of data format found. Complete renewal.
% 11/26/2019 Makoto. Data provided by Elham Sherkat, which has 'Trigger' in the last channel, is supported.
% 09/10/2018 ver 1.02 by Brian Silverstein. Added parsing of channel labels in second line.
% 02/01/2017 ver 1.01 by Makoto. C = strsplit(firstLine, ' '); has raw vector.
% 07/17/2013 ver 1.00 by Makoto. Created for my collaboration with Eishi Asano.

% Copyright (C) 2013 Makoto Miyakoshi SCCN,INC,UCSD. Cincinnati Children's Hospital Medical Center.
%
% 1. Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice,
% this list of conditions and the following disclaimer in the documentation
% and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
% THE POSSIBILITY OF SUCH DAMAGE.

function [output, srate, scale, chanlabels] = readNihonKodenM00(input)


%%%%%%%%%%%%%%%%%%%%%%%%
%%% Read the header. %%%
%%%%%%%%%%%%%%%%%%%%%%%%
% I found that using this legacy method is most straightforward for reading the header. (10/27/2024 Makoto)
FID = fopen(input);
firstLine  = fgetl(FID);
fclose(FID);

% Parse the header info.
firstLineHeaderInfo  = strsplit(firstLine, ' ');

timePointsIdx       = find(contains(firstLineHeaderInfo, 'TimePoints='));
channelsIdx         = find(contains(firstLineHeaderInfo, 'Channels='));
samplingIntervalIdx = find(contains(firstLineHeaderInfo, 'SamplingInterval[ms]='));
binsMicroVIdx       = find(contains(firstLineHeaderInfo, 'Bins/uV='));

timePointsCells       = strsplit(firstLineHeaderInfo{timePointsIdx}, '=');
channelsCells         = strsplit(firstLineHeaderInfo{channelsIdx}, '=');
samplingIntervalCells = strsplit(firstLineHeaderInfo{samplingIntervalIdx}, '=');
binsMicroVCells       = strsplit(firstLineHeaderInfo{binsMicroVIdx}, '=');

numTimePoints = str2double(timePointsCells{2}); % counts.
numChannels   = str2double(channelsCells{2}); % counts.
srate         = 1000/str2double(samplingIntervalCells{2}); % Hz.
scale         = str2double(binsMicroVCells{2}); % bin/microV.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Read the data array. %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import the whole data as a table. readtable() was supported in Matlab 2013b.
importedTable = readtable(input, 'FileType', 'text', 'Delimiter', ' ', 'MultipleDelimsAsOne', true, 'VariableNamingRule', 'preserve');

% Identify data columns: Scalp electrodes and Trigger.
headerCells   = importedTable.Properties.VariableNames;
dataColumnIdx = find(contains(headerCells, '-') | contains(headerCells, 'Trigger'));

% Extract the data part.
dataTable = importedTable(:, dataColumnIdx);

% Prepare outputs.
output     = single(table2array(dataTable));
chanlabels = dataTable.Properties.VariableNames;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Validate the dimension of the imported data. %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(output,1) == numTimePoints & size(output,2) == numChannels
    disp('Imported successfully.')
else
    error('Data dimension mismatch occured. Contact Makto: mmiyakoshi@ucsd.edu')
end