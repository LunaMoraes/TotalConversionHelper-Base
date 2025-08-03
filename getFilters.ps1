# --- Configuration ---
# The path to your mod folder.
$modPath = "C:\Users\PICHAU\Documents\Paradox Interactive\Crusader Kings III\mod\TotalConversionHelper-Base"
# The path to the base game installation.
$baseGamePath = "C:/Jogos/Crusader Kings 3" # Using forward slash for Sublime compatibility

# --- Script Logic ---
# A list of folders that are typically inside the game's main /game/ directory.
$gameSubFolders = @('common', 'decisions', 'dlc', 'dlc_metadata', 'documentation', 'events', 'gfx', 'gui', 'history', 'jomini', 'localization', 'map_data', 'music', 'pdx_launcher', 'shaders', 'sound', 'tests', 'tools', 'tweakergui_assets', 'virtual_filesystem')

# Generate the list of files to exclude from the base game search.
$exclusions = Get-ChildItem -Path $modPath -Recurse -File | ForEach-Object {
    # Get the file's path relative to the mod's root folder.
    $relativePath = $_.FullName.Substring($modPath.Length).TrimStart('\').Replace('\','/')
    
    # Check if the file belongs in a /game/ subfolder.
    $firstDir = ($relativePath -split '/')[0]
    
    if ($gameSubFolders -contains $firstDir) {
        # Create a filter for a file inside the /game/ directory.
        "-*/game/$relativePath*"
    } else {
        # Create a filter for a file in the root directory (like descriptor.mod).
        "-*/$relativePath*"
    }
}

# --- Output ---
# Construct the final string:
# 1. Search the base game path.
# 2. Search the mod path.
# 3. Apply all the exclusion filters.
$modPathForSearch = $modPath.Replace('\', '/') # Ensure mod path uses forward slashes for search
$finalString = "$baseGamePath, $modPathForSearch, " + ($exclusions -join ", ")

# Pipe the final string to the clipboard.
$finalString | Set-Clipboard

# Give the user feedback that the script is done and the result is on the clipboard.
Write-Host "Sublime Text filter string has been copied to your clipboard."
Write-Host "It will now search both the base game AND your mod folder."
# This line keeps the PowerShell window open for a few seconds to see the message.
Start-Sleep -Seconds 4