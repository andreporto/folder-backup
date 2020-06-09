#!/bin/bash
source=$1
target=$2
custom_password=$3
backup_date=$(date +%F)
folder="$source-$backup_date"
key_file_name=folder-backup.key
key=""

if [ ! $source ]; then
	echo ------------------------------------------------------------------------------------------
	echo USAGE:
	echo 	folder-backup \'SOURCE_FOLDER\' [\'TARGET FOLDER NAME\'] [\'CUSTOM PASSWORD\']
	echo ------------------------------------------------------------------------------------------
	echo \* \'SOURCE_FOLDER\' IS THE SOURCE FOLDER NAME TO BACKUP, IT CAN CONTAINS FILES AND SUB-FOLDERS
	echo \* folder-backup.key FILE CONTENT WILL BE THE ENCRYPTION KEY FOR ALL BACKUP FILES IF NO CUSTOM PASSWORD INFORMED
	echo \* OPTIONALLY YOU CAN ENTER A [CUSTOM PASSWORD] TO OVERRIDE backup.key FILE USAGE
	echo ------------------------------------------------------------------------------------------

	exit
fi

# It must exists backup.key file with password inside
if [ ! -s $1 ]; then
	echo ----------------------------------------
	echo ERROR: BACKUP SOURCE FOLDER $1 NOT FOUND\!\!
	echo ----------------------------------------

	exit	
fi

# It must exists backup.key file with password inside
if [ -s $key_file_name ] && [ ! $custom_password ]; then
	echo "Using backup.key file to get backup encryption password..."
	key=`cat $key_file_name`
fi

# If [CUSTOM PASSWORD] informed override folder-backu.key file
if [ $custom_password ]; then
	echo "Using custom password to encrypt backup files..."
	key=$custom_password
fi

# If there is no key, trow an error and exit
if [ ! $key ]; then
	echo ---------------------------------------------------------------------------------------
	echo ERROR: IT\'S NECESSARY backup.key FILE OR A CUSTOM PASSWORD TO MAKE BACKUP MORE SECURE
	echo ---------------------------------------------------------------------------------------

	exit
fi

echo "STARTING $1 BACKUP TO $folder FOLDER"

# If has target use it insted default folder
if [ $target ]; then
	folder=$target
fi

# Make backup folder
mkdir $folder

# Zip files in source folder
find $1 -maxdepth 1 -mindepth 1 -type f -exec zip -e -P $key -r {}.zip {} \;

# Zip folders in source folder
find $1 -maxdepth 1 -mindepth 1 -type d -exec zip -e -P $key -r {}.zip {} -x "*node_modules*" \;

# Move zip files to target folder
mv $1/*zip "$folder/"
mv $1/.*zip "$folder/"

# Make unzip script
echo "find . -type f -exec unzip -P '$key' {} \;" > "$folder/restaurar.sh"
chmod +x "$folder/restaurar.sh"

echo "END OF $1 BACKUP"
