![GitHub repo size](https://img.shields.io/github/repo-size/andreporto/folder-backup) ![Last commit](https://img.shields.io/github/last-commit/andreporto/folder-backup)

# Simple shell script to make encrypted folder backup 
## Backup:
<img src="demo/demo-backup.gif">


## Restore:
<img src="demo/demo-restore.gif">


## Usage

---
```shell
folder-backup.sh "SOURCE_FOLDER" ["TARGET FOLDER NAME"] ["CUSTOM PASSWORD"]
```
---
* "SOURCE_FOLDER" IS THE SOURCE FOLDER NAME TO BACKUP, IT CAN CONTAINS FILES AND SUB-FOLDERS
* folder-backup.key FILE CONTENT WILL BE THE ENCRYPTION KEY FOR ALL BACKUP FILES IF NO CUSTOM PASSWORD INFORMED
* OPTIONALLY YOU CAN ENTER A [CUSTOM PASSWORD] TO OVERRIDE backup.key FILE USAGE
---

### Examples:


- Zip all files and sub-folders from MyFolder to a new folder named with MyFolder-YYYY-MM-DD pattern. All zip files will be encrypted with folder-backup.key file content as password
```shell
./folder-backup.sh MyFolder
```
---

- Zip all files and sub-folders from MyFolder to MySafeStorage folder. All zip files will be encrypted with folder-backup.key file content as password.
```shell
./folder-backup.sh MyFolder MySafeStorage
```
---

- Zip all files and sub-folders from MyFolder to MySafeStorage folder. All zip files will be encrypted with "MySecureKey123" password.
```shell
./folder-backup.sh MyFolder MySafeStorage MySecureKey123
```
---

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)
