deployed on heroku:
rubyhwhw.herokuapp.com/


Three branches:
1.heokutest --- fetch the record pushed from the remote repo called heroku
2.test --- fetch the record the last second repo from master branch 
3.master --- original local repo


._
1. git fetch heroku --- download the last post from the remote repo heroku;
   git merge ---used to merge different people's work together with yours; 
   git pull ---- a combination of fetch and merge;
._/n
2.fetch the record the last second repo from master branch, saved in a newly created branch called test:
git checkout HEAD~2 -b test;
push this photo record to my repo page, under brance test
git push origin test 
