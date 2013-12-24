#!/bin/bash

# Original command
# git "--git-dir" "git@gito.nexcel.vn:agency/fanex-age-ui.git" "-c" "core.quotepath=false" "-c" "log.decorate=no" "log" "--no-color" "--encoding=UTF-8" "--date=iso" "--pretty=fuller" "--no-merges" "-n" "1"

# set +v

redmine_git_repository=/usr/local/redmine_git_repository

# No parameters
if [ $# -eq 0 ]
then
  git
fi

# Perform creating directory and pull, then re-pass parameters with local git directory
if [ "$1" = "--git-dir" ]
then
  i=$(echo $2 | cut -d':' -f2)
  project_dir=$(echo $i | cut -d'/' -f1)
  repo_id=$(echo $i | cut -d'/' -f2)
  repo_dir=$(echo $repo_id | cut -d'.' -f1)
  
  # echo $project
  # echo $dir  
  
  
  if [ ! -d "$redmine_git_repository/$project_dir" ]
  then
    mkdir $redmine_git_repository/$project_dir
  fi  
  
  if [ ! -d "$redmine_git_repository/$project_dir/$repo_dir" ]
  then
    mkdir $redmine_git_repository/$project_dir/$repo_dir
    git clone $2 $redmine_git_repository/$project_dir/$repo_dir
  else
    cd $redmine_git_repository/$project_dir/$repo_dir
    git clean -df
    git checkout .
    git pull --quiet
  fi
  
  pass_parameters=$*
  local_dir=$redmine_git_repository/$project_dir/$repo_dir/.git
  resolve_parameters=$(echo ${pass_parameters//$2/$local_dir})
  
  git $resolve_parameters
  
# Re-pass all other parameters
else
  git $*
fi