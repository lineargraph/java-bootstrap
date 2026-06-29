import java.io.File;

// <mkdir> in ant had some trouble with mkdirs() not reporting the correct status, i think
public class MkdirTest {
    public static void main(String[] a) throws Exception {
        File base = new File(System.getProperty("java.io.tmpdir"),
                             "mkt_" + System.currentTimeMillis());
        File nested = new File(base, "x/y/z");

        Check.that("nested.exists() before == false", !nested.exists());
        boolean r = nested.mkdirs();
        Check.that("mkdirs() == true",       r);
        Check.that("nested.exists() after",  nested.exists());
        Check.that("nested.isDirectory()",   nested.isDirectory());

        Check.done("MkdirTest");
    }
}
