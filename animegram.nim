import os, osproc, strutils

proc capitalize(s: string): string =
  if s.len == 0:
    return s
  return s[0].toUpperAscii & s[1..^1].toLowerAscii


# Function to format the filename into a displayable anime name
proc formatAnimeName(filename: string): string =
  # Removing file extension
  let nameWithoutExt = filename.replace(".mp4", "")
  # Splitting the name on underscores
  let words = nameWithoutExt.split('_')
  
  # Create an empty sequence for capitalized words
  var capitalizedWords: seq[string]
  
  # Capitalize each word and add it to the sequence
  for word in words:
    capitalizedWords.add(word.capitalize())
  
  # Join the capitalized words with spaces and return
  return capitalizedWords.join(" ")


proc editVideo(srcDir: string, destDir: string) =
  # Check if the source directory exists
  if not dirExists(srcDir):
    echo "Source directory does not exist!"
    return

  # Create the destination directory if it doesn't exist
  if not dirExists(destDir):
    createDir(destDir)

  # Iterate over each file in the source directory
  for video in walkFiles(srcDir & "/*.mp4"):
    let videoName = extractFilename(video)
    let outputVideo = destDir & "/" & videoName

    # Formatting the anime name from filename
    let animeName = formatAnimeName(videoName)

    # FFmpeg command with drawtext filter for the formatted anime name
    let cmd = "ffmpeg -i " & video & " -vf \"scale=720:-1,pad=720:1280:(ow-iw)/2:(oh-ih)/2,drawtext=text='" & animeName & "':fontsize=24:fontcolor=white:x=w-tw-10:y=h-th-10\" -c:a copy " & outputVideo

    # Execute the command
    let result = execCmd(cmd)

    if result != 0:
      echo "Error processing: ", videoName
    else:
      echo "Processed: ", videoName

# Main function
when isMainModule:
  editVideo("source_directory", "uploads")
