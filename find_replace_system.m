function find_replace_system(varargin)
% "find_replace_system" will search and replace almost any
% block/annotation/signal property in Simulink.
%
% Ref: Simulink API documentation "find_system".
% Please refer the syntax and examples below.
%
% Syntax:
%   >>find_replace_system('<model name/subsystem name>',<find_system property value-pairs if required>,'<Find Property Name>','<Find Property Value>','<Replace Value>','prompt')
%   >>find_replace_system('<model name/subsystem name>','<Find Property Name>','<Find Property Value>','<Replace Value>','prompt')
%   >>find_replace_system('<model name/subsystem name>','<Find Property Name>','<Find Property Value>','<Replace Value>')
%       - <find_system property value-pairs if required> Refer help
%       find_system of all different types of properties can be used to
%       narrow down the search, 'LookUnderMasks', 'RegExp', 'SearchDepth',
%       'FollowLinks', etc..
%       - 'prompt' is an optional keyword.
%
% Example:
%   >>find_replace_system('sldemo_autotrans','LookUnderMasks','all','FindAll','on','type','block','Name','Transmission','AutoTransmission','prompt')
%   >>find_replace_system('sldemo_autotrans','ForegroundColor','Red','Blue')
%   >>find_replace_system('sldemo_clutch/Friction Mode Logic','Position',get_param('sldemo_clutch/Friction Mode Logic','Position'),[250 292 400 433],'prompt')
%   >>find_replace_system(gcs,'SampleTime','-1','0.1','prompt')
%   >>find_replace_system(gcs,'Amplitude','3','1.5')
%   >>find_replace_system(gcs,'ZeroCross','on','off','prompt')
%
% Developed by: Sysenso Systems, www.sysenso.com
%

%--------------------------------------------------------------------------
% Input validation.
help_needed = false;
if nargin < 4
    % Atleast four arguments are required.
    help_needed  = true;
else
    try
        system_name = varargin{1};
        if strcmpi(varargin{end},'prompt')
            prompt = true;
            prop_name = varargin{end-3};
            prop_value = varargin{end-2};
            new_value = varargin{end-1};
            find_props = varargin(2:end-4);
        else
            prompt = false;
            prop_name = varargin{end-2};
            prop_value = varargin{end-1};
            new_value = varargin{end};
            find_props = varargin(2:end-3);
        end
    catch
        help_needed  = true;
    end
end
if help_needed
    disp('************************************************************');
    disp(['Error in ' upper(mfilename) ' usage.']);
    disp('************************************************************');
    help(mfilename);
    return;
end

%--------------------------------------------------------------------------
% Do a search here.
try
    find_match = find_system(system_name,find_props{:},prop_name,prop_value);
catch
    msgbox('There is no match for this search!!!','Find and Replace','help');
    return;
end
%--------------------------------------------------------------------------
% Return if there is no match found.
if isempty(find_match)
    msgbox('There is no match for this search!!!','Find and Replace','help');
    return;
end
%--------------------------------------------------------------------------
% Replace the block property.
handle_path = [];
if ~isnumeric(find_match)
    % Path
    for ind = 1:length(find_match)
        handle_path(ind) = get_param(find_match{ind},'Handle');
    end
else
    % Handle
    handle_path = find_match;
end

for ind = 1:length(find_match)
    old_value = get_param(handle_path(ind),prop_name);
    if isnumeric(old_value) && isnumeric(prop_value)
        % Numeric property values.
        replace_value = new_value;
    else
        % String property values.
        replace_value = regexprep(old_value,prop_value,new_value,'ignorecase');
    end
    go_replace = true;
    % Prompt the user before the change.
    if prompt
        hilite_system(handle_path(ind),'find');
        ButtonName = questdlg(['Do you want to change the block ' upper(prop_name) '?'], ...
            'Find and Replace', ...
            'Yes', 'No', 'Stop', 'Yes');
        switch ButtonName
            case 'Yes'
                go_replace = true;
            case 'No'
                go_replace = false;
            case 'Stop'
                hilite_system(handle_path(ind),'none');
                break;
        end
        hilite_system(handle_path(ind),'none');
    else
        go_replace = true;
    end
    if go_replace
        try
            set_param(handle_path(ind),prop_name,replace_value);
        catch
            % If the change is not successfully done, then prompt the
            % user again.
            hilite_system(handle_path(ind),'find');
            ButtonName = questdlg(['The property ' upper(prop_name)  ' is not successfully modified!!!',...
                'Do you want to continue?'], ...
                'Find and Replace', ...
                'Yes', 'Stop', 'Yes');
            switch ButtonName
                case 'Yes'
                case 'Stop'
                    break;
            end
            hilite_system(handle_path(ind),'none');
        end
    end
end

end
