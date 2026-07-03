runHook preUnpack

mkdir $sourceRoot

for _src in $srcs; do
	if [[ -d "$_src"/bundles ]]; then
		cp -r "$_src"/bundles/* $sourceRoot
	else
		cp -r "$_src"/* $sourceRoot
	fi
done

chmod -R u+w $sourceRoot

if ! [[ -z $zippedSourceProjectsStr ]]; then
	for project in $zippedSourceProjectsStr; do
		echo '<?xml version="1.0" encoding="UTF-8"?><classpath><classpathentry path="src" kind="src"/></classpath>' > $sourceRoot/$project/.classpath
		mkdir $sourceRoot/$project/src
		(
			cd $sourceRoot/$project/src
			unzip ../*src.zip
			rm -rf org/osgi/service/{jini,io,http}
		)
	done
fi

IFS=$'\n'
for srcFile in $(find . -type f -name '*.java'); do
	# Can i avoid iconv'ing _everything_?
	(iconv -f cp1250 -t utf8 "$srcFile" || continue) | sponge "$srcFile" &
done
wait

runHook postUnpack