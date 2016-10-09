#!/bin/sh
for a in "$@"
do
	case "$a" in
	-java_home=*) JAVA_HOME=${a#*=}; break; ;;
	-JAVA_HOME=*) JAVA_HOME=${a#*=}; break; ;;
	-java_opts=*) JAVA_OPTS=${a#*=}; break; ;;
	-JAVA_OPTS=*) JAVA_OPTS=${a#*=}; break; ;;
	esac
done

this_script=`which "$0" 2>/dev/null`
[ $? -gt 0 -a -f "$0" ] && this_script="$0"
cp=$this_script
JRE=$(dirname $this_script)/jre
if [ -n "$LUCEE_CLASSPATH" ]
then
	cp="$cp:$LUCEE_CLASSPATH"
fi

if [ -z "$JAVA_OPTS" ]
then
  JAVA_OPTS="-client -Xms128m -Xmx512m"
fi

# Cleanup paths for Cygwin.
#
case "`uname`" in
CYGWIN*)
	cp=`cygpath --windows --mixed --path "$cp"`
	;;
Darwin)
	if [ -e /System/Library/Frameworks/JavaVM.framework ]
	then
		JAVA_OPTS=$JAVA_OPTS'
			-Dcom.apple.mrj.application.apple.menu.about.name=Lucee
			-Dcom.apple.mrj.application.growbox.intrudes=false
			-Dapple.laf.useScreenMenuBar=true
			-Xdock:name=Lucee
			-Dfile.encoding=UTF-8
		'
	fi
	;;
esac

CLASSPATH="$cp"
export CLASSPATH

java=java
if [ -n "$JAVA_HOME" ]
then
	java="$JAVA_HOME/bin/java"
fi

if [ -d "$JRE" ]
then
  java="$JRE/bin/java"
fi

exec "$java" $JAVA_OPTS -jar ${jar.name} "$@"
exit 0
