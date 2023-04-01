#This script will inspect a designated directory for files (Movies / TV Shows) that are formatting properly for Synology's Video Station, if any files are found which are NOT formatted properly the script will prompt the user if you'd like to rename them. 
#To use this tool run the script then input your target directory into the prompt and the designated content type (Movie or TV Show). Synology requires the format for proper indexing and catagorization of content: TV_Show_Name.SXX.EYY.ext or Movie_Name (Release_Year).ext

#Variables used to prompt the user for input using the promptforchoice method. 
$title    = 'Confirm Selection'
$question = 'Your input was printed to the screen, do you want to continue?'
$choices  = '&Yes', '&No'

#Clears the screen before prompting the user. 
Clear-Host

#User input location of the media center, I reccomend doing a few TV shows at a time rather than your entire library at once.
$DIR = Read-Host "Network location of your media server. EX: \\NAS\Movies\" -AsSecureString
$DIR2string = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DIR))
write-host "Media server location: $DIR2string" -ForegroundColor Cyan -BackgroundColor Black

#Prompts user if they would like to continue after inputting the media center location. 
$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    Write-Host ''
} else {
    exit
}

#User input content type by chooseing between "tv" or "movies". This allows for proper filtering and renaming.
$ContentType = Read-Host "Which media type is this? EX: movie or tv" -AsSecureString
$contenttype2string = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($ContentType))
write-host "Content type: $contenttype2string" -ForegroundColor Cyan -BackgroundColor Black

#Prompts user if they would like to continue after inputting the content type. 
$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    Write-Host ''
} else {
    exit
}

#Evaluates user input then runs checks based on designated content type, checks the users directory input for any already properly formmated files, these will be skipped in the renaming as they are already correct, this is also used at the end to ensure all files were properly renamed. 
If($contenttype2string.ToLower() -like "movie") {
    Write-Host "Inspecting current formatting of movies.." -ForegroundColor Cyan -BackgroundColor Black
    Write-Host ""
    $MovieCorrect = Get-ChildItem $DIR2string -Recurse | Where-Object {($_.Name -like "*(????)*")} | Select-Object Name 
    
    If($MovieCorrect -like "*") {
    Write-Host "The following movies are already formatted correctly: " -ForegroundColor Green -BackgroundColor Black

        $MovieCorrect | ForEach-Object{
        Write-host "Name = $($_.name)" -ForegroundColor Green -BackgroundColor Black
        }
    }
}
elseif($contenttype2string.ToLower() -like "tv") {
    Write-Host "Inspecting current formatting of tv shows.." -ForegroundColor Cyan -BackgroundColor Black
    Write-Host ""
    $TVCorrect = Get-ChildItem $DIR2string -Recurse | Select-Object Name | Where-Object {($_.name -like "*.S??.*") -and ($_.name -like "*.E??.*")}
    
    
    If($TVCorrect -like "*") {
    Write-Host "The following TV shows are already formatted correctly: " -ForegroundColor Green -BackgroundColor Black

        $TVCorrect | ForEach-Object{
        Write-host "Name = $($_.name)" -ForegroundColor Green -BackgroundColor Black
        }
    }
}
else {
    Throw "Content type is not movie or tv, please re-run the script..." 
    Break 
}
