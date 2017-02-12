desiredVolume = 21;
%% Vol Limit

vols = [10:0.5:desiredVolume];
parfor i=1:length(vols)
    [nox(i),~,~]=reactorAsPBR(vols(i),620,0.85);
end

figure(1);
plot(vols,nox,[vols(1) vols(end)],[200 200]);

%% Temp Conversion
temps = [550:5:800];
parfor i=1:length(temps)
    [~,xno(i),xnh3(i), kno(i),knh3(i)]=reactorAsPBR(desiredVolume,temps(i),0.85);
end

figure(2);
plot(temps,xno,temps,xnh3);
legend('NO','NH3');
figure(5)
plot(temps,kno,temps,knh3);
legend('k_N_O','k_N_H_3');

%% Ammonia Conversion
ammoniaRatio = [0:0.01:2];
parfor i=1:length(ammoniaRatio)
    [~,xnon(i),xnh3n(i)]=reactorAsPBR(desiredVolume,620,ammoniaRatio(i));
end

figure(3);
plot(ammoniaRatio,xnon, ammoniaRatio,xnh3n);
legend('NO','NH3');


%% Ammonia Conversion Surface
temps = [580:10:640];
ammoniaRatio = [0:0.01:2];
for i=1:length(temps)
    parfor j=1:length(ammoniaRatio)
        [~,xnosurf(i,j),xnh3surf(i,j)]=reactorAsPBR(desiredVolume,temps(i),ammoniaRatio(j));
    end
end
figure(4)
surf(ammoniaRatio,temps,xnh3surf);
figure(6)
surf(ammoniaRatio,temps,xnosurf);

