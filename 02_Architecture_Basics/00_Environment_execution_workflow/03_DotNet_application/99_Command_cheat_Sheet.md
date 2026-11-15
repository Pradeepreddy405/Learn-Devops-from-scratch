# 1. Check .NET
dotnet --version

# 2. Create directory
mkdir -p ~/dotnet-app

# 3. Navigate
cd ~/dotnet-app

# 4. Create application
dotnet new console -n HelloWorld

# 5. Navigate into project
cd HelloWorld

# 6. View source code
cat Program.cs

# 7. Execute application
dotnet run