% readNihonKodenM00 - reads Nihon Koden .m00 text files.
%
% Usage  : [output,srate,scale] = readNihonKodenM00(input);
%
% Inputs : path to the Nihon Koden .m00 text file
% 
% Outputs: Matlab variable in channels x timepoints, sampling rate, and
%          amplitude scale. If 'scale' is 1, no need to rescale the data. If
%          'scale'~=1, rescale the data by the factor of 'scale'. 
%
% History:
% 11/26/2019 Makoto. Data provided by Elham Sherkat, which has 'Trigger' in the last channel, is supported.
% 09/10/2018 ver 1.02 by Brian Silverstein. Added parsing of channel labels in second line.
% 02/01/2017 ver 1.01 by Makoto. C = strsplit(firstLine, ' '); has raw vector.
% 07/17/2013 ver 1.00 by Makoto. Created for my collaboration with Eishi Asano.

% Copyright (C) 2013 Makoto Miyakoshi SCCN,INC,UCSD
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

function [output,srate,scale,chanlabels] = readNihonKodenM00(input)

% open the file
FID = fopen(input);

% skip the first two lines
firstLine  = fgetl(FID);
secondLine = fgetl(FID);

% Parse header info in the first line.
C = strsplit(firstLine, ' ');
if     size(C,1)==6 & size(C,2)==1
    timePnts = str2num(C{1,1}(12:end));             % 12 letters are 'TimePoints='
    numChans = str2num(C{2,1}(10:end));             % 10 letters are 'Channels='
    srate    = round(1000/str2num(C{4,1}(22:end))); % 22 letters are 'SamplingInterval[ms]='
    scale    = str2num(C{5,1}(9:end));              % 9  letters are 'Bins/uV='  
    
elseif size(C,1)==1 & size(C,2)==6 % New pattern confirmed in 2016. Depends on which strsplit() is used.
    timePnts = str2num(C{1,1}(12:end));             % 12 letters are 'TimePoints='
    numChans = str2num(C{1,2}(10:end));             % 10 letters are 'Channels='
    srate    = round(1000/str2num(C{1,4}(22:end))); % 22 letters are 'SamplingInterval[ms]='
    scale    = str2num(C{1,5}(9:end));              % 9  letters are 'Bins/uV='
end

% Parse header info in the second line.
C = strsplit(secondLine, ' ');
if ~isempty(str2double(C{2}))                       % Check to make sure the second line contains strings, not numbers.
    chanlabels=C(2:end);                            % Line starts with a space, so labels will start in second cell.
end

% parse data structure
tmpData = fscanf(FID, '%f');
fclose(FID);

% check consistency between header info and actual data size
if length(chanlabels)>numChans
    numChans = length(chanlabels);
end
if size(tmpData,1) ~= numChans*timePnts;
    warning('Data size does not match header information. Check consistency.')
end

% reshape the data for finalizing
output = reshape(tmpData, [numChans timePnts]);