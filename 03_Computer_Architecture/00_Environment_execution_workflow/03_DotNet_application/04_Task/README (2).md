# Task 4 — Background execution with log redirection

## Create and build
```bash
cd ~/dotnet-app
dotnet new console -n Task4Logging
cd Task4Logging
dotnet build
```
Replace `Program.cs` with this folder's source before building.

## Start
```bash
nohup dotnet bin/Debug/net10.0/Task4Logging.dll > application.log 2>&1 &
```
- `nohup` ignores SIGHUP.
- `>` redirects stdout (file descriptor 1) and replaces the log file.
- `2>&1` sends stderr (file descriptor 2) to the same destination as stdout.
- `&` starts a shell background job.

## Verify and view logs
```bash
pgrep -af Task4Logging
ls -lh application.log
tail -f application.log
```
Press `Ctrl+C` to stop `tail`; the application continues.

## Stop application
```bash
pgrep -af Task4Logging
kill <PID>
```
`nohup` does not restart a crashed process or configure boot startup.
