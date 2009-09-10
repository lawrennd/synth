% DEMPROJECTVOICES Demonstrate projection of voices onto reduced dimension.
 
% COPYRIGHT : Jon Barker, 2009
%
% MODIFICATIONS : Neil D. Lawrence, 2009

% SYNTH

% Load in the processed grid data.

[cmpm, cmpv] = synthLoadData('cmp');

fhandle = figure;

a = ver('matlab');
if strcmp(a.Version, '7.0.1')
  menu = 'listbox';
else
  menu = 'popupmenu';
end

string = {'bbaf3s', 'pbav3s', 'ay', 'place'};
ud.utt_popup = uicontrol('Style', menu, ...
                         'Parent',fhandle, ...
                         'Units','normalized', ...
                         'Position',[0.02, 0.05, 0.2, 0.05], ...
                         'String', string, ...
                         'Min', 1, ...
                         'Max', length(string), ...
                         'Value', 1, ...
                         'listboxtop', 1);

h = ud.utt_popup;
if(strcmp(menu, 'listbox'))
  set(h, 'listboxtop', get(h, 'value'));
end


[void, void, lbls]=synthLoadData('cmp');
string = lbls{2};
ud.id_edit = uicontrol('Style', 'listbox', ...
                       'Parent',fhandle, ...
                       'Units','normalized', ...
                       'Position',[0.24, 0.0, 0.15, 0.1], ...
                       'String',string, ...
                       'Min', 1, ...
                       'Max', length(string), ...
                       'Value', 1);
h = ud.id_edit;
set(h, 'listboxtop', get(h, 'value'));

% NDim Control
uicontrol('Style', 'text', ...
          'Parent', fhandle, ...
          'Units', 'normalized', ...
          'Position',[0.39 0.05 0.1 0.05], ...
          'String', 'NDims');


ud.ndims_edit = uicontrol('Style', 'edit', ...
                          'Parent', fhandle, ...
                          'Units','normalized', ...
                          'Position', [0.49 0.05 0.05 0.05], ...
                          'Min', 0, ...
                          'Max', 0, ...
                          'String', '0');


% Original button
uicontrol('Parent', fhandle, ...
          'Units','normalized', ...
          'Callback', 'synthProjectionCallback(''orig'');', ...
          'Position', [0.54 0.05 0.15 0.05], ...
          'String', 'Original');

% Projected button
uicontrol('Parent', fhandle, ...
          'Units','normalized', ...
          'Callback','synthProjectionCallback(''reduced'');', ...
          'Position',[0.69 0.05 0.15 0.05], ...
          'String','Projected');


% Error
ud.error_text=uicontrol('Style', 'text', ...
                        'Parent', fhandle, ...
                        'Units','normalized',...
                        'Position',[0.84 0.05 0.1 0.05], ...
                        'String', '-----');

% Error
ud.mode_checkbox=uicontrol('Style', 'checkbox', ...
                           'Parent', fhandle, ...
                           'Units','normalized', ...
                           'Position', [0.94 0.05 0.04 0.05]);



ud.spec1plot = subplot('Position', [0.01, 0.66, 0.98, 0.33]);
set(ud.spec1plot, 'Visible','off')
ud.spec2plot = subplot('Position', [0.01, 0.18, 0.98, 0.33]);
set(ud.spec2plot, 'Visible','off')

ud.cmpm=cmpm;
ud.cmpv=cmpv;

set(ud.utt_popup, 'visible', 'on', 'value', 4)

set(gcf,'UserData',ud)
