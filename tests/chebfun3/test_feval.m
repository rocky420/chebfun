function pass = test_feval(pref)
% Test feval

if ( nargin == 0 ) 
    pref = chebfunpref; 
end
tol = 100*pref.cheb3Prefs.chebfun3eps;

seedRNG(42);

f = chebfun3(@(x,y,z) x, [-1 2 -pi/2 pi -3 1]); 
pass(1) = (abs(f(0,0,0)) < tol*vscale(f));  

pass(2) = (abs(f(pi/6,pi/12,-1)-pi/6) < tol*vscale(f));  

f = chebfun3(@(x,y,z) y, [-1 2 -pi/2 pi -3 1]); 
pass(3) = (abs(f(0,0,0)) < tol);   

pass(4) = (abs(f(pi/6,pi/12,-1)-pi/12) < tol*vscale(f)); 

f = chebfun3(@(x,y,z) z, [-1 2 -pi/2 pi -3 1]); 
pass(5) = (abs(f(0,0,0)) < tol);   

pass(6) = (abs(f(pi/6,pi/12,-1)+1) < tol*vscale(f)); 

% some harder tests. 
f = @(x,y,z) cos(x) + sin(x.*y) + sin(z.*x); 
g = chebfun3(f);
pts = 2*rand(3,1) - 1;
pass(7) = (abs(f(pts(1),pts(2),pts(3)) - g(pts(1),pts(2),pts(3)))<tol*vscale(g));

% Are we evaluating on arrays correctly?
r = rand(10,1); 
s = rand(10,1); 
t = rand(10,1); 
[rr, ss, tt]=meshgrid(r,s,t);
pass(8) = (norm((f(r,s,t) - g(r,s,t))) < tol*vscale(g));

pass(9) = (max(max(max(abs(f(rr,ss,tt) - g(rr,ss,tt))))) < tol*vscale(g));

% Does this work off [-1,1]^2
g = chebfun3(f,[-pi/6 pi/2 -pi/12 sqrt(3) -3 1]); % strange domain. 
r = 0.126986816293506; s = 0.632359246225410; t = 0.351283361405006;
% three fixed random number in domain.
pass(10) = (abs(f(r,s,t) - g(r,s,t))<tol*vscale(g));

% Are we evaluating on arrays correctly
pass(11) = (norm((f(r,s,t) - g(r,s,t)))<tol*vscale(g));

pass(12) = (max(max(max(abs(f(rr,ss,tt) - g(rr,ss,tt)))))<tol*vscale(g)); 

%% vector inputs
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
xx = linspace(-1, 1, 100)';
yy = linspace(-1, 1, 100)';
zz = linspace(-1, 1, 100)';
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(13) = norm(F - FF) < 100*tol;

% row vector inputs
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
xx = linspace(-1, 1, 100);
yy = linspace(-1, 1, 100);
zz = linspace(-1, 1, 100);
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(14) = norm(F - FF) < 100*tol;

% 'trig' flag + vector inputs
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff, 'trig');
xx = linspace(-1, 1, 100)';
yy = linspace(-1, 1, 100)';
zz = linspace(-1, 1, 100)';
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(15) = norm(F - FF) < 100*tol;

% random vector inputs
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
xx = rand(100, 1);
yy = rand(100, 1);
zz = rand(100, 1);
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(16) = norm(F - FF) < 100*tol;

% 'trig' flag + random vector inputs
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff, 'trig');
xx = rand(100, 1);
yy = rand(100, 1);
zz = rand(100, 1);
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(17) = norm(F - FF) < 100*tol;

%% Matrix input with meshgrid
% x and y are matrix inputs (meshgrid) and z is a matrix containing copies 
% of a single scalar
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
xx = linspace(-1, 1, 100)';
[xx, yy] = meshgrid(xx);
zz = xx(1,1)*ones(size(xx));
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(18) = norm(F - FF) < 100*tol;

% y and z are matrix inputs (meshgrid) and x is just a matrix of just one 
% scalar
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
zz = linspace(-1, 1, 100)';
[yy, zz] = meshgrid(zz);
xx = zz(1,1)*ones(size(xx));
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(19) = norm(F - FF) < 100*tol;

% x and z are matrix inputs (meshgrid) and y is a matrix of just one scalar
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
zz = linspace(-1, 1, 100)';
[xx, zz] = meshgrid(zz);
yy = zz(1,1)*ones(size(xx));
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(20) = norm(F - FF) < 100*tol;

%% Matrix input with ndgrid
% x and y are matrix inputs (ndgrid) and z is a matrix containing copies 
% of a single scalar
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
xx = linspace(-1, 1, 100)';
[xx, yy] = ndgrid(xx);
zz = xx(1,1)*ones(size(xx));
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(21) = norm(F - FF) < 100*tol;

% y and z are matrix inputs (ndgrid) and x is just a matrix of just one 
% scalar
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
zz = linspace(-1, 1, 100)';
[yy, zz] = ndgrid(zz);
xx = zz(1,1)*ones(size(xx));
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(22) = norm(F - FF) < 100*tol;

% x and z are matrix inputs (ndgrid) and y is a matrix of just one scalar
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
zz = linspace(-1, 1, 100)';
[xx, zz] = ndgrid(zz);
yy = zz(1,1)*ones(size(xx));
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(23) = norm(F - FF) < 100*tol;

%% Tensor inputs
% Tensor input generated by meshgrid
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
[xx, yy, zz] = meshgrid(linspace(-1, 1, 100));
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(24) = norm(F(:) - FF(:)) < 100*tol;

% 'trig' flag + meshgrid
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff, 'trig');
[xx, yy, zz] = meshgrid(linspace(-1, 1, 100));
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(25) = norm(F(:) - FF(:)) < 100*tol;

% % Tensor input generated by ndgrid
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
[xx, yy, zz] = ndgrid(linspace(-1, 1, 100));
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(26) = norm(F(:) - FF(:)) < 100*tol;

% 'trig' flag + ndgrid
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff, 'trig');
[xx, yy, zz] = ndgrid(linspace(-1, 1, 100));
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(27) = norm(F(:) - FF(:)) < 100*tol;

% random tensor inputs
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff);
xx = rand(10, 20, 30);
yy = rand(10, 20, 30);
zz = rand(10, 20, 30);
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(28) = norm(F(:) - FF(:)) < 100*tol;

% 'trig' flag + random tensor inputs
ff = @(x,y,z) sin(pi*(x+y+z));
f = chebfun3(ff, 'trig');
xx = rand(10, 20, 30);
yy = rand(10, 20, 30);
zz = rand(10, 20, 30);
F = f(xx,yy,zz);
FF = ff(xx,yy,zz);
pass(29) = norm(F(:) - FF(:)) < 100*tol;

%% Cross sections
% Fixed x
ff = @(x,y,z) sin(x+y+z) + x + y; % A function with different variable-ranks
dom = [-1 1 -4 -2 6 8];
f = chebfun3(ff, dom);
f2D = f(0.5, :, :);
fChebfun2 = chebfun2(@(y,z) ff(0.5, y, z), dom(3:6));
pass(30) = norm(fChebfun2 - f2D) < 100*tol;

% APA's bug report for a function that has x-rank 1:
ff = @(x, y, z) cos(y + z).*sin(z).*exp(x);
f = chebfun3(ff, dom);
f2D = f(0.5, :, :);
fChebfun2 = chebfun2(@(y,z) ff(0.5, y, z), dom(3:6));
pass(31) = norm(fChebfun2 - f2D) < 100*tol;

% APA's bug report for a function that has y-rank 1:
ff = @(x, y, z) cos(x + z).*sin(z).*exp(y);
f = chebfun3(ff, dom);
f2D = f(0.5, :, :);
fChebfun2 = chebfun2(@(y,z) ff(0.5, y, z), dom(3:6));
pass(32) = norm(fChebfun2 - f2D) < 100*tol;

% Similar to APA's bug report for a function that has z-rank 1:
ff = @(x, y, z) cos(x + y).*sin(y).*exp(z);
f = chebfun3(ff, dom);
f2D = f(0.5, :, :);
fChebfun2 = chebfun2(@(y,z) ff(0.5, y, z), dom(3:6));
pass(33) = norm(fChebfun2 - f2D) < 100*tol;

% Fixed y
ff = @(x,y,z) sin(x+y+z) + x + y; % A function with different variable-ranks
f = chebfun3(ff, dom);
f2D = f(:, -3, :);
fChebfun2 = chebfun2(@(x,z) ff(x, -3, z), [dom(1:2) dom(5:6)]);
pass(34) = norm(fChebfun2 - f2D) < 100*tol;

% A function that has x-rank 1:
ff = @(x, y, z) cos(y + z).*sin(z).*exp(x);
f = chebfun3(ff, dom);
f2D = f(:, -3, :);
fChebfun2 = chebfun2(@(x, z) ff(x, -3, z), [dom(1:2) dom(5:6)]);
pass(35) = norm(fChebfun2 - f2D) < 100*tol;

% A function that has y-rank 1:
ff = @(x, y, z) cos(x + z).*sin(z).*exp(y);
f = chebfun3(ff, dom);
f2D = f(:, -3, :);
fChebfun2 = chebfun2(@(x, z) ff(x, -3, z), [dom(1:2) dom(5:6)]);
pass(36) = norm(fChebfun2 - f2D) < 100*tol;

% A function that has z-rank 1:
ff = @(x, y, z) cos(x + y).*sin(y).*exp(z);
f = chebfun3(ff, dom); 
f2D = f(:, -3, :);
fChebfun2 = chebfun2(@(x, z) ff(x, -3, z), [dom(1:2) dom(5:6)]);
pass(37) = norm(fChebfun2 - f2D) < 100*tol;

% Fixed z
%ff = @(x,y,z) sin(x+y+z);
ff = @(x,y,z) sin(x+y+z) + z + y; % A function with different variable-ranks
f = chebfun3(ff, dom);
f2D = f(:, :, 7);
fChebfun2 = chebfun2(@(x,y) ff(x, y, 7), dom(1:4));
pass(38) = norm(fChebfun2 - f2D) < 100*tol;

% A function that has x-rank 1:
ff = @(x, y, z) cos(y + z).*sin(z).*exp(x);
f = chebfun3(ff, dom);
f2D = f(:, :, 7);
fChebfun2 = chebfun2(@(x, y) ff(x,y, 7), dom(1:4));
pass(39) = norm(fChebfun2 - f2D) < 100*tol;

% A function that has y-rank 1:
ff = @(x, y, z) cos(x + z).*sin(z).*exp(y);
f = chebfun3(ff, dom);
f2D = f(:, :, 7);
fChebfun2 = chebfun2(@(x, y) ff(x, y, 7), dom(1:4));
pass(40) = norm(fChebfun2 - f2D) < 100*tol;

% A function that has z-rank 1:
ff = @(x, y, z) cos(x + y).*sin(y).*exp(z);
f = chebfun3(ff, dom);
f2D = f(:, :, 7);
fChebfun2 = chebfun2(@(x, y) ff(x, y, 7), dom(1:4));
pass(41) = norm(fChebfun2 - f2D) < 100*tol;

% Fixed x and y
ff = @(x,y,z) sin(x+y+z);
f = chebfun3(ff);
f1 = f(0.5, 0.5, :);
fChebfun = chebfun(@(z) sin(1+z));
pass(42) = norm(fChebfun - f1) < 100*tol;

% Fixed x and z
ff = @(x,y,z) sin(x+y+z);
f = chebfun3(ff);
f1 = f(0.5, :, 0.5);
fChebfun = chebfun(@(z) sin(1+z));
pass(43) = norm(fChebfun - f1) < 100*tol;

% Fixed y and z
ff = @(x,y,z) sin(x+y+z);
f = chebfun3(ff);
f1 = f(:, 0.5, 0.5);
fChebfun = chebfun(@(z) sin(1+z));
pass(44) = norm(fChebfun - f1) < 100*tol;

% No fixed variables
ff = @(x,y,z) sin(x+y+z);
f = chebfun3(ff);
fNew = f(:, :, :);
pass(45) = norm(fNew - f) < 100*tol;

%% Evaluate at parametric 1D chebfuns
f = chebfun3(@(x,y,z) x+y.*z);
curve = chebfun(@(t) [cos(t) sin(t) t/(8*pi)], [0, 8*pi]);
f1D = f(curve(:, 1), curve(:, 2), curve(:, 3));
fExact = curve(:, 1) + curve(:, 2).*curve(:, 3);
pass(46) = norm(fExact - f1D) < 100*tol;

end