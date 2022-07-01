# Explore-Paths

Get-Command -Noun Path

Split-Path $profile
Split-Path -Path $profile
Split-Path -Parent $profile
Split-Path -Leaf $profile

Test-Path $profile

Test-Path C:\nonexistentpath

Join-Path C:\win* System* -Resolve

Join-Path C:\temp foo
