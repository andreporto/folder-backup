#!/bin/bash
source=$1
target=$2
custom_password=$3
backup_date=$(date +%F)
folder="$source-$backup_date"
key="REPLACE-THIS-TEXT-WITH-YOUR-REAL-PASSWORD-IN-DOUBLE-QUOTES"

if [ ! $source ]; then
	echo ------------------------------------------------------------------------------------------
	echo USAGE:
	echo 	folder-backup \'SOURCE_FOLDER\' [\'TARGET FOLDER NAME\'] [\'CUSTOM PASSWORD\']
	echo ------------------------------------------------------------------------------------------
	echo \* \'SOURCE_FOLDER\' IS THE SOURCE FOLDER NAME TO BACKUP, IT CAN CONTAINS FILES AND SUB-FOLDERS
	echo \* IF NO TARGET FOLDER IS ENTERED IT WILL BE CREATED A SOURCE_FOLDER + DATE NAMED FOLDER
	echo \* folder-backup.key FILE CONTENT WILL BE THE ENCRYPTION KEY FOR ALL BACKUP FILES IF NO CUSTOM PASSWORD INFORMED
	echo \* OPTIONALLY YOU CAN ENTER A [CUSTOM PASSWORD]
	echo \* \"REPLACE-THIS-TEXT-WITH-YOUR-REAL-PASSWORD-IN-DOUBLE-QUOTES\" IS THE DEFAULT PASSWORD AND YOU CAN CHANGE IT.
	echo ------------------------------------------------------------------------------------------

	exit
fi

# It must exists backup.key file with password inside
if [ ! -s $source ]; then
	echo ----------------------------------------
	echo ERROR: BACKUP SOURCE FOLDER $source NOT FOUND\!\!
	echo ----------------------------------------

	exit	
fi

# If [CUSTOM PASSWORD] informed override folder-backu.key file
if [ $custom_password ]; then
	echo "Using custom password to encrypt backup files..."
	key=$custom_password
else
	echo "Using default password..."
fi

echo "STARTING $source BACKUP TO $folder FOLDER"

# If has target use it insted default folder
if [ $target ]; then
	folder=$target
fi

# Make backup folder
if [ ! -s $folder ]; then
	mkdir -p $folder
fi

# Zip files in source folder
find $source -maxdepth 1 -mindepth 1 -type f -execdir zip -e -P $key -r {}.zip {} \;

# Zip folders in source folder
find $source -maxdepth 1 -mindepth 1 -type d -execdir zip -e -P $key -r {}.zip {} -x "*node_modules*" -x "*.DS_Store*" \;

#Move all zip files to target folder
mv $source/*zip $folder/

# Make unzip script
echo '#!/bin/bash' > "$folder/restore.sh"
echo 'target=./' >> "$folder/restore.sh"
echo 'if [ $1 ]; then ' >> "$folder/restore.sh"
echo 'target=$1' >> "$folder/restore.sh"
echo 'fi' >> "$folder/restore.sh"
echo 'find . -type f -exec unzip -d $target -P '$key' {} \;' >> "$folder/restore.sh"
chmod +x "$folder/restore.sh"

echo "--- END OF $1 BACKUP ---"
