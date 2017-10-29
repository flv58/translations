# @package    translations
# @copyright  (c) 2010-2017 Akeeba Ltd
# @license    GNU GPLv3 or, at your option, any later version published by the Free Software Foundation
#
# Create the language packages and publish them to S3
#

# Make sure BuildFiles is up-to-date
pushd ../buildfiles
git pull --all
composer install
popd

$pwd=Get-Location
$allArgs = "$args"

Get-ChildItem -Directory | ForEach-Object {
	$d = $_.Name
	$absoluteFolder = $pwd.Path + "\" + $d

	if (($d -eq "build") -or ($d -eq "_pages") -or ($d -eq "release") -or ($d -eq ".idea"))
	{
		return
	}

	Write-Host "Building " -Foreground Green -NoNewline
	Write-Host $d -Foreground Cyan

	# Create the output folder for this project
	$releaseFolder = $pwd.Path + "\release\" + $d
	Remove-Item -R $releaseFolder -EA SilentlyContinue
	New-Item $releaseFolder -ItemType Dir | Out-Null

	php ../buildfiles/tools/build-language.php -t $absoluteFolder -o $releaseFolder -d $allArgs
}