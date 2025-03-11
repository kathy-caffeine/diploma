addpath("fast_NVG\");
addpath("ecgGen\");
addpath("signals\");
addpath("healthy-rr-interval\");

m = readmatrix("C:\Users\User\matlab\diploma\signals\013.txt");

% % построить ритмограмму
% bar(m);

% % вытащить RR из ЭКГ
% s = size(m);
% a = s(1)/200;
% x = linspace(0, a, s(1));
% Threshold = max(m) * 0.86;
% [r, ind] = findpeaks(m,'MinPeakHeight',Threshold);
% rr = zeros(size(r)-1);
% for i = 1:size(r)-1
%     rr(i) = abs(x(ind(i+1))-x(ind(i)));
% end

% построить граф из RR
rr = m(1:100, 1);
z = 1:size(rr);
nvg = fast_NVG(rr, z, 'w', 0);
g_nvg = graph(nvg);

% векторочек мощностей вершин графа
p = degree(g_nvg);
unique_degrees = unique(p); % уникальные степени вершин
P_k = zeros(1, length(unique_degrees)); % доли вершин по степеням
inv_k = zeros(1, length(unique_degrees)); % обратное значение степени
for i = 1:length(unique_degrees)
    k = unique_degrees(i);
    P_k(i) = sum(p == k) / length(p); % Доля вершин со степенью k
    inv_k(i) = 1 / k; % Обратное значение степени
end

% figure;
% loglog(unique_degrees, P_k, 'bo-', 'LineWidth', 2); % Логарифмический график P(k)
% hold on;
% loglog(unique_degrees, inv_k, 'r--', 'LineWidth', 2); % Логарифмический график 1/k
% xlabel('Степень k');
% ylabel('P(k) и 1/k');
% legend('P(k)', '1/k');
% title('Распределение степеней и обратных степеней');
% grid on;

log_P_k = log2(P_k);
log_inv_k = log2(inv_k);

coefficients = polyfit(log_inv_k, log_P_k, 1);
PSVG = -coefficients(1); % Наклон с учетом знака

figure;
plot(log_inv_k, log_P_k, 'bo', 'LineWidth', 2); % Исходные данные
hold on;
plot(log_inv_k, -PSVG * log_inv_k + coefficients(2), 'r-', 'LineWidth', 2); % Линия регрессии
xlabel('log_2(1/k)');
ylabel('log_2(P(k))');
legend('Данные', 'Линейная регрессия');
title(['PSVG = ', num2str(PSVG)]);
grid on;

% % рисуночек графика с графом сверху
% % Построение графика сигнала
% figure;
% plot(t, rr, 'b-', 'LineWidth', 1.5); % График сигнала
% hold on;
% grid on;
% 
% % Извлечение рёбер графа
% edges = g_nvg.Edges; % Таблица рёбер графа
% numEdges = size(edges, 1); % Количество рёбер
% % Визуализация рёбер графа
% for i = 1:numEdges
%     % Получение индексов вершин для текущего ребра
%     sourceNode = edges.EndNodes(i, 1);
%     targetNode = edges.EndNodes(i, 2);
%     
%     % Координаты вершин
%     x1 = z(sourceNode);
%     y1 = rr(sourceNode);
%     x2 = z(targetNode);
%     y2 = rr(targetNode);
%     
%     % Отрисовка ребра
%     plot([x1, x2], [y1, y2], 'r-', 'LineWidth', 0.5);
% end
% % Легенда
% legend('Ритмограмма', 'Рёбра графа видимости');
% hold off;

% % сгенерировать сигнал, 
% % построить ритмограмму и тахограмму из него
% amount = 100;
% x=0.01:0.01:amount;
% [ecgSignal] = NormalECG(x);
% figure;
% plot(x, ecgSignal);
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
