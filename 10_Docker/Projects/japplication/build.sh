#!/bin/bash
mkdir -p out
javac -cp "lib/*" -d out src/com/example/app/*.java
echo "Build complete. To run: java -cp 'out:lib/*' com.example.app.Main"
