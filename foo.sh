for i in `find . -name "*.rhtml"`
 do
    mv "$i" "${i%.rhtml}.html.erb"
 done
