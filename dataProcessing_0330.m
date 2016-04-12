P_L_tC = 10.^(S21/10);
rs = rsr + rsx.*1i;
P_avs_u = abs(1-rs).^2;
P_avs_d = 1 - abs(rs).^2;
P_avs_tc = P_avs_u./P_avs_d;
Gt = P_L_tC./P_avs_tc;
Gt_db = 10.*log10(Gt);
scatter3(rsr,rsx,Gt_db);
%%
rin = 0.1617+1i*0.228;
pop_u = (abs(1-rs1).^2).*(abs(1-rs2*rin).^2);
pop_d = (abs(1-rs2).^2).*(abs(1-rs1*rin).^2);
pop = pop_u./pop_d;
pop_db = 10.*log10(pop);
