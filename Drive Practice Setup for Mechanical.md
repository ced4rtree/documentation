# Drive Practice Setup for Mechanical Students
## aka How To Get The Robot To Drive Without Being A Programmer

```java
// TODO intro
```

# Step 0: Login
1. Boot up the laptop.
2. Log in with the PIN of 2122.
3. Connect to a mobile hotspot.

# Step 1: Open the Robot Project
1. Open the "{this year} WPILib VS Code" (e.g. 2024 WPILib VS Code)
2. Check the top of the window:  
  [screenshot of said top of window]  
  If it has the [name of the robot you're working with](Robot%20Names.md), great. Otherwise, check File > Open Recent for the repo, else File > Open Folder and open whichever one of these paths exists:
    - `C:\Code\<robot name here>`
    - `C:\Users\senti\Code\<robot name here>`
    - `C:\Users\<other users>\Code\<robot name here>`  
  If none exist, it may not be on that laptop. Check the other one.

# Step 2: Fetch
1. Once you have the correct robot code open, press Ctrl-Shift-C to open a terminal.
2. Type `git fetch` into the terminal (at the bottom) and press Enter.
3. Check the output:
  - If it has `Could not resolve hostname`, make sure you're connected to the internet and try again.
  - If the last line is like `Unpacking objects: 100% (XX/XX), XX.XX KiB | X.XX MiB/s, done.`, you've successfully fetched. Continue to the next step.
  - If there was no output (if it just gave you another prompt), you're already up to date. Continue to the next step.

## Step 3: Select Tag
1. With the terminal still open, type in `git tag` and press Enter.