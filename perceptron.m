figure(1)
scatter3(effects(:,1),effects(:,2),effects(:,3),'o')
title('Normalized Data')
xlabel('Shot Clock (x_{1})')
ylabel('Shot Distance (x_{2})')
zlabel('Defensive Coverage (x_{3})')
%%
% STEP 2: Learning rate ---------------------------------------------------
a   = 0.75; 

% STEP 3: Initialize w(t=0),  b(t=0) --------------------------------------                 ...
kmax = length(effects(:,1));
w = zeros(3, kmax);
b = zeros(1, kmax); 
w(:,1) = 2*rand(3,1)-1;    %Give the random initail w(t=0).
b(1)   = 2*rand(1,1)-1;    %Give the random initail b(t=0).

% STEP 4: Updating (w1, w2, b) --------------------------------------------
for k = 1: kmax
   
   y = f(w(:,k)'*effects(k,:)' + b(k));
   w(:, k+1) =  w(:,k) + a*(SHOT(k) - y)*effects(k,:)'; % update w(k);
   b(k+1)    =  b(k) + a*(SHOT(k) - y); % update b(k);
    
   if k > 1000 && (all(w(:,k+1)==w(:,k-20)) && b(k+1)==b(k-20))
       break
   end   
end


% STEP 5: Find the stablized (w1, w2, b) ----------------------------------
index = 1:k;
ind_w1 = index(diff(w(1,1:k))~=0);  % find all of the steps when the w1 changes
ind_w2 = index(diff(w(2,1:k))~=0);  % find all of the steps when the w2 changes
ind_w3 = index(diff(w(3,1:k))~=0);  % find all of the steps when w3 changes
ind_b  = index(diff(b(1:k)  )~=0);  % find all of the steps when the b  changes

% The number of iterations to reach a set of stable (w1, w2, b).
ind_final = max([1, ind_w1, ind_w2, ind_w3, ind_b]); 
disp(['Number of iterations: ', num2str(ind_final)])

w1 = w(1,ind_final); w2 = w(2,ind_final); w3 = w(3,ind_final); b0 = b(ind_final);
[x1,x2] = meshgrid(-2.5:0.1:2.5);
x3 = -(b0 + w1.*x1 + w2.*x2)./w3;
figure(2)
surf(x1,x2,x3)
title('Linear Classifier')
xlabel('Shot Clock (x_{1})')
ylabel('Shot Distance (x_{2})')
zlabel('Defensive Coverage (x_{3})')

save perceptron.mat w1 w2 w3 b0