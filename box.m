clear all;
clc;

% Importiere Daten aus praeparierten Tabellen
Ohm100  = importdata('100ohm.dat',',');
Ohm1k   = importdata('1000ohm.dat',',');
Ohm10k  = importdata('10kOhm.dat',',');
Ohm100k = importdata('100kOhm.dat',',');
Ohm1M   = importdata('1MOhm.dat',',');

% fasse diese in data-Array zusammen
data = [Ohm100 Ohm1k Ohm10k Ohm100k];

% X-Werte sind theoretische Widerstaende
X = 10.^[2:6];

% Y-Werte sind gemessene Widerstaende, dazu muessen wir
% Real- und Imaginaeteil zusammenzaehlen! Bei 1M Ohm habe
% ich Scheissdaten herausgenommen, daher extra Zeile
Y = [1:5];
for i = 0:3
    Y(i+1) = mean(1./sqrt(data(:,2*i+1).^2+data(:,2*i+2).^2));
end
Y(5)= mean(1./sqrt(Ohm1M(:,1).^2+Ohm1M(:,2).^2));

% Fehler 0,01% bzw. 0.1%
Errors(1:3) = 0.001*X(1:3);
Errors(4:5) = 0.01*X(4:5);

% erstelle Fit
[f,gof] = fit(X',Y','poly1','Weights',Errors')

% Berechne Fehler der Steigung und des Achsenabschnitt
a = confint(f)
fehler_steig = 0.5.*(a(2,1)-a(1,1))
fehler_abschn = 0.5.*(a(2,2)-a(1,2))

% Plot mit beschrifteten Achsen etc.
% Fehlerbalken wegen Sichtbarkeit verzehnfacht
figure(1) 
hold on
errorbar(X,Y,10.*Errors,'x')
plot(f)
xlabel('$R_{theo}$ in $\Omega$','Interpreter','latex')
ylabel('$R_{exp}$ in $\Omega$','Interpreter','latex')
legend({'Messpunkte','Fit'},'Location','northwest','Interpreter','latex')
set(gca,'TickLabelInterpreter','latex')
hold off

% speichere Plot als Bild ab
% saveas(gcf,'box.epsc')




