# Task 2 — Foreground execution

## Create
```bash
cd ~/dotnet-app
dotnet new console -n Task2Foreground
cd Task2Foreground
```
Replace `Program.cs` with this folder's source.

## Build and run
```bash
dotnet build
dotnet run
```
The program prints a timestamp every five seconds. The terminal remains occupied.

## Stop
Press `Ctrl+C`. The terminal sends an interrupt to the foreground process.

## Why
`while (true)` repeats; `Console.WriteLine` writes to stdout; `Thread.Sleep` pauses for five seconds. Foreground execution keeps the command attached to your terminal.

Optional process check from another SSH session:
```bash
pgrep -af Task2Foreground
```
