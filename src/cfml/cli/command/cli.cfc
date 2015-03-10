/**
 * General CLI commands (in the default namespace)
 * You can specify the command name to use with: @command.name
 * and you can specify any aliases (not shown in command list)
 * via: @command.aliases list,of,aliases
 **/
component output="false" persistent="false" trigger="" {

	function init(shell) output="false" {
		variables.shell = shell;
		cr = chr(10);
		return this;
	}

	/**
	 * display help information
	 * @namespace.hint namespace (or namespaceless command) to get help for
 	 * @command.hint command to get help for
 	 * @command.aliases h,?
  	 **/
	function help(String namespace="", String command="") output="false" {
		return shell.help(namespace,command);
	}

	/**
	 * echo arguments (test function)
	 **/
	function echoargs() output="false" {
		return arguments;
	}

	/**
	 * List directories
	 * 	ex: dir /my/path
	 * @directory.hint directory
	 * @recurse.hint recursively list
 	 * @command.aliases ls, directory
	 **/
	function dir(String directory="", Boolean recurse=false) output="false" {
		var result = "";
		directory = trim(directory) == "" ? shell.pwd() : directory;
		if(!directoryExists(directory)) {
			throw(type="command.exception", message="Directory does not exist: " & directory);
		}
		for(var d in directoryList(directory,recurse)) {result &= shell.ansi("cyan",d) & cr;}
		return result;
	}

	/**
	 * returns shell version
	 **/
	function version()  {
		return shell.version();
	}


	/**
	 * Set prompt
	 **/
	function prompt(String prompt="")  {
		shell.setPrompt(prompt);
	}

	/**
	 * Clear screen
	 **/
	function clear()  {
		shell.clearScreen();
	}

	/**
	 * print working directory (current dir)
	 **/
	function pwd()  {
		return shell.pwd();
	}

	/**
	 * change directory
	 * @directory.hint directory to CD to
* 	 **/
	function cd(directory="")  {
		return shell.cd(directory);
	}

	/**
	 * display file contents
	 * @command.aliases type
	 * @file.hint file to view contents of
 	 **/
	function cat(file="")  {
		if(left(file,1) != "/"){
			file = shell.pwd() & "/" & file;
		}
		return fileRead(file);
	}

	/**
	 * dump a variable
	 * @command.aliases cfdump
	 * @command.name dump
	 * @var.hint variable to dump
 	 **/
	function dumpvar(var="",label="")  {
		return evaluate(var);
	}

	/**
	 * delete a file or directory
	 * @command.aliases rm,del
	 * @file.hint file or directory to delete
	 * @force.hint force deletion
	 * @recurse.hint recursive deletion of files
	 **/
	function delete(required file="", Boolean force=false, Boolean recurse=false)  {
		if(!fileExists(file)) {
			shell.printError({message="file does not exist: #file#"});
		} else {
			var isConfirmed = shell.ask("delete #file#? [y/n] : ");
			if(left(isConfirmed,1) == "y" || isBoolean(isConfirmed) && isConfirmed) {
				fileDelete(file);
				return "deleted #file#";
			}
		}
		return "";
	}

	/**
	 * updates the shell
	 * @command.aliases update
	 **/
	function update(Boolean force=false) {
		var temp = shell.getTempDir();
		http url="http://cfmlprojects.org/artifacts/org/getlucee/lucee.cli/maven-metadata.xml" file="#temp#/maven-metadata.xml";
		var mavenData = xmlParse("#temp#/maven-metadata.xml");
		var latest = xmlSearch(mavendata,"/metadata/versioning/versions/version[last()]/text()");
		latest = latest[1].xmlValue;
		if(latest!=shell.version() || force) {
			var result = shell.callCommand("cfdistro","dependency",{artifactId:"lucee.cli",groupId:"org.lucee",version=latest,classifier="cfml"});
		}
		zip action="unzip" file="#shell.getArtifactsDir()#/org/getlucee/lucee.cli/#latest#/lucee.cli-#latest#-cfml.zip"
		 destination="#shell.getHomeDir()#/cfml";
		return "installed #latest# (#result#)";
	}

	/**
	 * updates the engine
	 * @command.name update-engine
	 * @command.aliases update
	 **/
	function updateengine(Boolean force=false) {
		var temp = shell.getTempDir();
		http url="http://cfmlprojects.org/artifacts/org/getlucee/lucee-rc/maven-metadata.xml" file="#temp#/maven-metadata.xml";
		var mavenData = xmlParse("#temp#/maven-metadata.xml");
		var latest = xmlSearch(mavendata,"/metadata/versioning/versions/version[last()]/text()");
		var current = server.lucee.version;
		var message = "Current Version: " & current & cr;
		latest = latest[1].xmlValue;
		message &= "Latest Version: " & latest & cr;
		if(latest!=current || force) {
			var result = shell.callCommand("cfdistro","dependency",{artifactId:"lucee-rc",groupId:"org.lucee",version=latest,type="rc",classifier=""});
			message &= "Updating to " & latest & cr;
			fileCopy("#shell.getArtifactsDir()#/org/getlucee/lucee-rc/#latest#/lucee-rc-#latest#.rc",
				"#shell.getHomeDir()#/server/lucee-server/patches");
			admin action="restart" type="server" password="testtest" remoteClients="";
			admin action="updatePassword" type="web" newPassword="test1234";
		}
		return message;
	}

	/**
	 * echoes output
	 * @message.hint message
  	 **/
	function echo(required String message) {
		return message;
	}

	/**
	 * executes a cfml file
	 **/
	function execute(file="")  {
		return include(file);
	}

	/**
	 * get all or set system property
	 **/
	function set(prop="")  {
		if(prop == "") {
			return createObject("java","java.lang.System").getProperties();
		} else {
			shell.env(prop);
		}
	}

	/**
	* Exit the shell
	* @command.aliases quit,q
	*/
	function exit()  {
		shell.exit();
	}

	/**
	 * Reload CLI
	 * @clearScreen.hint clears the screen after reload
  	 **/
	function reload(Boolean clearScreen=true)  {
		shell.reload(clearScreen);
	}

}