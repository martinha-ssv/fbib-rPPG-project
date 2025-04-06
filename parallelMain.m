fs = 60;

mu_n_1 = 0;
mu_s_n_1 = 0;
sigma_s_n_1 = 0;


parpool('Processes',1);
D = parallel.pool.DataQueue;
fig = figure('Visible','on');
afterEach(D,@postProcessing.processImg);
f = parfeval(@acquisition.getFrameFromCamera,0,D,fs);
pause(30);
cancel(f);