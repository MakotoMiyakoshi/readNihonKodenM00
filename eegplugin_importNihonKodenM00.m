% eegplugin_importNihonKodenM00() - EEGLAB plugin for importing Nihon Koden
%                                   .m00 text-format data.
%
% Usage:
%   >> eegplugin_nihonkodenM00import(fig, trystrs, catchstrs);
%
% Author: Makoto Miyakoshi SCCN, INC, UCSD
%
% See also: pop_importNihonKodenM00() importNihonKodenM00()

% History:
% 07/17/2013 ver 1.0 by Makoto. Created for my collaboration with Eishi Asano.

% Copyright (C) 2013 Makoto Miyakoshi, SCCN, INC, UCSD.
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

function eegplugin_nihonkodenM00import(fig, trystrs, catchstrs)
    
    % find import data menu
    % ---------------------
    menu = findobj(fig, 'tag', 'import data');
    
    % menu callbacks
    % --------------
    comcnt = [ trystrs.no_check '[EEG LASTCOM] = pop_importNihonKodenM00('''');' catchstrs.new_and_hist ];
    
    % create menus
    % ------------
    uimenu( menu, 'label', 'From Nihon Koden .m00 text files', 'callback', comcnt);