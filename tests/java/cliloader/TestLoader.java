package cliloader;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class TestLoader {

	private LoaderCLIMain cliLoader;

	@Before
	public void setUp() throws Exception {
		cliLoader = new LoaderCLIMain();
	}

	@After
	public void tearDown() throws Exception {
	}

	@SuppressWarnings("static-access")
	@Test
	public final void testGetPathRoot() {
		String root = cliLoader.getPathRoot("D:\\Users\\someone\\home");
		assertTrue(root.equals("D:\\"));
		root = cliLoader.getPathRoot("C:/Users/someone/home");
		assertTrue(root.equals("C:/"));
		root = cliLoader.getPathRoot("D:/Users/someone/home");
		assertTrue(root.equals("D:/"));
		root = cliLoader.getPathRoot("D:\\Users\\someone\\home");
		assertTrue(root.equals("D:\\"));
		root = cliLoader.getPathRoot("/wee/hoo");
		assertTrue(root.equals("/"));
		root = cliLoader.getPathRoot("/");
		assertTrue(root.equals("/"));
	}
	
	@Test
	public final void testVersionComparator() {
		String lowerVersion = "1.2.4";
		String higherVersion = "1.2.5";
		VersionComparator versionComparator = new VersionComparator();
		int result = versionComparator.compare(higherVersion, lowerVersion);
		assertTrue(result > 0);
		result = versionComparator.compare(lowerVersion,higherVersion);
		assertTrue(result < 0);
		higherVersion = "1.2.1";
		lowerVersion = "1.2";
		result = versionComparator.compare(higherVersion, lowerVersion);
		assertTrue(result > 0);
		result = versionComparator.compare(higherVersion, higherVersion);
		assertTrue(result == 0);
	}
	
	@Test
	public final void testRemovePreviousLibs() {
		try {
			File libDir = Files.createTempDirectory("lib").toFile();
			File runwarOld = File.createTempFile("runwar", ".jar", libDir);
			File runwarOld2 = File.createTempFile("runwar-1", ".jar", libDir);
			assertTrue(runwarOld.exists());
			assertTrue(runwarOld2.exists());
			Util.removePreviousLibs(libDir);
			assertFalse(runwarOld.exists());
			assertFalse(runwarOld2.exists());
			libDir.delete();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	

}