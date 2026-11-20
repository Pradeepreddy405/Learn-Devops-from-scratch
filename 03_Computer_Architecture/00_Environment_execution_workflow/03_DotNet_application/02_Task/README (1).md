# Task 3 — Background execution

## Create and build
```bash
cd ~/dotnet-app
dotnet new console -n Task3Background
cd Task3Background
dotnet build
```
Replace `Program.cs` with this folder's source before building.

## Start in background
```bash
dotnet bin/Debug/net10.0/Task3Background.dll &
```
`&` asks the shell to run the command as a background job, returning the prompt.

## Verify
```bash
jobs -l
pgrep -af Task3Background
ps -ef | grep '[T]ask3Background'
```
Output still goes to the terminal and may mix with commands.

## Stop
```bash
pgrep -af Task3Background
kill <PID>
```
Use the actual PID. `&` does not provide restart-on-crash or boot startup, and session logout may affect the job.
