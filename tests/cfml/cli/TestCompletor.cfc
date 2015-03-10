component name="TestShell" extends="mxunit.framework.TestCase" {

	CompleteOperation = createObject("java","org.jboss.jreadline.complete.CompleteOperation");

	public void function setUp()  {
		var shell = new cfml.cli.Shell();
		var commandHandler = new cfml.cli.CommandHandler(shell);
		commandHandler.initCommands();
		variables.completor = new cfml.cli.Completor(commandHandler);
	}

	public void function testPrefixMatchesParam()  {
		var cmdline = "dir dir";
		var co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		var candidates = co.getCompletionCandidates();
		var cursor = co.getCursor();
		debug(candidates);
		assertTrue(candidates.contains("directory="));
		assertFalse(candidates.contains("recurse="));
		assertEquals(7,cursor);
		candidates.clear();
	}

	public void function testPartialNoPrefixCommands()  {
		var cmdline = "";
		var co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		var candidates = co.getCompletionCandidates();
		var cursor = co.getCursor();
		assertTrue(candidates.size() > 4);
		assertTrue(candidates.contains("help"));
		assertTrue(candidates.contains("dir"));
		assertTrue(candidates.contains("ls"));
		assertTrue(candidates.contains("cfdistro"));
		assertEquals(0,cursor);
		candidates.clear();

		cmdline = "he";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertFalse(candidates.contains("command="));
		assertTrue(candidates.contains("help"));
		assertFalse(candidates.contains("dir"));
		assertEquals(2,cursor);
		candidates.clear();

		cmdline = "help";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertFalse(candidates.contains("command="));
		assertTrue(candidates.contains("help"));
		assertEquals(4,cursor);
		candidates.clear();

		cmdline = "help ";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertTrue(candidates.contains("command="));
		assertFalse(candidates.contains("help"));
		assertEquals(5,cursor);
		candidates.clear();

		cmdline = "help com";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertTrue(candidates.contains("command="));
		assertFalse(candidates.contains("help"));
		assertEquals(8,cursor);
		candidates.clear();

		cmdline = "dir ";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertTrue(candidates.contains("directory="));
		assertTrue(candidates.contains("recurse="));
		assertEquals(4,cursor);
		candidates.clear();

		cmdline = "dir directory=blah ";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertTrue(candidates.contains("recurse="));
		assertFalse(candidates.contains("directory"));
		assertFalse(candidates.contains("directory="));
		assertEquals(19,cursor);
		candidates.clear();

		cmdline = "dir directory=blah recurse=";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertTrue(candidates.contains("true"));
		assertTrue(candidates.contains("false"));
		assertEquals(27,cursor);
		candidates.clear();

		cmdline = "dir directory=blah recurse=tr";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertTrue(candidates.contains("true"));
		assertFalse(candidates.contains("false"));
		assertEquals(29,cursor);
		candidates.clear();

		cmdline = "cfdistro ";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertTrue(candidates.contains("war"));
		assertTrue(candidates.contains("dependency"));
		assertEquals(len(cmdline),cursor);
		candidates.clear();

		cmdline = "cfdistro war";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertTrue(candidates.contains("war"));
		assertFalse(candidates.contains("dependency"));
		assertEquals(12,cursor);
		candidates.clear();

		cmdline = "cfdistro d";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		assertTrue(candidates.contains("dependency"));
		assertFalse(candidates.contains("build"));
		assertEquals(10,cursor);
		candidates.clear();

		cmdline = "cfdistro dependency ";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		debug(candidates);
		assertTrue(candidates.contains("artifactId="));
		assertTrue(candidates.contains("exclusions="));
		assertEquals(len(cmdline),cursor);
		candidates.clear();

		cmdline = "init";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		debug(candidates);
		assertTrue(candidates.contains("init"));
		assertEquals(len(cmdline),cursor);
		candidates.clear();

		cmdline = "iDoNotExist ";
		co = CompleteOperation.init(cmdline,len(cmdline));
		completor._complete(co);
		candidates = co.getCompletionCandidates();
		cursor = co.getCursor();
		debug(candidates);
		assertEquals(0,candidates.size());
		assertEquals(len(cmdline),cursor);
		candidates.clear();
	}
}