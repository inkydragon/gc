# background xref: https://github.com/git-for-windows/git/issues/2435#issuecomment-605035472
# sf ref: https://superuser.com/questions/958686/renaming-hidden-files-to-their-filename-sans-double-dot

for i in .*.png; do
# echo => eval to exec
echo "mv \"$i\" \"`echo "$i" | sed 's/^\.\\\\Figs\\\\//g'`\"";
# mv ".\Figs\DiskImpact_4801.png" "DiskImpact_4801.png"
done
