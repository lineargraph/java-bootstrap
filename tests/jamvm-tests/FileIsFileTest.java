import java.io.File;

// Regression probe for the VMFile.isFile() bug: cpio_checkType left *entryType
// unset on the stat-failure path, and CPFILE_FILE==0, so a NONEXISTENT path
// reported isFile()==true. The key invariant: !exists => !isFile && !isDirectory.
// args[0] = a path that really is a file, args[1] = a path that really is a dir.
public class FileIsFileTest {
    public static void main(String[] a) throws Exception {
        File missing = new File("/no/such/path/xyzzy_" + System.currentTimeMillis());
        Check.that("missing.exists() == false",      !missing.exists());
        Check.that("missing.isFile() == false",      !missing.isFile());        // the bug
        Check.that("missing.isDirectory() == false", !missing.isDirectory());

        File f = new File("FileIsFileTest.java");
        Check.that("file.exists()",            f.exists());
        Check.that("file.isFile()",            f.isFile());
        Check.that("file.isDirectory()==false", !f.isDirectory());

        File d = new File(".");
        Check.that("dir.exists()",        d.exists());
        Check.that("dir.isDirectory()",   d.isDirectory());
        Check.that("dir.isFile()==false", !d.isFile());

        Check.done("FileIsFileTest");
    }
}
