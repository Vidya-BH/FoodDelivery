$url = "https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip"
$zip = "C:\FoodDelivery\maven.zip"
$dest = "C:\FoodDelivery"

Write-Output "Downloading portable Maven from official Apache servers..."
Invoke-WebRequest -Uri $url -OutFile $zip

Write-Output "Extracting files to C:\FoodDelivery\maven..."
Expand-Archive -Path $zip -DestinationPath $dest

Write-Output "Finalizing folder structure..."
Rename-Item -Path "C:\FoodDelivery\apache-maven-3.9.6" -NewName "maven"
Remove-Item $zip

Write-Output "Local Maven setup is complete!"
