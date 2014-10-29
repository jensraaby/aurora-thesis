function [W, mu, cov, alpha, errors] = fit_em(img, mu0, sigma0, alpha0, maxiterations)


        alpha = alpha0;
        mu = mu0;
        cov = sigma0;
        errors = zeros(maxiterations,1);
        
        % measure initial error:
        [~, E] = reconstruct( mu, cov, alpha, img, 1, 0 );
        
        for iteration = 1:maxiterations
            
            
            Eold = E;
            [ canvas, E ] = reconstruct( mu, cov, alpha, img, 1, 0 );
             errors(iteration) = E;
             
             
            % check error not a lot worse, but only after first 5
            % iterations
            if (Eold-E < -0.02) & (iteration > 5)
                disp('error value increased - stopping')
                Eold
                E
                break
            end
            
   
           
           
            % Expectation Maximisation step
            [ W,alpha,mu,cov ] = update_mixture( img, length(alpha), alpha, mu, cov );

        end
      
        
        % make sure all error traces are the same length!
        if iteration<maxiterations
            errors(iteration:maxiterations) = errors(iteration-1);
        end
end