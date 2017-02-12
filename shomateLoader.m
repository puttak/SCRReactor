function [WB, Hf298] = shomateLoader(desiredComponents)
gibbsData = loadjson('shomate.json');
for i=1:length(desiredComponents)
    j = 1;
    found = 0;
    while j<=length(gibbsData) && found == 0
        if strcmp(gibbsData{j}.name, desiredComponents{i})
            %fprintf('FOUND %s\n',gibbsData{j}.name);
            found = 1;
        else
            j=j+1;
        end
    end
    if found == 0
        fprintf('COULD NOT FIND %s\n',desiredComponents{i});
    else
        % We found the record
        WB(i,:) = gibbsData{j}.shomate;
        Hf298(i,:) = gibbsData{j}.H_f298;
    end
end
end
