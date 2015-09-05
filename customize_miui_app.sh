#/bin/bash

XMLMERGYTOOL=$PORT_ROOT/tools/ResValuesModify/jar/ResValuesModify
GIT_APPLY=$PORT_ROOT/tools/git.apply

curdir=`pwd`

function applyPatch () {
    for patch in `find $1 -name *.patch`
    do
        cd out
        $GIT_APPLY ../$patch
        cd ..
        for rej in `find $2 -name *.rej`
        do
            echo "Patch $patch fail"
            exit 1
        done
    done
}

function appendSmaliPart() {
    for file in `find $1/smali -name *.part`
    do
		filepath=`dirname $file`
		filename=`basename $file .part`
		dstfile="out/$filepath/$filename"
        cat $file >> $dstfile
    done
}

function mergyXmlPart() {
	for file in `find $1/res -name *.xml.part`
	do
		src=`dirname $file`
		dst=${src/$1/$2}
		$XMLMERGYTOOL $src $dst
	done
}


if [ $1 = "MiuiHome" ];then
    $XMLMERGYTOOL $1/res/values $2/res/values
fi


if [ $1 = "Settings" ];then
	$XMLMERGYTOOL $1/res/values $2/res/values
	$XMLMERGYTOOL $1/res/values-zh-rCN $2/res/values-zh-rCN
	$XMLMERGYTOOL $1/res/values-zh-rTW $2/res/values-zh-rTW
	applyPatch $1 $2
fi

if [ $1 = "TelephonyProvider" ];then
	applyPatch $1 $2
fi

if [ $1 = "QuickSearchBox" ];then
	applyPatch $1 $2
fi

if [ $1 = "MiuiSystemUI" ];then
	$XMLMERGYTOOL $1/res/values $2/res/values
	$XMLMERGYTOOL $1/res/values-zh-rCN $2/res/values-zh-rCN
	$XMLMERGYTOOL $1/res/values-zh-rTW $2/res/values-zh-rTW
	appendSmaliPart $1
fi

if [ $1 = "Phone" ];then
    $XMLMERGYTOOL $1/res/values $2/res/values
    $XMLMERGYTOOL $1/res/values-zh-rCN $2/res/values-zh-rCN

    cp $1/phone.patch out/
    cp $1/LTE.patch out/
    cp $1/preferred_network_type_ltew.patch out/
    cd out
    $GIT_APPLY phone.patch
    $GIT_APPLY LTE.patch
    $GIT_APPLY preferred_network_type_ltew.patch
    cd ..
    for file in `find $2 -name *.rej`
    do
echo "Phone patch done"
        exit 1
    done

fi
