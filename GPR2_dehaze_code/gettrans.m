function [pre_y1,pre_y2,variance_y1,variance_y2]=gettrans(local_stru,local_var,pre_trans2,pre_var2);
pre_y1=local_stru(:,9);
pre_y2=pre_trans2(:,9);
variance_y1=local_var/255;
variance_y1=variance_y1/255;
variance_y2=pre_var2';


