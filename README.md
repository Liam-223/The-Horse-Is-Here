# Changes your wallpaper every x amount of time

# Disclaimer
- I haven't tested it on any Windows version below Windows 11 25H2
- So sorry if this is formatted weird :P
- Sorry if it's explained weirdly, if you have any problems don't hesitate to ask me over my various socials

# Showcase
https://www.youtube.com/watch?v=20livPTfE_U


# How To Set It Up
## 1. - Download the Project

## 2. - Drop the Project wherever you want

## 3. - Running it
### 3.1 
- I recommend the Task Scheduler to run the programm
- Open Task Scheduler
- Action -> Create Task
- General tab:
    ```sh
    -> Name = xyz
    -> Check others how you like, doesn't matter
    -> Click OK
    ```
- Triggers tab: 
    ```sh
    -> Click New
    -> Begin the task: At log on
    -> Make sure your user is selected, or all if you want that
    -> Click OK
    ```
- Actions tab: 
    ```sh
    -> Click New
    -> Action: Start a program
    -> Program/script: powershell.exe (just type it in like that)
    -> Add arguments: -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "PUT THE PATH TO YOUR ps1 HERE" 
    (example: "C:\Users\TestUser\Documents\Wallpaper\randomWallpaper.ps1")
    -> Click OK
    ```
Finally click OK to save the task.
Now log out and back in (or reboot). Your wallpaper should start changing.
### 3.2
- Just go to the ps1 file and execute it via right click -> Run with Powershell

## 4. - Killing it
### 4.1 
- Stop/Delete it via the Task Scheduler (This CAN be temporary if you only disable it or stop it for this session)
### 4.2
- Kill the powershell programm in the task manager (This IS temporary because you only end the powershell programm running this)


# How To Configure It
- Small Disclaimer: VS Code is not needed but it's nice to edit code
- https://code.visualstudio.com/download
- Change assets in "assets" to your liking

Make sure to change the file names at the top of the script if you change the files (I am to stupid to make it look for them automaticly)
```sh
$images = @(
    (Join-Path $assetsDir 'version1.png'),
    (Join-Path $assetsDir 'version2.png'),
    (Join-Path $assetsDir 'version3.png')
)
```

- Change min-/maxTime at the top of the script to change the random time in wich the wallpaper changes (it's in seconds)

- The sound system works like that:
- Choose a random new wallpaper -> check name -> check if there is an audio file with the same name -> if yes, play that

- Audio types that are supported: "wav"
- Image types that are supported: ".png", ".jpg", ".jpeg", ".bmp"


# Credits
- Me (Liam)
- That guy that made this really cool base wallpaper (i seriously use it on like EVERY device)




- Any feedback is highly welcome!