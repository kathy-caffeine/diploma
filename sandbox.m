addpath("fast_NVG\");
addpath("ecgGen\");
addpath("signals\");
addpath("wfdb\database\");
addpath("wfdb\mcode\");
addpath("lobachevsky-university-electrocardiography-database-1.0.1\data\");
% addpath("healthy-rr-interval\");

N=10000;
[ecg,Fs,tm]=rdsamp('mitdb/203',1,N);
plot(ecg);

name = 'АритмияНатуральный203';

plot(ecg);
exportFig(strcat('ЭКГ', name));

% % сгенерировать ритмограмму
% amount = 30;
% x=0.01:0.01:amount;
% rr = zeros(1, amount);
% for i = 1:1:amount
%     rr(i) = 0.7 + (1.3-0.7)*rand();
% end
% bar(rr);
% exportFig(strcat('ритмограмма', name));

% % прочитать ЭКГ из тхт
% % 24 часа, для обработки нужен кусочек в 1 час
% matrix = readmatrix("C:\Users\User\matlab\diploma\signals\W6_01.txt");
% m = matrix(:, 1);
% plot(m);

% % прочитать ритмограмму
% rr_full = readmatrix("C:\Users\User\matlab\diploma\signals\W7_01.txt");
% rr = rr_full(100:159, 1);
% bar(rr);
% exportFig(strcat('ритмограмма', name));

% % построить ритмограмму
% bar(m);

% % сгенерировать сигнал 
% % построить ритмограмму и тахограмму из него
% amount = 30;
% x=0.01:0.01:amount;
% [ecgSignal] = NormalECG(x, 72);
% % figure;
% % plot(x, ecgSignal);
% Threshold = max(ecgSignal) * 0.95;
% [r, ind] = findpeaks(ecgSignal,'MinPeakHeight',Threshold);
% rr = zeros(size(r)-1);
% for i = 1:numel(r)-1
%     rr(i) = abs(x(ind(i+1))-x(ind(i)));
% end
% tach = zeros(size(rr));
% for i = 1:numel(rr)
%     tach(i) = 60/rr(i);
% end

% вытащить RR из ЭКГ
s = size(ecg);
a = s(1)/200;
x = linspace(0, a, s(1));
Threshold = min(ecg) + ((max(ecg) - min(ecg)) * 0.6);
[r, ind] = findpeaks(ecg,'MinPeakHeight',Threshold);
rr = zeros(size(r)-1);
for i = 1:size(r)-1
    rr(i) = abs(x(ind(i+1))-x(ind(i)));
end

% нарисовать ритмограмму
figure;
bar(rr);
exportFig(strcat('ритмограмма', name));

% построить граф из RR
z = 1:numel(rr);
nvg = fast_NVG(rr, z, 'u', 0);
g_nvg = graph(nvg);

% рисуночек графика с графом сверху
figure;
plot(rr, 'b-', 'LineWidth', 1.5); % График сигнала
hold on;
grid on;
% Извлечение рёбер графа
edges = g_nvg.Edges; % Таблица рёбер графа
numEdges = size(edges, 1); % Количество рёбер
% Визуализация рёбер графа
for i = 1:numEdges
    % Получение индексов вершин для текущего ребра
    sourceNode = edges.EndNodes(i, 1);
    targetNode = edges.EndNodes(i, 2);
    
    % Координаты вершин
    x1 = z(sourceNode);
    y1 = rr(sourceNode);
    x2 = z(targetNode);
    y2 = rr(targetNode);
    
    % Отрисовка ребра
    plot([x1, x2], [y1, y2], 'r-', 'LineWidth', 0.5);
end
% Легенда
legend('Ритмограмма', 'Рёбра графа видимости');
hold off;
exportFig(strcat('граф', name));

% степени вершин и их вероятность
p = degree(g_nvg); % векторочек мощностей вершин графа
unique_degrees = unique(p); % уникальные степени вершин
P_k = zeros(1, length(unique_degrees)); % доли вершин по степеням
inv_k = zeros(1, length(unique_degrees)); % обратное значение степени
for i = 1:length(unique_degrees)
    k = unique_degrees(i);
    P_k(i) = sum(p == k) / length(p); % Доля вершин со степенью k
    inv_k(i) = 1 / k; % Обратное значение степени
end

% график распределения степеней
figure;
loglog(unique_degrees, P_k, 'bo-', 'LineWidth', 2); % Логарифмический график P(k)
hold on;
loglog(unique_degrees, inv_k, 'r--', 'LineWidth', 2); % Логарифмический график 1/k
xlabel('Степень k');
ylabel('P(k) и 1/k');
legend('P(k)', '1/k');
title('Распределение вероятностей степеней и значений обратных степеней вершин');
grid on;
exportFig(strcat('степени', name));

% PSVG
log_P_k = log2(P_k);
log_inv_k = log2(inv_k);

true_log_P_k = log_P_k(2:numel(log_P_k));
true_log_inv_k = log_inv_k(2:numel(log_inv_k));

norm_P_k = norm(P_k);
norm_inv_K = norm(inv_k);
lambda = norm_P_k/norm_inv_K;

coefficients = polyfit(true_log_inv_k, true_log_P_k, 1);
PSVG = coefficients(1);

% график ПСВГ
figure;
plot(true_log_inv_k, true_log_P_k, 'bo', 'LineWidth', 2); % Исходные данные
hold on;
plot(true_log_inv_k, PSVG * true_log_inv_k + coefficients(2), 'r-', 'LineWidth', 2); % Линия регрессии
xlabel('log_2(1/k)');
ylabel('log_2(P(k))');
legend('Данные', 'Линейная регрессия');
title(['PSVG = ', num2str(PSVG)]);
grid on;
exportFig(strcat('псвг', name));
