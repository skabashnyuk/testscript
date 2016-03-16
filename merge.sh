rm -rf codenvy_merge
mkdir codenvy_merge
cd codenvy_merge
git init
wget https://raw.githubusercontent.com/codenvy/onpremises/master/.gitignore
git add .gitignore
git commit -m "Init ignore"
echo "Start merging"
 PLIST=("hosted-infrastructure" "plugins" "factory" "odyssey" "dashboard" "analytics" "platform-api-client-java" "cli" "cdec" "onpremises")
# PLIST=("hosted-infrastructure" "plugins")
for project in ${PLIST[@]}; do
  echo "Merging $project"
  git remote add -f $project git@github.com:codenvy/$project.git
  git merge -s ours --no-commit $project/master
  git read-tree --prefix=$project/ -u $project/master
  git rm -f $project/.gitignore
  git commit -m "Subtree merged in $project"
  echo "Merging $project complete"
done
git mv onpremises/ assembly/
git commit -m "Moving onpremises ot assembly folder"
curl https://gist.githubusercontent.com/skabashnyuk/dfa0a04f09152c311220/raw/24f261ecb156ee835d2e7239dfe8e4a6479b9d4c/gistfile1.txt | git apply -v --index
