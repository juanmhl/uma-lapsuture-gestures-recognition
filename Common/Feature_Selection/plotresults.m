%% ReliefF
load("idx_reliefF.mat");
figure;
somenames = [ "dist"
    "angle"
    "vel\_norm\_left"
    "vel\_norm\_right"
    "gripper\_angle\_left "
    "gripper\_angle\_right"
    "eulerZ\_left"
    "eulerY\_left"
    "eulerX\_left"
    "eulerZ\_right"
    "eulerY\_right"
    "eulerX\_right"
    "vel\_left\_x "
    "vel\_left\_y"
    "vel\_left\_z"
    "vel\_right\_x"
    "vel\_right\_y"
    "vel\_right\_z"
    "vel\_ang\_left\_x"
    "vel\_ang\_left\_y"
    "vel\_ang\_left\_z"
    "vel\_ang\_right\_x"
    "vel\_ang\_right\_y"
    "vel\_ang\_right\_z"];

scores = abs(scores)
barh(flip(scores(idx)/max(scores)))
xlim([0,1.05])
yticks(1:24)
set(gca,'yticklabel',flip(somenames(idx)))
title("Selección de Componentes con ReliefF")
ylabel("Variable")
xlabel("Puntuación de cada variable")


%% PCA
load("idx_reliefF.mat");
figure;

scores = abs(scores)
barh(flip(scores(idx)/max(scores)))
xlim([0,1.05])
yticks(1:24)
set(gca,'yticklabel',flip(somenames(idx)))
title("Selección de Componentes con PCA")
ylabel("Variable")
xlabel("Puntuación de cada variable")


%% NCA
load("resultados_nca.mat");
figure;

scores = abs(scores)
barh(flip(scores/max(scores)))
xlim([0,1.05])
yticks(1:24)
set(gca,'yticklabel',flip(somenames(idx)))
title("Selección de Componentes con NCA")
ylabel("Variable")
xlabel("Puntuación de cada variable")
