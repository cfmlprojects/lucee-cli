<cfsilent>
<cfset _shellprops = { version:'0.1' } >
<cfsetting requesttimeout="9999" />
<cfsavecontent variable="_shellprops.help">Welcome!
Type "help" for help, or "help [namespace|command] [command]" to be more specific.
</cfsavecontent>
<cfscript>
	system = createObject("java","java.lang.System");
	___in = system.in;
	___out = system.out;
	___err = system.err;
	exitStatus = 0;
	args = system.getProperty("cfml.cli.arguments");
	try {
		if(!isNull(args) && trim(args) != "") {
    		outputStream = createObject("java","java.io.ByteArrayOutputStream").init();
    		bain = createObject("java","java.io.ByteArrayInputStream").init("#args##chr(10)#".getBytes());
			shell = new Shell(inStream=bain,outputStream=outputStream);
			shell.runCommandLine(args);
			//shell = new Shell(outputStream=outputStream);
			//shell.run(bain);
			system.out.print(outputStream);
			shell = javacast("null","");
			system.out.flush();
		} else {
			systemOutput(_shellprops.help);
			shell = new Shell();
			while (shell.run()) {
				systemOutput("Reloading shell.");
				SystemCacheClear("all");
			    system.runFinalization();
			    system.gc();
				shell = javacast("null","");
				shell = new Shell();
			}
		}
	} catch (any erro) {
		systemOutput(erro.message);
		exitStatus = 1;
	}
	system.setIn(___in);
	system.setOut(___out);
	system.setErr(___err);
</cfscript>
</cfsilent>
