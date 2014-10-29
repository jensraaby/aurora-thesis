function [] = plotEMComponentContributions(k, cidx, P)
%%% [] = plotEMComponentContributions(k, cidx, P)

meansk = zeros(k);
meanskrand = zeros(k);
for j = 1:k
    
    % show for each cluster the contribution of that component to all the
    % points in it
    clusterPs = P(cidx==j,:);
    meansk(j,:) = mean(clusterPs)

    legstr{j} = [num2str(j)];
end
%
bar(1:k,meansk,'stack')
xlabel('Cluster','FontSize',14)
ylabel('Component responsibility','FontSize',14)
legend(legstr,'Location','NorthEastOutside');
set(gca,'FontSize',16)
ylim([0 1])
