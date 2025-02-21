Write-Host "Building Flutter web app..."
flutter build web --web-renderer canvaskit --no-tree-shake-icons

Write-Host "Copying extension manifest..."
Copy-Item -Path "manifest.json" -Destination "build/web/manifest.json" -Force

Write-Host "Copying icons..."
if (Test-Path "icons") {
    Copy-Item -Path "icons" -Destination "build/web" -Recurse -Force
}

Write-Host "Build complete! Load the extension from the build/web directory."
