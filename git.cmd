@ECHO OFF

setlocal enabledelayedexpansion

:: Original command
::"C:\Program Files (x86)\Git\cmd\git.exe" "--git-dir" "git@gito.nexcel.vn:agency/fanex-age-ui.git" "-c" "core.quotepath=false" "-c" "log.decorate=no" "log" "--no-color" "--encoding=UTF-8" "--date=iso" "--pretty=fuller" "--no-merges" "-n" "1"


SET git_cmd="C:\Program Files (x86)\Git\cmd\git.exe"
SET redmine_dir=D:\workspace\redmine
SET redmine_git_repository="D:\workspace\redmine_git_repository"

ECHO %* >> "%redmine_git_repository%\git.log

IF "%1"=="" (
  %git_cmd%
  goto END
)

IF %1=="--git-dir" (

   for /f "tokens=1,2,3,4 delims=:" %%a in (%2) do set g=%%a&set i=%%b

   for /f "tokens=1,2,3,4 delims=/" %%a in ("!i!") do set project=%%a&set repo=%%b

   for /f "tokens=1,2,3,4 delims=." %%a in ("!repo!") do set dir=%%a&set ext=%%b


   IF "!dir!"=="" (
     goto END
   )

   IF not exist "%redmine_git_repository%\!project!" mkdir "%redmine_git_repository%\!project!"
   IF not exist "%redmine_git_repository%\!project!\!dir!" (
      mkdir "%redmine_git_repository%\!project!\!dir!"
      %git_cmd% clone %2 "%redmine_git_repository%\!project!\!dir!"
   )

   IF "%7"==""branch"" (
      D:
      cd "%redmine_git_repository%\!project!\!dir!"
      %git_cmd% fetch     
   )

   SET git_parameters=%*
   CALL SET git_parameters=%%git_parameters:%2="!redmine_git_repository!\!project!\!dir!\.git"%%
   %git_cmd% !git_parameters!
 

) else (
  %git_cmd% %*
)

:END

endlocal
