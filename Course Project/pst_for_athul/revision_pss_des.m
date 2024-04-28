clear all; close all; clc; 

run('svm_mgen'); 

gidx = 2; 
a=a_mat; b=b_vr(:,gidx); c=c_p(gidx,:); d=0;

%rot_idx = sort([ang_idx;ang_idx+1])
%pause

[tw,t1,t2,t3,t4] = pss_des(a,b,c,d);