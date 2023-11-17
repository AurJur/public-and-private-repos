@echo off
set /p project_name=Enter project name (repo/directory name): 
set /p github_user=Enter your GitHub username: 
set /p local_user_name=Enter your local Git user name: 
set /p local_user_email=Enter your local Git user email: 

echo.
echo Creating a new directory for your project...
mkdir %project_name%
cd %project_name%

echo.
echo Initializing a new Git repository...
git init --initial-branch=public

echo.
echo Setting local user name and email...
git config user.name "%local_user_name%"
git config user.email "%local_user_email%"

echo.
echo Please ensure you have created two repositories on GitHub: %project_name%-public with branch "main" and %project_name%-private with branch "main".
set /p confirm=Have you created the required repositories? (Y/N):

if /i "%confirm%" neq "Y" (
    echo Exiting script. Please create the required repositories and run the script again.
    exit /b 1
)

echo.
echo Adding remote %project_name%-public to your local repo as "local-public"...
git remote add local-public git@github.com:%github_user%/%project_name%-public.git

echo.
echo Pulling to this branch from "local-public" remote's main branch...
git pull local-public main

echo.
echo Setting up tracking for this branch to pull changes from "local-public" remote's main branch...
git branch -u local-public/main

echo.
echo Creating branch "private", switching to it and cleaning the directory... 
git checkout --orphan private
git rm -rfq .
git clean -fdX

echo.
echo Adding remote %project_name%-private to your local repo as "local-private"...
git remote add local-private git@github.com:%github_user%/%project_name%-private.git

echo.
echo Pulling to this branch from "local-private" remote's main branch...
git pull local-private main

echo.
echo Setting up tracking for this branch to pull changes from "local-private" remotes's main branch...
git branch -u local-private/main
