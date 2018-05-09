a = find(testlabels ==1);
class1 = pred(a);
a = find(testlabels ==2);
class2 = pred(a);
a = find(testlabels ==3);
class3 = pred(a);
a = find(testlabels ==4);
class4 = pred(a);
a = find(testlabels ==5);
class5 = pred(a);
clear a
nn = numel(find(class1 == 1));
ns = numel(find(class1 == 2));
nv = numel(find(class1 == 3));
nf = numel(find(class1 == 4));
nq = numel(find(class1 == 5));
n = [nn ns nv nf nq];
clear nn ns nv nf nq

sn = numel(find(class2 == 1));
ss = numel(find(class2 == 2));
sv = numel(find(class2 == 3));
sf = numel(find(class2 == 4));
sq = numel(find(class2 == 5));
s = [sn ss sv sf sq];
clear sn ss sv sf sq

vn = numel(find(class3 == 1));
vs = numel(find(class3 == 2));
vv = numel(find(class3 == 3));
vf = numel(find(class3 == 4));
vq = numel(find(class3 == 5));
v = [vn vs vv vf vq];
clear vn vs vv vf vq

fn = numel(find(class4 == 1));
fs = numel(find(class4 == 2));
fv = numel(find(class4 == 3));
ff = numel(find(class4 == 4));
fq = numel(find(class4 == 5));
f = [fn fs fv ff fq];
clear fn fs fv ff fq

qn = numel(find(class5 == 1));
qs = numel(find(class5 == 2));
qv = numel(find(class5 == 3));
qf = numel(find(class5 == 4));
qq = numel(find(class5 == 5));
q = [qn qs qv qf qq];
clear qn qs qv qf qq


