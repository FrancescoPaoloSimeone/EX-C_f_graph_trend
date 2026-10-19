%parametri
p_c = 21.5; %bar
p_a = 1.013; %bar
gamma = 1.146;
Gamma = 0.6378;
A_t = 16.85; %cm^2
eta_Cf = 0.96;

M_e = 0.8 : 0.05 : 4.01;

%rapporto di presssione in funzione di M_e
pe_pc = (1 + ((gamma - 1) / 2) * M_e.^2).^(-gamma / (gamma - 1));

%rapporto aree in funzione di M_e
epsilon = (1 ./ M_e) .* (((2 / (gamma + 1)) * (1 + ((gamma - 1) / 2) * M_e.^2)).^((gamma + 1) / (2 * (gamma - 1))));

%calcolo Cf reale
termine_moto = eta_Cf * Gamma * sqrt((2 * gamma / (gamma - 1)) * (1 - pe_pc.^((gamma - 1) / gamma)));
termine_pressione = (pe_pc - (p_a / p_c)) .* epsilon;
Cf_reale = termine_moto + termine_pressione;



%tracciamento grafico
figure;
plot(epsilon, Cf_reale, 'LineWidth', 2, 'Color', 'b');
grid on;
xlabel('Expansion ratio \epsilon (A_e / A_t)');
ylabel('Real thrust coefficient C_F');
title('Trend of C_F as a function of \epsilon');

%massimo di Cf
[Cf_max, idx_max] = max(Cf_reale);
epsilon_opt = epsilon(idx_max);

testo_ottimale = sprintf('Optimal (\\epsilon = %.2f)', epsilon_opt);
text(epsilon_opt + 0.8, Cf_max, testo_ottimale, ...
    'VerticalAlignment', 'middle', 'FontSize', 10, 'Color', 'w', 'FontWeight', 'bold');

hold on;
plot(epsilon_opt, Cf_max, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');


idx_sotto = 1:idx_max;
area(epsilon(idx_sotto), Cf_reale(idx_sotto), 'FaceColor', [1 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

idx_sopra = idx_max:length(epsilon);
area(epsilon(idx_sopra), Cf_reale(idx_sopra), 'FaceColor', [0.8 0.8 1], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
ylim([0, 1.4]);
legend('Real C_F Curve', 'Point of Optimal Adaptation', 'Under-expansion zone', 'Over-expansion zone', 'Location', 'northeast');

exportgraphics(gcf, 'Great_0_Cf_Graph.pdf', 'ContentType', 'vector');
