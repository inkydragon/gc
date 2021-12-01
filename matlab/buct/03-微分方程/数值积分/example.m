clear;
for n = 1:1:13
    h(n)  = 1/8^(n-1);
    df(n) = (sqrt(2+h(n))-sqrt(2-h(n)))/2/h(n);
    exact_df(n) = 1/2/sqrt(2);
end
'-------------h------------- df------------exact_df'
vpa([h',df',exact_df'],8)