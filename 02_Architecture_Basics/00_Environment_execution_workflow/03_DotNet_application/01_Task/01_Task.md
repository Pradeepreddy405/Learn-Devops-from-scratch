# Task 1 — Hello World

## Create
```bash
mkdir -p ~/dotnet-app
cd ~/dotnet-app
dotnet new console -n Task1HelloWorld
cd Task1HelloWorld
```
Replace `Program.cs` with the source in this folder.

## Build and run
```bash
dotnet build
dotnet run
```
Expected:
```text
Hello World from .NET!
```

## Why
`dotnet new console` creates the project. `Program.cs` contains C# source. `dotnet build` compiles it into a .NET assembly. `dotnet run` builds if needed and starts it using the .NET runtime.

Inspect build files:
```bash
find bin -type f
```
