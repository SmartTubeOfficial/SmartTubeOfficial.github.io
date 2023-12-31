@echo off

REM http://joseoncode.com/2011/11/27/solving-utf-problem-with-jekyll-on-windows/
chcp 65001

cd /d "%~dp0"
REM rmdir _site /s /q
call jekyll build
copy /y README.md.gen _site\README.md
REM git --git-dir=.git --work-tree=_site add --all
REM git --git-dir=.git --work-tree=_site commit -m "autogen: update site"
REM git --git-dir=.git --work-tree=_site push

for %%s in ("git@github.com:SmartYouTubeTV/SmartYouTubeTV.github.io.git" "git@github.com:SmartTubeNext/SmartTubeNext.github.io.git" "git@github.com:SmartTubeOfficial/SmartTubeOfficial.github.io.git") do call :publishSite %%s

goto End

:publishSite
	set REPO=%1

	echo.
	echo Publishing %REPO%...
	echo.

	pushd _site

	git init
	git remote rm origin
	git remote add origin %REPO%
	git add -A
	git commit -m "autogenerated content"
	REM f - force overwrite remote repo
	git push -f origin master

	popd

	REM new branch: sources

	git init
	git remote rm origin
	git remote add origin %REPO%
	git checkout -b sources
	git add -A
	git commit -m "autogenerated content"
	git push -f --set-upstream origin sources
goto :eof

:End

pause