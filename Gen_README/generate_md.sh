#!/usr/bin/env bash

if [ $DEBUG_MODE = 0 ];then
   set -u
else 
   set -uex
fi

git config --global user.name "Kazanami"
git config --global user.email ${GITH_EMAIL}
REMOTE_GIT="https://github.com/Kazanami/zeus-bucket"
REMOTE_RAW="https://raw.githubusercontent.com/Kazanami/zeus-bucket/master/bucket"
REMOTE_BUCKET="${REMOTE_GIT}/blob/master/bucket"
LOCAL_WORK=`dirname ${PWD}`
LOCAL_BUCKET="${LOCAL_WORK}/bucket"
README_TEMPLATE="${PWD}/template"
COMMIT_MSG="README: Update README List"

function manifest_check(){
  # git log --pretty=format:%h -2
  COMMIT_HASH=`git log --pretty=format:%h -2`
  BEFORE=`echo ${COMMIT_HASH} | cut -d " " -f 1` >> /dev/null
  AFTER=`echo ${COMMIT_HASH} |  cut -d " " -f 2` >> /dev/null
  
  git diff $BEFORE $AFTER --relative=bucket --exit-code --name-only
  #git diff HEAD --relative=bucket --exit-code --name-only
  echo $?
}


function main(){
# git diff HEAD --relative=bucket --exit-code --name-only
 MAN_CHECK=$(manifest_check)
 if [ $MAN_CHECK == 0 ];then
    echo "No Update"
    return 0;
 else 
    echo "Update README.md"
 fi
 Generate "en"
 Generate "ja"
 cd ../
 git add .
 git commit -m "${COMMIT_MSG}"
 git push
}

function Encode_URL() {
  echo "${1}" | nkf -WwMQ | tr = % | tr -d "\n" | sed -e "s/%2E/\./g" \
                                                      -e "s/%2D/\-/g" \
                                                      -e "s/%2F%master/%2Fmaster/g"
}


echo "Generating README.md ..."

function Generate() {
README_TEMP=$(tempfile)

echo "Getting Files..."
MANIFEST=`ls -1 ${LOCAL_BUCKET} | grep -v ".bak"`


cat ${README_TEMPLATE}/${1}/Header.md >> ${README_TEMP}
cat ${README_TEMPLATE}/List_Header.md >> ${README_TEMP}

for f in ${MANIFEST};do
  Package_Name=${f%.*}
  Package_desc=`jq -r .description "${LOCAL_BUCKET}/${f}"`
  Manifest_URL="${REMOTE_BUCKET}/${f}"
  Enc_Manifest_URL=$(Encode_URL ${REMOTE_RAW}/${f})
  eval "echo \"$(eval cat ${README_TEMPLATE}/List_Body.md)\"" >> ${README_TEMP}
# \
#    sed -e "s@Package\_Name@${Package_name}@" \
#        -e "s@Package\_desc@${Package_desc}@" \
#        -e "s@Manifest\_URL@${Manifest_URL}@" \
#        -e "s@Enc\_Manifest\_URL@${Enc_Manifest_URL}@"
done

cat ${README_TEMPLATE}/${1}/Footer.md >> ${README_TEMP}

if [[ ${1} = "en" ]];then
  mv ${README_TEMP} ../README.md
else
  mv ${README_TEMP} ../README_${1^^}.md
fi

echo "Generate README.md Finished."
}

main
