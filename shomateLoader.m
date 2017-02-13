% This function loads the data nessisary to use the shomate equation. The
% data is loaded from a JSON file, using the JSONLAB toolbox; and then
% manipulated into the format needed.

function [shomate, Hf298] = shomateLoader(desiredComponents)
gibbsData = loadjson('shomate.json');
for i=1:length(desiredComponents)
    j = 1;
    found = 0;
    while j<=length(gibbsData) && found == 0
        if strcmp(gibbsData{j}.name, desiredComponents{i})
            found = 1;
        else
            % Record wasn't found so increase the count and repeat
            j=j+1;
        end
    end
    if found == 0
        % Data for the desired component was not found, so print an error
        % message.
        fprintf('COULD NOT FIND %s\n',desiredComponents{i});
    else
        % We found the record
        shomate(i,:) = gibbsData{j}.shomate;
        Hf298(i,:) = gibbsData{j}.H_f298;
    end
end
end
