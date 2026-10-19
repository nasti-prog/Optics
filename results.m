function [] = results(RRMSE_result, convex_result)
    figure
    subplot(2, 1, 1)
    plot(RRMSE_result)
    title('RRMSE')
    grid on

    subplot(2, 1, 2)
    plot(convex_result)
    title('Convex function')
    grid on
end