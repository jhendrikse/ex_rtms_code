

indir = '/Users/alexfornito/Desktop/multiband/converted/';
subs = dir([indir,'*1008*']);

for i = 1:length(subs)
    
    master_script_testloop_mb(subs(i).name);
end
