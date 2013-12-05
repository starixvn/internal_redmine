@ECHO OFF

setlocal enabledelayedexpansion

:: Original command
::"C:\Program Files (x86)\Git\cmd\git.exe" "--git-dir" "git@gito.nexcel.vn:agency/fanex-age-ui.git" "-c" "core.quotepath=false" "-c" "log.decorate=no" "log" "--no-color" "--encoding=UTF-8" "--date=iso" "--pretty=fuller" "--no-merges" "-n" "1"

:: Test command
::D:\workspace\redmine\git.cmd "--git-dir" "git@gito.nexcel.vn:agency/fanex-age-ui.git" "-c" "core.quotepath=false" "-c" "log.decorate=no" "branch" "--no-color" "--verbose" "--no-abbrev"

IF "%1"=="" (
  %gitcmd%
  goto END
)

SET gitcmd="C:\Program Files (x86)\Git\cmd\git.exe"
SET redminedir=D:\workspace\redmine
SET redmine_git_dir="D:\workspace\redmine_git_dir"

IF %1=="--git-dir" (

   for /f "tokens=1,2,3,4 delims=:" %%a in (%2) do set g=%%a&set i=%%b

   for /f "tokens=1,2,3,4 delims=/" %%a in ("!i!") do set project=%%a&set repo=%%b

   for /f "tokens=1,2,3,4 delims=." %%a in ("!repo!") do set dir=%%a&set ext=%%b


   IF "!dir!"=="" (
     goto END
   )

   IF not exist "%redmine_git_dir%\!project!" mkdir "%redmine_git_dir%\!project!"
   IF not exist "%redmine_git_dir%\!project!\!dir!" (
      mkdir "%redmine_git_dir%\!project!\!dir!"
      %gitcmd% clone %2 "%redmine_git_dir%\!project!\!dir!"
   )

   IF "%7"==""branch"" (
      D:
      cd "%redmine_git_dir%\!project!\!dir!"
      %gitcmd% pull --quiet         
   )

   SET git_parameters=%*
   CALL SET git_parameters=%%git_parameters:%2="!redmine_git_dir!\!project!\!dir!\.git"%%
   %gitcmd% !git_parameters!
 

) else (
  %gitcmd% %*
)

:END

endlocal
